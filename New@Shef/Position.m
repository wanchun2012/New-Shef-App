//
//  Position.m
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "Position.h"
#define NEWSHEF_DB @"NEWSHEF_DB.sql"

@implementation Position
@synthesize positionId, name, subCollection;

- (id)initWithId:(int)Id
            name:(NSString *)n
{
    if ((self = [super init]))
    {
        self.positionId = Id;
        self.name = n;
        self.subCollection = [[NSMutableArray alloc] init];
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
        NSLog(@"Sqlite3: create one database in document directory");
    }
    else
    {
        NSLog(@"Sqlite3: exist one database in document directory");
    }
}

- (void) clearData
{
    //DELETE FROM tablename
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        
        NSString *deleteSQL = @"DELETE FROM UEBPOSITION";
        const char *delete_stmt = [deleteSQL UTF8String];
        if(sqlite3_prepare_v2(db, delete_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            sqlite3_step(statement);
        }
        else
        {
            NSLog(@"Sqlite3: Fail delete, qlite3_prepare_v2()");
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
        NSLog(@"Sqlite3: Fail delete, fail open db");
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
        NSString *selectSQL = @"select * from UEBPOSITION";
        
        const char *select_stmt = [selectSQL UTF8String];
        if(sqlite3_prepare_v2(db, select_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Sqlite3: Success select");
                int Id = sqlite3_column_int(statement, 0);
                char *cName = (char *) sqlite3_column_text(statement, 1);
                
                NSString *n = [[NSString alloc] initWithUTF8String:cName];
                
                Position *record = [[Position alloc]
                                   initWithId:Id name:n];
                [collection addObject:record];
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
    return collection;
}

- (void) saveData:(int)Id name:(NSString *)n
{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        int idx = -1;
        NSString *insertSQL = @"INSERT INTO UEBPOSITION (ID, POSITIONNAME) VALUES (:ID, :POSITIONNAME)";
        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_prepare_v2(db, insert_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            idx = sqlite3_bind_parameter_index(statement, ":ID");
            sqlite3_bind_int(statement, idx, Id);
            idx = sqlite3_bind_parameter_index(statement, ":POSITIONNAME");
            sqlite3_bind_text(statement, idx, [n UTF8String], -1, SQLITE_STATIC );
            
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
