//
//  SubPosition.m
//  New@Shef
//
//  Created by Wanchun Zhang on 27/08/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "SubPosition.h"
#define NEWSHEF_DB @"NEWSHEF_DB.sql"

@implementation SubPosition
@synthesize subId, name, uebName, uebDescription, foreignkey, uebImage, imageUrl,contenttype;

- (id)initWithId:(int)Id
            name:(NSString *)n uebName:(NSString *)un contenttype:(NSString *)t imageURL:(NSString *)url foreignkey:(int)fk 
{
    if ((self = [super init]))
    {
        self.subId = Id;
        self.name = n;
        self.uebName = un;
        self.contenttype = t;
        self.imageUrl = url;
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

- (void) clearData
{
    //DELETE FROM tablename
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        
        NSString *deleteSQL = @"DELETE FROM UEBSUBPOSITION";
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
        NSString *selectSQL = @"select * from UEBSUBPOSITION";
        
        const char *select_stmt = [selectSQL UTF8String];
        if(sqlite3_prepare_v2(db, select_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
               
                NSLog(@"Sqlite3: Success select");
                int Id = sqlite3_column_int(statement, 0);
                char *cName = (char *) sqlite3_column_text(statement, 1);
                char *cUebName = (char *) sqlite3_column_text(statement, 2);
                char *cContentType = (char *) sqlite3_column_text(statement, 4);
                char *cUrl = (char *) sqlite3_column_text(statement, 5);
                int fk = sqlite3_column_int(statement, 6);
                
                NSString *n = [[NSString alloc] initWithUTF8String:cName];
                NSString *un = [[NSString alloc] initWithUTF8String:cUebName];
                NSString *t = [[NSString alloc] initWithUTF8String:cContentType];
                NSString *url = [[NSString alloc] initWithUTF8String:cUrl];
                SubPosition *record = [[SubPosition alloc]
                                       initWithId:Id name:n uebName:un contenttype:t imageURL:url foreignkey:fk];
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

-(int) lengthDescription:(int)Id
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *selectSQL = [NSString stringWithFormat:
                               @"select * from UEBSUBPOSITION where ID=\"%@\"",
                               [NSString stringWithFormat:@"%i",Id]];
        
        const char *select_stmt = [selectSQL UTF8String];
        if(sqlite3_prepare_v2(db, select_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                 
                if(sqlite3_column_bytes(statement, 3)==0)
                {
                    return 0;
                    
                }
                else
                {
                    return 1;
                }
            }
            
        }
        else
        {
            NSLog(@"Sqlite3: Fail select, qlite3_prepare_v2()");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
            return 0;
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
        return 0;
    }
    return 0;

}

- (NSString *) selectDataById:(int)Id
{
    
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *selectSQL = [NSString stringWithFormat:
                               @"select * from UEBSUBPOSITION where ID=\"%@\"",
                               [NSString stringWithFormat:@"%i",Id]];
        
        const char *select_stmt = [selectSQL UTF8String];
        if(sqlite3_prepare_v2(db, select_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                char *cDescription = (char *) sqlite3_column_text(statement, 3);
                NSString *temp = [[NSString alloc] initWithUTF8String:cDescription];
                return temp;
            }
            
        }
        else
        {
            NSLog(@"Sqlite3: Fail select, qlite3_prepare_v2()");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
            return NULL;
        }
        
        //sqlite3_clear_bindings(statement);
        //sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(db);
        
    }
    else
    {
        NSLog(@"Sqlite3: Fail insert, fail open db");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fail load data, Exit app?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        return NULL;
    }
    return NULL;
}
 
- (void) saveData:(int)Id
             name:(NSString *)n uebName:(NSString *)un contenttype:(NSString *)t imageURL:(NSString *)url foreignkey:(int)fk

{
 
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        int idx = -1;
        NSString *insertSQL = @"INSERT INTO UEBSUBPOSITION (ID, SUBPOSITIONNAME, UEBNAME, UEBDESCRIPTION, CONTENTTYPE, IMAGEURL, FK) VALUES (:ID, :SUBPOSITIONNAME, :UEBNAME, :UEBDESCRIPTION, :CONTENTTYPE, :IMAGEURL, :FK)";
        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_prepare_v2(db, insert_stmt,-1, &statement, NULL)== SQLITE_OK)
        {  
            idx = sqlite3_bind_parameter_index(statement, ":ID");
            sqlite3_bind_int(statement, idx, Id);
            idx = sqlite3_bind_parameter_index(statement, ":SUBPOSITIONNAME");
            sqlite3_bind_text(statement, idx, [n UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":UEBNAME");
            sqlite3_bind_text(statement, idx, [un UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":UEBDESCRIPTION");
            sqlite3_bind_text(statement, idx, [@"" UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":CONTENTTYPE");
            sqlite3_bind_text(statement, idx, [t UTF8String], -1, SQLITE_STATIC );
            idx = sqlite3_bind_parameter_index(statement, ":IMAGEURL");
            sqlite3_bind_text(statement, idx, [url UTF8String], -1, SQLITE_STATIC );

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

- (void) updateData:(int)Id text:(NSString *)txt
{
    int idx = -1;
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK)
    {
        NSString *updateSQL = @"UPDATE UEBSUBPOSITION SET UEBDESCRIPTION =:UEBDESCRIPTION WHERE ID =:ID";
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(db, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            idx = sqlite3_bind_parameter_index(statement, ":UEBDESCRIPTION");
            sqlite3_bind_text(statement, idx, [txt UTF8String], -1, SQLITE_STATIC );
            
            idx = sqlite3_bind_parameter_index(statement, ":ID" );
            sqlite3_bind_int(statement, idx, Id);
           
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

- (NSString *)getDescription
{
    return uebDescription;
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
