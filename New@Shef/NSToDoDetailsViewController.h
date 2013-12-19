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

@interface NSToDoDetailsViewController : UIViewController
{
    MyDocument *document;
    NSURL *documentURL;
    NSURL *ubiquityURL;
    NSString *iCloudText;
    NSMetadataQuery *metadataQuery;
    
    UIActivityIndicatorView *activityIndicator;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;
@property (weak, nonatomic) IBOutlet UITextView *tvDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelResponsiblePerson;
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
