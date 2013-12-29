//
//  NSiPadTwitterViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 21/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
@class NSiPadFacebookViewController;
@class NSiPadYoutubeViewController;

@interface NSiPadTwitterViewController : UIViewController<UITabBarControllerDelegate, UIPopoverControllerDelegate, UISplitViewControllerDelegate>
{
    UIPopoverController *popoverController;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSiPadFacebookViewController *facebookVC;
    NSiPadYoutubeViewController *youtubeVC;
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnYoutube;

@property (strong, nonatomic) IBOutlet UIWebView *webview;

@property (nonatomic, retain) NSiPadFacebookViewController *facebookVC;
@property (nonatomic, retain) NSiPadYoutubeViewController *youtubeVC;

-(IBAction) selectFacebook;
-(IBAction) selectYoutube;

@end
