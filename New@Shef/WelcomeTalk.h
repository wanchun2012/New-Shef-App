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
    NSString *imageUrl;

    NSString *databasePath;
    sqlite3 *db;
}

@property (nonatomic, readwrite) NSInteger welcomeTalkID;
@property (nonatomic, retain) NSString *welcomeText; 
@property (nonatomic, retain) UIImage *welcomeImage;
@property (nonatomic, retain) NSString *imageUrl;

- (void) initDB;
- (void) saveData:(NSInteger)index welcometext:(NSString *)txt;
- (void) updateData:(NSInteger)index welcometext:(NSString *)txt;
- (void) selectData;
 
@end
