//
//  NSiPadYoutubeViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 21/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"

@class NSiPadFacebookViewController;
@class NSiPadTwitterViewController;

@interface NSiPadYoutubeViewController : UIViewController<UITabBarControllerDelegate, UIPopoverControllerDelegate, UISplitViewControllerDelegate>
{
    UIPopoverController *popoverController;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSiPadFacebookViewController *facebookVC;
    NSiPadTwitterViewController *twitterVC;
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;

@property (strong, nonatomic) IBOutlet UIWebView *webview;

@property (nonatomic, retain) NSiPadFacebookViewController *facebookVC;
@property (nonatomic, retain) NSiPadTwitterViewController *twitterVC;

-(IBAction) selectFacebook;
-(IBAction) selectTwitter;


@end




