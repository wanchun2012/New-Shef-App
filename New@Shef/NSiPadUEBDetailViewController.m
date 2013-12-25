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

@interface NSiPadUEBDetailViewController ()

@end

@implementation NSiPadUEBDetailViewController

@synthesize appDelegate, popoverController;
@synthesize labelRole,tvDetails, txtName, txtRole, txtDescription, ivPhoto, txtStatus, uebId, txtUrl, txtType, uebVC;
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
	self.title=@"UEB";
 
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    
    [self.tvDetails setEditable:NO];
    self.tvDetails.textAlignment = NSTextAlignmentJustified;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    [self.tvDetails setFont:[UIFont systemFontOfSize:14]];
    [self.tvDetails setFrame:CGRectMake(screenSize.width/8,
                                        screenSize.height/8,
                                        screenSize.width/4*3,
                                        screenSize.height/8*5)];
    //prepare for label
    labelRole.numberOfLines = 0;
    labelRole.lineBreakMode = NSLineBreakByWordWrapping;
    
    labelRole.text = [txtName stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [labelRole setFont: [UIFont systemFontOfSize:14]];
    
    [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    [super viewDidLoad];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"Back"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = btnBack;

}

-(void)backgroundThread
{
    NSLog(@"NSUEBDetailViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
    UIImage * myImage;
    if ([self connectedToNetwork] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet, please try later?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    else
    {
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
    [ivPhoto setImage:myImage];
    
    // prepare for description
    self.tvDetails.text = @"";
    // first, separate by new line
    self.tvDetails.text = txtDescription;
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = [txtRole stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:16.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor blackColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
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
	
    self.uebVC=[[NSiPadUEBViewController alloc]init];
    [viewControllerArray addObject:self.uebVC];
    self.appDelegate.splitViewController.delegate = (id)self.uebVC;
    
    [[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] setViewControllers:viewControllerArray animated:NO];
	[self.appDelegate.splitViewController viewWillAppear:YES];
    
}


@end
