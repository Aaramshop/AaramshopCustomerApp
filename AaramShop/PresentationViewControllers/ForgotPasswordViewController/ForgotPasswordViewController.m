//
//  ForgotPasswordViewController.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()
{
    AppDelegate *appDeleg;
}
@end

@implementation ForgotPasswordViewController
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
}

-(BOOL)validateEmail:(NSString*)email
{
    NSString *regex1 = @"\\A[a-z0-9]+([-._][a-z0-9]+)*@([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,4}\\z";
    NSString *regex2 = @"^(?=.{1,64}@.{4,64}$)(?=.{6,100}$).*";
    NSPredicate *test1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate *test2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    if ([test1 evaluateWithObject:email] && [test2 evaluateWithObject:email])
    {
        return YES;
    }
    
    return NO;
}


#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
 [scrollViewForgotPassword setContentOffset:CGPointMake(0, 200) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollViewForgotPassword setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtfEmail resignFirstResponder];
    return YES;
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


#pragma mark - Guesture Delegates

-(void)hideKeyboard
{
    [scrollViewForgotPassword setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtfEmail resignFirstResponder];
}

#pragma mark - Button Actions

- (IBAction)btnBackClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSendClick:(UIButton *)sender {
    
    [btnSend setEnabled:NO];
    txtfEmail.text = [txtfEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (txtfEmail.text.length>1) {
        NSString *str = [txtfEmail.text substringToIndex:1];
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:kTextFieldDigitRange];
        NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:str];
        BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
        if(stringIsValid)
        {
            if(txtfEmail.text.length != 10)
            {
                [Utils showAlertView:kAlertTitle message:@"Please enter valid mobile number" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
                [sender setEnabled:YES];
            }
            else if(txtfEmail.text.length==0)
            {
                [Utils showAlertView:kAlertTitle message:@"Please enter password" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
                [sender setEnabled:YES];
            }
            else
                [self createDataForForgotPassword];
        }
        else
        {
            if ([self validateEmail:txtfEmail.text])
            {
                [self createDataForForgotPassword];
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

-(void)createDataForForgotPassword
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
//    [dict removeObjectForKey:kSessionToken];
    [dict removeObjectForKey:kUserId];
    [dict setObject:txtfEmail.text forKey:kUsername];
    [self callWebserviceForEnterNewMobile:dict];
}

# pragma webService Calling
-(void)callWebserviceForEnterNewMobile:(NSMutableDictionary*)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [btnSend setEnabled:YES];
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kForgotPasswordURL withInput:aDict withCurrentTask:TASK_FORGOT_PASSWORD Delegate:self andMultipartData:nil withMediaKey:nil];
}
-(void) didFailWithError:(NSError *)error
{
    [btnSend setEnabled:YES];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_FORGOT_PASSWORD) {
        [btnSend setEnabled:YES];
        
        if ([[responseObject objectForKey:kstatus]intValue] == 1 ) {
         
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];

        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
        
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
