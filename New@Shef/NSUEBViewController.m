//
//  NSUEBViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 18/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//
//  reference: 1. load, save, image:
//             http://stackoverflow.com/questions/9941292/objective-c-failed-to-write-image-to-documents-directory
//             2. delete image:
//             http://stackoverflow.com/questions/9415221/delete-image-from-app-directory-in-iphone

#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "NSUEBViewController.h" 
#import "NSUEBDetailViewController.h"
#import "Position.h"
#import "SubPosition.h"
 
@implementation NSUEBViewController
NSString *serverVersion;
NSString *statusImage;
NSInteger numOfAlert;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        statusImage =@"";
        numOfAlert = 0;
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
    UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"University Executive Board";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:18.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    if ([self connectedToNetwork] == YES)
    {
 
        [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    }
    [super viewDidLoad];
}

-(void)backgroundThread
{
    self.tableView.separatorStyle = NO;
    NSLog(@"NSUEBViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
    
 
    [self getVersionWebService];
    modelVersionControl = [[VersionControl alloc] init];
    [modelVersionControl initDB];
    [modelVersionControl selectData];
    
    collectionUEB = [[NSMutableArray alloc] init];
    collectionUEBSub = [[NSMutableArray alloc] init];
    
    if ([modelVersionControl.vUEB isEqualToString: @"0"])
    {
        // initialize welcometalk
        NSLog(@"NSUEBViewController: %s","initialize UEB");
        [self loadDataFromWebService];
        Position *p = [[Position alloc]init];
        SubPosition *s = [[SubPosition alloc] init];
        
        [s initDB];
        [s clearData];
        
        [p initDB];
        [p clearData];
        
        for (Position * object in collectionUEB)
        {
            [object initDB];
            [object saveData:object.positionId name:object.name];
        }
        
        for (SubPosition * object in collectionUEBSub)
        {
            [object initDB];
            [object saveData:object.subId name:object.name uebName:object.uebName contenttype:object.contenttype imageURL:object.imageUrl foreignkey:object.foreignkey];
            
        }
        
        [modelVersionControl initDB];
        [modelVersionControl updateData:@"versionueb =:versionueb" variable:@":versionueb" data:serverVersion];
        statusImage = @"download";
    }
    else
    {
        if ([modelVersionControl.vUEB isEqualToString: serverVersion])
        {
            // sqlite db version is equal to mysql db version
            // get data from sqlite database
            NSLog(@"NSUEBViewController: %s","fetch from UEB(sqlite)");
            SubPosition *subueb = [[SubPosition alloc] init];
            [subueb initDB];
            collectionUEBSub = [[subueb selectData] mutableCopy];
            
            Position *ueb = [[Position alloc] init];
            [ueb initDB];
            collectionUEB = [[ueb selectData] mutableCopy];
            
            for (Position * object in collectionUEB)
            {
                for (SubPosition * obj in collectionUEBSub)
                {
                    if(obj.foreignkey == object.positionId)
                    {
                        [object.subCollection addObject:obj];
                    }
                }
                
                SubPosition *s1 = [[SubPosition alloc] init];
                [object.subCollection addObject:s1];
                SubPosition *s2 = [[SubPosition alloc] init];
                [object.subCollection addObject:s2];
            }
        }
        else
        {
            // load data from mysql database
            // update data in sqlite database
            NSLog(@"NSUEBViewController: %s","fetch from UEB(Web database)");
            [self loadDataFromWebService];
            
            Position *p = [[Position alloc]init];
            SubPosition *s = [[SubPosition alloc] init];
            
            [s initDB];
            [s clearData];
            
            [p initDB];
            [p clearData];
            
            for (Position * object in collectionUEB)
            {
                [object initDB];
                [object saveData:object.positionId name:object.name];
            }
            
            for (SubPosition * object in collectionUEBSub)
            {
                [object initDB];
                [object saveData:object.subId name:object.name uebName:object.uebName contenttype:object.contenttype imageURL:object.imageUrl foreignkey:object.foreignkey];
            }
            
            [modelVersionControl initDB];
            [modelVersionControl updateData:@"versionueb =:versionueb" variable:@":versionueb" data:serverVersion];
            statusImage = @"download";
            
        }
    }
    
    
    [self.tableView reloadData];
    [self performSelectorOnMainThread:@selector(mainThreadFinishing) withObject:nil waitUntilDone:NO];
    NSLog(@"NSUEBViewController: %s","backgroundThread finishing...");
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

-(void) getDataFromJson:(NSData *) dataUEB Json:(NSData *) dataSUBUEB
{
    NSError *error;
    jsonUEB = [NSJSONSerialization JSONObjectWithData:dataUEB options:kNilOptions error:&error];
    jsonUEBSub = [NSJSONSerialization JSONObjectWithData:dataSUBUEB options:kNilOptions error:&error];
}

-(void) prepareForWebService
{
    for (int i=0; i<jsonUEBSub.count; i++)
    {
        NSDictionary *info = [jsonUEBSub objectAtIndex:i];
        
        int Id = [[info objectForKey:@"id"] intValue];
        NSString *n = [info objectForKey:@"subpositionName"];
        NSString *un = [info objectForKey:@"uebName"];
        NSString *t = [info objectForKey:@"content_type"]; 
        NSString *temp =[info objectForKey:@"imageURL"];
        [temp stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSString *url = temp;
        int fk = [[info objectForKey:@"position_id"] intValue];
        
        SubPosition *record = [[SubPosition alloc]
                               initWithId:Id name:n uebName:un contenttype:t imageURL:url foreignkey:fk];
        [collectionUEBSub addObject:record];
        NSLog(@"hello prepare for sub%@", n);
    }
    
    for (int i=0; i<jsonUEB.count; i++)
    {
        NSDictionary *info = [jsonUEB objectAtIndex:i];
        
        int Id = [[info objectForKey:@"id"] intValue];
        NSString *n = [info objectForKey:@"positionName"];
        
        Position *record = [[Position alloc]
                           initWithId:Id name:n];
        
        for (SubPosition * object in collectionUEBSub)
        {
            if(object.foreignkey == record.positionId)
            {
                [record.subCollection addObject:object];
            }
        }
        
        Position *d1 = [[Position alloc] init];
        [record.subCollection addObject:d1];
        Position *d2 = [[Position alloc] init];
        [record.subCollection addObject:d2];
        [collectionUEB addObject:record];
        
    }
    
}

-(void) loadDataFromWebService
{
    NSURL *urlUEB = [NSURL URLWithString:GETUEB];
    NSData *dataUEB = [NSData dataWithContentsOfURL:urlUEB];
    
    NSURL *urlSUBUEB = [NSURL URLWithString:GETSUBUEB];
    NSData *dataSUBUEB = [NSData dataWithContentsOfURL:urlSUBUEB];
    
    [self getDataFromJson:dataUEB Json:dataSUBUEB];
    [self prepareForWebService];
}

-(void) getVersionWebService
{
    NSURL *url = [NSURL URLWithString:GETVersion];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    jsonVersion = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary *info = [jsonVersion objectAtIndex:0];
    
    serverVersion = [info objectForKey:@"versionUEB"];
}

-(NSString *) getUEBDescription:(int)Id
{
    NSString *temp=@"";
    if ([self connectedToNetwork] == YES) {
 
    NSString *urlstr =[NSString stringWithFormat:GETDescription, Id];
    NSURL *url = [NSURL URLWithString: urlstr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    NSMutableArray *jsonDescription = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary *info = [jsonDescription objectAtIndex:0];
    temp = [info objectForKey:@"uebDescription"];
    }
    return temp;
}

#pragma mark - Table view data source

- (BOOL)ungroupSimpleElementsInTableView:(ExpandableTableView *)tableView {
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(ExpandableTableView *)tableView
{
    // Return the number of sections.
    return [collectionUEB count];
}

- (NSInteger)tableView:(ExpandableTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([collectionUEB count] == 0) {
		return 0;
	}
    // Return the number of rows in the section.
    Position *ueb = [collectionUEB objectAtIndex:section];
    return [ueb.subCollection count];
}

- (UITableViewCell *)tableView:(ExpandableTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RowCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
 
    Position *ueb = [collectionUEB objectAtIndex:indexPath.section];
    SubPosition *sub = [ueb.subCollection objectAtIndex:indexPath.row];
    if (sub.name == NULL) {
        cell.userInteractionEnabled = false;
        cell.textLabel.text = @"";
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.hidden = true;
    }
    else
    {
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = true;
 
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
        cell.textLabel.text = [NSString stringWithFormat:@"-%@", [sub.name stringByReplacingOccurrencesOfString :@"+" withString:@" "]];
        
        UIColor *colorSelect = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:0.5f];
        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=colorSelect;
    }
	// just change the cells background color to indicate group separation
	cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	cell.backgroundView.backgroundColor = [UIColor whiteColor];
	
    return cell;
}

- (UITableViewCell *)tableView:(ExpandableTableView *)tableView cellForGroupInSection:(NSUInteger)section
{
    static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];;
    Position *ueb = [collectionUEB objectAtIndex:section];
    cell.textLabel.text = ueb.name;
    cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    if (ueb.subCollection.count==2)
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

#pragma mark - Table view delegate

- (void)tableView:(ExpandableTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//[self performSegueWithIdentifier:@"showContactDetails" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SubPosition *sub ;
    NSUEBDetailViewController *viewController = segue.destinationViewController;
	
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    Position *ueb = [collectionUEB objectAtIndex:indexPath.section];
    sub = [ueb.subCollection objectAtIndex:indexPath.row-1];
    /*
    // I failed to fix this, it supposed to work by checking
    [sub initDB];
    if ([sub lengthDescription:sub.subId]==0)
    {
      
        NSString *temp = [self getUEBDescription:sub.subId];
        viewController.txtDescription = temp;
        [sub initDB];
        [sub updateData:sub.subId text:temp];
        NSLog(@"load uebdescription from web server");
        sub.uebDescription = viewController.txtDescription;

    }else
    {
        [sub initDB];
        viewController.txtDescription = [sub selectDataById:sub.subId];
        NSLog(@"load uebdescription from local server");
        sub.uebDescription = viewController.txtDescription;
    }
   */
    
     
    NSString *temp = [self getUEBDescription:sub.subId];
    viewController.txtDescription = temp;
    [sub initDB];
    [sub updateData:sub.subId text:temp];
    NSLog(@"load uebdescription from web server");
    sub.uebDescription = viewController.txtDescription;
   
    /*
     //local server
    [sub initDB];
    viewController.txtDescription = [sub selectDataById:sub.subId];
    NSLog(@"load uebdescription from local server");
    sub.uebDescription = viewController.txtDescription;
    */
 
    viewController.txtName = sub.uebName;
    viewController.txtName = [viewController.txtName stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    viewController.txtRole = sub.name;
    viewController.txtRole = [viewController.txtRole stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    viewController.txtUrl = sub.imageUrl;
    viewController.txtStatus = statusImage;
    viewController.txtType = sub.contenttype;
    viewController.uebId = [NSString stringWithFormat:@"%d",sub.subId];
}

-(UIImage *) getImageFromURL:(NSString *)url {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    result = [UIImage imageWithData:data];
    
    return result;
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"image/png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"image/jpg"] || [[extension lowercaseString] isEqualToString:@"image/jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

- (void)removeImage:(NSString*)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    if ([[extension lowercaseString] isEqualToString:@"image/png"]) {
        NSString *fullPath1 = [directoryPath stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"%@.png", fileName]];
        
        if(![fileManager removeItemAtPath: fullPath1 error:&error]) {
            NSLog(@"Delete failed:%@", error);
        } else {
            NSLog(@"image removed: %@", fullPath1);
        }
    }
    if ([[extension lowercaseString] isEqualToString:@"image/jpg"] || [[extension lowercaseString] isEqualToString:@"image/jpeg"]) {
        NSString *fullPath2 = [directoryPath stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"%@.jpg", fileName]];
        if(![fileManager removeItemAtPath: fullPath2 error:&error]) {
            NSLog(@"Delete failed:%@", error);
        } else {
            NSLog(@"image removed: %@", fullPath2);
        }
    }
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result;
    NSLog(@"image loading........");
    if ([[extension lowercaseString] isEqualToString:@"image/png"]) {
        result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, @"png"]];
    }
    if ([[extension lowercaseString] isEqualToString:@"image/jpg"]|| [[extension lowercaseString] isEqualToString:@"image/jpeg"]) {
        result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, @"jpg"]];
    }
    return result;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        numOfAlert --;
        exit(-1);
    }
    
}

- (BOOL) connectedToNetwork
{
    BOOL result = NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    result = !(networkStatus==NotReachable);
    if (result == NO) {
        if (numOfAlert<1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            numOfAlert ++;
        }
        return NO;
    }
    return YES;
}

@end