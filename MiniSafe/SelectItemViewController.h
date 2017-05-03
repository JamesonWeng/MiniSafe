//
//  ContentsViewController.h
//  MiniSafe
//

#import <UIKit/UIKit.h>

@interface SelectItemViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *titleList;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)addItem:(id)sender;

@end
