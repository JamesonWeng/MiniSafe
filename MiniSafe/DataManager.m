//
//  DataManager.m
//  MiniSafe
//
//  Created by Jameson Weng on 2017-01-22.
//  Copyright © 2017 Jameson Weng. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

- (id)init {
    if (!(self = [super init])) {
        NSLog(@"failed to initalize object");
        return nil;
    }
    
    return self;
}

+ (id)sharedInstance {
    static DataManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}

- (NSString *)databasePath {
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"test.db"];
}

- (BOOL)databaseExists {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self databasePath]];
}

- (BOOL)openDatabase:(NSString *)password {
    
    NSString *databasePath = [self databasePath];
    
    sqlite3_stmt *preparedStmt;
    NSString *createTableCmd = @"CREATE TABLE IF NOT EXISTS data_table (title text PRIMARY_KEY, contents text);";
    
    // open a connection to the database
    if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
        NSLog(@"failed to open database at %@", databasePath);
        return NO;
    }
    
    /*
    // register the key for encrypting/decrypting the database
    NSString *databaseKey = @"My secret key";
    if (sqlite3_key(database, [databaseKey UTF8String], [databaseKey length]) != SQLITE_OK) {
        NSLog(@"failed to key the database");
        goto cleanupDatabase;
    }
    */
    
    // check if key was correct
    if (sqlite3_exec(database, "SELECT count (*) FROM sqlite_master;", NULL, NULL, NULL) != SQLITE_OK) {
        NSLog(@"sqlite3_exec failed - password was incorrect");
        goto cleanupDatabase;
    }
    
    // prepare the statement
    if (sqlite3_prepare_v2(database, [createTableCmd UTF8String], -1, &preparedStmt, NULL) != SQLITE_OK) {
        NSLog(@"failed to prepare statement");
        goto cleanupDatabase;
    }
    
    // execute the statement
    if (sqlite3_step(preparedStmt) != SQLITE_DONE) {
        NSLog(@"failed to create table to store user data");
        goto cleanupStmt;
    }
    
    sqlite3_finalize(preparedStmt); // free the prepared statement
    return YES;

cleanupStmt:
    sqlite3_finalize(preparedStmt);
    
cleanupDatabase:
    sqlite3_close(database);
    return NO;
}

- (NSMutableArray *)getTitles {
    static NSString *getCmd = @"SELECT title FROM data_table;";
    
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    sqlite3_stmt *preparedStmt;
    
    if (sqlite3_prepare_v2(database, [getCmd UTF8String], -1, &preparedStmt, NULL) != SQLITE_OK) {
        NSLog(@"failed to prepare statement");
        return nil;
    }
    
    while (true) {
        int step_rv = sqlite3_step(preparedStmt);
        
        if (step_rv == SQLITE_DONE) {
            break;
        }
        else if (step_rv != SQLITE_ROW) {
            NSLog(@"failed to execute query statement");
            goto cleanupStmt;
        }
        
        [titles addObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(preparedStmt, 0)]];
    }

    return titles;
    
cleanupStmt:
    sqlite3_finalize(preparedStmt);
    return nil;
}

- (void)addTitle:(NSString *)title {
    static NSString *addCmd = @"INSERT INTO data_table (title, contents) VALUES (?1,'');";
    
    sqlite3_stmt *preparedStmt;
    
    // prepare the statement
    if (sqlite3_prepare_v2(database, [addCmd UTF8String], -1, &preparedStmt, NULL) != SQLITE_OK) {
        NSLog(@"failed to prepare statement");
        return;
    }
    
    // bind the title to ?1
    if (sqlite3_bind_text(preparedStmt, 1, [title UTF8String], [title length], SQLITE_STATIC) != SQLITE_OK) {
        NSLog(@"failed to bind title to sqlite statement");
        goto cleanupStmt;
    }
    
    // execute the statement
    if (sqlite3_step(preparedStmt) != SQLITE_DONE) {
        NSLog(@"did not successfully add row to data table");
        goto cleanupStmt;
    }
    
cleanupStmt:
    sqlite3_finalize(preparedStmt);
}

- (void)removeTitle:(NSString *)title {
    static NSString *deleteCmd = @"DELETE FROM data_table WHERE title = ?1;";
    
    sqlite3_stmt *preparedStmt;
    
    // prepare the statement
    if (sqlite3_prepare_v2(database, [deleteCmd UTF8String], -1, &preparedStmt, NULL) != SQLITE_OK) {
        NSLog(@"failed to prepare statement");
        goto cleanupStmt;
    }
    
    // bind title to ?1
    if (sqlite3_bind_text(preparedStmt, 1, [title UTF8String], [title length], SQLITE_STATIC) != SQLITE_OK) {
        NSLog(@"failed to bind title to sqlite statement");
        goto cleanupStmt;
    }
    
    // execute the statement
    if (sqlite3_step(preparedStmt) != SQLITE_DONE) {
        NSLog(@"delete statement didn't execute successfully");
        goto cleanupStmt;
    }
    
cleanupStmt:
    sqlite3_finalize(preparedStmt);
}

- (NSString *)getContentsForTitle:(NSString *)title {
    static NSString *query = @"SELECT contents FROM data_table WHERE title = ?1;";
    
    sqlite3_stmt *preparedStmt;
    NSString *contents;
    
    // prepare the statement
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &preparedStmt, NULL) != SQLITE_OK) {
        NSLog(@"failed to prepare statement");
        return nil;
    }
    
    // bind the title to ?1
    if (sqlite3_bind_text(preparedStmt, 1, [title UTF8String], [title length], SQLITE_STATIC) != SQLITE_OK) {
        NSLog(@"failed to bind title to sqlite statement");
        goto cleanupStmt;
    }
    
    // execute the statement
    if (sqlite3_step(preparedStmt) != SQLITE_ROW) {
        NSLog(@"did not find any rows matching title");
        goto cleanupStmt;
    }
    
    contents = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(preparedStmt, 0)];
    
    sqlite3_finalize(preparedStmt);
    
    return contents;
    
cleanupStmt:
    sqlite3_finalize(preparedStmt);
    return nil;
}

- (void)setContents:(NSString *)contents forTitle:(NSString *)title {
    static NSString *insertCmd = @"UPDATE data_table SET contents = ?1 WHERE title = ?2;";
    
    sqlite3_stmt *preparedStmt;
    
    // prepare the statement
    if (sqlite3_prepare_v2(database, [insertCmd UTF8String], -1, &preparedStmt, NULL) != SQLITE_OK) {
        NSLog(@"failed to prepare statement");
        return;
    }
    
    // bind contents to ?1
    if (sqlite3_bind_text(preparedStmt, 1, [contents UTF8String], [contents length], SQLITE_STATIC) != SQLITE_OK) {
        NSLog(@"failed to bind contents to sqlite statement");
        goto cleanupStmt;
    }
    
    // bind title to ?2
    if (sqlite3_bind_text(preparedStmt, 2, [title UTF8String], [title length], SQLITE_STATIC) != SQLITE_OK) {
        NSLog(@"failed to bind title to sqlite statement");
        goto cleanupStmt;
    }
  
    // execute statement
    if (sqlite3_step(preparedStmt) != SQLITE_DONE) {
        NSLog(@"did not successfully insert into the table");
        goto cleanupStmt;
    }
    
cleanupStmt:
    sqlite3_finalize(preparedStmt);
}

- (void)cleanup {
    sqlite3_close(database);
}

@end
