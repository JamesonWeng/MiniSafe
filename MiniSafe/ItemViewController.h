//
//  ItemViewController.h
//  MiniSafe
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UIViewController {
    NSString *itemTitle;
}

@property (strong, nonatomic) IBOutlet UITextView *textView;

- (void)showContentsForTitle:(NSString *)title;
- (IBAction)saveContents:(id)sender;

@end
