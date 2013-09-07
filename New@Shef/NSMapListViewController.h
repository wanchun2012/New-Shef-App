//
//  NSMapListViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 06/09/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "GoogleMap.h"
#import "VersionControl.h"

#define GETUrl @"http://newshef.co.uk/db/getGoogleMap.php"
#define GETVersion @"http://newshef.co.uk/db/getVersionControl.php"

@interface NSMapListViewController : UITableViewController
{
    NSMutableArray *jsonGoogleMap;
    NSMutableArray *jsonVersion;
    NSMutableArray *collection;
    NSMutableArray *insideCollection;
    VersionControl *modelVersionControl;
}

@end