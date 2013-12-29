//
//  NSiPadUEBDetailViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
@class NSiPadUEBViewController;

@interface NSiPadUEBDetailViewController : UIViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate>
{
    
    UIPopoverController *popoverController;
    UIActivityIndicatorView *activityIndicator;
    NSiPadUEBViewController *uebVC;

}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (strong) NSString *txtName;
@property (strong) NSString *txtUrl;
@property (strong) NSString *txtRole;
@property (strong) NSString *txtDescription;
@property (strong) NSString *txtStatus;
@property (strong) NSString *txtType;
@property (strong) NSString *uebId;
 
@property (nonatomic, retain) NSiPadUEBViewController *uebVC;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
