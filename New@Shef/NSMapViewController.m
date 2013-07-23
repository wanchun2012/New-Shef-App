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

@implementation NSMapViewController {
    GMSMapView *mapView_;
    GMSPanoramaView *panoView_;
}



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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;
}

- (void)loadView {
    /*
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:53.381309
                                                            longitude:-1.484587
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(53.381309, -1.484587);
    marker.title = @"The University of Sheffield";
    marker.snippet = @"UK";
    marker.map = mapView_;
    */
    panoView_ = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];
    self.view = panoView_;
    
    [panoView_ moveNearCoordinate:CLLocationCoordinate2DMake(-33.732, 150.312)];
}

@end
