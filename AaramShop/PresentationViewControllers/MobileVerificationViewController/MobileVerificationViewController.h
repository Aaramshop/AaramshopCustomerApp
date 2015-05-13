//
//  MobileVerificationViewController.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileVerificationViewController : BaseViewController<UIGestureRecognizerDelegate>
{
    
    __weak IBOutlet UITextField *txtfVerificationCode;
    __weak IBOutlet UILabel *lblMobileNumber;
    __weak IBOutlet UIImageView *imgVBg;
}
@property(nonatomic,strong) NSString *strMobileNum;
- (IBAction)btnBackClick:(UIButton *)sender;
- (IBAction)btnContinueVerificationClick:(UIButton *)sender;
- (IBAction)btnResendVerificationClick:(UIButton *)sender;

@end
