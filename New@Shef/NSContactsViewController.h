//
//  NSContactsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 13/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ExpandableTableViewController.h"
#import "VersionControl.h"
#import <MessageUI/MessageUI.h>

#define GETFaculty @"http://54.213.22.84/getFaculty.php"
#define GETDepartment @"http://54.213.22.84/getDepartment.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"

@interface NSContactsViewController : ExpandableTableViewController <ExpandableTableViewDataSource,                                  ExpandableTableViewDelegate>
{
    NSMutableArray *jsonDepartment;
    NSMutableArray *jsonFaculty;
    NSMutableArray *jsonVersion;
    NSMutableArray *collectionDepartment;
    NSMutableArray *collectionFaculty;
    VersionControl *modelVersionControl;
 
}


/*
@property (strong) NSMutableArray *dataModel; // department collection
@property (nonatomic, strong) NSDictionary *contacts;
@property (nonatomic, strong) NSArray *faculties; // faculty
*/
@end