//
//  NSiPadChecklistViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSiPadToDoDetailsViewController.h"
#import "NSiPadChecklistViewController.h"
#import "NSiPadRootViewController.h"
#import "Activity.h"
#import "Group.h"
@interface NSiPadChecklistViewController ()

@end

@implementation NSiPadChecklistViewController
@synthesize appDelegate, popoverController;
@synthesize iCloudText,document,documentURL,ubiquityURL,metadataQuery,toDoVC;
NSString *serverVersion;
 

-(id) init {
	if (self=[super init]) {
		self.appDelegate = (NSAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	return self;
}
#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
	barButtonItem.title = @"Menu";
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
	[self setPopoverController:pc];
	self.appDelegate.rootPopoverButtonItem = barButtonItem;
    
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	[[self navigationItem] setLeftBarButtonItem:nil];
	[self setPopoverController:nil];
	self.appDelegate.rootPopoverButtonItem = barButtonItem;
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
    
    [super viewWillAppear:animated];

    
	self.title=@"Checklist";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
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
    
    if ([self iCloudIsAvailable])
    {
        if ([self connectedToNetwork] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet, please try later?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
            
        }
        else
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidLoad) name:@"loadiCloud" object:nil];
            
            // iCloud loading
            [self loadiCloud];
            [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
        }
    }

    [self.tableView reloadData];
}

-(void)backgroundThread
{
    self.tableView.separatorStyle = NO;
    NSLog(@"NSChecklistViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
    
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
    
    [self.tableView reloadData];
 
 
    
    [self performSelectorOnMainThread:@selector(mainThreadFinishing) withObject:nil waitUntilDone:NO];
    NSLog(@"NSChecklistViewController: %s","backgroundThread finishing...");
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [collectionGroup count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([collectionGroup count] == 0)
    {
		return 0;
	}
    // Return the number of rows in the section.
    Group *group = [collectionGroup objectAtIndex:section];
    return [group.activityCollection count]-2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font =[UIFont systemFontOfSize:15.0f];
    
    Group *group = [collectionGroup objectAtIndex:indexPath.section];
    Activity *activity = [group.activityCollection objectAtIndex:indexPath.row];
    if (activity.name == NULL)
    {
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
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.userInteractionEnabled = true;
        cell.textLabel.text = [NSString stringWithFormat:@"-%@",activity.name];
        
        cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString :@"+" withString:@" "];
        
    }
	// just change the cells background color to indicate group separation
	cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	cell.backgroundView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
	
    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    Group *group = [collectionGroup objectAtIndex:section];
    return [group.name stringByReplacingOccurrencesOfString :@"+" withString:@" "];
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.appDelegate.splitViewController viewWillDisappear:YES];
	NSMutableArray *viewControllerArray=[[NSMutableArray alloc] initWithArray:[[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] viewControllers]];
	[viewControllerArray removeLastObject];
	
    self.toDoVC=[[NSiPadToDoDetailsViewController alloc]init];
    [viewControllerArray addObject:self.toDoVC];
    self.appDelegate.splitViewController.delegate = (id)self.toDoVC;
    
    Group *group = [collectionGroup objectAtIndex:indexPath.section];
    Activity *activity = [group.activityCollection objectAtIndex:indexPath.row];
	//viewController.text = activity.name;
    
    self.toDoVC.txtDescription = activity.detail;
    self.toDoVC.txtResponsiblePerson = activity.responsiblePerson;
    self.toDoVC.txtId = [NSString stringWithFormat:@"%d",activity.activityId];
    
    self.toDoVC.txtStatus = @"Incomplete";
    
    for (Finished* object in collectionFinished)
    {
        if(object.activityId == activity.activityId)
        {
            self.toDoVC.txtStatus = object.finishedTime;
            break;
        }
        
    }
    
    [[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] setViewControllers:viewControllerArray animated:NO];
	[self.appDelegate.splitViewController viewWillAppear:YES];
    
}



- (void) loadiCloud
{
    NSLog(@"iCloud loading..........................");
    
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
    }
    else
    {
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
}

// iCloud setting
- (BOOL) iCloudIsAvailable
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ubiquityURL = [fileManager
                   URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_URL];
    
    if ([fileManager fileExistsAtPath:[ubiquityURL path]] == NO)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ROFL"
                                                        message:@"Dee dee doo doo."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
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
             if (success)
             {
                 NSLog(@"Opened cloud doc");
                 self.iCloudText = document.userText;
                 Finished *finished = [[Finished alloc]init];
                 
                 collectionFinished = [finished getFinishedActivityCollection:document.userText];
                 
                 for (Finished* object in collectionFinished)
                 {
                     NSLog(@"%d", object.activityId);
                 }
             }
             else
             {
                 NSLog(@"Not opened cloud doc");
             }
         }];
    }
    else
    {
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
