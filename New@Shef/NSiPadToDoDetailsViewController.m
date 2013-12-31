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
@synthesize txtResponsiblePerson,txtDescription, txtStatus,txtId, iCloudText,document,documentURL,ubiquityURL,metadataQuery, checklistVC, txtActivityName;
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
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
    
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	[[self navigationItem] setLeftBarButtonItem:nil];
	[self setPopoverController:nil];
	self.appDelegate.rootPopoverButtonItem = barButtonItem;
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
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
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
    UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"Checklist";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:20.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    btnDone = [[UIBarButtonItem alloc]
               initWithTitle:@"Done"
               style:UIBarButtonItemStyleBordered
               target:self
               action:@selector(saveDocument)];
    self.navigationItem.rightBarButtonItem = btnDone;
    
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"< Back"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(goBack)];
    UIColor *iosBlue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    btnBack.tintColor = iosBlue;
    self.navigationItem.leftBarButtonItem = btnBack;

 
    btnDone.tintColor = iosBlue;
 
    if ([self connectedToNetwork] == YES)
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
        
        labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(50,50,self.view.frame.size.width, 20)];
        if([txtStatus isEqualToString:@"Incomplete"])
        {
            labelTitle.text = @"Status: Incomplete";
            btnDone.enabled = YES;
        }
        else
        {
            labelTitle.text = txtStatus;
            btnDone.enabled = NO;
        }
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.numberOfLines = 0;
        labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
        labelTitle.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
        [self.scrollView addSubview:labelTitle];
        
        NSString *text = [NSString stringWithFormat:@"Summery: \n%@",
                          [self.txtActivityName stringByReplacingOccurrencesOfString :@"+" withString:@" "]];
        text = [text stringByAppendingString:@"\n \n"];
        
        text = [text stringByAppendingString:
                [NSString stringWithFormat:@"Responsible person: \n%@",
                 [self.txtResponsiblePerson stringByReplacingOccurrencesOfString :@"+" withString:@" "]]];
        text = [text stringByAppendingString:@"\n \n"];
        
        text = [text stringByAppendingString:
                [NSString stringWithFormat:@"Description: \n%@",
                 [self.txtDescription stringByReplacingOccurrencesOfString :@"+" withString:@" "]]];
        
        
        UITextView *mainContent = [[UITextView alloc]initWithFrame:CGRectMake(50,80, self.view.frame.size.width-100.f,0)];
        mainContent.text = text;
        mainContent.textAlignment = NSTextAlignmentJustified;
        mainContent.textColor = [UIColor blackColor];
        mainContent.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
        mainContent.scrollEnabled = NO;
        mainContent.editable = NO;
        mainContent.layer.borderWidth =1.0;
        mainContent.layer.cornerRadius =5.0;
        mainContent.layer.borderColor = [UIColor grayColor].CGColor;
        [mainContent sizeToFit];
        [self.scrollView addSubview: mainContent];
        
        [self.scrollView setScrollEnabled:YES];
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, mainContent.frame.size.height+80.f+50.f)];
        
    }

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
    if ([self connectedToNetwork]==YES)
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
        labelTitle.numberOfLines = 0;
        labelTitle.text = [NSString stringWithFormat:@"Status:%@",myDateString];
        NSString *iCloudStatus = [NSString stringWithFormat:@"%@(%@( end", txtId,labelTitle.text];
        
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
  
}

-(void)activityIndicatorThreadStarting
{

}

-(void)activityThreadFinishing
{

    if ([self iCloudIsAvailable]==YES) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Time and Status saved to iCloud" delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
    }

    btnDone.tintColor = [UIColor grayColor];
    self.navigationItem.backBarButtonItem.enabled = YES;
}

// iCloud setting
- (BOOL) iCloudIsAvailable
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ubiquityURL = [fileManager
                   URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_URL];
    
    if ([fileManager fileExistsAtPath:[ubiquityURL path]] == NO)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOICLOUDTITLE
                                                        message:NOICLOUDMSG
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Wait later", nil];
        [alert show];
        return NO;
    }
    return YES;
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
        if (![alertView.title isEqualToString:SAVEDTITLE]) {
            exit(-1);
        }
        
    }
    
}

- (BOOL) connectedToNetwork
{
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://google.co.uk"] encoding:NSUTF8StringEncoding error:nil];
    if (connect==NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
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
