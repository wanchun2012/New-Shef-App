//
//  NSChecklistViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 20/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSChecklistViewController.h"
#import "NSToDoDetailsViewController.h"
#import "Activity.h"
#import "Group.h"

@interface NSChecklistViewController ()

@end

@implementation NSChecklistViewController
@synthesize iCloudText,document,documentURL,ubiquityURL,metadataQuery;
NSString *serverVersion;

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
     
    // iCloud loading
    NSLog(@"iCloud loading..........................");
    [self iCloudIsAvailable];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dataFile = [docsDir stringByAppendingPathComponent: @"newshef.txt"];
    self.documentURL = [NSURL fileURLWithPath:dataFile];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    ubiquityURL = [[filemgr URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_URL] URLByAppendingPathComponent:@"Documents"];
    NSLog(@"iCloud path = %@", [ubiquityURL path]);
    
    if ([filemgr fileExistsAtPath:[ubiquityURL path]] == NO)
    {
        NSLog(@"iCloud Documents directory does not exist");
        [filemgr createDirectoryAtURL:ubiquityURL withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"iCloud Documents directory exists");
    }
    
    ubiquityURL = [ubiquityURL URLByAppendingPathComponent:@"newshef.txt"];
    NSLog(@"Full ubiquity path = %@", [ubiquityURL path]);
    
    // Search for document in iCloud storage
    metadataQuery = [[NSMetadataQuery alloc] init];
    [metadataQuery setPredicate: [NSPredicate predicateWithFormat: @"%K like 'newshef.txt'",
                                  NSMetadataItemFSNameKey]];
    [metadataQuery setSearchScopes:[NSArray arrayWithObjects:NSMetadataQueryUbiquitousDocumentsScope,nil]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataQueryDidFinishGathering:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:metadataQuery];
    NSLog(@"starting query");
    [metadataQuery startQuery];
  
    
    // web database or internal database
    [self getVersionWebService];
    modelVersionControl = [[VersionControl alloc] init];
    [modelVersionControl initDB];
    [modelVersionControl selectData];
    
    collectionGroup = [[NSMutableArray alloc] init];
    collectionActivity = [[NSMutableArray alloc] init];
    
    if ([modelVersionControl.vChecklist isEqualToString: @"0"])
    {
        // initialize checklist
        NSLog(@"NSChecklistViewController: %s","initialize CHECKLIST");
        [self loadDataFromWebService];
              
        Group *g = [[Group alloc]init];
        Activity *a = [[Activity alloc] init];
        
        [a initDB];
        [g initDB];
       
        
        for (Group * object in collectionGroup)
        {
            [object initDB];
            [object saveData:object.groupId name:object.name];
            
      
        }
        
        for (Activity * object in collectionActivity)
        {
            [object initDB];
            [object saveData:object.activityId name:object.name detail:object.detail responsibleperson:object.responsiblePerson foreignkey:object.foreignkey];
        }
        [modelVersionControl initDB];
        [modelVersionControl updateData:@"versionchecklist =:versionchecklist" variable:@":versionchecklist" data:serverVersion];
       
    }
    else
    {
     
        // sqlite db version is equal to mysql db version
        // get data from sqlite database
        NSLog(@"NSChecklistViewController: %s","fetch from Checklist(sqlite)");
        Activity *activity = [[Activity alloc] init];
        [activity initDB];
        collectionActivity = [[activity selectData] mutableCopy];
            
        Group *group = [[Group alloc] init];
        [group initDB];
        collectionGroup = [[group selectData] mutableCopy];
            
        for (Group * object in collectionGroup)
        {
            for (Activity * obj in collectionActivity)
            {
                if(obj.foreignkey == object.groupId)
                {
                    [object.activityCollection addObject:obj];
                }
            }
                
            Activity *d1 = [[Activity alloc] init];
            [object.activityCollection addObject:d1];
            Activity *d2 = [[Activity alloc] init];
            [object.activityCollection addObject:d2];
        }
    }
    
    [super viewDidLoad];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"Checklist";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor blackColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

-(void) getDataFromJson:(NSData *) dataGroup Json:(NSData *) dataActivity
{
    NSError *error;
    jsonGroup = [NSJSONSerialization JSONObjectWithData:dataGroup options:kNilOptions error:&error];
    jsonActivity = [NSJSONSerialization JSONObjectWithData:dataActivity options:kNilOptions error:&error];
}

-(void) prepareForWebService
{
    for (int i=0; i<jsonActivity.count; i++)
    {
        NSDictionary *info = [jsonActivity objectAtIndex:i];
        
        int Id = [[info objectForKey:@"id"] intValue];
        NSString *n = [info objectForKey:@"activityName"];
        NSString *d = [info objectForKey:@"details"];
        NSString *p = [info objectForKey:@"responsiblePerson"];
        int fk = [[info objectForKey:@"group_id"] intValue];
        
        Activity *record = [[Activity alloc]
                              initWithId:Id name:n detail:d responsibleperson:p foreignkey:fk];
        [collectionActivity addObject:record];
   
    }
    
    for (int i=0; i<jsonGroup.count; i++)
    {
        NSDictionary *info = [jsonGroup objectAtIndex:i];
        
        int Id = [[info objectForKey:@"id"] intValue];
        NSString *n = [info objectForKey:@"groupName"];
        
        Group *record = [[Group alloc]
                           initWithId:Id name:n];
        
        for (Activity * object in collectionActivity)
        {
            if(object.foreignkey == record.groupId)
            {
                [record.activityCollection addObject:object];
            }
        }
        
        Activity *d1 = [[Activity alloc] init];
        [record.activityCollection addObject:d1];
        Activity *d2 = [[Activity alloc] init];
        [record.activityCollection addObject:d2];
        [collectionGroup addObject:record];
        
    }
    
}

-(void) loadDataFromWebService
{
    NSURL *urlGroup = [NSURL URLWithString:GETGroup];
    NSData *dataGroup = [NSData dataWithContentsOfURL:urlGroup];
    
    NSURL *urlActivity = [NSURL URLWithString:GETActivity];
    NSData *dataActivity = [NSData dataWithContentsOfURL:urlActivity];
        
    [self getDataFromJson:dataGroup Json:dataActivity];

    [self prepareForWebService];
}

-(void) getVersionWebService
{
    NSURL *url = [NSURL URLWithString:GETVersion];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    jsonVersion = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary *info = [jsonVersion objectAtIndex:0];
    
    serverVersion = [info objectForKey:@"versionChecklist"];
}

#pragma mark - Table view data source

- (BOOL)ungroupSimpleElementsInTableView:(ExpandableTableView *)tableView {
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(ExpandableTableView *)tableView
{
    // Return the number of sections.
    return [collectionGroup count];
}

- (NSInteger)tableView:(ExpandableTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([collectionGroup count] == 0) {
		return 0;
	}
    // Return the number of rows in the section.
    Group *group = [collectionGroup objectAtIndex:section];
    return [group.activityCollection count];
}

- (UITableViewCell *)tableView:(ExpandableTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RowCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell.textLabel.font =[UIFont systemFontOfSize:15.0f];
    
    Group *group = [collectionGroup objectAtIndex:indexPath.section];
    Activity *activity = [group.activityCollection objectAtIndex:indexPath.row];
    if (activity.name == NULL) {
        cell.userInteractionEnabled = false;
        cell.textLabel.text = @"";
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.hidden = true;
        
    }
    else
    {
        
        for (Finished* object in collectionFinished)
        {
            if(object.activityId == activity.activityId)
            {
                cell.accessoryType =  UITableViewCellAccessoryCheckmark;
                break;
            }
            else
            {
                cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;

  
        cell.userInteractionEnabled = true;
        cell.textLabel.text = [NSString stringWithFormat:@"-%@",activity.name];
    }
	// just change the cells background color to indicate group separation
	cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	cell.backgroundView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
	
    return cell;
}

- (UITableViewCell *)tableView:(ExpandableTableView *)tableView cellForGroupInSection:(NSUInteger)section
{
    static NSString *CellIdentifier = @"GroupCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:12];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;

    Group *group = [collectionGroup objectAtIndex:section];
    cell.textLabel.text = group.name;
    
    if (group.activityCollection.count==2)
    {
        cell.userInteractionEnabled = false;
    }
    else
    {
        cell.userInteractionEnabled = true;
    }
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
    NSToDoDetailsViewController *viewController = segue.destinationViewController;
 
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];;
    
    Group *group = [collectionGroup objectAtIndex:indexPath.section];
    Activity *activity = [group.activityCollection objectAtIndex:indexPath.row-1];
	//viewController.text = activity.name;
    
    viewController.txtDescription = activity.detail;
    viewController.txtResponsiblePerson = activity.responsiblePerson;
    viewController.txtId = [NSString stringWithFormat:@"%d",activity.activityId];
    NSLog(@"sfsdfsdgfgbathroom");
    NSLog(viewController.txtId);
    viewController.txtStatus = @"Incomplete";
   
    for (Finished* object in collectionFinished)
    {
        NSLog(object.finishedTime);
        if(object.activityId == activity.activityId)
        {
            viewController.txtStatus = object.finishedTime;
            NSLog(object.finishedTime);
            break;
        }
        
    }
    
 
}


// iCloud setting
- (void) iCloudIsAvailable
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *ubiquityURL = [fileManager
                          URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_URL];
    if(ubiquityURL)
        NSLog(@"YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
    else
        NSLog(@"NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN");
    
}

- (void)metadataQueryDidFinishGathering:(NSNotification *)notification
{
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
    [query stopQuery];
    NSArray *results = [[NSArray alloc] initWithArray:[query results]];
    
    
    if ([results count] == 1)
    {
        NSLog(@"File exists in cloud");
        ubiquityURL = [[results objectAtIndex:0] valueForAttribute:NSMetadataItemURLKey];
        self.document = [[MyDocument alloc] initWithFileURL:ubiquityURL];
        //self.document.userText = @"";
        [document openWithCompletionHandler:
         ^(BOOL success) {
             if (success){
                 NSLog(@"Opened cloud doc");
                 self.iCloudText = document.userText;
                 Finished *finished = [[Finished alloc]init];
                 NSLog(document.userText);
                 collectionFinished = [finished getFinishedActivityCollection:document.userText];
             } else {
                 NSLog(@"Not opened cloud doc");
             }
         }];
    } else {
        NSLog(@"File does not exist in cloud");
        self.document = [[MyDocument alloc] initWithFileURL:ubiquityURL];
        
        [document saveToURL:ubiquityURL
           forSaveOperation: UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success){
                  NSLog(@"Saved to cloud");
              }  else {
                  NSLog(@"Failed to save to cloud");
              }
          }];
    }
}



@end
