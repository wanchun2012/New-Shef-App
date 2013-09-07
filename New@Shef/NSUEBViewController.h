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

#define GETUEB @"http://newshef.co.uk/db/getUEB.php"
#define GETSUBUEB @"http://newshef.co.uk/db/getUEBSub.php"
#define GETVersion @"http://newshef.co.uk/db/getVersionControl.php"
#define GETDescription @"http://newshef.co.uk/db/getUEBDescription.php?id=%d"

@interface NSUEBViewController : ExpandableTableViewController <ExpandableTableViewDataSource,
                                        ExpandableTableViewDelegate>
{     
    NSMutableArray *jsonUEB;
    NSMutableArray *jsonUEBSub;
    NSMutableArray *jsonVersion;
    NSMutableArray *collectionUEB;
    NSMutableArray *collectionUEBSub;
    VersionControl *modelVersionControl;
    
}

@end