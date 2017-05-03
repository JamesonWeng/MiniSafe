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
        NSLog(@"Failed to initalize superclass object");
        return self;
    }
    
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *databasePath = [documentsDir stringByAppendingPathComponent:@"test.db"];
    
    // open a connection to the database
    if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
        NSLog(@"Failed to open database at %@", databasePath);
        return nil;
    }
    
    /*
    // register the key for encrypting/decrypting the database
    NSString *database_key = @"My secret key";
    if (sqlite3_key(database, [database_key UTF8String], [database_key length]) != SQLITE_OK) {
        NSLog(@"Failed to key the database");
        goto cleanup_database;
    }
    */
    
    sqlite3_stmt *preparedStmt;
    NSString *createTableCmd = @"CREATE TABLE IF NOT EXISTS data_table ( title text PRIMARY_KEY, contents text );";
    
    // prepare the statement
    if (sqlite3_prepare_v2(database, [createTableCmd UTF8String], -1, &preparedStmt, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare statement");
        goto cleanupDatabase;
    }
    
    // execute the statement
    if (sqlite3_step(preparedStmt) != SQLITE_DONE) {
        NSLog(@"Failed to create table to store user data");
        goto cleanupStmt;
    }
    
    sqlite3_finalize(preparedStmt); // free the prepared statement
    NSLog(@"Created table");
    
    return self;

cleanupStmt:
    sqlite3_finalize(preparedStmt);
    
cleanupDatabase:
    sqlite3_close(database);
    
    return nil;
}

- (NSArray *)getItemTitles {
    NSArray *titles = [[NSArray alloc] init];
    return titles;
}

- (void)addTitle:(NSString *)title {
    static NSString *addCmd = @"INSERT INTO data_table (title, contents) VALUES (?1,'');";
    
    sqlite3_stmt *preparedStmt;
    
    // prepare the statement
    if (sqlite3_prepare_v2(database, [addCmd UTF8String], -1, &preparedStmt, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare statement");
        return;
    }
    
    // bind the title to ?1
    if (sqlite3_bind_text(preparedStmt, 1, [title UTF8String], [title length], SQLITE_STATIC) != SQLITE_OK) {
        NSLog(@"Failed to bind title to sqlite statement");
        goto cleanupStmt;
    }
    
    // execute the statement
    if (sqlite3_step(preparedStmt) != SQLITE_DONE) {
        NSLog(@"Did not successfully add row to data table");
        goto cleanupStmt;
    }
    
cleanupStmt:
    sqlite3_finalize(preparedStmt);
}

- (NSString *)getContentsForTitle:(NSString *)title {
    static NSString *query = @"SELECT contents FROM data_table WHERE title = ?1";
    
    sqlite3_stmt *preparedStmt;
    
    NSString *contents;
    
    // prepare the statement
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &preparedStmt, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare statement");
        return nil;
    }
    
    // bind the title to ?1
    if (sqlite3_bind_text(preparedStmt, 1, [title UTF8String], [title length], SQLITE_STATIC) != SQLITE_OK) {
        NSLog(@"Failed to bind title to sqlite statement");
        goto cleanupStmt;
    }
    
    // execute the statement
    if (sqlite3_step(preparedStmt) != SQLITE_ROW) {
        NSLog(@"Did not find any rows matching title");
        goto cleanupStmt;
    }
    
    contents = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(preparedStmt, 0)];
    
    sqlite3_finalize(preparedStmt);
    
    return contents;
    
    
cleanupStmt:
    sqlite3_finalize(preparedStmt);
    return nil;
}

- (void)updateContents:(NSString *)contents forTitle:(NSString *)title {
    static NSString *insertCmd = @"UPDATE data_table SET contents = ?1 WHERE title = ?2;";
    
    sqlite3_stmt *preparedStmt;
    
    // prepare the statement
    if (sqlite3_prepare_v2(database, [insertCmd UTF8String], -1, &preparedStmt, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare statement");
        return;
    }
    
    // bind contents to ?1
    if (sqlite3_bind_text(preparedStmt, 1, [contents UTF8String], [contents length], SQLITE_STATIC) != SQLITE_OK) {
        NSLog(@"Failed to bind contents to sqlite statement");
        goto cleanupStmt;
    }
    
    // bind title to ?2
    if (sqlite3_bind_text(preparedStmt, 2, [title UTF8String], [title length], SQLITE_STATIC) != SQLITE_OK) {
        NSLog(@"Failed to bind title to sqlite statement");
        goto cleanupStmt;
    }
  
    // execute statement
    if (sqlite3_step(preparedStmt) != SQLITE_DONE) {
        NSLog(@"Did not successfully insert into the table");
        goto cleanupStmt;
    }
    
cleanupStmt:
    sqlite3_finalize(preparedStmt);
}

- (void)cleanup {
    sqlite3_close(database);
}

@end
