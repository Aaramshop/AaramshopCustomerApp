//
//  MobileVerificationViewController.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "MobileVerificationViewController.h"


@interface MobileVerificationViewController ()
{
    UIImage * effectImage;
}
@end

@implementation MobileVerificationViewController
@synthesize strMobileNum,aaramShop_ConnectionManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
    aaramShop_ConnectionManager.delegate=self;
    UITapGestureRecognizer *gst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    gst.cancelsTouchesInView = NO;
    gst.delegate = self;
    [self.view addGestureRecognizer:gst];
    
    lblMobileNumber.text = [NSString stringWithFormat:@"xxx xxx xx%@",[strMobileNum substringFromIndex:8]];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:kImage];
    if (imageData) {
        UIImage* image = [UIImage imageWithData:imageData];
        effectImage = [UIImageEffects imageByApplyingDarkEffectToImage:image];
        imgVBg.image = effectImage;

    }
    else
        imgVBg.image = [UIImage imageNamed:@"bg4.jpg"];
}

-(void)createDataForOtpSend
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kSessionToken];
    [dict setObject:kOptionLogin_otp_validate forKey:kOption];
    [dict setObject:txtfVerificationCode.text forKey:kOtp];
    [dict setObject:strMobileNum forKey:kMobile];
    [self callWebserviceForOtpSend:dict];
    /*

    UITabBarController *tabBarController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarScreen"];
    [self.navigationController pushViewController:tabBarController animated:YES];
     */
}
-(void)createDataForOtpResend
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kSessionToken];
    [dict setObject:strMobileNum forKey:kMobile];
    [dict setObject:kOptionResend_otp forKey:kOption];
    [self callWebserviceForOtpResend:dict];
    /*
     
     UITabBarController *tabBarController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarScreen"];
     [self.navigationController pushViewController:tabBarController animated:YES];
     */
}


-(void)callWebserviceForOtpSend:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:@"" withInput:aDict withCurrentTask:TASK_VERIFY_MOBILE andDelegate:self];
}
-(void)callWebserviceForOtpResend:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:@"" withInput:aDict withCurrentTask:TASK_RESEND_OTP andDelegate:self];
}

-(void) didFailWithError:(NSError *)error
{
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_VERIFY_MOBILE) {
        if ([[responseObject objectForKey:kIsValid] isEqualToString:@"1"] && [[responseObject objectForKey:kstatus] intValue] == 1) {
            UITabBarController *tabBarController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarScreen"];
            [self.navigationController pushViewController:tabBarController animated:YES];
            
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
    else if (aaramShop_ConnectionManager.currentTask == TASK_RESEND_OTP)
    {
        if ([[responseObject objectForKey:kstatus]intValue] == 1) {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];

        }
    }
}

#pragma mark - UITextfield Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtfVerificationCode resignFirstResponder];
    return YES;
}
-(void)hideKeyboard
{
    [txtfVerificationCode resignFirstResponder];
}

#pragma mark - Button Actions

- (IBAction)btnBackClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)btnContinueVerificationClick:(UIButton *)sender {
      [self createDataForOtpSend];
    /*
    if ([txtfVerificationCode.text length] == 0) {
        [Utils showAlertView:kAlertTitle message:@"Please enter verification code to continue" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else
    {
        [self createDataForOtpSend];
    }
     */
}

- (IBAction)btnResendVerificationClick:(UIButton *)sender {
    [self createDataForOtpResend];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
