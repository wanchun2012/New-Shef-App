//
//  NSiPadUEBViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
#import "VersionControl.h"

#define GETUEB @"http://54.213.22.84/getUEB.php"
#define GETSUBUEB @"http://54.213.22.84/getUEBSub.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"
#define GETDescription @"http://54.213.22.84/getUEBDescription.php?id=%d"

@class NSiPadUEBDetailViewController;
@interface NSiPadUEBViewController : UITableViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate>
{
    
    UIPopoverController *popoverController;
    
    
    NSMutableArray *jsonUEB;
    NSMutableArray *jsonUEBSub;
    NSMutableArray *jsonVersion;
    NSMutableArray *collectionUEB;
    NSMutableArray *collectionUEBSub;
    VersionControl *modelVersionControl;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSiPadUEBDetailViewController *uebDetailVC;

    
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;

@property (nonatomic, retain) NSiPadUEBDetailViewController *uebDetailVC;

@end
