//
//  Department.h
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Department : NSObject
{
    int departmentId;
    NSString *email;
    NSString *name;
    NSString *phone;
    int foreignkey;
    
    NSString *databasePath;
    sqlite3 *db;
}

@property (nonatomic, assign) int departmentId;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, assign) int foreignkey;

- (void) initDB;
- (Department *)initWithId:(int)Id
                name:(NSString *)n email:(NSString *)e phone:(NSString *)p foreignkey:(int)fk;
- (void) saveData:(int)Id
             name:(NSString *)n email:(NSString *)e phone:(NSString *)p foreignkey:(int)fk;
- (void) clearData;
- (NSArray *) selectData;
- (NSArray *) selectDataById:(int)fk;
@end
