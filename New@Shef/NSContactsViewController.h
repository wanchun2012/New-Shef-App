//
//  NSContactsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 13/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ExpandableTableViewController.h"
#import "VersionControl.h"
#import <MessageUI/MessageUI.h>

#define GETFaculty @"http://54.213.22.84/getFaculty.php"
#define GETDepartment @"http://54.213.22.84/getDepartment.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
#define NOEMAILTITLE @"No email account"
#define NOEMAILMSG @"Do you want exit app and login one email account now?"
#define NOPHONETITLE @"No carrier"
#define NOPHONEMSG @"Cant make call on this device or dont have enough credit, try on other device: "
@interface NSContactsViewController : ExpandableTableViewController <ExpandableTableViewDataSource,                                  ExpandableTableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSMutableArray *jsonDepartment;
    NSMutableArray *jsonFaculty;
    NSMutableArray *jsonVersion;
    NSMutableArray *collectionDepartment;
    NSMutableArray *collectionFaculty;
    VersionControl *modelVersionControl;
 
    UIActivityIndicatorView *activityIndicator;
}

@end