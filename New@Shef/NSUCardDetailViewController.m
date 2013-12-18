//
//  NSUCardDetailViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 10/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSUCardDetailViewController.h"

@interface NSUCardDetailViewController ()

@end

@implementation NSUCardDetailViewController

@synthesize website;

- (void)viewDidLoad
{
    NSString *urlString = @"http://www.shef.ac.uk/cics/ucards/staff";
    NSURL *myURL = [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.website loadRequest:request];
    self.website.scalesPageToFit = YES;
    self.website.frame=self.view.bounds;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
}


@end
