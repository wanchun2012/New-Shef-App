//
//  FAQ.h
//  New@Shef
//
//  Created by Wanchun Zhang on 15/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface FAQ : NSObject
{
    int faqId;
    NSString *question;
    NSString *answer;
    
    NSString *databasePath;
    sqlite3 *db;

}

@property (nonatomic, assign) int faqId;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *answer;

- (void) initDB;
- (FAQ *)initWithId:(int)Id
         question:(NSString *)q answer:(NSString *)a;
- (void) saveData:(int)Id
      question:(NSString *)q answer:(NSString *)a;
- (void) clearData;
- (NSArray *) selectData;

@end

