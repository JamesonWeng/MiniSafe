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
    
    titleList = [[DataManager sharedInstance] getTitles];
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
    UIAlertController *titleAlert = [UIAlertController alertControllerWithTitle:@"Set Title" message:@"Choose a title for the new item" preferredStyle:UIAlertControllerStyleAlert];
    
    [titleAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"title";
    }];
    
    [titleAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *title = titleAlert.textFields[0].text;
        
        // check uniqueness
        if ([titleList containsObject:title] == YES) {
            
            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This title already exists" preferredStyle:UIAlertControllerStyleAlert];
            
            [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            
            [self presentViewController:errorAlert animated:YES completion:nil];
            
            return;
        }
        
        // update data & reload table
        DataManager *manager = [DataManager sharedInstance];
        [manager addTitle:title];
        titleList = [manager getTitles];
        [self.tableView reloadData];
    }]];

    [titleAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:titleAlert animated:YES completion:nil];
}

@end
