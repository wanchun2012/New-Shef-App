//
//  NSBuildingDetailViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//
// Reference: 1. inside view
//           http://jingjong404.blogspot.co.uk/2013/09/webviewgoogle.html
//

#import "NSBuildingDetailViewController.h"

@interface NSBuildingDetailViewController ()

@end

@implementation NSBuildingDetailViewController
@synthesize webview, lon, lat;

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
    
    [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    [super viewDidLoad];
}

-(void)backgroundThread
{
    NSLog(@"NSBuildingDetailViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
    // Do any additional setup after loading the view.
    float height = self.view.frame.size.height;
    float width = self.view.frame.size.width;
    
    NSString *htmlString = [NSString stringWithFormat:@"<html>\
                            <head>\
                            <meta id=\"viewport\" name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\">\
                            <script src='http://maps.google.com/maps/api/js?sensor=false' type='text/javascript'></script>\
                            </head>\
                            <body onload=\"new google.maps.StreetViewPanorama(document.getElementById('p'),{position:new google.maps.LatLng(%f, %f)});\" style='padding:0px;margin:0px;'>\
                            <div id='p' style='height:%f;width:%f;'></div>\
                            </body>\
                            </html>",[lat floatValue], [lon floatValue],height,width];
    
    [webview loadHTMLString:htmlString baseURL:nil];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    sleep(1);
    [self performSelectorOnMainThread:@selector(mainThreadFinishing) withObject:nil waitUntilDone:NO];
    NSLog(@"NSBuildingDetailViewController: %s","backgroundThread finishing...");
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

@end
