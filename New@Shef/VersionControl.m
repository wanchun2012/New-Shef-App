//
//  VersionControl.m
//  New@Shef
//
//  Created by Wanchun Zhang on 26/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "VersionControl.h"
#define NEWSHEF_DB @"NEWSHEF_DB.sql"

@implementation VersionControl
@synthesize vChecklist, vContact, vGoogleMap, vLink, vUEB, vWelcomeTalk;

-(void)initDB
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Path to the database file
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

- (void) updateData:(NSString *)col variable:(NSString *)v data:(NSString *)d;
{
    int idx = -1;
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSMutableString *updateSQL = [[NSMutableString alloc]init];
        [updateSQL appendString:@"UPDATE VERSIONCONTROL SET "];
        [updateSQL appendString:col];
        [updateSQL appendString:@" where id =:id"];
         
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(db, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            idx = sqlite3_bind_parameter_index(statement, [v UTF8String]);
            sqlite3_bind_text(statement, idx, [d UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":id" );
            sqlite3_bind_int(statement, idx, 1);
            
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

- (void) selectData
{
    int idx = -1;
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *selectSQL = @"select * from VersionControl where id=:id";
               
        const char *select_stmt = [selectSQL UTF8String];
        if(sqlite3_prepare_v2(db, select_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            idx = sqlite3_bind_parameter_index(statement, ":id" );
            sqlite3_bind_int(statement, idx, 1);
            
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Sqlite3: Success select");
                char *cChecklist = (char*)sqlite3_column_text(statement, 1);
                vChecklist = [[NSString alloc]initWithUTF8String:cChecklist];
                char *cContact = (char*)sqlite3_column_text(statement, 2);
                vContact = [[NSString alloc]initWithUTF8String:cContact];
                char *cGoogleMap = (char*)sqlite3_column_text(statement, 3);
                vGoogleMap = [[NSString alloc]initWithUTF8String:cGoogleMap];
                char *cLink = (char*)sqlite3_column_text(statement, 4);
                vLink = [[NSString alloc]initWithUTF8String:cLink];
                char *cUEB = (char*)sqlite3_column_text(statement, 5);
                vUEB = [[NSString alloc]initWithUTF8String:cUEB];
                char *cWelcomeTalk = (char*)sqlite3_column_text(statement, 6);
                vWelcomeTalk = [[NSString alloc]initWithUTF8String:cWelcomeTalk];
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
        //return;
        //  exit(-1); // no
    }
    if(buttonIndex == 1)
    {
        exit(-1); // yes
    }
    
}

@end
