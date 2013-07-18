//
//  NSContactsViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 13/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSContactsViewController.h"
#import "NSContactDetailViewController.h"


@implementation NSContactsViewController

@synthesize dataModel, contacts, faculties;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *pFile = [[NSBundle mainBundle] pathForResource:@"pContactsList" ofType:@"plist"];
    contacts = [[NSDictionary alloc] initWithContentsOfFile:pFile];
    faculties = [[contacts allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
 
 
	 	
	dataModel = [[NSMutableArray alloc] initWithCapacity:[faculties count]];
    for(int i = 0; i<[faculties count]; i++)
    {
      [dataModel addObject:[[[contacts objectForKey:[faculties objectAtIndex:i]] allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (BOOL)ungroupSimpleElementsInTableView:(ExpandableTableView *)tableView {
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(ExpandableTableView *)tableView
{
    // Return the number of sections.
    return [dataModel count];
}

- (NSInteger)tableView:(ExpandableTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([dataModel count] == 0) {
		return 0;
	}
    // Return the number of rows in the section.
    return [[dataModel objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(ExpandableTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RowCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	cell.textLabel.text = [[dataModel objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	// just change the cells background color to indicate group separation
	cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	cell.backgroundView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:243.0/255.0 blue:1.0 alpha:1.0];
	
    return cell;
}

- (UITableViewCell *)tableView:(ExpandableTableView *)tableView cellForGroupInSection:(NSUInteger)section
{
    static NSString *CellIdentifier = @"GroupCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:12];
 
    cell.textLabel.text = [faculties objectAtIndex:section];
 
	// We add a custom accessory view to indicate expanded and colapsed sections
	cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExpandableAccessoryView"] highlightedImage:[UIImage imageNamed:@"ExpandableAccessoryView"]];
	UIView *accessoryView = cell.accessoryView;
	if ([[tableView indexesForExpandedSections] containsIndex:section]) {
		accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
	} else {
		accessoryView.transform = CGAffineTransformMakeRotation(0);
	}
    return cell;
}

// The next two methods are used to rotate the accessory view indicating whjether the
// group is expanded or now
- (void)tableView:(ExpandableTableView *)tableView willExpandSection:(NSUInteger)section {
	UITableViewCell *headerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
	[UIView animateWithDuration:0.3f animations:^{
		headerCell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI - 0.00001); // we need this little hack to subtract a small amount to make sure we rotate in the correct direction
	}];
}

- (void)tableView:(ExpandableTableView *)tableView willContractSection:(NSUInteger)section {
	UITableViewCell *headerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
	[UIView animateWithDuration:0.3f animations:^{
		headerCell.accessoryView.transform = CGAffineTransformMakeRotation(0);
	}];
}

#pragma mark - Table view delegate

- (void)tableView:(ExpandableTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//[self performSegueWithIdentifier:@"showContactDetails" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSContactDetailViewController *viewController = segue.destinationViewController;
	
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];;
    NSLog([NSString stringWithFormat:@"Hello from '%d'",indexPath.section]);
	viewController.text = [[dataModel objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
    NSString *selectedFaculty = [faculties objectAtIndex:indexPath.section];
    NSString *selectedDepartment = [[dataModel objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
    viewController.emailtxt = [[[contacts objectForKey: selectedFaculty] objectForKey:selectedDepartment] objectForKey:@"Email"];
    viewController.phonetxt = [[[contacts objectForKey: selectedFaculty] objectForKey:selectedDepartment] objectForKey:@"Phone"];
    //viewController.phonetxt =
}


 
 

 

@end