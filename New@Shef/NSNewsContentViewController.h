//
//  NSNewsContentViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSNewsContentViewController : UIViewController
{
    UIActivityIndicatorView *activityIndicator;
}

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end
