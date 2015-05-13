//
//  ForgotPasswordViewController.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
