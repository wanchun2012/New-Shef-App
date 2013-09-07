//
//  Group.h
//  New@Shef
//
//  Created by Wanchun Zhang on 01/09/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Group : NSObject
{
    int groupId;
    NSString *name;
    NSMutableArray *activityCollection;
    
    NSString *databasePath;
    sqlite3 *db;
}

@property (nonatomic, assign) int groupId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *activityCollection;

- (void) initDB;
- (Group *)initWithId:(int)Id
                   name:(NSString *)n;
- (void) saveData:(int)Id
             name:(NSString *)n;
- (NSArray *) selectData;


@end
