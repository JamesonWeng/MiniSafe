//
//  LoginViewController.m
//  MiniSafe
//
//  Created by Jameson Weng on 2017-05-05.
//  Copyright © 2017 Jameson Weng. All rights reserved.
//

#import "LoginViewController.h"

#import "DataManager.h"
#import "SelectItemViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[DataManager sharedInstance] databaseExists] == NO) {
        self.messageLabel.text = @"Please enter your password";
    }
    else {
        self.messageLabel.text = @"Please choose a password";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)submitPassword:(UIButton *)sender {
    NSLog(@"Entered password");
    
    // try to create/decrypt database
    if ([[DataManager sharedInstance] openDatabase:self.passwordField.text] == NO) {
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please try again" preferredStyle:UIAlertControllerStyleAlert];
        
        [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:errorAlert animated:YES completion:nil];
        return;
    }
    
    // successfully opened database
    // now segue to item selection page
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SelectItemViewController *selectItemController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectItemViewController"];
    
    [self.navigationController pushViewController:selectItemController animated:YES];
}
@end
