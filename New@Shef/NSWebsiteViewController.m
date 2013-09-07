//
//  NSWebsiteViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSWebsiteViewController.h"

@interface NSWebsiteViewController ()

@end

@implementation NSWebsiteViewController
@synthesize webview, url;

- (void)viewDidLoad
{
    NSString *urlString = [self.url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *myURL = [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webview loadRequest:request];
    self.webview.scalesPageToFit = YES;
    self.webview.frame=self.view.bounds;
}

@end
