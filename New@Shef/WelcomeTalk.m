//
//  WelcomeTalk.m
//  New@Shef
//
//  Created by Wanchun Zhang on 24/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//
#import "NSAppDelegate.h" 
#import "WelcomeTalk.h"

#define NEWSHEF_DB @"NEWSHEF_DB.sql"
 
@implementation WelcomeTalk
@synthesize welcomeTalkID, welcomeText, welcomeImage, imageUrl;

/*
 TABLE WELCOMETALK: ID, WELCOMETEXT, WELCOMEIMAGEURL
 */

-(void)initDB
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc]initWithString:
                    [docsDir stringByAppendingPathComponent:NEWSHEF_DB]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: NEWSHEF_DB];
        [filemgr copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
        NSLog(@"Sqlite3: create one database in document directory");
    }
    else
    {
        NSLog(@"Sqlite3: exist one database in document directory");
    }
}

- (void) updateData:(NSInteger)index welcometext:(NSString *)txt
{
    int idx = -1;
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *updateSQL = @"UPDATE WELCOMETALK SET WELCOMETEXT =:WELCOMETEXT WHERE ID =:ID";
         
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(db, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            idx = sqlite3_bind_parameter_index(statement, ":WELCOMETEXT");
            sqlite3_bind_text(statement, idx, [txt UTF8String], -1, SQLITE_STATIC );
            
            idx = sqlite3_bind_parameter_index(statement, ":ID" );
            sqlite3_bind_int(statement, idx, index);
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Sqlite3: Success update");
            }
            else
            {
                NSLog(@"Sqlite3: Fail update, sqlite3_step()");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alert show];
            }
        }
        else
        {
            NSLog(@"Sqlite3: Fail update, qlite3_prepare_v2()");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
        }
        
        sqlite3_clear_bindings(statement);
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    else
    {
        NSLog(@"Sqlite3: Fail insert, fail open db");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    
}

- (void) saveData:(NSInteger)index welcometext:(NSString *)txt
{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        int idx = -1;
        NSString *insertSQL = @"INSERT INTO WELCOMETALK (ID, WELCOMETEXT) VALUES  (:ID, :WELCOMETEXT)";
        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_prepare_v2(db, insert_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            idx = sqlite3_bind_parameter_index(statement, ":ID" );
            sqlite3_bind_int(statement, idx, index);
            idx = sqlite3_bind_parameter_index(statement, ":WELCOMETEXT" );
            sqlite3_bind_text(statement, idx, [txt UTF8String], -1, SQLITE_STATIC );
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Sqlite3: Success insert");
                
            }
            else
            {
                NSLog(@"Sqlite3: Fail insert, sqlite3_step()");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alert show];
            }
        }
        else
        {
            NSLog(@"Sqlite3: Fail insert, qlite3_prepare_v2()");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
        }
        sqlite3_clear_bindings(statement);
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    else
    {
        NSLog(@"Sqlite3: Fail insert, fail open db");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

- (void) selectData
{
    int idx = -1;
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *selectSQL = @"select * from WELCOMETALK where id=:id";
        
        const char *select_stmt = [selectSQL UTF8String];
        if(sqlite3_prepare_v2(db, select_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            idx = sqlite3_bind_parameter_index(statement, ":id" );
            sqlite3_bind_int(statement, idx, 1);
            
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Sqlite3: Success select");
                char *cWelcomeText = (char*)sqlite3_column_text(statement, 1);
                welcomeText = [[NSString alloc]initWithUTF8String:cWelcomeText];
            }
            else
            {
                NSLog(@"Sqlite3: Fail select, sqlite3_step()");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alert show];
            }
        }
        else
        {
            NSLog(@"Sqlite3: Fail select, qlite3_prepare_v2()");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
        }
        
        sqlite3_clear_bindings(statement);
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    else
    {
        NSLog(@"Sqlite3: Fail insert, fail open db");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
      //  exit(-1); // no
    }
    if(buttonIndex == 1)
    {
        exit(-1); // yes
    }
  
}

@end
