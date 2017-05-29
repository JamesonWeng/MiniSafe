//
//  LoginViewController.h
//  MiniSafe
//
//  Created by Jameson Weng on 2017-05-05.
//  Copyright © 2017 Jameson Weng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)submitPassword:(UIButton *)sender;

@end
