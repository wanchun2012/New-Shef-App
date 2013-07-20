//
//  NSToDosViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 20/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSToDosViewController : UIViewController

@property (nonatomic,assign) int index;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *starterChecklist;
@end
