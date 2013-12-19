//
//  NSMapViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 23/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface NSMapViewController ()

@end

@implementation NSMapViewController
{
    GMSMapView *mapView_;
    GMSPanoramaView *panoView_;
}
@synthesize webview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"Map";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor blackColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];

    [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    [super viewDidLoad];
}

-(void)backgroundThread
{
    NSLog(@"NSMapViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSString *urlAddress = @"http://maps.google.com/maps?q=The+University+of+Sheffield";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webview loadRequest:requestObj];
    [self performSelectorOnMainThread:@selector(mainThreadFinishing) withObject:nil waitUntilDone:NO];
    NSLog(@"NSMapViewController: %s","backgroundThread finishing...");
}

-(void)mainThreadStarting
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [activityIndicator startAnimating];
}

-(void)mainThreadFinishing
{
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskLandscape;
}

@end
