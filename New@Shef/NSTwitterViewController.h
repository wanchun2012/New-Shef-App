//
//  NSTwitterViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 11/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"

@interface NSTwitterViewController : UIViewController
{
    UIActivityIndicatorView *activityIndicator;
}

@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end
