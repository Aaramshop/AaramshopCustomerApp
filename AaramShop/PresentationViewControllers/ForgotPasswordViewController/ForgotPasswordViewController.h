//
//  ForgotPasswordViewController.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : BaseViewController<UIGestureRecognizerDelegate>
{
    
    __weak IBOutlet UIScrollView *scrollViewForgotPassword;
    __weak IBOutlet UITextField *txtfEmail;
}
- (IBAction)btnBackClick:(UIButton *)sender;

@end
