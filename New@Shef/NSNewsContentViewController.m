//
//  NSNewsContentViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSNewsContentViewController.h"

@interface NSNewsContentViewController ()

@end

@implementation NSNewsContentViewController

@synthesize webview, url;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *urlString = [self.url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *myURL = [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webview loadRequest:request];
    self.webview.scalesPageToFit = YES;
    self.webview.frame=self.view.bounds;
    
    //NSLog(url);
    
}

@end
