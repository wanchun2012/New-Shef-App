//
//  NSiPadLinkViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
#import "sqlite3.h"
#import "Link.h"
#import "VersionControl.h"


#define GETVersion @"http://54.213.22.84/getVersionControl.php"
#define GETUrl @"http://54.213.22.84/getLink.php"
@class NSiPadWebsiteViewController;
@interface NSiPadLinkViewController : UITableViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate>
{
    
    UIPopoverController *popoverController;
    
    NSMutableArray *jsonLink;
    NSMutableArray *jsonVersion;
    NSMutableArray *collection;
    VersionControl *modelVersionControl;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSiPadWebsiteViewController *websiteVC;
    
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) NSiPadWebsiteViewController *websiteVC;

@end
