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

@synthesize appDelegate, popoverController, ucardDetailVC, tvOne, tvTwo, tvThree, btnLink, btnTake;

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
 
 
	UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"UCard";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:20.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    tvOne.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    tvTwo.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    tvThree.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    
    btnTake.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    btnLink.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    
    UIBarButtonItem *btnEmail = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Email"
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(sendEmail)];
    btnEmail.tintColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = btnEmail;

    self.navigationController.navigationBar.tintColor = [UIColor blueColor];

    if ([self connectedToNetwork] == NO)
    {
 
     
        btnTake.enabled = NO;
        btnLink.enabled = NO;
     
        
        
 
        btnLink.tintColor = [UIColor grayColor];
        btnTake.tintColor = [UIColor grayColor];
     
        
    }
    else
    {
        btnTake.enabled = YES;
        btnLink.enabled = YES;
     
        
        UIColor *iosBlue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
      
        btnLink.tintColor = iosBlue;
        btnTake.tintColor = iosBlue;
        
    }


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
    if ([self connectedToNetwork] == YES)
    {
        if ([MFMailComposeViewController canSendMail]) {
            if(self.image == nil)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOPHOTOTITLE message:NOPHOTOMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                MFMailComposeViewController *mailController = [[ MFMailComposeViewController alloc]init];
                [mailController setMailComposeDelegate:self];
                NSString *toEmail = UCardEmail;
                NSArray *emailArray = [[NSArray alloc]initWithObjects:toEmail, nil];
                NSString *message = UCARDEMAILMSG;
                [mailController setMessageBody:message isHTML:NO];
                [mailController setToRecipients:emailArray];
                [mailController setSubject:UCARDEMAILSUBJECT];
                NSData *imageData = UIImagePNGRepresentation(self.image);
                [mailController addAttachmentData:imageData mimeType:@"image/png" fileName:@"Name"];
                [self presentViewController:mailController animated:YES completion:nil];
            }
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (![alertView.title isEqualToString:NOPHOTOTITLE])
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
