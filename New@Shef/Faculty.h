//
//  Faculty.h
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Faculty : NSObject
{
    int facultyId;
    NSString *name;
    NSMutableArray *deptCollection;
   
    NSString *databasePath;
    sqlite3 *db;
}

@property (nonatomic, assign) int facultyId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *deptCollection;
 
- (void) initDB;
- (Faculty *)initWithId:(int)Id
         name:(NSString *)n;
- (void) saveData:(int)Id
         name:(NSString *)n;
- (void) clearData;
- (NSArray *) selectData;

@end
