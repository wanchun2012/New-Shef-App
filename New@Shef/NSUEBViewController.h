//
//  NSUEBViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 18/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ExpandableTableViewController.h"
#import "VersionControl.h"

#define GETUEB @"http://54.213.22.84/getUEB.php"
#define GETSUBUEB @"http://54.213.22.84/getUEBSub.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"
#define GETDescription @"http://54.213.22.84/getUEBDescription.php?id=%d"
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
@interface NSUEBViewController : ExpandableTableViewController <ExpandableTableViewDataSource,
                                        ExpandableTableViewDelegate>
{     
    NSMutableArray *jsonUEB;
    NSMutableArray *jsonUEBSub;
    NSMutableArray *jsonVersion;
    NSMutableArray *collectionUEB;
    NSMutableArray *collectionUEBSub;
    VersionControl *modelVersionControl;
    
    UIActivityIndicatorView *activityIndicator;
}

@end