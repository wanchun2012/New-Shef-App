//
//  NSiPadMapViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 21/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
@class NSiPadInsideViewController;
@class NSiPadMapListViewController;

@interface NSiPadMapViewController : UIViewController<UITabBarControllerDelegate, UIPopoverControllerDelegate, UISplitViewControllerDelegate>
{
    
    UIPopoverController *popoverController;
    NSiPadInsideViewController *insideVC;
    NSiPadMapListViewController *overviewVC;
    UIActivityIndicatorView *activityIndicator;

    
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnInside;
@property (strong, nonatomic) IBOutlet UIButton *btnOverview;

@property (nonatomic, retain) NSiPadInsideViewController *insideVC;
@property (nonatomic, retain) NSiPadMapListViewController *overviewVC;

-(IBAction)selectInside;
-(IBAction)selectOverview;

@end
