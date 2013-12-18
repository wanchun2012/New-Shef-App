//
//  NSUCardViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSUCardViewController.h"

@interface NSUCardViewController ()

@end

@implementation NSUCardViewController
@synthesize sendbutton;
- (IBAction)TakePhoto
{
    self.picker1 = [[UIImagePickerController alloc] init];
    self.picker1.delegate = self;
    [self.picker1 setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:self.picker1 animated:YES completion:NULL];
    //[picker1 relsease];
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

-(IBAction)SendEmail
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
    self.sendbutton.tintColor = [UIColor blueColor]; 
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
        //  exit(-1); // no
    }
    if(buttonIndex == 1)
    {
        exit(-1); // yes
    }
    
}
@end
