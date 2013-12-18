//
//  VersionControl.h
//  New@Shef
//
//  Created by Wanchun Zhang on 26/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface VersionControl : NSObject
{
    NSString *vChecklist;
    NSString *vContact;
    NSString *vGoogleMap;
    NSString *vLink;
    NSString *vUEB;
    NSString *vWelcomeTalk;
    NSString *vFAQ;
    
    NSString *databasePath;
    sqlite3 *db;
}

@property (nonatomic, retain) NSString *vChecklist;
@property (nonatomic, retain) NSString *vContact;
@property (nonatomic, retain) NSString *vGoogleMap;
@property (nonatomic, retain) NSString *vLink;
@property (nonatomic, retain) NSString *vUEB;
@property (nonatomic, retain) NSString *vWelcomeTalk;
@property (nonatomic, retain) NSString *vFAQ;

- (void) initDB;
- (void) updateData:(NSString *)col variable:(NSString *)v data:(NSString *)d;
- (void) selectData;

@end