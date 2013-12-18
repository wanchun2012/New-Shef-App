//
//  NSYoutubeViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 11/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSYoutubeViewController.h"

@interface NSYoutubeViewController ()

@end

@implementation NSYoutubeViewController

@synthesize webview;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSString *url = @"http://www.youtube.com/user/uniofsheffield";
    NSString *urlString = [url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *myURL = [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webview loadRequest:request];
    self.webview.scalesPageToFit = YES;
    self.webview.frame=self.view.bounds;
}

@end
