//
//  NSiPadToDoDetailsViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 23/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSiPadToDoDetailsViewController.h"
#import "NSiPadChecklistViewController.h"
@interface NSiPadToDoDetailsViewController ()

@end

@implementation NSiPadToDoDetailsViewController
@synthesize appDelegate, popoverController;
@synthesize tvDescription, labelStatus, txtResponsiblePerson,txtDescription, txtStatus,txtId, iCloudText,document,documentURL,ubiquityURL,metadataQuery, checklistVC;
-(id) init {
	if (self=[super init]) {
		self.appDelegate = (NSAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	return self;
}
#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
	barButtonItem.title = @"Menu";
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
	[self setPopoverController:pc];
	self.appDelegate.rootPopoverButtonItem = barButtonItem;
    
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	[[self navigationItem] setLeftBarButtonItem:nil];
	[self setPopoverController:nil];
	self.appDelegate.rootPopoverButtonItem = barButtonItem;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[self navigationItem] setLeftBarButtonItem:nil];
	}
	else {
		[[self navigationItem] setLeftBarButtonItem:self.appDelegate.rootPopoverButtonItem];
	}
	return YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.title=@"Welcome Talk";
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"Back"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = btnBack;

    
    self.navigationController.navigationBar.translucent = NO;
    if ([self connectedToNetwork] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet, please try later?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    else
    {
        // iCloud loading
        NSLog(@"iCloud loading..........................");
        
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
        }
        else
        {
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
        }
    }
    
    btnDone.tintColor = [UIColor blueColor];
    tvDescription.textAlignment = NSTextAlignmentJustified;
    tvDescription.userInteractionEnabled = NO;
    tvDescription.text = [tvDescription.text stringByAppendingString:
                          [NSString stringWithFormat:@"Responsible person: \n%@",
                           [self.txtResponsiblePerson stringByReplacingOccurrencesOfString :@"+" withString:@" "]]];
    tvDescription.text = [tvDescription.text stringByAppendingString:@"\n \n"];
    
    tvDescription.text = [tvDescription.text stringByAppendingString:
                          [NSString stringWithFormat:@"Description: \n%@",
                           [self.txtDescription stringByReplacingOccurrencesOfString :@"+" withString:@" "]]];
    
    
    labelStatus.text = txtStatus;
    
    btnDone = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Done"
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(saveDocument)];
    self.navigationItem.rightBarButtonItem = btnDone;

}



- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveDocument
{
    self.navigationItem.backBarButtonItem.enabled = NO;
    btnDone.enabled = NO;
    [[UIBarButtonItem appearance] setTintColor:[UIColor grayColor]];
    [NSThread detachNewThreadSelector:@selector(activityIndicatorThreadStarting) toTarget:self withObject:nil];
    NSDate *myDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *myDateString = [dateFormatter stringFromDate:myDate];
    labelStatus.numberOfLines = 0;
    labelStatus.text = [NSString stringWithFormat:@"Status:%@",myDateString];
    NSString *iCloudStatus = [NSString stringWithFormat:@"%@(%@( end", txtId,labelStatus.text];
    
    NSString *test = [document.userText stringByAppendingString:iCloudStatus];
    self.document.userText = test;
    
    [self.document saveToURL:ubiquityURL forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:^(BOOL success) {
               if (success){
                   NSLog(@"Saved to cloud for overwriting");
                   
               } else {
                   NSLog(@"Not saved to cloud for overwriting");
               }
           }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadiCloud" object:nil];
    [self activityThreadFinishing];
}

-(void)activityIndicatorThreadStarting
{

}

-(void)activityThreadFinishing
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Time and Status saved to iCloud" delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
        
    self.navigationItem.backBarButtonItem.enabled = YES;
}

// iCloud setting
- (BOOL) iCloudIsAvailable
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ubiquityURL = [fileManager
                   URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_URL];
    
    NSError *err;
    if ([ubiquityURL checkResourceIsReachableAndReturnError:&err] == NO)
    {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please sign in icloud, please try later?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
        return NO;
    }
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
             if (success)
             {
                 NSLog(@"Opened cloud doc");
                 iCloudText = document.userText;
             }
             else
             {
                 NSLog(@"Not opened cloud doc");
             }
         }];
    }
    else
    {
        NSLog(@"File does not exist in cloud");
        self.document = [[MyDocument alloc] initWithFileURL:ubiquityURL];
        
        [document saveToURL:ubiquityURL
           forSaveOperation: UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success)
              {
                  NSLog(@"Saved to cloud");
              }
              else
              {
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

-(void)goBack
{
    [self.appDelegate.splitViewController viewWillDisappear:YES];
	NSMutableArray *viewControllerArray=[[NSMutableArray alloc] initWithArray:[[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] viewControllers]];
	[viewControllerArray removeLastObject];
	
    self.checklistVC=[[NSiPadChecklistViewController alloc]init];
    [viewControllerArray addObject:self.checklistVC];
    self.appDelegate.splitViewController.delegate = (id)self.checklistVC;
    
    [[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] setViewControllers:viewControllerArray animated:NO];
	[self.appDelegate.splitViewController viewWillAppear:YES];
    
}



@end
