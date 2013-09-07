//
//  Link.h
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Link : NSObject
{
    int linkId;    
    NSString *description;
    NSString *url;
  
    NSString *databasePath;
    sqlite3 *db;
}

@property (nonatomic, assign) int linkId; 
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *url;
 
- (void) initDB;
- (Link *)initWithId:(int)Id  
            description:(NSString *)d url:(NSString *)u;
- (void) saveData:(int)Id
            description:(NSString *)d url:(NSString *)u;
- (void) clearData;
- (NSArray *) selectData;


@end
