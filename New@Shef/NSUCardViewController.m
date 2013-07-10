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
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)SendEmail
{
    MFMailComposeViewController *mailController = [[ MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    NSString *toEmail = @"decadentia0616@gmail.com";
    NSArray *emailArray = [[NSArray alloc]initWithObjects:toEmail, nil];
    NSString *message = @"hello this is the photo for ucard";
    [mailController setMessageBody:message isHTML:NO];
    [mailController setToRecipients:emailArray];
    [mailController setSubject:@"New@Shef:ucard"];
    NSData *imageData = UIImagePNGRepresentation(self.image);
    [mailController addAttachmentData:imageData mimeType:@"image/png" fileName:@"Name"];
    [self presentViewController:mailController animated:YES completion:nil];
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
