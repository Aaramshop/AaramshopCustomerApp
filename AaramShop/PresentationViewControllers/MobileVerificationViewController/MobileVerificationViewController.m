//
//  MobileVerificationViewController.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "MobileVerificationViewController.h"

#import "LocationEnterViewController.h"

@interface MobileVerificationViewController ()
{
    UIImage * effectImage;
}
@end

@implementation MobileVerificationViewController
@synthesize strMobileNum,aaramShop_ConnectionManager,responseData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
    aaramShop_ConnectionManager.delegate=self;
    UITapGestureRecognizer *gst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    gst.cancelsTouchesInView = NO;
    gst.delegate = self;
    [self.view addGestureRecognizer:gst];
    
    NSInteger mobLength = [strMobileNum length];
    lblMobileNumber.text = [NSString stringWithFormat:@"xxx xxx xx%@",[strMobileNum substringFromIndex:mobLength-2]];

    if (gAppManager.imgProfile) {
        effectImage = [UIImageEffects imageByApplyingDarkEffectToImage:gAppManager.imgProfile];
        imgVBg.image = effectImage;
    }
    else
        imgVBg.image = [UIImage imageNamed:@"bg4.jpg"];
}

-(void)createDataForOtpSend
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
//    [dict removeObjectForKey:kSessionToken];
    [dict setObject:txtfVerificationCode.text forKey:kOtp];
    [dict setObject:strMobileNum forKey:kMobile];
    
    if (self.responseData)
    {
        [dict setObject:[self.responseData valueForKey:kUserId] forKey:kUserId];
        [self callWebserviceForOtpSend:dict];
    }
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
    [aaramShop_ConnectionManager getDataForFunction:kOtpValidateURL withInput:aDict withCurrentTask:TASK_VERIFY_MOBILE andDelegate:self];
}

-(void)createDataForOtpResend
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
//    [dict removeObjectForKey:kSessionToken];
    [dict setObject:strMobileNum forKey:kMobile];
    
    
    if (self.responseData)
    {
        [dict setObject:[self.responseData valueForKey:kUserId] forKey:kUserId];
        [self callWebserviceForOtpResend:dict];
    }
    
}

-(void)callWebserviceForOtpResend:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    [continueBtn setEnabled:YES];
    [resendBtn setEnabled:YES];
    [backBtn setEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kResendOtpURL withInput:aDict withCurrentTask:TASK_RESEND_OTP andDelegate:self];
}

-(void) didFailWithError:(NSError *)error
{
    [aaramShop_ConnectionManager failureBlockCalled:error];
    [continueBtn setEnabled:YES];
    [resendBtn setEnabled:YES];
    [backBtn setEnabled:YES];
}
-(void) responseReceived:(id)responseObject
{
    
    if (aaramShop_ConnectionManager.currentTask == TASK_VERIFY_MOBILE) {
        if ([[responseObject objectForKey:kIsValid] isEqualToString:@"1"] && [[responseObject objectForKey:kstatus] intValue] == 1) {
            [AppManager saveUserDatainUserDefault];

            // temporary commented , for testing purpose
            
//            if ([_strIsRegistered intValue]==1)
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessfulNotificationName object:self userInfo:nil];
//            }
//            else
//            {
                LocationEnterViewController *locationScreen = (LocationEnterViewController*) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationEnterScreen"];
                [self.navigationController pushViewController:locationScreen animated:YES];
//            }
            

            [self saveDataToLocal:self.responseData];

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
    [continueBtn setEnabled:YES];
    [resendBtn setEnabled:YES];
    [backBtn setEnabled:YES];
}

#pragma mark - UITextfield Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtfVerificationCode resignFirstResponder];
    
    [self btnContinueClicked:continueBtn];
    
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
//    [sender setEnabled:NO];
//    [resendBtn setEnabled:NO];
//    [backBtn setEnabled:NO];
//      [self createDataForOtpSend];
    /*
    if ([txtfVerificationCode.text length] == 0) {
        [Utils showAlertView:kAlertTitle message:@"Please enter verification code to continue" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else
    {
        [self createDataForOtpSend];
    }
     */
    
    [self btnContinueClicked:sender];
}


-(void)btnContinueClicked:(UIButton *)sender
{
    [sender setEnabled:NO];
    [resendBtn setEnabled:NO];
    [backBtn setEnabled:NO];
    [self createDataForOtpSend];

}


- (IBAction)btnResendVerificationClick:(UIButton *)sender {
    [sender setEnabled:NO];
    [resendBtn setEnabled:NO];
    [backBtn setEnabled:NO];
    [self createDataForOtpResend];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)saveDataToLocal:(id)responseObject{
    
    
    NSDictionary *dict = (NSDictionary*)responseObject;
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kUserId] forKey:kUserId];
    
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kDeviceId] forKey:kDeviceId];
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kImage_url_100] forKey:kImage_url_100];
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kImage_url_320] forKey:kImage_url_320];
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kImage_url_640] forKey:kImage_url_640];
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kFullname] forKey:kFullname];
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kProfileImage] forKey:kProfileImage];
    if([dict objectForKey:kChatUsername])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kChatUsername] forKey:kChatUsername];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@@%@",[dict objectForKey:kChatUsername],STRChatServerURL] forKey:kXMPPmyJID1];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}



@end
