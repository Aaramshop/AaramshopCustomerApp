//
//  MobileVerificationViewController.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileVerificationViewController : UIViewController<UIGestureRecognizerDelegate,AaramShop_ConnectionManager_Delegate>
{
    __weak IBOutlet UIButton *backBtn;
    
    __weak IBOutlet UIButton *continueBtn;
    __weak IBOutlet UIButton *resendBtn;
    __weak IBOutlet UITextField *txtfVerificationCode;
    __weak IBOutlet UILabel *lblMobileNumber;
    __weak IBOutlet UIImageView *imgVBg;
}
@property(nonatomic,strong) NSString *strMobileNum;
@property(nonatomic,strong)AaramShop_ConnectionManager *aaramShop_ConnectionManager;

@property (nonatomic,strong) NSString *strIsRegistered;

- (IBAction)btnBackClick:(UIButton *)sender;
- (IBAction)btnContinueVerificationClick:(UIButton *)sender;
- (IBAction)btnResendVerificationClick:(UIButton *)sender;


@end
