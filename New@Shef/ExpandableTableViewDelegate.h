//
//  ExpandableTableViewDelegate.h
//  New@Shef
//
//  Created by Wanchun Zhang on 18/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExpandableTableView;

@protocol ExpandableTableViewDelegate <NSObject>

@optional
- (void)tableView:(ExpandableTableView *)tableView willExpandSection:(NSUInteger)section;
- (void)tableView:(ExpandableTableView *)tableView didExpandSection:(NSUInteger)section;
- (void)tableView:(ExpandableTableView *)tableView willContractSection:(NSUInteger)section;
- (void)tableView:(ExpandableTableView *)tableView didContractSection:(NSUInteger)section;

- (BOOL)tableView:(ExpandableTableView *)tableView canRemoveSection:(NSUInteger)section;


- (NSInteger)tableView:(ExpandableTableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(ExpandableTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(ExpandableTableView *)tableView willDisplayCell:(UITableViewCell *)cell forSection:(NSUInteger)section;


- (NSIndexPath *)tableView:(ExpandableTableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(ExpandableTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)tableView:(ExpandableTableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(ExpandableTableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;


@end

