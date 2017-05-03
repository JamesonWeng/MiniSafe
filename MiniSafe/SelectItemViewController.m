//
//  ContentsViewController.m
//  MiniSafe
//


#import "SelectItemViewController.h"

#import "DataManager.h"
#import "ItemViewController.h"

@interface SelectItemViewController ()

@end

@implementation SelectItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // test database
    DataManager *manager = [DataManager sharedInstance];
    [manager openDatabase:@"no password"];
    
    for (int i = 0; i < 5; i++) {
        NSString *title = [NSString stringWithFormat:@"sample title %d", i];
        NSString *contents = [NSString stringWithFormat:@"sample contents %d", i];
        
        [manager addTitle:title];
        [manager setContents:contents forTitle:title];
    }
    
    titleList = [manager getTitles];

    [manager cleanup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TitleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = titleList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ItemViewController *itemController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ItemViewController"];
    
    [itemController showContentsForTitle:titleList[indexPath.row]];
    
    [self.navigationController pushViewController:itemController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addItem:(id)sender {
    NSLog(@"preparing to add item...");
}

@end
