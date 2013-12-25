//
//  NSiPadUCardDetailViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 23/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
@class NSiPadUCardViewController;

@interface NSiPadUCardDetailViewController : UIViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate>
{
    
    UIPopoverController *popoverController;
    UIActivityIndicatorView *activityIndicator;
    NSiPadUCardViewController *ucardVC;
    
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;

@property (weak, nonatomic) IBOutlet UIWebView *website;
@property (nonatomic, retain) NSiPadUCardViewController *ucardVC;
@end
