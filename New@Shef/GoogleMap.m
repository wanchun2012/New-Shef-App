//
//  GoogleMap.m
//  New@Shef
//
//  Created by Wanchun Zhang on 26/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "GoogleMap.h"
#define NEWSHEF_DB @"NEWSHEF_DB.sql"

@implementation GoogleMap
@synthesize googleMapId, insideview, latitude, longitude, snippet, title;

- (id)initWithId:(int)Id insideview:(int)inside
latitude:(NSString *)lat longitude:(NSString *)lon
title:(NSString *)t snippet:(NSString *)s
{
    if ((self = [super init])) {
        self.googleMapId = Id;
        self.insideview = inside;
        self.latitude = lat;
        self.longitude = lon;
        self.title = t;
        self.snippet = s;
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
   
        NSString *deleteSQL = @"DELETE FROM GoogleMap";
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
        NSLog(@"Sqlite3: Fail insert, fail open db");
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
        NSString *selectSQL = @"select * from GoogleMap";
        
        const char *select_stmt = [selectSQL UTF8String];
        if(sqlite3_prepare_v2(db, select_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) 
            {
                NSLog(@"Sqlite3: Success select");
                int Id = sqlite3_column_int(statement, 0);
                int inside = sqlite3_column_int(statement, 1);
                
                char *clat = (char *) sqlite3_column_text(statement, 2);
                char *clon = (char *) sqlite3_column_text(statement, 3);
                char *cs= (char *) sqlite3_column_text(statement, 4);
                char *ct= (char *) sqlite3_column_text(statement, 5);
                NSString *lat = [[NSString alloc] initWithUTF8String:clat];
                NSString *lon = [[NSString alloc] initWithUTF8String:clon];
                NSString *s = [[NSString alloc] initWithUTF8String:cs];
                NSString *t = [[NSString alloc] initWithUTF8String:ct];
                GoogleMap *record = [[GoogleMap alloc]
                                    initWithId:Id insideview:inside
                                    latitude:lat longitude:lon title:t snippet:s];
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

- (void) saveData:(int)Id insideview:(int)inside
         latitude:(NSString *)lat longitude:(NSString *)lon
            title:(NSString *)t snippet:(NSString *)s;
{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        int idx = -1;
        NSString *insertSQL = @"INSERT INTO GOOGLEMAP (ID, INSIDEVIEW, LATITUDE, LONGITUDE, SNIPPET, TITLE) VALUES  (:ID, :INSIDEVIEW, :LATITUDE, :LONGITUDE, :SNIPPET, :TITLE)";
        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_prepare_v2(db, insert_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            idx = sqlite3_bind_parameter_index(statement, ":ID");
            sqlite3_bind_int(statement, idx, Id);
            idx = sqlite3_bind_parameter_index(statement, ":INSIDEVIEW");
            sqlite3_bind_int(statement, idx, inside);
            idx = sqlite3_bind_parameter_index(statement, ":LATITUDE" );
            sqlite3_bind_text(statement, idx, [lat UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":LONGITUDE" );
            sqlite3_bind_text(statement, idx, [lon UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":SNIPPET" );
            sqlite3_bind_text(statement, idx, [s UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":TITLE" );
            sqlite3_bind_text(statement, idx, [t UTF8String], -1, SQLITE_STATIC );
            
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
