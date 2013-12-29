//
//  NSOverViewViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 28/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
@interface NSOverViewViewController : UIViewController

@property (strong, nonatomic) NSString *lon;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *snippet;
@end
