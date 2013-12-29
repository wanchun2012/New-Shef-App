//
//  NSUCardDetailViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 10/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
@interface NSUCardDetailViewController : UIViewController
{
    UIActivityIndicatorView *activityIndicator;
}

@property (weak, nonatomic) IBOutlet UIWebView *website;

@end
