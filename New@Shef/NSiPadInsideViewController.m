//
//  NSiPadInsideViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//
#import "NSiPadMapViewController.h"
#import "NSiPadMapListViewController.h"
#import "NSiPadInsideViewController.h"
#import "NSiPadRootViewController.h"

@interface NSiPadInsideViewController ()

@end

@implementation NSiPadInsideViewController
@synthesize appDelegate, popoverController,tableView;

NSString *serverVersion;

NSString *latDetail;
NSString *lonDetail;
UIWebView *webview ;
UIBarButtonItem *btnBack;

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
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
    
	UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"Map-InsideView";
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
    NSLog(@"NSInsideViewController: %s","backgroundThread starting...");
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
        NSLog(@"NSInsideViewController: %s","initialize GOOGLEMAP");
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
            NSLog(@"NSInsideViewController: %s","fetch from GOOGLEMAP(sqlite)");
            GoogleMap *googleMap = [[GoogleMap alloc] init];
            [googleMap initDB];
            collection = [[googleMap selectData] mutableCopy];
        }
        else
        {
            // load data from mysql database
            // update data in sqlite database
            NSLog(@"NSInsideViewController: %s","fetch from GOOGLEMAP(Web database)");
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
        if (object.insideview == 1)
        {
            [insideCollection addObject:object];
        }
    }
    
    [self.tableView reloadData];
    [self performSelectorOnMainThread:@selector(mainThreadFinishing) withObject:nil waitUntilDone:NO];
    NSLog(@"NSInsideViewController: %s","backgroundThread finishing...");
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

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     */
    self.tableView.hidden = YES;
    //[self.tableView removeFromSuperview];

    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 1024,768)];
   
    GoogleMap *map = [[GoogleMap alloc]init];
    map = [insideCollection objectAtIndex:indexPath.row];
    latDetail = map.latitude;
    lonDetail = map.longitude;
    
 
    if ([self connectedToNetwork]==YES) {
        [NSThread detachNewThreadSelector:@selector(backgroundViewThread:) toTarget:self withObject:webview];
    }
}

-(void)backgroundViewThread:(UIWebView *)webview
{
    NSLog(@"NSBuildingDetailViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadViewStarting) withObject:nil waitUntilDone:NO];
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
                            </html>",[latDetail floatValue], [lonDetail floatValue],height,width];
    
    [webview loadHTMLString:htmlString baseURL:nil];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    sleep(1);
    [self performSelectorOnMainThread:@selector(mainThreadViewFinishing:) withObject:webview waitUntilDone:NO];
    NSLog(@"NSBuildingDetailViewController: %s","backgroundThread finishing...");
}

-(void)mainThreadViewStarting
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [activityIndicator startAnimating];
}

-(void)mainThreadViewFinishing:(UIWebView *)webview
{
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    [self.view addSubview:webview];
    btnBack.enabled = YES;
    btnBack.tintColor = [UIColor blueColor];
}

-(void) goBack
{
    if ([self connectedToNetwork]==YES)
    {
        [webview removeFromSuperview];
        self.tableView.hidden = NO;
        btnBack.enabled = NO;
        UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
        btnBack.tintColor = nevBarColor;
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
