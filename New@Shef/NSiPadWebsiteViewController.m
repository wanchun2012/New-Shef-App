//
//  NSiPadWebsiteViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSiPadWebsiteViewController.h"
#import "NSiPadLinkViewController.h"
#import "NSiPadRootViewController.h"
@interface NSiPadWebsiteViewController ()

@end

@implementation NSiPadWebsiteViewController
@synthesize appDelegate, popoverController;
@synthesize webview, url, linkVC;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.appDelegate = (NSAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

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
	self.title=@"Link";
}


- (void)viewDidLoad
{
    self.popoverController = nil;
    self.webview.scalesPageToFit = YES;
    self.webview.frame=self.view.bounds;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    
    [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    [super viewDidLoad];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"Back"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = btnBack;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backgroundThread
{
    NSLog(@"NSWebsiteViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
    NSString *urlString = [self.url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *myURL = [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webview loadRequest:request];
    sleep(1);
    [self performSelectorOnMainThread:@selector(mainThreadFinishing) withObject:nil waitUntilDone:NO];
    NSLog(@"NSWebsiteViewController: %s","backgroundThread finishing...");
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
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

-(void)goBack
{
    [self.appDelegate.splitViewController viewWillDisappear:YES];
	NSMutableArray *viewControllerArray=[[NSMutableArray alloc] initWithArray:[[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] viewControllers]];
	[viewControllerArray removeLastObject];
	
    self.linkVC=[[NSiPadLinkViewController alloc]init];
    [viewControllerArray addObject:self.linkVC];
    self.appDelegate.splitViewController.delegate = (id)self.linkVC;
    
    [[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] setViewControllers:viewControllerArray animated:NO];
	[self.appDelegate.splitViewController viewWillAppear:YES];
    
}



@end