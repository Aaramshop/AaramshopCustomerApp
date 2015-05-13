//
//  MobileEnterViewController.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileEnterViewController : BaseViewController<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    
    __weak IBOutlet UIImageView *imgVUser;
    __weak IBOutlet UIButton *btnProfile;
    __weak IBOutlet UIScrollView *scrollViewMobileEnter;
    __weak IBOutlet UITextField *txtFMobileNumber;
    UIImage *imgUser;
    NSData *imageData;
}
- (IBAction)btnContinueClick:(UIButton *)sender;
- (IBAction)btnBackClick:(UIButton *)sender;
- (IBAction)btnPickProfileClick:(UIButton *)sender;

@end
