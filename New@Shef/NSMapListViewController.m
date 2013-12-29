//
//  NSMapListViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 06/09/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSMapListViewController.h"
#import "NSOverViewViewController.h"

@interface NSMapListViewController ()

@end

@implementation NSMapListViewController

NSString *serverVersion;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    if ([self connectedToNetwork] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    }
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellBuilding";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    GoogleMap *marker = [[GoogleMap alloc]init];
    marker = [insideCollection objectAtIndex:indexPath.row];
    cell.textLabel.text = marker.title;
    cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    return cell;
}

-(CGFloat)getLabelHeightForText:(NSString *)text andWidth:(CGFloat)labelWidth
{
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text
                                                                        attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleGothic" size:15.0f]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){labelWidth, 9999}
                                               options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    if (rect.size.height <= 50.f) {
        return 50.f;
    }
    else
    {
        return rect.size.height+1.f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoogleMap *marker = [[GoogleMap alloc]init];
    marker = [insideCollection objectAtIndex:indexPath.row];
    NSString *string = marker.title;
    string = [string stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    CGFloat textHeight = [self getLabelHeightForText:string andWidth:self.view.frame.size.width/10*9];
    
    return textHeight;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showOverview"])
    {
        NSOverViewViewController *viewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];;
        GoogleMap *map = [[GoogleMap alloc]init];
        map = [insideCollection objectAtIndex:indexPath.row];
        NSString *lat = map.latitude;
        NSString *lon = map.longitude;
        NSString *title = map.title;
        NSString *snippet = map.snippet;
        
        viewController.lon = lon;
        viewController.lat = lat;
        viewController.title = title;
        viewController.title = [viewController.title stringByReplacingOccurrencesOfString :@"+" withString:@" "];
        viewController.snippet = snippet;
        viewController.snippet = [viewController.snippet stringByReplacingOccurrencesOfString :@"+" withString:@" "];
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
