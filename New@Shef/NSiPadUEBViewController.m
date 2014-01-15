//
//  NSiPadUEBViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

#import "NSiPadUEBDetailViewController.h"
#import "NSiPadUEBViewController.h"
#import "NSiPadRootViewController.h"
#import "Position.h"
#import "SubPosition.h"
@interface NSiPadUEBViewController ()

@end

@implementation NSiPadUEBViewController

@synthesize appDelegate, popoverController, uebDetailVC;
NSString *serverVersion;
NSString *statusImage;
NSInteger numOfAlert;
-(id) init {
	if (self=[super init]) {
		self.appDelegate = (NSAppDelegate *)[[UIApplication sharedApplication] delegate];
        statusImage =@"";
        numOfAlert = 0;
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
    [super viewWillAppear:animated];
	self.title=@"University Executive Board";
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
	UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"University Executive Board";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:20.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];

    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    if ([self connectedToNetwork]==YES)
    {
        [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    
    }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [collectionUEB count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([collectionUEB count] == 0) {
		return 0;
	}
    // Return the number of rows in the section.
    Position *ueb = [collectionUEB objectAtIndex:section];
    return [ueb.subCollection count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
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
        //NSString *str = sub.name;
        //str = [str stringByAppendingString: [NSString stringWithFormat:@" \n %@",sub.uebName]];
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = true;
        //cell.imageView.image = [UIImage imageNamed:@"noimage.jpeg"];

        cell.textLabel.text = [NSString stringWithFormat:@"-%@",sub.name];
        cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    }
	// just change the cells background color to indicate group separation
	//cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	//cell.backgroundView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Position *ueb = [collectionUEB objectAtIndex:section];
    return [ueb.name stringByReplacingOccurrencesOfString :@"+" withString:@" "];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [self.appDelegate.splitViewController viewWillDisappear:YES];
	NSMutableArray *viewControllerArray=[[NSMutableArray alloc] initWithArray:[[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] viewControllers]];
	[viewControllerArray removeLastObject];
	
    self.uebDetailVC=[[NSiPadUEBDetailViewController alloc]init];
    [viewControllerArray addObject:self.uebDetailVC];
    self.appDelegate.splitViewController.delegate = (id)self.uebDetailVC;
    
  
    SubPosition *sub;
    Position *ueb = [collectionUEB objectAtIndex:indexPath.section];
    sub = [ueb.subCollection objectAtIndex:indexPath.row];
  
    NSString *temp = [self getUEBDescription:sub.subId];
    self.uebDetailVC.txtDescription = temp;
    [sub initDB];
    [sub updateData:sub.subId text:temp];
    NSLog(@"load uebdescription from web server");
    sub.uebDescription = self.uebDetailVC.txtDescription;
    
    self.uebDetailVC.txtName = sub.uebName;
    self.uebDetailVC.txtName = [self.uebDetailVC.txtName stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    self.uebDetailVC.txtRole = sub.name;
    self.uebDetailVC.txtRole = [self.uebDetailVC.txtRole stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    self.uebDetailVC.txtUrl = sub.imageUrl;
    self.uebDetailVC.txtStatus = statusImage;
    self.uebDetailVC.txtType = sub.contenttype;
    self.uebDetailVC.uebId = [NSString stringWithFormat:@"%d",sub.subId];
    
    [[self.appDelegate.splitViewController.viewControllers objectAtIndex:1] setViewControllers:viewControllerArray animated:NO];
	[self.appDelegate.splitViewController viewWillAppear:YES];
   
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
    }
    
    return result;
}

@end
