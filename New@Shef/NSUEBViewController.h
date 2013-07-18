//
//  NSUEBViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 18/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ExpandableTableViewController.h"

@interface NSUEBViewController : ExpandableTableViewController <ExpandableTableViewDataSource, ExpandableTableViewDelegate>

@property (strong) NSMutableArray *dataModel;
@property (nonatomic, strong) NSDictionary *ueb;
@property (nonatomic, strong) NSArray *positions;
 
@end