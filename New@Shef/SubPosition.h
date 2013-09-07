//
//  SubPosition.h
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SubPosition : NSObject
{
    int subId;
    NSString *name;
    NSString *uebName;
    NSString *uebDescription;
    int foreignkey;
    
    UIImage *uebImage;
    NSString *imageUrl;
    NSString *contenttype;
    
    NSString *databasePath;
    sqlite3 *db;
}

@property (nonatomic, assign) int subId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *uebName;
@property (nonatomic, retain) NSString *uebDescription;
@property (nonatomic, assign) int foreignkey;
@property (nonatomic, retain) UIImage *uebImage;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *contenttype;

- (void) initDB;
- (SubPosition *)initWithId:(int)Id
                       name:(NSString *)n uebName:(NSString *)un contenttype:(NSString *)t imageURL:(NSString *)url foreignkey:(int)fk;
- (void) saveData:(int)Id
             name:(NSString *)n uebName:(NSString *)un contenttype:(NSString *)t imageURL:(NSString *)url foreignkey:(int)fk;
- (void) clearData;
- (NSArray *) selectData;
- (NSString *) selectDataById:(int)Id;
- (void) updateData:(int)Id text:(NSString *)txt;
- (int) lengthDescription:(int)Id;
- (NSString *) getDescription;
@end
