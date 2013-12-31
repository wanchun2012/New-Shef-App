//
//  NSiPadMapListViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSiPadMapViewController.h"
#import "NSiPadMapListViewController.h"
#import "NSiPadInsideViewController.h"
#import "NSiPadRootViewController.h"

#import <GoogleMaps/GoogleMaps.h>
@interface NSiPadMapListViewController ()
{
    GMSMapView *mapView_;
}

@end

@implementation NSiPadMapListViewController

@synthesize appDelegate, popoverController,tableView;
NSString *serverVersion;
NSString *lonDetail;
NSString *latDetail;
NSString *titleDetail;
NSString *snippetDetail;
UIBarButtonItem *btnBack;
UIView *temp;
UIView *backup;
 
-(id) init {
	if (self=[super init]) {
		//self.appDelegate = (NSAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	return self;
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
	barButtonItem.title = @"Menu";
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
	[self setPopoverController:pc];
	self.appDelegate.rootPopoverButtonItem = barButtonItem;
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
    
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	[[self navigationItem] setLeftBarButtonItem:nil];
	[self setPopoverController:nil];
	self.appDelegate.rootPopoverButtonItem = barButtonItem;
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[self navigationItem] setLeftBarButtonItem:nil];
	}
	else {
		[[self navigationItem] setLeftBarButtonItem:self.appDelegate.rootPopoverButtonItem];
	}
	return YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.popoverController = nil;
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
    [super viewWillAppear:animated];
	UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"Map-Overview";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:20.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    btnBack = [[UIBarButtonItem alloc]
               initWithTitle:@"< Back"
               style:UIBarButtonItemStyleBordered
               target:self
               action:@selector(goBack)];
    btnBack.tintColor = nevBarColor;
    btnBack.enabled = NO;
    self.navigationItem.leftBarButtonItem = btnBack;
    
    if ([self connectedToNetwork]==YES)
    {
        [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    }
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backgroundThread
{
    self.tableView.separatorStyle = NO;
    NSLog(@"NSMapListViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
    
 
    [self getVersionWebService];
    modelVersionControl = [[VersionControl alloc] init];
    [modelVersionControl initDB];
    [modelVersionControl selectData];
    
    collection = [[NSMutableArray alloc] init];
    insideCollection = [[NSMutableArray alloc] init];
    
    if ([modelVersionControl.vGoogleMap isEqualToString: @"0"])
    {
        // initialize welcometalk
        NSLog(@"NSMapListViewController: %s","initialize GOOGLEMAP");
        [self loadDataFromWebService];
        int first = 0;
        for (GoogleMap * object in collection)
        {
            [object initDB];
            if(first == 0)
            {
                [object clearData];
                first = 1;
            }
            
            [object saveData:object.googleMapId insideview:object.insideview latitude:object.latitude longitude:object.longitude title:object.title snippet:object.snippet];
        }
        [modelVersionControl initDB];
        [modelVersionControl updateData:@"versiongooglemap =:versiongooglemap" variable:@":versiongooglemap" data:serverVersion];
    }
    else
    {
        if ([modelVersionControl.vGoogleMap isEqualToString: serverVersion])
        {
            // sqlite db version is equal to mysql db version
            // get data from sqlite database
            NSLog(@"NSMapListViewController: %s","fetch from GOOGLEMAP(sqlite)");
            GoogleMap *googleMap = [[GoogleMap alloc] init];
            [googleMap initDB];
            collection = [[googleMap selectData] mutableCopy];
        }
        else
        {
            // load data from mysql database
            // update data in sqlite database
            NSLog(@"NSMapListViewController: %s","fetch from GOOGLEMAP(Web database)");
            [self loadDataFromWebService];
            
            int first = 0;
            for (GoogleMap * object in collection)
            {
                [object initDB];
                if(first == 0)
                {
                    [object clearData];
                    first = 1;
                }
                [object saveData:object.googleMapId insideview:object.insideview latitude:object.latitude longitude:object.longitude title:object.title snippet:object.snippet];
            }
            
            [modelVersionControl initDB];
            [modelVersionControl updateData:@"versiongooglemap =:versiongooglemap" variable:@":versiongooglemap" data:serverVersion];
        }
    }
    
    for (GoogleMap * object in collection)
    {
        [insideCollection addObject:object];
    }
    
    [self.tableView reloadData];
    [self performSelectorOnMainThread:@selector(mainThreadFinishing) withObject:nil waitUntilDone:NO];
    NSLog(@"NSMapListViewController: %s","backgroundThread finishing...");
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
    self.tableView.separatorStyle = YES;
}


-(void) getDataFromJson:(NSData *) data
{
    NSError *error;
    jsonGoogleMap = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

-(void) prepareForWebService
{
    for (int i=0; i<jsonGoogleMap.count; i++)
    {
        NSDictionary *info = [jsonGoogleMap objectAtIndex:i];
        
        int Id = [[info objectForKey:@"id"] intValue];
        int inside = [[info objectForKey:@"insideView"] intValue];
        
        NSString *lat = [info objectForKey:@"latitude"];
        NSString *lon = [info objectForKey:@"longitude"];
        NSString *s = [info objectForKey:@"snippet"];
        NSString *t = [info objectForKey:@"title"];
        GoogleMap *record = [[GoogleMap alloc]
                             initWithId:Id insideview:inside
                             latitude:lat longitude:lon title:t snippet:s];
        [collection addObject:record];
    }
}

-(void) loadDataFromWebService
{
    NSURL *url = [NSURL URLWithString:GETUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self getDataFromJson:data];
    [self prepareForWebService];
}

-(void) getVersionWebService
{
    NSURL *url = [NSURL URLWithString:GETVersion];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    jsonVersion = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary *info = [jsonVersion objectAtIndex:0];
    
    serverVersion = [info objectForKey:@"versionGoogleMap"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return insideCollection.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

-(CGFloat)getLabelHeightForText:(NSString *)text andWidth:(CGFloat)labelWidth
{
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text
                                                                        attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleGothic" size:15.0f]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){labelWidth, 10000}
                                               options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return rect.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoogleMap *marker = [[GoogleMap alloc]init];
    marker = [insideCollection objectAtIndex:indexPath.row];
    
    NSString *string = marker.title;
    string = [string stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    CGFloat textHeight = [self getLabelHeightForText:string andWidth:self.view.frame.size.width];//give your label width
    
    if (textHeight > 60.f)
    {
        return textHeight + 10.f;
    }
    else
    {
        return 60.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    GoogleMap *marker = [[GoogleMap alloc]init];
    marker = [insideCollection objectAtIndex:indexPath.row];
    cell.textLabel.text = marker.title;
    cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    cell.textLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.hidden = YES;
    //[self.tableView removeFromSuperview];

    GoogleMap *map = [[GoogleMap alloc]init];
    map = [insideCollection objectAtIndex:indexPath.row];
    latDetail = map.latitude;
    lonDetail = map.longitude;
    titleDetail = map.title;
    snippetDetail = map.snippet;
    
 
    titleDetail = [titleDetail stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    snippetDetail = [snippetDetail stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    btnBack.enabled = YES;
    UIColor *iosBlue = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    btnBack.tintColor = iosBlue;
    if ([self connectedToNetwork]==YES) {
    [self updateToView];
    }
}

- (void)updateToView
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
    backup = self.view;
    temp = mapView_;
    self.view = temp;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
    marker.position = CLLocationCoordinate2DMake([latDetail floatValue],[lonDetail floatValue]);
    marker.title = titleDetail;
    
    marker.snippet = snippetDetail;
    marker.map = mapView_;
}

-(void)goBack
{
    if ([self connectedToNetwork]==YES)
    {
        self.view = backup;
        self.tableView.hidden = NO;
        UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
        btnBack.tintColor = nevBarColor;
        btnBack.enabled = NO;
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
    if (connect==NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    return (connect!=NULL)?YES:NO;
}

@end
