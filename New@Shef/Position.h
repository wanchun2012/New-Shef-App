//
//  Position.h
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Position : NSObject
{
    int positionId;
    NSString *name;
    NSMutableArray *subCollection;
    
    NSString *databasePath;
    sqlite3 *db;    
}

@property (nonatomic, assign) int positionId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *subCollection;

- (void) initDB;
- (Position *)initWithId:(int)Id
                   name:(NSString *)n;
- (void) saveData:(int)Id
             name:(NSString *)n;
- (void) clearData;
- (NSArray *) selectData;
@end
