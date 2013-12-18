//
//  NSLinkViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSLinkViewController.h"
#import "NSWebsiteViewController.h"

@interface NSLinkViewController ()

@end

@implementation NSLinkViewController

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
    if ([self connectedToNetwork] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet, please try later?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    } else {
    
    [self getVersionWebService];
    modelVersionControl = [[VersionControl alloc] init];
    [modelVersionControl initDB];
    [modelVersionControl selectData];
    
    collection = [[NSMutableArray alloc] init];
 
    
    if ([modelVersionControl.vLink isEqualToString: @"0"])
    {
        // initialize welcometalk
        NSLog(@"NSLinkViewController: %s","initialize Link");
        [self loadDataFromWebService];
        int first = 0;
        for (Link * object in collection)
        {
            [object initDB];
            if(first == 0)
            {
                [object clearData];
                first = 1;
            }
            
            [object saveData:object.linkId description:object.description url:object.url];
        }
        [modelVersionControl initDB];
        [modelVersionControl updateData:@"versionlink =:versionlink" variable:@":versionlink" data:serverVersion];
    }
    else
    {
        if ([modelVersionControl.vLink isEqualToString: serverVersion])
        {
            // sqlite db version is equal to mysql db version
            // get data from sqlite database
            NSLog(@"NSLinkViewController: %s","fetch from Link(sqlite)");
            Link *link = [[Link alloc] init];
            [link initDB];
            collection = [[link selectData] mutableCopy];
        }
        else
        {
            // load data from mysql database
            // update data in sqlite database
            NSLog(@"NSLinkViewController: %s","fetch from Link(Web database)");
            [self loadDataFromWebService];
            
            int first = 0;
            for (Link * object in collection) {
                [object initDB];
                if(first == 0)
                {
                    [object clearData];
                    first = 1;
                }
                [object saveData:object.linkId description:object.description url:object.url];
            }
            
            [modelVersionControl initDB];
            [modelVersionControl updateData:@"versionlink =:versionlink" variable:@":versionlink" data:serverVersion];
        }
    }
    }
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
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
    jsonLink = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

-(void) prepareForWebService
{
    for (int i=0; i<jsonLink.count; i++)
    {
        NSDictionary *info = [jsonLink objectAtIndex:i];
        
        int Id = [[info objectForKey:@"id"] intValue];
        NSString *d = [info objectForKey:@"description"];
        NSString *u = [info objectForKey:@"url"];
        
        Link *record = [[Link alloc]
                             initWithId:Id description:d url:u];
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
    
    serverVersion = [info objectForKey:@"versionLink"];
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
    return collection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    Link *link = [[Link alloc]init];
    link = [collection objectAtIndex:indexPath.row];
    cell.textLabel.text = link.description;
    cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    return cell;
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
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showWebsite"])
    {
   
        NSWebsiteViewController *viewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];;
        Link *link = [[Link alloc]init];
        link = [collection objectAtIndex:indexPath.row];
        NSString *string = link.url;
        
        viewController.url = string;
        
    }
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
