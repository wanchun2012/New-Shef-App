//
//  NSiPadContactsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"

#import "VersionControl.h"
#import <MessageUI/MessageUI.h>

#define GETFaculty @"http://54.213.22.84/getFaculty.php"
#define GETDepartment @"http://54.213.22.84/getDepartment.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"
@interface NSiPadContactsViewController : UITableViewController <MFMailComposeViewControllerDelegate>
{
    
    UIPopoverController *popoverController;
    NSMutableArray *jsonDepartment;
    NSMutableArray *jsonFaculty;
    NSMutableArray *jsonVersion;
    NSMutableArray *collectionDepartment;
    NSMutableArray *collectionFaculty;
    VersionControl *modelVersionControl;
    
    UIActivityIndicatorView *activityIndicator;

}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;


@end
