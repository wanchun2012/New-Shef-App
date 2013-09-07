//
//  WelcomeTalk.h
//  New@Shef
//
//  Created by Wanchun Zhang on 24/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface WelcomeTalk : NSObject {
    NSInteger welcomeTalkID;
    NSString *welcomeText;
    UIImage *welcomeImage;
    NSString *contenttype;
    NSString *imageUrl;

    NSString *databasePath;
    sqlite3 *db;
}

@property (nonatomic, readwrite) NSInteger welcomeTalkID;
@property (nonatomic, retain) NSString *welcomeText; 
@property (nonatomic, retain) UIImage *welcomeImage;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *contenttype;

- (void) initDB;
- (void) saveData:(NSInteger)index welcometext:(NSString *)txt conenttype:(NSString *)t;
- (void) updateData:(NSInteger)index welcometext:(NSString *)txt conenttype:(NSString *)t;
- (void) selectData;
 
@end
