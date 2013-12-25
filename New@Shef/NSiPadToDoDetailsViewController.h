//
//  NSiPadToDoDetailsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 23/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
#import "NSiPadRootViewController.h"
#import "MyDocument.h"
#define UBIQUITY_CONTAINER_URL @"R84A95845G.The-University-of-Sheffield.NewShef"

@class NSiPadChecklistViewController;
@interface NSiPadToDoDetailsViewController : UIViewController
{
    
    UIPopoverController *popoverController;
    MyDocument *document;
    NSURL *documentURL;
    NSURL *ubiquityURL;
    NSString *iCloudText;
    NSMetadataQuery *metadataQuery;
    
    UIActivityIndicatorView *activityIndicator;
    UIBarButtonItem *btnDone;
    
    NSiPadChecklistViewController *checklistVC;

}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;

 
@property (weak, nonatomic) IBOutlet UITextView *tvDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

@property (strong) NSString *txtResponsiblePerson;
@property (strong) NSString *txtDescription;
@property (strong) NSString *txtId;
@property (strong) NSString *txtStatus;
@property (nonatomic, retain) NSString *iCloudText;
@property (strong, nonatomic) NSURL *documentURL;
@property (strong, nonatomic) MyDocument *document;
@property (strong, nonatomic) NSURL *ubiquityURL;
@property (strong, nonatomic) NSMetadataQuery *metadataQuery;

@property (nonatomic, retain) NSiPadChecklistViewController *checklistVC;

@end
