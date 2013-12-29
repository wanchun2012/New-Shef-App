//
//  NSNewsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UniRSS @"http://www.sheffield.ac.uk/cmlink/1.178033"
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
@interface NSNewsViewController : UIViewController <NSXMLParserDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
