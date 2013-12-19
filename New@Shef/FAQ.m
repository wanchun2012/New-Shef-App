//
//  FAQ.m
//  New@Shef
//
//  Created by Wanchun Zhang on 15/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "FAQ.h"
#define NEWSHEF_DB @"NEWSHEF_DB.sql"

@implementation FAQ
@synthesize faqId, question, answer;

- (id)initWithId:(int)Id
     question:(NSString *)q answer:(NSString *)a
{
    if ((self = [super init]))
    {
        self.faqId = Id;
        self.question = q;
        self.answer = a;
    }
    return self;
}

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
        NSLog(@"DB:FAQ: Sqlite3: create one database in document directory");
    }
    else
    {
        NSLog(@"DB:FAQ: Sqlite3: exist one database in document directory");
    }
}

- (void) clearData
{
    //DELETE FROM tablename
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *deleteSQL = @"DELETE FROM FAQ";
        const char *delete_stmt = [deleteSQL UTF8String];
        if(sqlite3_prepare_v2(db, delete_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            sqlite3_step(statement);
        }
        else
        {
            NSLog(@"DB:FAQ: Sqlite3: Fail delete, qlite3_prepare_v2()");
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
        NSLog(@"DB:FAQ: Sqlite3: Fail insert, fail open db");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    
}

- (NSArray *) selectData
{
    NSMutableArray *collection = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *selectSQL = @"select * from FAQ";
        
        const char *select_stmt = [selectSQL UTF8String];
        if(sqlite3_prepare_v2(db, select_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"DB:FAQ: Sqlite3: Success select");
                int Id = sqlite3_column_int(statement, 0);
                char *cQuestion = (char *) sqlite3_column_text(statement, 1);
                char *cAnswer = (char *) sqlite3_column_text(statement, 2);
                
                NSString *q = [[NSString alloc] initWithUTF8String:cQuestion];
                NSString *a = [[NSString alloc] initWithUTF8String:cAnswer];
                
                FAQ *record = [[FAQ alloc]
                                initWithId:Id question:q answer:a];
                [collection addObject:record];
            }
        }
        else
        {
            NSLog(@"DB:FAQ: Sqlite3: Fail select, qlite3_prepare_v2()");
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
        NSLog(@"DB:FAQ: Sqlite3: Fail insert, fail open db");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    return collection;
}

- (void) saveData:(int)Id
      question:(NSString *)q answer:(NSString *)a
{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        int idx = -1;
        NSString *insertSQL = @"INSERT INTO FAQ (ID, QUESTION, ANSWER) VALUES (:ID, :QUESTION, :ANSWER)";
        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_prepare_v2(db, insert_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            idx = sqlite3_bind_parameter_index(statement, ":ID");
            sqlite3_bind_int(statement, idx, Id);
            idx = sqlite3_bind_parameter_index(statement, ":QUESTION");
            sqlite3_bind_text(statement, idx, [q UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":ANSWER");
            sqlite3_bind_text(statement, idx, [a UTF8String], -1, SQLITE_STATIC );
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"DB:FAQ: Sqlite3: Success insert");
                
            }
            else
            {
                NSLog(@"DB:FAQ: Sqlite3: Fail insert, sqlite3_step()");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alert show];
            }
        }
        else
        {
            NSLog(@"DB:FAQ: Sqlite3: Fail insert, qlite3_prepare_v2()");
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
        NSLog(@"DB:FAQ: Sqlite3: Fail insert, fail open db");
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
