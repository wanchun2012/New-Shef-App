//
//  NSTwitterViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 11/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSTwitterViewController.h"

@interface NSTwitterViewController ()

@end

@implementation NSTwitterViewController
@synthesize webview;
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSString *url = @"https://twitter.com/Sheffunistaff";
    NSString *urlString = [url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *myURL = [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webview loadRequest:request];
    self.webview.scalesPageToFit = YES;
    self.webview.frame=self.view.bounds;
}

 

@end
