//
//  NSiPadFAQsViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

#import "NSiPadFAQsViewController.h"
#import "NSiPadRootViewController.h"
@interface NSiPadFAQsViewController ()

@end

@implementation NSiPadFAQsViewController
@synthesize popoverController,appDelegate;
@synthesize scrollView;


NSString *serverVersion;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.appDelegate=(NSAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}
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
}

- (void)viewDidLoad
{
    self.popoverController = nil;
    
	UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"FAQs";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:20.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    UIBarButtonItem *btnEmail = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Email"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(sendEmail)];
    UIColor *iosBlue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    btnEmail.tintColor = iosBlue;
    self.navigationItem.rightBarButtonItem = btnEmail;
  
    if ([self connectedToNetwork]==YES)
    {
        [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backgroundThread
{
    NSLog(@"NSFAQsViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
 
    [self getVersionWebService];
    modelVersionControl = [[VersionControl alloc] init];
    [modelVersionControl initDB];
    [modelVersionControl selectData];
    
    collection = [[NSMutableArray alloc] init];
    
    if ([modelVersionControl.vLink isEqualToString: @"0"])
    {
        // initialize welcometalk
        NSLog(@"NSFAQViewController: %s","initialize FAQ");
        [self loadDataFromWebService];
        int first = 0;
        for (FAQ * object in collection)
        {
            [object initDB];
            if(first == 0)
            {
                [object clearData];
                first = 1;
            }
            
            [object saveData:object.faqId question:object.question answer:object.answer];
        }
        [modelVersionControl initDB];
        [modelVersionControl updateData:@"versionfaq =:versionfaq" variable:@":versionfaq" data:serverVersion];
    }
    else
    {
        if ([modelVersionControl.vLink isEqualToString: serverVersion])
        {
            // sqlite db version is equal to mysql db version
            // get data from sqlite database
            NSLog(@"NSFAQViewController: %s","fetch from FAQ(sqlite)");
            FAQ *faq = [[FAQ alloc] init];
            [faq initDB];
            collection = [[faq selectData] mutableCopy];
        }
        else
        {
            // load data from mysql database
            // update data in sqlite database
            NSLog(@"NSFAQViewController: %s","fetch from FAQ(Web database)");
            [self loadDataFromWebService];
            
            int first = 0;
            for (FAQ * object in collection)
            {
                [object initDB];
                if(first == 0)
                {
                    [object clearData];
                    first = 1;
                }
                [object saveData:object.faqId question:object.question answer:object.answer];
            }
            
            [modelVersionControl initDB];
            [modelVersionControl updateData:@"versionfaq =:versionfaq" variable:@":versionfaq" data:serverVersion];
        }
    }
    
    [self performSelectorOnMainThread:@selector(mainThreadFinishing) withObject:nil waitUntilDone:NO];
    NSLog(@"NSFAQsViewController: %s","backgroundThread finishing...");
}

-(void)mainThreadStarting
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [activityIndicator startAnimating];
}

-(void)mainThreadFinishing
{
    UITextView *mainContent = [[UITextView alloc]initWithFrame:CGRectMake(50,50, self.view.frame.size.width-100.f,0)];
    mainContent.text = @"This is frequently answered question by new employees and you can use the top right button to send us an email of your own question.";
    mainContent.text = [mainContent.text stringByAppendingString:@"\n"];
    for(FAQ * faq in collection)
    {
        mainContent.text = [mainContent.text stringByAppendingString:@"\n"];
        mainContent.text = [mainContent.text stringByAppendingString:@"Q: "];
        mainContent.text = [mainContent.text stringByAppendingString:faq.question];
        mainContent.text = [mainContent.text stringByAppendingString:@"\n"];
        mainContent.text = [mainContent.text stringByAppendingString:@"A: "];
        mainContent.text = [mainContent.text stringByAppendingString:faq.answer];
        mainContent.text = [mainContent.text stringByAppendingString:@"\n"];
    }
    
    mainContent.textAlignment = NSTextAlignmentJustified;
    mainContent.textColor = [UIColor blackColor];
    mainContent.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    mainContent.scrollEnabled = NO;
    mainContent.editable = NO;
    /*
     mainContent.layer.borderWidth =1.0;
     mainContent.layer.cornerRadius =5.0;
     mainContent.layer.borderColor = [UIColor grayColor].CGColor;
     */
    [mainContent sizeToFit];
    
    [self.scrollView addSubview: mainContent];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, mainContent.frame.size.height+50.f+50.f)];
    
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];

}

-(void) getDataFromJson:(NSData *) data
{
    NSError *error;
    jsonFAQ = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

-(void) prepareForWebService
{
    for (int i=0; i<jsonFAQ.count; i++)
    {
        NSDictionary *info = [jsonFAQ objectAtIndex:i];
        
        int Id = [[info objectForKey:@"id"] intValue];
        NSString *q = [info objectForKey:@"question"];
        NSString *a = [info objectForKey:@"answer"];
        
        FAQ *record = [[FAQ alloc]
                       initWithId:Id question:q answer:a];
        [collection addObject:record];
    }
    
}

-(void) loadDataFromWebService
{
    NSURL *url = [NSURL URLWithString:GETFAQ];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self getDataFromJson:data];
    [self prepareForWebService];
}

-(void) getVersionWebService
{
    NSURL *url = [NSURL URLWithString:GETVersion];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    jsonVersion = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary *info = [jsonVersion objectAtIndex:0];
    
    serverVersion = [info objectForKey:@"versionFAQ"];
}

-(void)sendEmail
{
    if ([self connectedToNetwork]==YES)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            // device is configured to send mail
            
            MFMailComposeViewController *mailController = [[ MFMailComposeViewController alloc]init];
            [mailController setMailComposeDelegate:self];
            NSString *toEmail = FAQEmail;
            NSArray *emailArray = [[NSArray alloc]initWithObjects:toEmail, nil];
            NSString *message = @"";//self.emailbody.text;
            [mailController setMessageBody:message isHTML:NO];
            [mailController setToRecipients:emailArray];
            [mailController setSubject:FAQSUBJECT];
            mailController.navigationBar.tintColor = [UIColor blackColor];
            [self presentViewController:mailController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOEMAILTITLE message:NOEMAILMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:@"Wait later", nil];
            [alert show];
        }
    }
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        exit(-1);
    }
    
}

- (BOOL) connectedToNetwork
{
    BOOL result = NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    result = !(networkStatus == NotReachable);
    
    if (result == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    return result;
}


@end
