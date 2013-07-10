//
//  NSNewsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSNewsViewController : UIViewController <NSXMLParserDelegate>

 
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
