//
//  ItemViewController.m
//  MiniSafe
//

#import "ItemViewController.h"

#import "DataManager.h"

@interface ItemViewController ()

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.text = [[DataManager sharedInstance] getContentsForTitle:itemTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showContentsForTitle:(NSString *)title {
    itemTitle = title;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveContents:(id)sender {
    [[DataManager sharedInstance] setContents:self.textView.text forTitle:itemTitle];
}
@end
