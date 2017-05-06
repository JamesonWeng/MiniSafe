//
//  DataManager.h
//  MiniSafe
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

// Singleton for managing access to encrypted database
// Access the object through the sharedInstance method

// "Items" in the database consist of a title and associated contents,
// where the titles must be unique

@interface DataManager : NSObject {
    sqlite3 *database;
}

+ (id)sharedInstance;

- (BOOL)databaseExists;
// open & decrypt the database - this function must be called before title/content manipulation
// if database didn't exist before, this creates one keyed to the given password
- (BOOL)openDatabase:(NSString *)password;

// title manipulation
- (NSMutableArray *)getTitles;
- (void)addTitle:(NSString *)title;
- (void)removeTitle:(NSString *)title;

// content manipulation - the specified titles must exist beforehand
- (NSString *)getContentsForTitle:(NSString *)title;
- (void)setContents:(NSString *)contents forTitle:(NSString *)title;

- (void)cleanup;

@end
