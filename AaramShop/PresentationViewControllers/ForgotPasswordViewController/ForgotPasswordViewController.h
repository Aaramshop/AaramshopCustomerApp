//
//  ForgotPasswordViewController.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : BaseViewController<UIGestureRecognizerDelegate,AaramShop_ConnectionManager_Delegate>
{
    
    __weak IBOutlet UIScrollView *scrollViewForgotPassword;
    __weak IBOutlet UITextField *txtfEmail;
    
    __weak IBOutlet UIButton *btnSend;
}
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

- (IBAction)btnBackClick:(UIButton *)sender;
- (IBAction)btnSendClick:(UIButton *)sender;

@end
