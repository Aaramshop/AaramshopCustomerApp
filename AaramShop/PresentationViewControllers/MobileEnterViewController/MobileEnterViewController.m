//
//  MobileEnterViewController.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "MobileEnterViewController.h"
#import "MobileVerificationViewController.h"

@interface MobileEnterViewController ()
{
    AppDelegate *appDeleg;
}
@end

@implementation MobileEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDeleg = APP_DELEGATE;
    imgVUser.layer.cornerRadius = imgVUser.frame.size.height/2;
    imgVUser.clipsToBounds = YES;
    imgVUser.image = [UIImage imageNamed:@"defaultProfilePic.png"];
    
    btnProfile.layer.cornerRadius = btnProfile.frame.size.height/2;
    btnProfile.clipsToBounds = YES;
    btnProfile.backgroundColor = [UIColor clearColor];

    
    UITapGestureRecognizer *gst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    gst.cancelsTouchesInView = NO;
    gst.delegate = self;
    [self.view addGestureRecognizer:gst];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollViewMobileEnter setContentOffset:CGPointMake(0, 200) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollViewMobileEnter setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtFMobileNumber resignFirstResponder];
    return YES;
}
-(void)hideKeyboard
{
    [scrollViewMobileEnter setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtFMobileNumber resignFirstResponder];
}


- (IBAction)btnContinueClick:(UIButton *)sender {
    
    if ([txtFMobileNumber.text length]==0 || [txtFMobileNumber.text length]<10) {
        [Utils showAlertView:kAlertTitle message:@"Please enter valid mobile number" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else
    {
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:txtFMobileNumber.text forKey:kMobile];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    [dict setObject:kOptionNew_user_login forKey:kOption];
    [dict removeObjectForKey:kUserId];
    [dict removeObjectForKey:kSessionToken];
    [self callWebserviceForEnterNewMobile:dict];
    }
}
# pragma webService Calling
-(void)callWebserviceForEnterNewMobile:(NSMutableDictionary*)aDict
{
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
         //NSLog(@"value %@",responseObject);
         
         if ([[responseObject objectForKey:kstatus]intValue] == 1 &&[[responseObject objectForKey:kIsValid]intValue] == 1 && [[responseObject objectForKey:kMessage] isEqualToString:@"Mobile No. Registered & OTP Sent!"]) {
             
             [self saveDataToLocal:responseObject];
             MobileVerificationViewController *mobileVerificationVwController = (MobileVerificationViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MobileVerificationScreen"];
             mobileVerificationVwController.strMobileNum = txtFMobileNumber.text;
             [self.navigationController pushViewController:mobileVerificationVwController animated:YES];
         }
        // else if (<#expression#>)
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
-(void)saveDataToLocal:(id)responseObject{
    
    NSDictionary *dict = (NSDictionary*)responseObject;
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kUserId] forKey:kUserId];
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kDeviceId] forKey:kDeviceId];
}

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if((range.location >= 10))
        return NO;
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
        
        imgUser = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //myImagePickerController.allowsEditing=YES;
        imageData = [NSMutableData dataWithData:UIImageJPEGRepresentation(imgUser, 1.0)];
        imgVUser.image = imgUser;
    }];
}

#pragma mark - 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
