//
//  NSToDoDetailsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 20/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDocument.h"
#define UBIQUITY_CONTAINER_URL @"R84A95845G.The-University-of-Sheffield.NewShef"
#define NOICLOUDTITLE @"No iCloud account"
#define NOICLOUDMSG @"There is no iCloud account, exit app or try later to sign in"
#define SAVEDTITLE @"Saved"
#define SAVEDMSG @"Time and Status saved to iCloud" 
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
@interface NSToDoDetailsViewController : UIViewController
{
    MyDocument *document;
    NSURL *documentURL;
    NSURL *ubiquityURL;
    NSString *iCloudText;
    NSMetadataQuery *metadataQuery;
    
    UIActivityIndicatorView *activityIndicator;
    UILabel *labelTitle;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

@property (strong) NSString *txtActivityName;
@property (strong) NSString *txtResponsiblePerson;
@property (strong) NSString *txtDescription;
@property (strong) NSString *txtId;
@property (strong) NSString *txtStatus;
@property (nonatomic, retain) NSString *iCloudText;
@property (strong, nonatomic) NSURL *documentURL;
@property (strong, nonatomic) MyDocument *document;
@property (strong, nonatomic) NSURL *ubiquityURL;
@property (strong, nonatomic) NSMetadataQuery *metadataQuery;

-(IBAction)saveDocument;
 
@end
