//
//  NSiPadUEBDetailViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSiPadUEBDetailViewController.h"
#import "NSiPadUEBViewController.h"
#import "NSiPadRootViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface NSiPadUEBDetailViewController ()

@end

@implementation NSiPadUEBDetailViewController

@synthesize appDelegate, popoverController;
@synthesize txtName, txtRole, txtDescription, txtStatus, uebId, txtUrl, txtType, uebVC,scrollView;
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
 
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
 
	UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = self.txtRole;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:20.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];

    if ([self connectedToNetwork]==YES)
    {
        [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    }
    [super viewDidLoad];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"< Back"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(goBack)];
    btnBack.tintColor = [UIColor blueColor];
    self.navigationItem.leftBarButtonItem = btnBack;

}

-(void)backgroundThread
{
    NSLog(@"NSUEBDetailViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
    UIImage * myImage;
 
    // prepare for image
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *name = [NSString stringWithFormat:@"ueb_%@", uebId];
    NSString *dirpath = [path objectAtIndex:0];
    
    if([txtStatus isEqualToString:@"download"])
    {
        myImage = [self getImageFromURL:txtUrl];
        [self saveImage:myImage withFileName:name ofType:txtType inDirectory:dirpath];
        NSLog(@"download from webservice, due to web server updating....");
        
    }
    else
    {
        myImage = [self loadImage:name ofType:txtType inDirectory:dirpath];
        
        if(myImage==NULL)
        {
            myImage = [self getImageFromURL:txtUrl];
            [self saveImage:myImage withFileName:name ofType:txtType inDirectory:dirpath];
            NSLog(@"download from webservice, first download");
        }
    }
   
   
    [self performSelectorOnMainThread:@selector(mainThreadFinishing:) withObject:myImage waitUntilDone:NO];
    
    NSLog(@"NSUEBDetailViewController: %s","backgroundThread finishing...");
}

-(void)mainThreadStarting
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [activityIndicator startAnimating];
}

-(void)mainThreadFinishing:(UIImage *) myImage
{
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(50,50,self.view.frame.size.width, 20)];
    labelTitle.text = txtName;
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.numberOfLines = 0;
    labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
    labelTitle.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    [self.scrollView addSubview:labelTitle];
 
    UITextView * mainContent = [[UITextView alloc]initWithFrame:CGRectMake(50,180, self.view.frame.size.width-100.f, 0)];
    mainContent.text = txtDescription;
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
    
    UIImageView *ivUEB= [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 125.f, 50.f, 75.f, 100.f)];
    [ivUEB setImage:myImage];
    [self.scrollView addSubview:ivUEB];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, mainContent.frame.size.height+50.f+180.f)];
    
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *) getImageFromURL:(NSString *)url
{
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    result = [UIImage imageWithData:data];
    
    return result;
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName
           ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    if ([[extension lowercaseString] isEqualToString:@"image/png"])
    {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    }
    else if ([[extension lowercaseString] isEqualToString:@"image/jpg"] || [[extension lowercaseString] isEqualToString:@"image/jpeg"])
    {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    }
    else
    {
        NSLog(@"NSUEBDetailViewController: Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

- (void)removeImage:(NSString*)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    if ([[extension lowercaseString] isEqualToString:@"image/png"])
    {
        NSString *fullPath1 = [directoryPath stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"%@.png", fileName]];
        
        if(![fileManager removeItemAtPath: fullPath1 error:&error])
        {
            NSLog(@"NSUEBDetailViewController: Delete failed:%@", error);
        }
        else
        {
            NSLog(@"NSUEBDetailViewController: Image removed: %@", fullPath1);
        }
    }
    if ([[extension lowercaseString] isEqualToString:@"image/jpg"] || [[extension lowercaseString] isEqualToString:@"image/jpeg"])
    {
        NSString *fullPath2 = [directoryPath stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"%@.jpg", fileName]];
        if(![fileManager removeItemAtPath: fullPath2 error:&error])
        {
            NSLog(@"NSUEBDetailViewController: Delete failed:%@", error);
        }
        else
        {
            NSLog(@"NSUEBDetailViewController: Image removed: %@", fullPath2);
        }
    }
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    UIImage * result;
    NSLog(@"NSUEBDetailViewController: image loading........");
    if ([[extension lowercaseString] isEqualToString:@"image/png"])
    {
        result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, @"png"]];
    }
    if ([[extension lowercaseString] isEqualToString:@"image/jpg"]|| [[extension lowercaseString] isEqualToString:@"image/jpeg"])
    {
        result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, @"jpg"]];
    }
    return result;
}

-(void)goBack
{
  
        [self.appDelegate.splitViewController viewWillDisappear:YES];
        NSMutableArray *viewControllerArray=[[NSMutableArray alloc] initWithArray:[[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] viewControllers]];
        [viewControllerArray removeLastObject];
        
        self.uebVC=[[NSiPadUEBViewController alloc]init];
        [viewControllerArray addObject:self.uebVC];
        self.appDelegate.splitViewController.delegate = (id)self.uebVC;
        
        [[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] setViewControllers:viewControllerArray animated:NO];
        [self.appDelegate.splitViewController viewWillAppear:YES];
     
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
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://google.co.uk"] encoding:NSUTF8StringEncoding error:nil];
    if (connect==NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    return (connect!=NULL)?YES:NO;
}



@end
