//
//  ItemViewController.h
//  MiniSafe
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)saveContents:(id)sender;

@end
