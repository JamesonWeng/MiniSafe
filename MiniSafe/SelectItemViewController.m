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
    
    contentList = [[NSMutableArray alloc] init];
    for(int i = 0; i < 5; i++) {
        [contentList addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Content #%d\n", i], @"ContentName", nil]];
    }
    
    
    // test database
    DataManager *manager = [[DataManager alloc] init];
    [manager addTitle:@"sample title"];
    NSLog(@"contents are:%@", [manager getContentsForTitle:@"sample title"]);
    [manager updateContents:@"sample contents" forTitle:@"sample title"];
    NSLog(@"contents are:%@", [manager getContentsForTitle:@"sample title"]);
    [manager cleanup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"ContentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [[contentList objectAtIndex:indexPath.row] objectForKey:@"ContentName"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ItemViewController *itemController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ItemViewController"];
    
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
