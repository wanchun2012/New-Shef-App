//
//  NSOverViewViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 28/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSOverViewViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface NSOverViewViewController ()
{
    GMSMapView *mapView_;
}

@end

@implementation NSOverViewViewController
@synthesize lat, lon, title, snippet;

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
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
	// Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadView
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:53.381309
                                                            longitude:-1.484587
                                                                 zoom:15];
    mapView_.accessibilityElementsHidden = YES;
    mapView_.indoorEnabled = YES;
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.mapType = kGMSTypeNormal;
    mapView_.accessibilityElementsHidden = YES;
    mapView_.myLocationEnabled = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton =YES;
    mapView_.buildingsEnabled = YES;
    mapView_.indoorEnabled = YES;
    
    self.view = mapView_;
    
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
    marker.position = CLLocationCoordinate2DMake([lat floatValue],[lon floatValue]);
    marker.title = title;
    marker.title = [marker.title stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    marker.snippet = snippet;
    marker.snippet = [marker.snippet stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    marker.map = mapView_;
    
    
}

@end