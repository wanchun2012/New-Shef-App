//
//  Activity.m
//  New@Shef
//
//  Created by Wanchun Zhang on 01/09/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "Activity.h"
#define NEWSHEF_DB @"NEWSHEF_DB.sql"
@implementation Activity
@synthesize activityId,name,responsiblePerson,detail,foreignkey;
- (id)initWithId:(int)Id
            name:(NSString *)n detail:(NSString *)d responsibleperson:(NSString *)p foreignkey:(int)fk
{
    if ((self = [super init]))
    {
        self.activityId = Id;
        self.name = n;
        self.responsiblePerson = p;
        self.detail = d;
        self.foreignkey = fk;
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
- (NSArray *) selectData
{
    NSMutableArray *collection = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *selectSQL = @"select * from CHECKLISTACTIVITY";
        
        const char *select_stmt = [selectSQL UTF8String];
        if(sqlite3_prepare_v2(db, select_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                // departmentId, name, phone, email, foreignkey;
                NSLog(@"Sqlite3: Success select");
                int Id = sqlite3_column_int(statement, 0);
                char *cName = (char *) sqlite3_column_text(statement, 1);
                char *cDetail = (char *) sqlite3_column_text(statement, 2);
                char *cPerson = (char *) sqlite3_column_text(statement, 3);
                int fk = sqlite3_column_int(statement, 4);
                
                NSString *n = [[NSString alloc] initWithUTF8String:cName];
                NSString *d = [[NSString alloc] initWithUTF8String:cDetail];
                NSString *p = [[NSString alloc] initWithUTF8String:cPerson];
                
                Activity *record = [[Activity alloc]
                                    initWithId:Id name:n detail:d responsibleperson:p foreignkey:fk];
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

- (NSArray *) selectDataById:(int)fk
{
    NSMutableArray *collection = [[NSMutableArray alloc] init];
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *selectSQL = [NSString stringWithFormat:
                               @"select * from CHECKLISTACTIVITY where FK=\"%@\"",
                               [NSString stringWithFormat:@"%i",fk]];
        
        const char *select_stmt = [selectSQL UTF8String];
        if(sqlite3_prepare_v2(db, select_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Sqlite3: Success select");
                int Id = sqlite3_column_int(statement, 0);
                char *cName = (char *) sqlite3_column_text(statement, 1);
                char *cDetail = (char *) sqlite3_column_text(statement, 2);
                char *cPerson = (char *) sqlite3_column_text(statement, 3);
                int fk = sqlite3_column_int(statement, 4);
                
                NSString *n = [[NSString alloc] initWithUTF8String:cName];
                NSString *d = [[NSString alloc] initWithUTF8String:cDetail];
                NSString *p = [[NSString alloc] initWithUTF8String:cPerson];
                
                Activity *record = [[Activity alloc]
                                    initWithId:Id name:n detail:d responsibleperson:p foreignkey:fk];
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

- (void) saveData:(int)Id
             name:(NSString *)n detail:(NSString *)d responsibleperson:(NSString *)p foreignkey:(int)fk

{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        int idx = -1;
        NSString *insertSQL = @"INSERT INTO CHECKLISTACTIVITY (ID, NAME, DETAILS, RESPONSIBLEPERSON, FK) VALUES (:ID, :NAME, :DETAILS, :RESPONSIBLEPERSON, :FK)";
        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_prepare_v2(db, insert_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            NSLog(@"db wash bathroom");
            idx = sqlite3_bind_parameter_index(statement, ":ID");
            sqlite3_bind_int(statement, idx, Id);
            idx = sqlite3_bind_parameter_index(statement, ":NAME");
            sqlite3_bind_text(statement, idx, [n UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":DETAILS");
            sqlite3_bind_text(statement, idx, [d UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":RESPONSIBLEPERSON");
            sqlite3_bind_text(statement, idx, [p UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":FK");
            sqlite3_bind_int(statement, idx, fk);
            
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
