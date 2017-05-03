//
//  DataManager.h
//  MiniSafe
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataManager : NSObject {
    sqlite3 *database;
}

- (id)init;

- (NSArray *)getItemTitles;

- (void)addTitle:(NSString *)title;

- (NSString *)getContentsForTitle:(NSString *)title;

- (void)updateContents:(NSString *)contents forTitle:(NSString *)title;

- (void)cleanup;

@end
