//
//  ChangePasswordViewController.h
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 09/07/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
	
	__weak IBOutlet PWTextField *txtNewPassword;
	__weak IBOutlet PWTextField *txtCurPassword;
	__weak IBOutlet PWTextField *txtConfirmPass;
	__weak IBOutlet UIButton *submitBtn;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	UIButton *backBtn;
}
- (IBAction)btnSubmit:(id)sender;
@end
