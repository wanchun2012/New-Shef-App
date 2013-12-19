//
//  Activity.h
//  New@Shef
//
//  Created by Wanchun Zhang on 01/09/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Activity : NSObject
{
    int activityId;
    NSString *name;
    NSString *detail;
    NSString *responsiblePerson;
 
    int foreignkey;
    
    NSString *databasePath;
    sqlite3 *db;
}

@property (nonatomic, assign) int activityId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) NSString *responsiblePerson;
@property (nonatomic, assign) int foreignkey;

- (void) initDB;
- (Activity *)initWithId:(int)Id
                      name:(NSString *)n detail:(NSString *)d responsibleperson:(NSString *)p foreignkey:(int)fk;
- (void) saveData:(int)Id
             name:(NSString *)n detail:(NSString *)d responsibleperson:(NSString *)p foreignkey:(int)fk;

- (NSArray *) selectData;
- (NSArray *) selectDataById:(int)fk;

@end
