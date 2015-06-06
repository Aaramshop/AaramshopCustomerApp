//
//  MobileEnterViewController.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlagListTableViewController.h"
@interface MobileEnterViewController : BaseViewController<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,AaramShop_ConnectionManager_Delegate>
{
    
    __weak IBOutlet UIImageView *imgVUser;
    __weak IBOutlet UIButton *btnProfile;

    __weak IBOutlet UITextField *txtFMobileNumber;
    __weak IBOutlet UIImageView *imgFlagName;
    __weak IBOutlet UILabel *lblPhoneCode;
    __weak IBOutlet UIButton *btnCountryName;
    __weak IBOutlet UIImageView *imgBackground;
    UIImage *imgUser;
    NSData *imageData;
    
    __weak IBOutlet UILabel *lbltakeyourselfie;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextField *txtFullName;
    __weak IBOutlet UIButton *btnContinue;
}
@property(nonatomic,assign) BOOL isUpdateMobile;
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;
 - (IBAction)btnContinueClick:(UIButton *)sender;
- (IBAction)btnBackClick:(UIButton *)sender;
- (IBAction)btnPickProfileClick:(UIButton *)sender;
- (IBAction)btnCountryList:(id)sender;
@property (strong, nonatomic) IBOutlet AKKeyboardAvoidingScrollView *scrollViewMobileEnter;


@end
