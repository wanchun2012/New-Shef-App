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
    self.navigationController.navigationBar.translucent = NO;
    if ([self connectedToNetwork] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet, please try later?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    } else {
 
    [self getVersionWebService];
    modelVersionControl = [[VersionControl alloc] init];
    [modelVersionControl initDB];
    [modelVersionControl selectData];
    
    collection = [[NSMutableArray alloc] init];
    insideCollection = [[NSMutableArray alloc] init];
    
    if ([modelVersionControl.vGoogleMap isEqualToString: @"0"])
    {
        // initialize welcometalk
        NSLog(@"NSOverViewViewController: %s","initialize GOOGLEMAP");
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
            NSLog(@"NSOverViewViewController: %s","fetch from GOOGLEMAP(sqlite)");
            GoogleMap *googleMap = [[GoogleMap alloc] init];
            [googleMap initDB];
            collection = [[googleMap selectData] mutableCopy];
        }
        else
        {
            // load data from mysql database
            // update data in sqlite database
            NSLog(@"NSOverViewViewController: %s","fetch from GOOGLEMAP(Web database)");
            [self loadDataFromWebService];
            
            int first = 0;
            for (GoogleMap * object in collection) {
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
    }
    

    
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showOverview"]) {
        
        
        
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


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //  exit(-1); // no
    }
    if(buttonIndex == 1)
    {
        exit(-1); // yes
    }
    
}
- (BOOL) connectedToNetwork
{
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://google.co.uk"] encoding:NSUTF8StringEncoding error:nil];
    return (connect!=NULL)?YES:NO;
}

@end
