//
//  GoogleMap.h
//  New@Shef
//
//  Created by Wanchun Zhang on 26/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface GoogleMap : NSObject
{
    int googleMapId;
    int insideview;
    NSString *latitude;
    NSString *longitude;
    NSString *title;
    NSString *snippet;
    
    NSString *databasePath;
    sqlite3 *db;
}

@property (nonatomic, assign) int googleMapId;
@property (nonatomic, assign) NSInteger insideview;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *snippet;
 
- (void) initDB;
- (GoogleMap *)initWithId:(int)Id insideview:(int)inside
                latitude:(NSString *)lat longitude:(NSString *)lon 
                title:(NSString *)t snippet:(NSString *)s;
- (void) saveData:(int)Id insideview:(int)inside
                latitude:(NSString *)lat longitude:(NSString *)lon
                title:(NSString *)t snippet:(NSString *)s;
- (void) clearData;
- (NSArray *) selectData;

@end
