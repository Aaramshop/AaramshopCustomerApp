//
//  UpdateMobileViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 24/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMUpdateUsers.h"
#import "MobileVerificationViewController.h"
@interface UpdateMobileViewController : UIViewController<AaramShop_ConnectionManager_Delegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
	__weak IBOutlet UIImageView *imgVUser;
	__weak IBOutlet UIButton *btnProfile;
	
	__weak IBOutlet UITextField *txtFMobileNumber;
	__weak IBOutlet UIButton *backBtn;
	__weak IBOutlet UIImageView *imgBackground;
	UIImage *imgUser;
	NSData *imageData;
	
	__weak IBOutlet UILabel *lbltakeyourselfie;
	__weak IBOutlet UITextField *txtFullName;
	__weak IBOutlet UIButton *btnContinue;
}
@property (strong, nonatomic)CMUpdateUsers *updateUserModel;
@property(nonatomic,assign) BOOL isUpdateMobile;
@property (nonatomic) UIImage *image;
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;
- (IBAction)btnContinueClick:(UIButton *)sender;
- (IBAction)btnBackClick:(UIButton *)sender;
- (IBAction)btnPickProfileClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet AKKeyboardAvoidingScrollView *scrollViewMobileEnter;
@end
