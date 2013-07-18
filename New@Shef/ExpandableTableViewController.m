//
//  ExpandableTableViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 18/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "ExpandableTableViewController.h"
#import "ExpandableTableView.h"

@implementation ExpandableTableViewController

- (ExpandableTableView *)tableView {
	if (![super.tableView isKindOfClass:[ExpandableTableView class]]) {
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Received invalid tableView, was expecting an instance of ExpandableTableView" userInfo:nil];
	}
	return (ExpandableTableView *)super.tableView;
}

- (void)setTableView:(ExpandableTableView *)tableView {
	if (![tableView isKindOfClass:[ExpandableTableView class]]) {
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Expecting class of type ExpandableTableView" userInfo:nil];
	}
	[super setTableView:tableView];
}

@end