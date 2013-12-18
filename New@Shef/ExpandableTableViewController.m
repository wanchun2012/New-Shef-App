//
//  ExpandableTableViewController.h
//  ExpandableTableView
//
//  Created by Tom Fewster on 02/04/2012.
//
//  Reference: 1. ExpandableTableView
//  https://github.com/wannabegeek/ExpandableTableView
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