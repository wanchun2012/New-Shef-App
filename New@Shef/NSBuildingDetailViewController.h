//
//  NSBuildingDetailViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBuildingDetailViewController : UIViewController

@property (strong, nonatomic) NSString *lon;
@property (strong, nonatomic) NSString *lat;

@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end