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
@class NSiPadUCardDetailViewController;
@interface NSiPadUCardViewController : UIViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationBarDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate> 
{
    
    UIPopoverController *popoverController;
    NSiPadUCardDetailViewController *ucardDetailVC;
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;

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
