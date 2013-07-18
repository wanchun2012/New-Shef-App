//
//  NSContactsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 13/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ExpandableTableViewController.h"

@interface NSContactsViewController : ExpandableTableViewController <ExpandableTableViewDataSource, ExpandableTableViewDelegate>

@property (strong) NSMutableArray *dataModel;
@property (nonatomic, strong) NSDictionary *contacts;
@property (nonatomic, strong) NSArray *faculties;

@end