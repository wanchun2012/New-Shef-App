//
//  NSToDoDetailsViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 20/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSToDoDetailsViewController.h"

@interface NSToDoDetailsViewController ()

@end

@implementation NSToDoDetailsViewController
@synthesize btnDone, tvDescription, labelStatus, txtResponsiblePerson,txtDescription, labelResponsiblePerson, txtStatus,txtId, iCloudText,document,documentURL,ubiquityURL,metadataQuery;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.translucent = NO;
    if ([self connectedToNetwork] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet, please try later?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    } else {
    // iCloud loading
    NSLog(@"iCloud loading..........................");
    [self iCloudIsAvailable];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"newshef.txt"];
    self.documentURL = [NSURL fileURLWithPath:dataFile];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    ubiquityURL = [[filemgr URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_URL] URLByAppendingPathComponent:@"Documents"];
    NSLog(@"iCloud path = %@", [ubiquityURL path]);
    
    if ([filemgr fileExistsAtPath:[ubiquityURL path]] == NO)
    {
        NSLog(@"iCloud Documents directory does not exist");
        [filemgr createDirectoryAtURL:ubiquityURL withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"iCloud Documents directory exists");
    }
    
    ubiquityURL = [ubiquityURL URLByAppendingPathComponent:@"newshef.txt"];
    NSLog(@"Full ubiquity path = %@", [ubiquityURL path]);
    
    // Search for document in iCloud storage
    metadataQuery = [[NSMetadataQuery alloc] init];
    [metadataQuery setPredicate: [NSPredicate predicateWithFormat: @"%K like 'newshef.txt'",
                                  NSMetadataItemFSNameKey]];
    [metadataQuery setSearchScopes:[NSArray arrayWithObjects:NSMetadataQueryUbiquitousDocumentsScope,nil]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataQueryDidFinishGathering:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:metadataQuery];
    NSLog(@"starting query");
    [metadataQuery startQuery];
    
    
    if([txtStatus isEqualToString:@"Incomplete"])
    {
        btnDone.enabled = YES;
    }
    else
    {
        
        btnDone.enabled = NO;
        //btnDone.enabled = YES;
    }
    }
    
    [super viewDidLoad];
    self.btnDone.tintColor = [UIColor blueColor]; 
    tvDescription.textAlignment = NSTextAlignmentJustified;
    tvDescription.userInteractionEnabled = NO;
    tvDescription.text = self.txtDescription;
    labelResponsiblePerson.numberOfLines = 0;
    labelResponsiblePerson.text =[NSString stringWithFormat:@"Responsible person: \n%@", self.txtResponsiblePerson];
    labelResponsiblePerson.text = [labelResponsiblePerson.text stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    labelStatus.text = txtStatus;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveDocument
{
    
    NSDate *myDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *myDateString = [dateFormatter stringFromDate:myDate];
    labelStatus.numberOfLines = 0;
    labelStatus.text = [NSString stringWithFormat:@"Status:%@",myDateString];

    NSLog(@"lets have a look at the txtId");
    
    NSLog(txtId);
 
    NSString *iCloudStatus = [NSString stringWithFormat:@"%@(%@( end", txtId,labelStatus.text];
  
    NSString *test = [document.userText stringByAppendingString:iCloudStatus];
    self.document.userText = test;
    //self.document.userText = @"";
    NSLog(@"test userText");
    NSLog(iCloudStatus);
    [self.document saveToURL:ubiquityURL forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:^(BOOL success) {
               if (success){
                   NSLog(@"Saved to cloud for overwriting");
                   
               } else {
                   NSLog(@"Not saved to cloud for overwriting");
               }
           }];

    btnDone.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadiCloud" object:nil];
 
}


// iCloud setting
- (void) iCloudIsAvailable
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *ubiquityURL = [fileManager
                          URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_URL];
    if(ubiquityURL)
        NSLog(@"YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
    else
        NSLog(@"NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN");
    
}

- (void)metadataQueryDidFinishGathering:(NSNotification *)notification
{
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
    [query stopQuery];
    NSArray *results = [[NSArray alloc] initWithArray:[query results]];
    
    
    if ([results count] == 1)
    {
        NSLog(@"File exists in cloud");
        ubiquityURL = [[results objectAtIndex:0] valueForAttribute:NSMetadataItemURLKey];
        self.document = [[MyDocument alloc] initWithFileURL:ubiquityURL];
        //self.document.userText = @"";
        [document openWithCompletionHandler:
         ^(BOOL success) {
             if (success){
                 NSLog(@"Opened cloud doc");
                 iCloudText = document.userText;
             } else {
                 NSLog(@"Not opened cloud doc");
             }
         }];
    } else {
        NSLog(@"File does not exist in cloud");
        self.document = [[MyDocument alloc] initWithFileURL:ubiquityURL];
        
        [document saveToURL:ubiquityURL
           forSaveOperation: UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success){
                  NSLog(@"Saved to cloud");
              }  else {
                  NSLog(@"Failed to save to cloud");
              }
          }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //  exit(-1); // no
    }
    if(buttonIndex == 1)
    {
        exit(-1); // yes
    }
    
}
- (BOOL) connectedToNetwork
{
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://google.co.uk"] encoding:NSUTF8StringEncoding error:nil];
    return (connect!=NULL)?YES:NO;
}

@end
