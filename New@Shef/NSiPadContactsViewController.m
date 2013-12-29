//
//  NSiPadContactsViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSiPadContactsViewController.h"
#import "NSiPadRootViewController.h"
#import "Faculty.h"
#import "Department.h"
#import "UICustomizedButton.h"
@interface NSiPadContactsViewController ()

@end

@implementation NSiPadContactsViewController
@synthesize appDelegate, popoverController;

NSString *serverVersion;
NSString *phoneNumber;
NSString *emailAddress;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.appDelegate = (NSAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

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
    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
 
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
    
	UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"Contacts";
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
    NSLog(@"NSContactsViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
 
    [self getVersionWebService];
    modelVersionControl = [[VersionControl alloc] init];
    [modelVersionControl initDB];
    [modelVersionControl selectData];
    
    collectionFaculty = [[NSMutableArray alloc] init];
    collectionDepartment = [[NSMutableArray alloc] init];
    
    if ([modelVersionControl.vContact isEqualToString: @"0"])
    {
        // initialize welcometalk
        NSLog(@"NSContactsViewController: %s","initialize CONTACT");
        [self loadDataFromWebService];
        Faculty *f = [[Faculty alloc]init];
        Department *d = [[Department alloc] init];
        
        [d initDB];
        [d clearData];
        
        [f initDB];
        [f clearData];
        
        for (Faculty * object in collectionFaculty)
        {
            [object initDB];
            [object saveData:object.facultyId name:object.name];
        }
        
        for (Department * object in collectionDepartment)
        {
            [object initDB];
            [object saveData:object.departmentId name:object.name email:object.email phone:object.phone foreignkey:object.foreignkey];
        }
        [modelVersionControl initDB];
        [modelVersionControl updateData:@"versioncontact =:versioncontact" variable:@":versioncontact" data:serverVersion];
    }
    else
    {
        if ([modelVersionControl.vContact isEqualToString: serverVersion])
        {
            // sqlite db version is equal to mysql db version
            // get data from sqlite database
            NSLog(@"NSContactsViewController: %s","fetch from Contact(sqlite)");
            Department *department = [[Department alloc] init];
            [department initDB];
            collectionDepartment = [[department selectData] mutableCopy];
            
            Faculty *faculty = [[Faculty alloc] init];
            [faculty initDB];
            collectionFaculty = [[faculty selectData] mutableCopy];
            
            for (Faculty * object in collectionFaculty)
            {
                for (Department * obj in collectionDepartment)
                {
                    if(obj.foreignkey == object.facultyId)
                    {
                        [object.deptCollection addObject:obj];
                    }
                }
                
                Department *d1 = [[Department alloc] init];
                [object.deptCollection addObject:d1];
                Department *d2 = [[Department alloc] init];
                [object.deptCollection addObject:d2];
            }
        }
        else
        {
            // load data from mysql database
            // update data in sqlite database
            NSLog(@"NSContactsViewController: %s","fetch from Contact(Web database)");
            [self loadDataFromWebService];
            
            Faculty *f = [[Faculty alloc]init];
            Department *d = [[Department alloc] init];
            
            [d initDB];
            [d clearData];
            
            [f initDB];
            [f clearData];
            
            for (Faculty * object in collectionFaculty)
            {
                [object initDB];
                [object saveData:object.facultyId name:object.name];
            }
            
            for (Department * object in collectionDepartment)
            {
                [object initDB];
                [object saveData:object.departmentId name:object.name email:object.email phone:object.phone foreignkey:object.foreignkey];
            }
            
            [modelVersionControl initDB];
            [modelVersionControl updateData:@"versioncontact =:versioncontact" variable:@":versioncontact" data:serverVersion];
        }
    }
    [self.tableView reloadData];
    [self performSelectorOnMainThread:@selector(mainThreadFinishing) withObject:nil waitUntilDone:NO];
    NSLog(@"NSContactsViewController: %s","backgroundThread finishing...");
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



-(void) getDataFromJson:(NSData *) dataFaculty Json:(NSData *) dataDepartment
{
    NSError *error;
    jsonFaculty = [NSJSONSerialization JSONObjectWithData:dataFaculty options:kNilOptions error:&error];
    jsonDepartment = [NSJSONSerialization JSONObjectWithData:dataDepartment options:kNilOptions error:&error];
}

-(void) prepareForWebService
{
    for (int i=0; i<jsonDepartment.count; i++)
    {
        NSDictionary *info = [jsonDepartment objectAtIndex:i];
        
        int Id = [[info objectForKey:@"id"] intValue];
        NSString *n = [info objectForKey:@"departmentName"];
        NSString *e = [info objectForKey:@"email"];
        NSString *p = [info objectForKey:@"phone"];
        int fk = [[info objectForKey:@"faculty_id"] intValue];
        
        Department *record = [[Department alloc]
                              initWithId:Id name:n email:e phone:p foreignkey:fk];
        [collectionDepartment addObject:record];
    }
    
    for (int i=0; i<jsonFaculty.count; i++)
    {
        NSDictionary *info = [jsonFaculty objectAtIndex:i];
        
        int Id = [[info objectForKey:@"id"] intValue];
        NSString *n = [info objectForKey:@"facultyName"];
        
        Faculty *record = [[Faculty alloc]
                           initWithId:Id name:n];
        
        for (Department * object in collectionDepartment)
        {
            if(object.foreignkey == record.facultyId)
            {
                [record.deptCollection addObject:object];
            }
        }
        
        Department *d1 = [[Department alloc] init];
        [record.deptCollection addObject:d1];
        Department *d2 = [[Department alloc] init];
        [record.deptCollection addObject:d2];
        [collectionFaculty addObject:record];
        
    }
    
}

-(void) loadDataFromWebService
{
    NSURL *urlFaculty = [NSURL URLWithString:GETFaculty];
    NSData *dataFaculty = [NSData dataWithContentsOfURL:urlFaculty];
    
    NSURL *urlDepartment = [NSURL URLWithString:GETDepartment];
    NSData *dataDepartment = [NSData dataWithContentsOfURL:urlDepartment];
    
    [self getDataFromJson:dataFaculty Json:dataDepartment];
    [self prepareForWebService];
}

-(void) getVersionWebService
{
    NSURL *url = [NSURL URLWithString:GETVersion];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    jsonVersion = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary *info = [jsonVersion objectAtIndex:0];
    
    serverVersion = [info objectForKey:@"versionContact"];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return [collectionFaculty count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([collectionFaculty count] == 0)
    {
		return 0;
	}
    // Return the number of rows in the section.
    Faculty *faculty = [collectionFaculty objectAtIndex:section];
    return [faculty.deptCollection count]-1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font =[UIFont fontWithName:@"AppleGothic" size:15.0f];
    
    Faculty *faculty = [collectionFaculty objectAtIndex:indexPath.section];
    Department *department = [faculty.deptCollection objectAtIndex:indexPath.row];
    
    
   // UIImage *imgPhone = [UIImage imageNamed:@"phone-icon.jpg"];
    UIImage *imgEmail = [UIImage imageNamed:@"email-icon.jpg"];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
 /*
    UICustomizedButton *btnPhone = [UICustomizedButton buttonWithType:UIButtonTypeRoundedRect];
    //set the position of the butto
    btnPhone.frame = CGRectMake(cell.frame.origin.x+screenWidth-cell.frame.size.height*2, cell.frame.origin.y, cell.frame.size.height/2, cell.frame.size.height/2);
    btnPhone.phone = department.phone;//[department.phone stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    btnPhone.backgroundColor= [UIColor clearColor];
    [cell.contentView addSubview:btnPhone];
    [btnPhone setBackgroundImage:imgPhone forState:UIControlStateNormal];
  
    [btnPhone addTarget:self action:@selector(callPhone:)  forControlEvents:UIControlEventTouchUpInside];
    */
    
    UICustomizedButton *btnEmail = [UICustomizedButton buttonWithType:UIButtonTypeRoundedRect];
    //set the position of the button
    btnEmail.frame = CGRectMake(cell.frame.origin.x+screenWidth-cell.frame.size.height*2-5.f, cell.frame.origin.y+cell.frame.size.height/4, cell.frame.size.height/2, cell.frame.size.height/2);
    
    btnEmail.email = department.email;
    btnEmail.backgroundColor= [UIColor clearColor];
    [cell.contentView addSubview:btnEmail];
    [btnEmail setBackgroundImage:imgEmail forState:UIControlStateNormal];
    [btnEmail addTarget:self action:@selector(sendEmail:)  forControlEvents:UIControlEventTouchUpInside];
    
    
    if (department.name == NULL) {
        cell.userInteractionEnabled = false;
        cell.textLabel.text = @"";
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.hidden = true;
        
    }
    else
    {
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = true;
        cell.textLabel.text = [NSString stringWithFormat:@"-%@",department.name];
        cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString :@"+" withString:@" "];
        cell.detailTextLabel.font = [UIFont fontWithName:@"AppleGothic" size:12.0f];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"  %@", department.phone];
        cell.detailTextLabel.text=[cell.detailTextLabel.text stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    }
	// just change the cells background color to indicate group separation
	cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	cell.backgroundView.backgroundColor = [UIColor whiteColor];
	cell.accessoryType=UITableViewCellAccessoryNone;
    //cell.userInteractionEnabled = NO;
    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Faculty *faculty = [collectionFaculty objectAtIndex:section];
    return  [faculty.name stringByReplacingOccurrencesOfString :@"+" withString:@" "];
  
}

-(void)callPhone:(UICustomizedButton *)sender
{
    NSString *s = [NSString stringWithFormat:@"tel:%@",sender.phone];
    NSURL *tel = [NSURL URLWithString:s] ;
    if([[UIApplication sharedApplication] canOpenURL:tel])
    {
        [[UIApplication sharedApplication] openURL:tel];
        
    }
    else
    {
        //show alert later
        NSMutableString *msg = [[NSMutableString alloc] initWithString:@"Cant make call on ipad and do you have enough credit on the phone? Try this number:"];
        s = [s stringByReplacingOccurrencesOfString :@"+" withString:@" "];
        [msg appendString:s];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)sendEmail:(UICustomizedButton *)sender
{
        if ([MFMailComposeViewController canSendMail])
        {
            // device is configured to send mail
            MFMailComposeViewController *mailController = [[ MFMailComposeViewController alloc]init];
            [mailController setMailComposeDelegate:self];
            NSString *toEmail = sender.email;
            NSArray *emailArray = [[NSArray alloc]initWithObjects:toEmail, nil];
            NSString *message = @"";//self.emailbody.text;
            [mailController setMessageBody:message isHTML:NO];
            [mailController setToRecipients:emailArray];
            [mailController setSubject:@""];
   
            mailController.navigationBar.tintColor = [UIColor blackColor];
            [self presentViewController:mailController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOEMAILTITLE message:NOEMAILMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:@"Wait later", nil];
            [alert show];
        }
  
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // after send email, clean the emailbody field.
    // self.emailbody.text = @"";
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
    if (connect==NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    return (connect!=NULL)?YES:NO;
}


@end
