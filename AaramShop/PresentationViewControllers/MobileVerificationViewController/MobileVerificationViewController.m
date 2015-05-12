//
//  MobileVerificationViewController.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "MobileVerificationViewController.h"


@interface MobileVerificationViewController ()

@end

@implementation MobileVerificationViewController
@synthesize strMobileNum;
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *gst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    gst.cancelsTouchesInView = NO;
    gst.delegate = self;
    [self.view addGestureRecognizer:gst];
    
    lblMobileNumber.text = [NSString stringWithFormat:@"xxx xxx xx%@",[strMobileNum substringFromIndex:8]];
}

-(void)createDataForOtpSend
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kSessionToken];
    [dict setObject:kOptionLogin_otp_validate forKey:kOption];
    [dict setObject:txtfVerificationCode.text forKey:kOtp];
    [dict setObject:strMobileNum forKey:kMobile];
    [self callWebserviceForOtpSend:dict];
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
    AFHTTPSessionManager *manager = [Utils InitSetUpForWebService];
    [manager POST:@"" parameters:aDict
          success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [AppManager stopStatusbarActivityIndicator];
         NSLog(@"value %@",responseObject);
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"value %@",error);
         [AppManager stopStatusbarActivityIndicator];
         
         
         if ([Utils isRequestTimeOut:error])
         {
             [Utils showAlertView:kAlertTitle message:kRequestTimeOutMessage delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
         }
         else
         {
             //  [Utils showAlertView:kAlertTitle message:kAlertServiceFailed delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
         }
     }];
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
    
    if ([txtfVerificationCode.text length] == 0) {
        [Utils showAlertView:kAlertTitle message:@"Please enter verification code to continue" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else
    {
        [self createDataForOtpSend];
    }
}

- (IBAction)btnResendVerificationClick:(UIButton *)sender {
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
