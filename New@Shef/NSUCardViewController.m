//
//  NSUCardViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "NSUCardViewController.h"
 
#define SOURCETYPE UIImagePickerControllerSourceTypeCamera
@interface NSUCardViewController ()

@end

@implementation NSUCardViewController
@synthesize sendbutton, tvLineFour, tvLineOne, tvLineThree, tvLineTwo, tvLineFive, btnChoose, btnLink, btnTake;
- (IBAction)TakePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:SOURCETYPE]) {
    self.picker1 = [[UIImagePickerController alloc] init];
    self.picker1.delegate = self;
    [self.picker1 setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:self.picker1 animated:YES completion:NULL];
    //[picker1 relsease];
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOCAMERATITLE message:NOCAMERAMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:@"Wait later", nil];
        [alert show];
    }
}

- (IBAction)ChoosePhoto
{
    self.picker2 = [[UIImagePickerController alloc] init];
    self.picker2.delegate = self;
    [self.picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.picker2 animated:YES completion:NULL];
    //[picker2 relsease];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = self.image;
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.imageCard addSubview:self.imageView];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)SendEmail
{
    if ([self connectedToNetwork] == NO)
    {
 
        btnChoose.enabled = NO;
        btnTake.enabled = NO;
        btnLink.enabled = NO;
        
        
        btnChoose.tintColor = [UIColor grayColor];
        btnLink.tintColor = [UIColor grayColor];
        btnTake.tintColor = [UIColor grayColor];
        sendbutton.tintColor = [UIColor grayColor];
        
    }
    else
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
                
                mailController.navigationBar.tintColor = [UIColor blackColor];
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
    UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"UCard";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:30.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    tvLineOne.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    tvLineTwo.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    tvLineThree.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    tvLineFour.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    tvLineFive.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    
    btnTake.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    btnChoose.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    btnLink.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    
    if ([self connectedToNetwork] == NO)
    {
      
        btnChoose.enabled = NO;
        btnTake.enabled = NO;
        btnLink.enabled = NO;
        sendbutton.enabled = NO;
        
        
        btnChoose.tintColor = [UIColor grayColor];
        btnLink.tintColor = [UIColor grayColor];
        btnTake.tintColor = [UIColor grayColor];
        sendbutton.tintColor = [UIColor grayColor];
        
    }
    else
    {
        btnChoose.enabled = YES;
        btnTake.enabled = YES;
        btnLink.enabled = YES;
        sendbutton.enabled = YES;
        
        UIColor *iosBlue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        btnChoose.tintColor = iosBlue;
        btnLink.tintColor = iosBlue;
        btnTake.tintColor = iosBlue;
        sendbutton.tintColor = iosBlue;
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    BOOL result = NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    result = !(networkStatus==NotReachable);
    if (result == NO) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}
@end
