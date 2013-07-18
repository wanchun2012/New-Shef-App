//
//  ExpandableTableView.h
//  New@Shef
//
//  Created by Wanchun Zhang on 18/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandableTableViewDataSource.h"
#import "ExpandableTableViewDelegate.h"

@interface ExpandableTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

- (void)expandSection:(NSUInteger)section;
- (void)contractSection:(NSUInteger)section;

- (UITableViewCell *)cellForSection:(NSUInteger)section;
- (UITableViewCell *)cellForChildRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)cellVisibleForIndexPath:(NSIndexPath *)indexPath;

- (NSIndexSet *)indexesForExpandedSections;
- (void)reloadSectionCellsAtIndexes:(NSIndexSet *)indexes withRowAnimation:(UITableViewRowAnimation)animation;

@property (assign) BOOL ungroupSingleElement;

@end