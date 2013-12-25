//
//  NSiPadChecklistViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
#import "VersionControl.h"
#import "MyDocument.h"
#import "Finished.h"

#define UBIQUITY_CONTAINER_URL @"R84A95845G.The-University-of-Sheffield.NewShef"
#define GETGroup @"http://54.213.22.84/getGroup.php"
#define GETActivity @"http://54.213.22.84/getActivity.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"

@class NSiPadToDoDetailsViewController;
@interface NSiPadChecklistViewController : UITableViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate>
{
    
    UIPopoverController *popoverController;
    
    NSMutableArray *jsonActivity;
    NSMutableArray *jsonGroup;
    NSMutableArray *jsonVersion;
    NSMutableArray *collectionActivity;
    NSMutableArray *collectionGroup;
    NSArray *collectionFinished;
    VersionControl *modelVersionControl;
    
    //iCloud setting
    MyDocument *document;
    NSURL *documentURL;
    NSURL *ubiquityURL;
    NSString *iCloudText;
    NSMetadataQuery *metadataQuery;
    
    UIActivityIndicatorView *activityIndicator;
    NSiPadToDoDetailsViewController *toDoVC;
    
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) NSString *iCloudText;
@property (strong, nonatomic) NSURL *documentURL;
@property (strong, nonatomic) MyDocument *document;
@property (strong, nonatomic) NSURL *ubiquityURL;
@property (strong, nonatomic) NSMetadataQuery *metadataQuery;
@property (nonatomic, retain) NSiPadToDoDetailsViewController *toDoVC;



@end
