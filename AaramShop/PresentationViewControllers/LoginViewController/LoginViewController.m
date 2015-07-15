//
//  LoginViewController.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgotPasswordViewController.h"
#import "MobileEnterViewController.h"
#import "MobileVerificationViewController.h"
#import "LocationEnterViewController.h"
@interface LoginViewController ()
{
    AppDelegate *appDeleg;
}
@end

@implementation LoginViewController
@synthesize aaramShop_ConnectionManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    appDeleg = APP_DELEGATE;
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;

    UITapGestureRecognizer *gst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    gst.cancelsTouchesInView = NO;
    gst.delegate = self;
    [self.view addGestureRecognizer:gst];
    
    
#ifdef DEBUG
    
    txtUserName.text = @"9999614234";
    txtPassword.text = @"123456";

#else
    //
#endif
    
    
    
}

-(BOOL)validateEmail:(NSString*)email andPassword:(NSString *)password
{
    NSString *regex1 = @"\\A[a-z0-9]+([-._][a-z0-9]+)*@([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,4}\\z";
    NSString *regex2 = @"^(?=.{1,64}@.{4,64}$)(?=.{6,100}$).*";
    NSPredicate *test1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate *test2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    if ([test1 evaluateWithObject:email] && [test2 evaluateWithObject:email] && password.length>0)
    {
        return YES;
    }
    return NO;
}


#pragma mark - Button Actions

- (IBAction)btnForgotPasswordClick:(UIButton *)sender {
    
    ForgotPasswordViewController *forgotPasswordVwController = (ForgotPasswordViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgotPasswordScreen"];
    [self.navigationController pushViewController:forgotPasswordVwController animated:YES];
}

- (IBAction)btnLoginClick:(UIButton *)sender {
    
    [self.loginClickBtn setEnabled:NO];
    txtUserName.text = [txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (txtUserName.text.length>1) {
        NSString *str = [txtUserName.text substringToIndex:1];
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:kTextFieldDigitRange];
        NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:str];
        BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
        if(stringIsValid)
        {
            if(txtUserName.text.length != 10)
            {
                [Utils showAlertView:kAlertTitle message:@"Please enter valid mobile number" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
                [sender setEnabled:YES];
            }
            else if(txtPassword.text.length==0)
            {
                [Utils showAlertView:kAlertTitle message:@"Please enter password" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
                [sender setEnabled:YES];
            }
            else
                [self createDataForLogin];
        }
        else
        {
            if ([self validateEmail:txtUserName.text andPassword:txtPassword.text])
            {
                [self createDataForLogin];
            }
            else
            {
                [Utils showAlertView:kAlertTitle message:@"Please enter Email-id/Mobile no to continue" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
                [sender setEnabled:YES];
            }
        }
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Please enter Email-id/Mobile no to continue" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        [sender setEnabled:YES];
    }
}

- (IBAction)btnBackClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)createDataForLogin
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kUserId];
//    [dict removeObjectForKey:kSessionToken];
    [dict setObject:txtUserName.text forKey:kUsername];
    [dict setObject:txtPassword.text forKey:kpassword];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    [self callWebserviceForLogin:dict ];
}
# pragma webService Calling
-(void)callWebserviceForLogin:(NSMutableDictionary*)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    [activityVw startAnimating];

    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [activityVw stopAnimating];
        [self.loginClickBtn setEnabled:YES];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kExistingUserURL withInput:aDict withCurrentTask:TASK_LOGIN andDelegate:self ];
}

-(void) didFailWithError:(NSError *)error
{
    [activityVw stopAnimating];
    [self.loginClickBtn setEnabled:YES];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    [activityVw stopAnimating];
    if (aaramShop_ConnectionManager.currentTask == TASK_LOGIN) {
        [self.loginClickBtn setEnabled:YES];

        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kMessage] isEqualToString:@"OTP Sent!"]) {
            MobileVerificationViewController *mobileVerificationVwController =              (MobileVerificationViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MobileVerificationScreen" ];
            [self.navigationController pushViewController:mobileVerificationVwController animated:YES];
        }
        else if ([[responseObject objectForKey:kMobile_verified] intValue] == 1 && [[responseObject objectForKey:kstatus] intValue] == 1)
        {
            [AppManager saveDataToNSUserDefaults:responseObject];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@@%@",[responseObject objectForKey:kchatUserName],STRChatServerURL] forKey:kXMPPmyJID1];
            [[NSUserDefaults standardUserDefaults ]synchronize];
            [gCXMPPController connect];
            [AppManager saveUserDatainUserDefault];
            
                LocationEnterViewController *locationScreen = (LocationEnterViewController*) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationEnterScreen"];
                [self.navigationController pushViewController:locationScreen animated:YES];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
}


#pragma mark - UITextfield Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtUserName) {
        
        [scrollViewLogin setContentOffset:CGPointMake(0, 200) animated:YES];
    }
    else
        [scrollViewLogin setContentOffset:CGPointMake(0, 250) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
        
        
    } else {
        // Not found, so remove keyboard.
        
        [textField resignFirstResponder];
        [self btnLoginClick:self.loginClickBtn];
        
    }
    return YES; // We do not want UITextField to insert line-breaks.
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length>2) {
        NSString *str = [textField.text substringToIndex:1];
        
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:kTextFieldDigitRange];
        NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:str];
        BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
        if(stringIsValid)
        {
            if(textField.text.length == 10)
                if(range.length == 0)
                    return NO;
        }
    }
    
    return YES;
}

#pragma mark - Guesture delegates
-(void)hideKeyboard
{
    [scrollViewLogin setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtUserName resignFirstResponder];
    [txtPassword resignFirstResponder];
}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
