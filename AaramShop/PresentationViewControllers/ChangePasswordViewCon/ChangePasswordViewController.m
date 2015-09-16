//
//  ChangePasswordViewController.m
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 09/07/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;
	[self setUpNavigationBar];
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"ChangePassword"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
-(void)setUpNavigationBar
{
	CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 150, 44);
	UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
	_headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
	_headerTitleSubtitleView.autoresizesSubviews = NO;
	
	CGRect titleFrame = CGRectMake(0,0, 150, 44);
	UILabel* titleView = [[UILabel alloc] initWithFrame:titleFrame];
	titleView.backgroundColor = [UIColor clearColor];
	titleView.font = [UIFont fontWithName:kRobotoRegular size:15];
	titleView.textAlignment = NSTextAlignmentCenter;
	titleView.textColor = [UIColor whiteColor];
	titleView.text = @"Change Password";
	titleView.adjustsFontSizeToFitWidth = YES;
	[_headerTitleSubtitleView addSubview:titleView];
	self.navigationItem.titleView = _headerTitleSubtitleView;
	
	UIImage *imgBack = [UIImage imageNamed:@"backBtn"];
	backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.bounds = CGRectMake( -10, 0, 30, 30);
	
	[backBtn setImage:imgBack forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	
	NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
	self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void)backBtn
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)isValid
{
	txtCurPassword.text = [txtCurPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	txtNewPassword.text = [txtNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	txtConfirmPass.text = [txtConfirmPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	
	if ([txtCurPassword.text length]==0)
	{
		[Utils showAlertView:kAlertTitle message:@"Enter Current Password" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return NO;
	}
	else if ([txtNewPassword.text length]==0)
	{
		[Utils showAlertView:kAlertTitle message:@"Enter New Password" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return NO;
	}
	else if ([txtConfirmPass.text length]==0)
	{
		[Utils showAlertView:kAlertTitle message:@"Enter Confirm Password" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return NO;
	}
	else if (![txtNewPassword.text isEqualToString:txtConfirmPass.text])
	{
		[Utils showAlertView:kAlertTitle message:@"New Password & Confirm Password not matched" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return NO;
	}
	return YES;
}


- (IBAction)btnSubmit:(id)sender {
	if ([self isValid]) {
		[sender setEnabled:NO];
		[backBtn setEnabled:NO];
		[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
		NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
		[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
		[dict setObject:txtCurPassword.text forKey:kOld_password];
		[dict setObject:txtNewPassword.text forKey:kNew_password];
		[self performSelector:@selector(callWebserviceToChangePassword:) withObject:dict];
	}
}

#pragma mark - Call Webservice To Change Password
- (void)callWebserviceToChangePassword:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[submitBtn setEnabled:YES];
		[backBtn setEnabled:YES];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLChangePassword withInput:aDict withCurrentTask:TASK_TO_CHANGE_PASSWORD andDelegate:self ];
}

- (void)responseReceived:(id)responseObject
{
	[submitBtn setEnabled:YES];
	[backBtn setEnabled:YES];
	[AppManager stopStatusbarActivityIndicator];
	if (aaramShop_ConnectionManager.currentTask == TASK_TO_CHANGE_PASSWORD)
	{
		if([[responseObject objectForKey:kstatus] intValue] == 1)
		{
			
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
			
		}
		else
		{
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}
	}
}
- (void)didFailWithError:(NSError *)error
{
	[submitBtn setEnabled:YES];
	[backBtn setEnabled:YES];
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void)clearFields
{
	txtNewPassword.text	=	@"";
	txtCurPassword.text		=	@"";
	txtConfirmPass.text		=	@"";

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[self clearFields];
	}
	else
	{
		
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	
	NSInteger nextTag = textField.tag + 1;
	// Try to find next responder
	UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
	if (nextResponder) {
		// Found next responder, so set it.
		[nextResponder becomeFirstResponder];
		
	} else {
		// Not found, so remove keyboard.
		
		[self btnSubmit:submitBtn];
		[textField resignFirstResponder];

	}
	return YES; // We do not want UITextField to insert line-breaks.
	
	
}

@end
