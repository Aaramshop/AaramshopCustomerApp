//
//  MobileEnterViewController.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "MobileEnterViewController.h"
#import "MobileVerificationViewController.h"
#import "AppsFlyerTracker.h"

@interface MobileEnterViewController ()
{
    UIImage * effectImage;
    AppDelegate *appDeleg;
}
@property (nonatomic) UIImage *image;
@end

@implementation MobileEnterViewController
@synthesize isUpdateMobile,aaramShop_ConnectionManager,scrollViewMobileEnter;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDeleg = APP_DELEGATE;
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;
    [self setCountryCode];
    imgVUser.layer.cornerRadius = imgVUser.frame.size.height/2;
    imgVUser.clipsToBounds = YES;
    
    btnProfile.layer.cornerRadius = btnProfile.frame.size.height/2;
    btnProfile.clipsToBounds = YES;
    btnProfile.backgroundColor = [UIColor clearColor];
    scrollViewMobileEnter = [[AKKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollViewMobileEnter.frame.size.width, 0.01f)];
    scrollViewMobileEnter.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    UITapGestureRecognizer *gst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    gst.cancelsTouchesInView = NO;
    gst.delegate = self;
    [self.view addGestureRecognizer:gst];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.1)
    {
        UIGraphicsBeginImageContextWithOptions(self.image.size, NO, self.image.scale);
        [self.image drawAtPoint:CGPointZero];
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    if (self.view.frame.size.height <=560 ) {
        [imgVUser setFrame:CGRectMake(0, 0, 160, 160)];
    }
    
    if (gAppManager.imgProfile) {
        effectImage = [UIImageEffects imageByApplyingDarkEffectToImage:gAppManager.imgProfile];
        imgBackground.image = effectImage;
        imgVUser.image = gAppManager.imgProfile;
        lbltakeyourselfie.text = @"Change Picture";
    }
    else
    {
        imgBackground.image = [UIImage imageNamed:@"bgImageNew"];
        lbltakeyourselfie.text = @"Take a Selfie";
    }
    [imgBackground setClipsToBounds:YES];
    [self parseCountryListData];


    NSString *firstName = [[NSUserDefaults standardUserDefaults]objectForKey:kFullname];
   // NSString *lastName = [[NSUserDefaults standardUserDefaults]objectForKey:kLastName];
    if ([firstName length]==0)
    {
        txtFullName.text = @"";
    }
    else
    {
        NSString *fullName = [NSString stringWithFormat:@"%@", firstName];
        txtFullName.text = fullName;
    }
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"MobileEnter"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
- (void)setCountryCode
{
	NSArray *arrCountryCode=[NSArray arrayWithArray:[gAppManager getcountryList]];
	for (id obj in arrCountryCode) {
		NSString *curCountryCode = [obj valueForKey:@"CountryName"];
		if ([curCountryCode isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:kCountryName]]) {
			imgFlagName.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[obj valueForKey:@"CountryFlag"]]];
			[btnCountryName setTitle:[NSString stringWithFormat:@"%@ *",[obj valueForKey:@"CountryName"]] forState:UIControlStateNormal];
			[lblPhoneCode setText:[NSString stringWithFormat:@"%@",[obj valueForKey:@"CountryCode"]]];
		}
	}
}
-(void)parseCountryListData
{
    [gAppManager countryCodeData];
    lblPhoneCode.text = gAppManager.cmCountryList.CountryCode;
    imgFlagName.image = [UIImage imageNamed:gAppManager.cmCountryList.CountryFlag];
    [btnCountryName setTitle:gAppManager.cmCountryList.CountryName forState:UIControlStateNormal];
}


-(void)hideKeyboard
{
    [txtFMobileNumber resignFirstResponder];
    [txtFullName resignFirstResponder];
}


- (IBAction)btnContinueClick:(UIButton *)sender {
    
    [sender setEnabled:NO];
    [backBtn setEnabled:NO];
    if ([txtFMobileNumber.text length]==0 || [txtFMobileNumber.text length]>11 || [txtFMobileNumber.text length]<8) {
        [Utils showAlertView:kAlertTitle message:@"Please enter valid mobile number" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        [sender setEnabled:YES];
        [backBtn setEnabled:YES];

        return;
    }
    else if ([txtFullName.text length]==0 || [txtFullName.text length]>50) {
        [Utils showAlertView:kAlertTitle message:@"Please enter your full name" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        [sender setEnabled:YES];
        [backBtn setEnabled:YES];

        return;
    }
    else
    {
        if (isUpdateMobile)
        {
            [self createDataToUpdateMobileNumber];
        }
        else
            [self createDataToEnterMobileNumber];
    }
}
-(void)createDataToEnterMobileNumber
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kUserId];
    //    [dict removeObjectForKey:kSessionToken];
    
    [dict setObject:txtFMobileNumber.text forKey:kMobile];
    [dict setObject:txtFullName.text forKey:kFullname];
    [dict setObject:btnCountryName.titleLabel.text forKey:kCountryName];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    
    [self callWebserviceForEnterNewMobile:dict];
}
-(void)createDataToUpdateMobileNumber
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];

    [dict setObject:txtFMobileNumber.text forKey:kMobile];
    [dict setObject:txtFullName.text forKey:kFullname];
    [dict setObject:btnCountryName.titleLabel.text forKey:kCountryName];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    [self callWebserviceForEnterNewMobile:dict];
}
# pragma webService Calling
-(void)callWebserviceForEnterNewMobile:(NSMutableDictionary*)aDict
{

    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [btnContinue setEnabled:YES];
        [backBtn setEnabled:YES];

        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kNewUserURL withInput:aDict withCurrentTask:TASK_ENTER_MOBILE_NUMBER Delegate:self andMultipartData:imageData withMediaKey:kProfileImage];
}
-(void) didFailWithError:(NSError *)error
{
    [btnContinue setEnabled:YES];
    [backBtn setEnabled:YES];

    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_ENTER_MOBILE_NUMBER) {
        [btnContinue setEnabled:YES];
        [backBtn setEnabled:YES];

        if ([[responseObject objectForKey:kstatus]intValue] == 1 &&[[responseObject objectForKey:kIsValid]intValue] == 1 ) {
            
//            [self saveDataToLocal:responseObject];
            NSLog(@"...........----->>%@",responseObject);
            MobileVerificationViewController *mobileVerificationVwController = (MobileVerificationViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MobileVerificationScreen"];
            mobileVerificationVwController.strMobileNum = txtFMobileNumber.text;
            mobileVerificationVwController.strIsRegistered = [responseObject objectForKey:@"isRegistered"];
                        
            mobileVerificationVwController.responseData = responseObject;
            
            [self saveDataForInternationalisation:responseObject];
            
            [self.navigationController pushViewController:mobileVerificationVwController animated:YES];
        
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
        
    }
}
-(void)updateCurrencySymbol:(id)responseObject
{
    
    // Follwing code  used for the internationalization.......by Shahul
    NSNumber* tStr;
    for (NSString* str in [responseObject allKeys])
    {
        if([str isEqualToString:@"countryCode"])
        {
            tStr=[responseObject objectForKey:@"countryCode"];
        }
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CountryCodeList" ofType:@"plist"];
    NSArray *plistData = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary* tDic in plistData)
    {
        
        if([tDic objectForKey:@"Country Code"]==tStr)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[tDic objectForKey:@"Country Symbol"] forKey:kCurrencySymbol];
            
        }
    }
}
//-(void)saveDataToLocal:(id)responseObject{
//    
//    
//    NSDictionary *dict = (NSDictionary*)responseObject;
//    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kUserId] forKey:kUserId];
//    
//    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kDeviceId] forKey:kDeviceId];
//    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kImage_url_100] forKey:kImage_url_100];
//    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kImage_url_320] forKey:kImage_url_320];
//    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kImage_url_640] forKey:kImage_url_640];
//    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kFullname] forKey:kFullname];
//    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kProfileImage] forKey:kProfileImage];
//    if([dict objectForKey:kChatUsername])
//    {
//        [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kChatUsername] forKey:kChatUsername];
//        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@@%@",[dict objectForKey:kChatUsername],STRChatServerURL] forKey:kXMPPmyJID1];
//    }
//    [[NSUserDefaults standardUserDefaults]synchronize];
//
//}

-(void)createDataForOTPValidation
{
    //    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    //    [dict setObject:txtFMobileNumber.text forKey:kMobile];
    //    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    //    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    //    [dict removeObjectForKey:kUserId];
    //    [dict removeObjectForKey:kSessionToken];
    //    [self callWebserviceForSignUp:dict];
    
    
}

- (IBAction)btnBackClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnPickProfileClick:(UIButton *)sender {
    
    NSMutableArray * arrbuttonTitles = [[NSMutableArray alloc]initWithObjects:@"Camera",@"Select from Library", nil];
    
    [arrbuttonTitles addObject:@"Cancel"];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: nil destructiveButtonTitle: nil otherButtonTitles: nil];
    
    for (NSString *title in arrbuttonTitles) {
        [actionSheet addButtonWithTitle: title];
    }
    [actionSheet setCancelButtonIndex: [arrbuttonTitles count] - 1];
    
    [actionSheet showInView:self.view];
}

- (IBAction)btnCountryList:(id)sender {
    FlagListTableViewController *flagListVwController = (FlagListTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"flagScreen"];
    flagListVwController.delegate = self;
    [self.navigationController pushViewController:flagListVwController animated:YES];
}
-(void)updateCountryData:(CMCountryList *)objCountryData
{
    gAppManager.cmCountryList = objCountryData;
    lblPhoneCode.text = gAppManager.cmCountryList.CountryCode;
    imgFlagName.image = [UIImage imageNamed:gAppManager.cmCountryList.CountryFlag];
    [btnCountryName setTitle:gAppManager.cmCountryList.CountryName forState:UIControlStateNormal];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == txtFMobileNumber)
    {
        if((range.location >= 10))
            return NO;
    }
    

    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing=YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:^{}];
            }
            else
            {
                [Utils showAlertView:@"" message:@"Camera is not available." delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            }
        }
            break;
        case 1:
        {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing=YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:^{}];
        }
            break;
        case 2:
        {
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
            break;
            
        default:
            // Do Nothing.........
            break;
    }
}


#pragma - mark Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)pickerVw didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [pickerVw dismissViewControllerAnimated:YES completion:^{
        
        imgUser = [UIImage scaleDownOriginalImage:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
        
        gAppManager.imgProfile = imgUser;
        imageData = [NSMutableData dataWithData:UIImageJPEGRepresentation(gAppManager.imgProfile, 1.0)];
        imgVUser.image = gAppManager.imgProfile;
        imgBackground.image = gAppManager.imgProfile;
        effectImage = [UIImageEffects imageByApplyingDarkEffectToImage:gAppManager.imgProfile];
        imgBackground.image=effectImage;
        imgBackground.contentMode = UIViewContentModeScaleAspectFill;
        lbltakeyourselfie.text = @"Change Picture";
    }];
    
}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)saveDataForInternationalisation:(id)responseObject
{
	NSString *countryCode = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"countryCode"]];
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CountryCodeList" ofType:@"plist"];
	[AppsFlyerTracker sharedTracker].currencyCode = [[NSUserDefaults standardUserDefaults] valueForKey:kCurrencyCode];
	NSArray *plistData = [[NSArray alloc] initWithContentsOfFile:plistPath];
	for (NSDictionary* aDic in plistData)
	{
		NSString *curCountryCode =[NSString stringWithFormat:@"%@", [aDic objectForKey:@"Country Code"]];
		if([curCountryCode isEqualToString:countryCode])
		{
			[[NSUserDefaults standardUserDefaults] setObject:curCountryCode forKey:kCountryCode];
			NSString *curCountrySymbol =[NSString stringWithFormat:@"%@", [aDic objectForKey:@"Country Symbol"]];
			[[NSUserDefaults standardUserDefaults] setObject:curCountrySymbol forKey:kCurrencySymbol];
		}
	}
}
@end
