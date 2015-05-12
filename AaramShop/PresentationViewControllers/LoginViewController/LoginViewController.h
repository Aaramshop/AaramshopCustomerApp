//
//  LoginViewController.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController<UIGestureRecognizerDelegate>
{
    
    __weak IBOutlet UITextField *txtUserName;
    
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UIScrollView *scrollViewLogin;
    __weak IBOutlet UIActivityIndicatorView *activityVw;
}
- (IBAction)btnForgotPasswordClick:(UIButton *)sender;
- (IBAction)btnLoginClick:(UIButton *)sender;
- (IBAction)btnBackClick:(UIButton *)sender;

@end
