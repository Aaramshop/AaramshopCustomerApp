//
//  LoginViewController.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateMobileViewController.h"
#import "CMUpdateUsers.h"
@interface LoginViewController : UIViewController<UIGestureRecognizerDelegate,AaramShop_ConnectionManager_Delegate,CustomNavigationDelegate>
{
    
    __weak IBOutlet UITextField *txtUserName;
    
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UIScrollView *scrollViewLogin;
    __weak IBOutlet UIActivityIndicatorView *activityVw;
	CMUpdateUsers *updateUserModel;
}
@property (weak, nonatomic) IBOutlet UIButton *loginClickBtn;
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;
- (IBAction)btnForgotPasswordClick:(UIButton *)sender;
- (IBAction)btnLoginClick:(UIButton *)sender;
- (IBAction)btnBackClick:(UIButton *)sender;

@end
