//
//  NSiPadRootViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 21/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSiPadRootViewController.h"
#import "NSiPadWelcomeViewController.h"
#import "NSiPadNewsViewController.h"
#import "NSiPadMapViewController.h"
#import "NSiPadFacebookViewController.h"
#import "NSiPadUCardViewController.h"
#import "NSiPadUEBViewController.h"
#import "NSiPadChecklistViewController.h"
#import "NSiPadContactsViewController.h"
#import "NSiPadFAQsViewController.h"
#import "NSiPadLinkViewController.h"
#import "NSiPadTermsViewController.h"

#import "NSAppDelegate.h"
@interface NSiPadRootViewController ()

@end

@implementation NSiPadRootViewController
@synthesize appDelegate, welcomeVC, newsVC, facebookVC, mapVC, uebVC, checklistVC, contactsVC, linkVC, faqVC,ucardVC,termsVC;

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
	self.appDelegate = (NSAppDelegate *)[[UIApplication sharedApplication] delegate];
	//self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320.0, 600.0) style:UITableViewStyleGrouped];
	self.title=@"Menu";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
 
    return 11;
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSLog(@"hello we are working on table cells");
    // Configure the cell.
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Welcome Talk";
    }
    else if(indexPath.row == 1) {
        cell.textLabel.text = @"News";
    }
    else if (indexPath.row== 2) {
        cell.textLabel.text = @"Map";
    }
    else if (indexPath.row == 3){
        cell.textLabel.text = @"Social";
    }
    else if (indexPath.row == 4){
        cell.textLabel.text = @"UCard";
    }

    else if (indexPath.row == 5){
        cell.textLabel.text = @"UEB";
    }
    else if (indexPath.row == 6){
        cell.textLabel.text = @"Checklist";
    }
    else if (indexPath.row == 7){
        cell.textLabel.text = @"Contacts";
    }
    else if (indexPath.row == 8){
        cell.textLabel.text = @"FAQ";
    }
    else if (indexPath.row == 9){
        cell.textLabel.text = @"Link";
    }
    else{
        cell.textLabel.text = @"Terms and Conditions";
    }
        
        NSLog(@"hello we are working on table cells");
    return cell;
}
 
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     */
	NSUInteger row = indexPath.row;
    [self.appDelegate.splitViewController viewWillDisappear:YES];
	NSMutableArray *viewControllerArray=[[NSMutableArray alloc] initWithArray:[[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] viewControllers]];
	[viewControllerArray removeLastObject];
	
    
    if (row == 0)
    {
		self.welcomeVC=[[NSiPadWelcomeViewController alloc] init];
		[viewControllerArray addObject:self.welcomeVC];
		self.appDelegate.splitViewController.delegate = (id)self.welcomeVC;
	}
	
    if (row == 1)
    {
		self.newsVC=[[NSiPadNewsViewController alloc]init];
		[viewControllerArray addObject:self.newsVC];
		self.appDelegate.splitViewController.delegate = (id)self.newsVC;
    }
    
    if (row == 2)
    {
        self.mapVC=[[NSiPadMapViewController alloc]init];
		[viewControllerArray addObject:self.mapVC];
		self.appDelegate.splitViewController.delegate = (id)self.mapVC;
    }
    
    
    if (row == 3)
    {
		self.facebookVC=[[NSiPadFacebookViewController alloc]init];
		[viewControllerArray addObject:self.facebookVC];
		self.appDelegate.splitViewController.delegate = (id)self.facebookVC;
    }
    
    if (row == 4)
    {
		self.ucardVC=[[NSiPadUCardViewController alloc]init];
		[viewControllerArray addObject:self.ucardVC];
		self.appDelegate.splitViewController.delegate = (id)self.ucardVC;
    }
    
    if (row == 5) {
        self.uebVC=[[NSiPadUEBViewController alloc]init];
		[viewControllerArray addObject:self.uebVC];
		self.appDelegate.splitViewController.delegate = (id)self.uebVC;
    }
    
    if (row == 6) {
        self.checklistVC=[[NSiPadChecklistViewController alloc]init];
		[viewControllerArray addObject:self.checklistVC];
		self.appDelegate.splitViewController.delegate = (id)self.checklistVC;
    }
    

    
    if (row == 7) {
        self.contactsVC=[[NSiPadContactsViewController alloc]init];
		[viewControllerArray addObject:self.contactsVC];
		self.appDelegate.splitViewController.delegate = (id)self.contactsVC;
    }

    
    if (row == 8) {
        self.faqVC=[[NSiPadFAQsViewController alloc]init];
		[viewControllerArray addObject:self.faqVC];
		self.appDelegate.splitViewController.delegate = (id)self.faqVC;
    }
    
    if (row == 10) {
        self.termsVC=[[NSiPadTermsViewController alloc]init];
		[viewControllerArray addObject:self.termsVC];
		self.appDelegate.splitViewController.delegate = (id)self.termsVC;
    }
	
    if (row == 9) {
        self.linkVC=[[NSiPadLinkViewController alloc]init];
		[viewControllerArray addObject:self.linkVC];
		self.appDelegate.splitViewController.delegate = (id)self.linkVC;
    }
    [[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] setViewControllers:viewControllerArray animated:NO];
	
	
	[self.appDelegate.splitViewController viewWillAppear:YES];
	 
	 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end

