//
//  NSChecklistViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 20/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//  1. icloud and document
//             http://www.techotopia.com/index.php/Using_iCloud_Storage_in_an_iOS_5_iPhone_Application
//

#import <UIKit/UIKit.h>
#import "ExpandableTableViewController.h"
#import "VersionControl.h"
#import "MyDocument.h"
#import "Finished.h"

#define UBIQUITY_CONTAINER_URL @"R84A95845G.The-University-of-Sheffield.NewShef"
#define GETGroup @"http://newshef.co.uk/db/getGroup.php"
#define GETActivity @"http://newshef.co.uk/db/getActivity.php"
#define GETVersion @"http://newshef.co.uk/db/getVersionControl.php"

@interface NSChecklistViewController : ExpandableTableViewController <ExpandableTableViewDataSource,                                  ExpandableTableViewDelegate>
{
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
}

@property (nonatomic, retain) NSString *iCloudText;
@property (strong, nonatomic) NSURL *documentURL;
@property (strong, nonatomic) MyDocument *document;
@property (strong, nonatomic) NSURL *ubiquityURL;
@property (strong, nonatomic) NSMetadataQuery *metadataQuery;

@end