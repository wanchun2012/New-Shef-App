//
//  NSUCardViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
//#define UCardEmail @"hr-enq@sheffield.ac.uk"
#define UCardEmail @"wanchun.zhang2012@gmail.com"
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
#define UCARDEMAILMSG @"Hello this is the photo for ucard"
#define UCARDEMAILSUBJECT @"New@Shef:ucard"
#define NOEMAILTITLE @"No email account"
#define NOEMAILMSG @"Do you want exit app and login one email account now?"
#define NOPHOTOTITLE @"No photo exists"
#define NOPHOTOMSG @"Please, take a photo or choose from library before submit."

@interface NSUCardViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationBarDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendbutton;
@property (strong, nonatomic) UIImagePickerController *picker1;
@property (strong, nonatomic) UIImagePickerController *picker2;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageCard;

@property (weak, nonatomic) IBOutlet UILabel *tvLineOne;
@property (weak, nonatomic) IBOutlet UILabel *tvLineTwo;
@property (weak, nonatomic) IBOutlet UILabel *tvLineThree;
@property (weak, nonatomic) IBOutlet UILabel *tvLineFour;
@property (weak, nonatomic) IBOutlet UILabel *tvLineFive;

@property (weak, nonatomic) IBOutlet UIButton *btnTake;

@property (weak, nonatomic) IBOutlet UIButton *btnChoose;

@property (weak, nonatomic) IBOutlet UIButton *btnLink;

- (IBAction) TakePhoto;
- (IBAction) ChoosePhoto;
- (IBAction) SendEmail;
@end
