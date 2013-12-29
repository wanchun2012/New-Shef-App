//
//  NSiPadInsideViewController.h
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
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
@class NSiPadMapViewController;
@class NSiPadMapListViewController;
@interface NSiPadInsideViewController : UIViewController  <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
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
