//
//  NSInsideViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "GoogleMap.h"
#import "VersionControl.h"

#define GETUrl @"http://54.213.22.84/getGoogleMap.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"

@interface NSInsideViewController : UITableViewController
{
    NSMutableArray *jsonGoogleMap;
    NSMutableArray *jsonVersion;
    NSMutableArray *collection;
    NSMutableArray *insideCollection;
    VersionControl *modelVersionControl;
}

@end
