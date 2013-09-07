//
//  NSLinkViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Link.h"
#import "VersionControl.h"  

#define GETUrl @"http://newshef.co.uk/db/getLink.php"
#define GETVersion @"http://newshef.co.uk/db/getVersionControl.php"

@interface NSLinkViewController : UITableViewController
{
    NSMutableArray *jsonLink;
    NSMutableArray *jsonVersion;
    NSMutableArray *collection;
    VersionControl *modelVersionControl;
}

@end
