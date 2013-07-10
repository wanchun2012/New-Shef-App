//
//  NSHomeViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSHomeViewController.h"

@interface NSHomeViewController ()

@end

@implementation NSHomeViewController
 

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
    [super viewDidLoad];

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    // Return the number of rows in the section.
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NewsCellIdentifier = @"NewsCell";
    static NSString *GoogleMapCellCellIdentifier = @"GoogleMapCell";
    static NSString *SocialCellIdentifier = @"SocialCell";
    static NSString *ChecklistCellIdentifier = @"ChecklistCell";
    static NSString *UCardCellIdentifier = @"UCardCell";
    static NSString *StructureCellIdentifier = @"StructureCell";
    static NSString *ContactsCellIdentifier = @"ContactsCell";
    static NSString *UsefulLinksCellIdentifier = @"UsefulLinksCell";
    static NSString *FAQsCellIdentifier = @"FAQsCell";
    UITableViewCell *cell;
        
    // Configure the cell...
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"News";
    }
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:GoogleMapCellCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"Google Map";
    }
    else if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:SocialCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"Social";
    }
    else if (indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:ChecklistCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"Check list";
    }
    else if (indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:UCardCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"UCard";
    }
    else if (indexPath.row == 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:StructureCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"Structure";
    }
    else if (indexPath.row == 6) {
        cell = [tableView dequeueReusableCellWithIdentifier:ContactsCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"Contacts";
    }
    else if (indexPath.row == 7) {
        cell = [tableView dequeueReusableCellWithIdentifier:UsefulLinksCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"Useful links";
    }
    else if (indexPath.row == 8) {
        cell = [tableView dequeueReusableCellWithIdentifier:FAQsCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"FAQs";
    }
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

@end
