//
//  NSWebsiteViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSWebsiteViewController : UIViewController
{
    UIActivityIndicatorView *activityIndicator;
}

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end
