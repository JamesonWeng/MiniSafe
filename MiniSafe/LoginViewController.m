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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnToLoginViewController) name:@"returnToLogin" object:nil];
    
    self.passwordField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[DataManager sharedInstance] databaseExists] == YES) {
        self.messageLabel.text = @"Please enter your password";
    }
    else {
        self.messageLabel.text = @"Please choose a password";
    }
    
    // close the database if it was open before
    // otherwise, this is a no-op
    [[DataManager sharedInstance] closeDatabase];
}

- (void)returnToLoginViewController {
    [self.navigationController popToRootViewControllerAnimated:NO];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)submitPassword:(UIButton *)sender {
    NSString *password = self.passwordField.text;
    self.passwordField.text = @"";
    
    // try to create/decrypt database
    if ([[DataManager sharedInstance] openDatabase:password] == NO) {
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
