//
//  NSiPadUCardViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 23/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
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
#define NOPHOTOMSG @"Please, take a photo before submit."
#define NOCAMERATITLE @"No camera"
#define NOCAMERAMSG @"No camera exist, exit app and try on iPhone or iPad"
@class NSiPadUCardDetailViewController;
@interface NSiPadUCardViewController : UIViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationBarDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate> 
{
    
    UIPopoverController *popoverController;
    NSiPadUCardDetailViewController *ucardDetailVC;
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (weak, nonatomic) IBOutlet UILabel *tvOne;
@property (weak, nonatomic) IBOutlet UILabel *tvTwo;
@property (weak, nonatomic) IBOutlet UILabel *tvThree;
@property (weak, nonatomic) IBOutlet UIButton *btnLink;
@property (weak, nonatomic) IBOutlet UIButton *btnTake;

@property (strong, nonatomic) UIImagePickerController *picker1;
@property (strong, nonatomic) UIImagePickerController *picker2;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageCard;
@property (nonatomic, retain) NSiPadUCardDetailViewController *ucardDetailVC;
- (IBAction) TakePhoto;
//- (IBAction) ChoosePhoto;

- (IBAction)ucardInfo;

@end
