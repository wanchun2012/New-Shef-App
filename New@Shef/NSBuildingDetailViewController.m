//
//  NSBuildingDetailViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSBuildingDetailViewController.h"

@interface NSBuildingDetailViewController ()

@end

@implementation NSBuildingDetailViewController
@synthesize webview, lon, lat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *htmlString = [NSString stringWithFormat:@"<html>\
                            <head>\
                            <meta id=\"viewport\" name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\">\
                            <script src='http://maps.google.com/maps/api/js?sensor=false' type='text/javascript'></script>\
                            </head>\
                            <body onload=\"new google.maps.StreetViewPanorama(document.getElementById('p'),{position:new google.maps.LatLng(%f, %f)});\" style='padding:0px;margin:0px;'>\
                            <div id='p' style='height:460;width:320;'></div>\
                            </body>\
                            </html>",[lat floatValue], [lon floatValue]];
    
    [webview loadHTMLString:htmlString baseURL:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
