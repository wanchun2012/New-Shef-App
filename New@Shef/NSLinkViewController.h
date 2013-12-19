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

#define GETUrl @"http://54.213.22.84/getLink.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"

@interface NSLinkViewController : UITableViewController
{
    NSMutableArray *jsonLink;
    NSMutableArray *jsonVersion;
    NSMutableArray *collection;
    VersionControl *modelVersionControl;
    
    UIActivityIndicatorView *activityIndicator;
}

@end
