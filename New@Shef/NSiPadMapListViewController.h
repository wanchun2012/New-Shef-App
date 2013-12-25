//
//  NSiPadMapListViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
#import "sqlite3.h"
#import "GoogleMap.h"
#import "VersionControl.h"

#define GETUrl @"http://54.213.22.84/getGoogleMap.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"

@class NSiPadMapViewController;
@class NSiPadInsideViewController;

@interface NSiPadMapListViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

{
    
    UIPopoverController *popoverController;
    NSMutableArray *jsonGoogleMap;
    NSMutableArray *jsonVersion;
    NSMutableArray *collection;
    NSMutableArray *insideCollection;
    VersionControl *modelVersionControl;
    
    UIActivityIndicatorView *activityIndicator;
    
}

@property (nonatomic, assign) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;

@end
