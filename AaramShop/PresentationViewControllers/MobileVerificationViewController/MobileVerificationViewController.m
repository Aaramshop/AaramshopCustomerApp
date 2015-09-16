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
	if (strMobileNum == nil) {
		strMobileNum = [[NSUserDefaults standardUserDefaults] valueForKey:kMobile];
	}
    NSInteger mobLength = [strMobileNum length];
    lblMobileNumber.text = [NSString stringWithFormat:@"xxx xxx xx%@",[strMobileNum substringFromIndex:mobLength-2]];
	UIImageView *img = [[UIImageView alloc] init];
	[img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImage_url_320],[[NSUserDefaults standardUserDefaults] valueForKey:kProfileImage]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		
		
	}];
	if (gAppManager.imgProfile == nil) {
		gAppManager.imgProfile = img.image;
	}
	
    if (gAppManager.imgProfile) {
        effectImage = [UIImageEffects imageByApplyingDarkEffectToImage:gAppManager.imgProfile];
        imgVBg.image = effectImage;
    }
    else
        imgVBg.image = [UIImage imageNamed:@"bg4.jpg"];
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"MobileVerification"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void)createDataForOtpSend
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
//    [dict removeObjectForKey:kSessionToken];
    [dict setObject:txtfVerificationCode.text forKey:kOtp];
    [dict setObject:strMobileNum forKey:kMobile];
    
    if (self.responseData)// Priyanka's code .. begin (before 25 Aug 2015)
    {
        [dict setObject:[self.responseData valueForKey:kUserId] forKey:kUserId];
        [self callWebserviceForOtpSend:dict];
	}// Priyanka's code .. end
	else
	{
		[self callWebserviceForOtpSend:dict]; // Arbab ... 25 Aug 2015
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
    
    
    if (self.responseData) // Priyanka's code .. begin (before 25 Aug 2015)
    {
        [dict setObject:[self.responseData valueForKey:kUserId] forKey:kUserId];
        [self callWebserviceForOtpResend:dict];
    }// Priyanka's code .. end
	else
	{
		[self callWebserviceForOtpResend:dict]; // Arbab ... 25 Aug 2015
	}
	
}

-(void)callWebserviceForOtpResend:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
		[continueBtn setEnabled:YES];
		[resendBtn setEnabled:YES];
		[backBtn setEnabled:YES];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kResendOtpURL withInput:aDict withCurrentTask:TASK_RESEND_OTP andDelegate:self];
}

-(void) didFailWithError:(NSError *)error
{
	[continueBtn setEnabled:YES];
	[resendBtn setEnabled:YES];
	[backBtn setEnabled:YES];
    [aaramShop_ConnectionManager failureBlockCalled:error];
	
}

-(void) responseReceived:(id)responseObject
{
	[continueBtn setEnabled:YES];
	[resendBtn setEnabled:YES];
	[backBtn setEnabled:YES];
    if (aaramShop_ConnectionManager.currentTask == TASK_VERIFY_MOBILE) {
        if ([[responseObject objectForKey:kIsValid] isEqualToString:@"1"] && [[responseObject objectForKey:kstatus] intValue] == 1) {

            // temporary commented , for testing purpose
            
//            if ([_strIsRegistered intValue]==1)
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessfulNotificationName object:self userInfo:nil];
//            }
//            else
//            {
			
			
//            }
			if (self.responseData) {//Priyanka's code begins(before 25 Aug)

				[self saveDataToLocal:self.responseData];
			}//Priyanka's code ends(before 25 Aug)
			else // Arbab's code begins (25 August)
			{
				[self saveDataToLocal:responseObject];
			}
			if ([[[NSUserDefaults standardUserDefaults]valueForKey:kUser_address] count]>0) {
				[[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessfulNotificationName object:self userInfo:nil];
				
			}
			else
			{
				LocationEnterViewController *locationScreen = (LocationEnterViewController*) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationEnterScreen"];
				[self.navigationController pushViewController:locationScreen animated:YES];
			}
			

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
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:kUserId]] forKey:kUserId];
    
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
	[[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kUser_address] forKey:kUser_address];
	[[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kCity] forKey:kCity];
	[[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kState] forKey:kState];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}



@end
