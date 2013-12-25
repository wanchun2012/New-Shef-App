//
//  NSiPadUCardViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 23/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSiPadUCardViewController.h"
#import "NSiPadUCardDetailViewController.h"
#import "NSiPadRootViewController.h"
@interface NSiPadUCardViewController ()

@end

@implementation NSiPadUCardViewController

@synthesize appDelegate, popoverController, ucardDetailVC;

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
	self.title=@"UCard";
 
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
    
    self.navigationController.navigationBar.translucent = NO;
 
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"UCard";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor blackColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    UIBarButtonItem *btnEmail = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Send Email"
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(sendEmail)];
    self.navigationItem.rightBarButtonItem = btnEmail;


}

- (IBAction)TakePhoto
{
    self.picker1 = [[UIImagePickerController alloc] init];
    self.picker1.delegate = self;
    [self.picker1 setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:self.picker1 animated:YES completion:NULL];
    //[picker1 relsease];
}
/*
- (IBAction)ChoosePhoto
{
    self.picker2 = [[UIImagePickerController alloc] init];
    self.picker2.delegate = self;
    [self.picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.picker2 animated:YES completion:NULL];
    //[picker2 relsease];
}
*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"finish ======++++++");
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    
    self.imageView.image = self.image;
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self.imageCard addSubview:self.imageView];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)sendEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[ MFMailComposeViewController alloc]init];
        [mailController setMailComposeDelegate:self];
        NSString *toEmail = UCardEmail;
        NSArray *emailArray = [[NSArray alloc]initWithObjects:toEmail, nil];
        NSString *message = @"hello this is the photo for ucard";
        [mailController setMessageBody:message isHTML:NO];
        [mailController setToRecipients:emailArray];
        [mailController setSubject:@"New@Shef:ucard"];
        NSData *imageData = UIImagePNGRepresentation(self.image);
        [mailController addAttachmentData:imageData mimeType:@"image/png" fileName:@"Name"];
        [self presentViewController:mailController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Do you want to login one email account now?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
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
        //  exit(-1); // no
    }
    if(buttonIndex == 1)
    {
        exit(-1); // yes
    }
    
}
-(IBAction)ucardInfo
{
    [self.appDelegate.splitViewController viewWillDisappear:YES];
	NSMutableArray *viewControllerArray=[[NSMutableArray alloc] initWithArray:[[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] viewControllers]];
	[viewControllerArray removeLastObject];
	
    self.ucardDetailVC=[[NSiPadUCardDetailViewController alloc]init];
    [viewControllerArray addObject:self.ucardDetailVC];
    self.appDelegate.splitViewController.delegate = (id)self.ucardDetailVC;
    
    
    
    [[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] setViewControllers:viewControllerArray animated:NO];
	[self.appDelegate.splitViewController viewWillAppear:YES];
}


@end
