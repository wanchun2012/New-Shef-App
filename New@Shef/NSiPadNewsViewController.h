//
//  NSiPadNewsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 21/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
#define UniRSS @"http://www.sheffield.ac.uk/cmlink/1.178033"
@class NSiPadNewsContentViewController;

@interface NSiPadNewsViewController : UITableViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate,NSXMLParserDelegate>
{
    UIPopoverController *popoverController;
    NSiPadNewsContentViewController *newsContentVC;
   
    UIActivityIndicatorView *activityIndicator;
    
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) NSiPadNewsContentViewController *newsContentVC;


@end
