//
//  NSOverViewViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 28/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSOverViewViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface NSOverViewViewController()
{
    GMSMapView *mapView_;
}

@end

@implementation NSOverViewViewController
@synthesize lat, lon, titlet, snippet;

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
    UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"Map";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:30.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
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
    if ([self connectedToNetwork] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
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
        marker.title = titlet;
        marker.title = [marker.title stringByReplacingOccurrencesOfString :@"+" withString:@" "];
        marker.snippet = snippet;
        marker.snippet = [marker.snippet stringByReplacingOccurrencesOfString :@"+" withString:@" "];
        marker.map = mapView_;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        exit(-1);
    }
}

- (BOOL) connectedToNetwork
{
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://google.co.uk"] encoding:NSUTF8StringEncoding error:nil];
    return (connect!=NULL)?YES:NO;
}

@end