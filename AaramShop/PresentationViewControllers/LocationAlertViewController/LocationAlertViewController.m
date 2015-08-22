//
//  LocationAlertViewController.m
//  AaramShop
//
//  Created by Approutes on 16/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "LocationAlertViewController.h"
#import "LocationEnterViewController.h"
@interface LocationAlertViewController ()
{
    LocationEnterViewController *locationEnter;
    AppDelegate *appDeleg;
}
@end

@implementation LocationAlertViewController
@synthesize delegate,scrollView,objAddressModel,aaramShop_ConnectionManager,cordinatesLocation;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    subView.layer.cornerRadius = 5;
    subView.layer.masksToBounds = YES;
    
    appDeleg = APP_DELEGATE;
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;

    scrollView=[[AKKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, 0.01f)];
    
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [scrollView setContentSize:CGSizeMake(320, ([UIScreen mainScreen].bounds.size.height-100))];
    btnHome.selected = YES;
    btnOffice.selected = NO;
    btnOthers.selected = NO;
    [txtTitle setHidden:YES];
    [self bindData];

    
}
-(void)bindData
{
    txtAddress.text = objAddressModel.address;
    txtState.text = objAddressModel.state;
    txtCity.text = objAddressModel.city;
    txtLocality.text = objAddressModel.locality;
    txtPinCode.text = objAddressModel.pincode;
}
-(void)saveAddressIntoDataBase
{
//    NSMutableArray *arrAddress = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:kAddressForLocation]] ;
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:txtAddress.text forKey:kAddress];
//    [dict setObject:txtState.text forKey:kState];
//    [dict setObject:txtCity.text forKey:kCity];
//    [dict setObject:txtLocality.text forKey:kLocality];
//    [dict setObject:txtPinCode.text forKey:kPincode];
//    
//    if (btnHome.selected) {
//        [dict setObject:@"Home" forKey:kTitle];
//        [arrAddress replaceObjectAtIndex:0 withObject:dict];
//    }
//    else if (btnOffice.selected) {
//        [dict setObject:@"Office" forKey:kTitle];
//        [arrAddress replaceObjectAtIndex:1 withObject:dict];
//    }
//    else if (btnOthers.selected) {
//        [dict setObject:txtTitle.text forKey:kTitle];
//        [arrAddress addObject:dict];
//    }
//    
//    [[NSUserDefaults standardUserDefaults]setObject:arrAddress forKey:kAddressForLocation];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    
    [self.view removeFromSuperview];
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(LocationAlertViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(saveAddress)])
    {
        [self.delegate saveAddress];
    }
}

#pragma mark - UIButton Actions

- (IBAction)btnCancel:(id)sender
{
        [self.view removeFromSuperview];
}

- (IBAction)btnSave:(id)sender
{
    subView.userInteractionEnabled = NO;
    
    txtAddress.text = [txtAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    txtState.text = [txtState.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    txtCity.text = [txtCity.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    txtLocality.text = [txtLocality.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    txtPinCode.text = [txtPinCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([txtAddress.text length] == 0) {
        
        [Utils showAlertView:kAlertTitle message:@"Enter address" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        subView.userInteractionEnabled = YES;


        return;
    }
    
    else if ([txtState.text length] == 0) {
        
        [Utils showAlertView:kAlertTitle message:@"Enter state" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        subView.userInteractionEnabled = YES;

        return;
    }
    
    else if ([txtCity.text length] == 0) {
        
        [Utils showAlertView:kAlertTitle message:@"Enter city" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        subView.userInteractionEnabled = YES;

        return;
    }
    
    else if ([txtLocality.text length] == 0) {
        
        [Utils showAlertView:kAlertTitle message:@"Enter locality" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        subView.userInteractionEnabled = YES;

        return;
    }
    
    else if ([txtPinCode.text length] == 0) {
        
        [Utils showAlertView:kAlertTitle message:@"Enter pincode" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        subView.userInteractionEnabled = YES;

        return;
    }
    
    
    else if (btnOthers.selected) {
        txtTitle.text = [txtTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([txtTitle.text length] == 0) {
            
            [Utils showAlertView:kAlertTitle message:@"Enter title" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            subView.userInteractionEnabled = YES;

            
            return;
        }
        else
        {
            [self createDataForAddressUpdate];
        }
    }
    else
    {
        [self createDataForAddressUpdate];
    }
}
-(void)createDataForAddressUpdate
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:txtAddress.text forKey:kAddress];
    [dict setObject:txtState.text forKey:kState];
    [dict setObject:txtCity.text forKey:kCity];
    [dict setObject:txtLocality.text forKey:kLocality];
    [dict setObject:txtPinCode.text forKey:kPincode];
    
    if (btnHome.selected) {
        [dict setObject:@"Home" forKey:kTitle];
    }
    else if (btnOffice.selected) {
        [dict setObject:@"Office" forKey:kTitle];
    }
    else if (btnOthers.selected) {
        [dict setObject:txtTitle.text forKey:kTitle];
    }

    [dict setObject:[NSString stringWithFormat:@"%f",cordinatesLocation.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",cordinatesLocation.longitude] forKey:kLongitude];
    [self callWebServiceForAddressUpdate:dict];
}
-(void)callWebServiceForAddressUpdate:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        subView.userInteractionEnabled = YES;

        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kUpdateAddressURL withInput:aDict withCurrentTask:TASK_UPDATE_ADDRESS andDelegate:self ];
}

-(void) didFailWithError:(NSError *)error
{
    subView.userInteractionEnabled = YES;

    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_UPDATE_ADDRESS) {
        
        subView.userInteractionEnabled = YES;

        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
			[[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:kUser_address] forKey:kUser_address];
			[[NSUserDefaults standardUserDefaults] synchronize];
            [self saveAddressIntoDataBase];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
}


- (IBAction)btnActionClicked:(UIButton *)sender {
    
    if (sender.tag == 100) {
        if (btnHome.selected) {
            btnHome.selected = YES;
        }
        else
            sender.selected = !sender.selected;
    }
    else if (sender.tag == 101) {
        if (btnOffice.selected) {
            btnOffice.selected = YES;
        }
        else
            sender.selected = !sender.selected;
    }

   else if (sender.tag == 102) {
      
       if (btnOthers.selected) {
           btnOthers.selected = YES;
       }
       else
           sender.selected = !sender.selected;
    }

    switch (sender.tag) {
        case 100:
        {
            btnOffice.selected = NO;
            btnOthers.selected = NO;
            [txtTitle setHidden:YES];
        }
            break;
        case 101:
        {
            btnHome.selected = NO;
            btnOthers.selected = NO;
            [txtTitle setHidden:YES];
        }
            break;

        case 102:
        {
            btnOffice.selected = NO;
            btnHome.selected = NO;
            [txtTitle setHidden:NO];
        }
            break;

        default:
            break;
    }
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == txtAddress) {
        [txtState becomeFirstResponder];
    }
    else if (textField == txtState) {
        [txtCity becomeFirstResponder];
    }
    else if (textField == txtCity) {
        [txtLocality becomeFirstResponder];
    }
    else if (textField == txtLocality) {
        [txtPinCode becomeFirstResponder];
    }
    else if (textField == txtPinCode) {
        if (btnOthers.selected) {
            [txtTitle becomeFirstResponder];
        }
        else
            [txtPinCode resignFirstResponder];
    }
    else
    {
        [txtTitle resignFirstResponder];
    }
    return YES;
}


//#pragma mark OptionPatch
//
//-(void)showOptionPatch:(BOOL)isShow
//{
//    if(isShow)
//    {
//        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
//         {
//             keyBoardToolBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) -(196 + 20) , [[UIScreen mainScreen]bounds].size.width, 40 );
//         }completion:nil];
//
//    }
//    else
//    {
//        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
//         {
//             keyBoardToolBar.frame = CGRectMake(0, [[UIScreen mainScreen]bounds].size.height + 40, [[UIScreen mainScreen]bounds].size.width, 40);
//         }
//                         completion:nil];
//    }
//}
//
//-(void)ToolBarDesignes
//{
//    if (keyBoardToolBar==nil)
//    {
//        keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 610 , [[UIScreen mainScreen]bounds].size.width, 40)];
//        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarBtnClicked:)];
//
//        keyBoardToolBar.backgroundColor=[UIColor blackColor];
//        UIBarButtonItem *tempDistance = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarBtnClicked:)];
//
//        keyBoardToolBar.items = [NSArray arrayWithObjects:btnCancel,tempDistance,btnDone, nil];
//    }
//    else
//    {
//        [keyBoardToolBar removeFromSuperview];
//    }
//
//    [self.view addSubview:keyBoardToolBar];
//    [self.view bringSubviewToFront:keyBoardToolBar];
//}
//-(void)toolBarBtnClicked:(UIBarButtonItem *)sender
//{
//    NSInteger indexValue = [picker selectedRowInComponent:0];
//
//    if ([picker selectedRowInComponent:0] >=0) {
//        [dropDownBtn setTitle:[dataSource objectAtIndex:indexValue] forState:UIControlStateNormal];
//        [self checkForCustomLabelForIndex:indexValue];
//
//    }
//    else
//    {
//        [Utils showAlertView:kAlertTitle message:@"Please Select Address Type" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//
//    }
//    [self showOptionPatch:NO];
//    [self showPickerView:NO];
//}
//-(void)PickerView
//{
//    picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)+100, [[UIScreen mainScreen]bounds].size.width,196)];
//    picker.delegate =self;
//    picker.dataSource =self;
//    picker.backgroundColor=[UIColor whiteColor];
//    picker.showsSelectionIndicator = YES;
//    [self.view addSubview:picker];
//}
//
//#pragma mark Show and Hide Picker View
//
//-(void)showPickerView:(BOOL)isShow
//{
//    if(isShow)
//    {
//        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            picker.frame = CGRectMake(0,CGRectGetHeight(self.view.bounds)-(196-20), [[UIScreen mainScreen]bounds].size.width, 196);
//
//        }
//                         completion:nil];
//
//    }
//    else
//    {
//        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
//                         animations:^{
//                             picker.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)+100, [[UIScreen mainScreen]bounds].size.width,196);
//                         }
//                         completion:nil];
//
//    }
//}
//

//- (IBAction)btnDropDown:(id)sender
//{
//    [picker selectRow:0 inComponent:0 animated:YES];
//    [dropDownBtn setTitle:[dataSource objectAtIndex:0] forState:UIControlStateNormal];
//    [self showPickerView:YES];
//    [self showOptionPatch:YES];
//}
//#pragma mark PickerView Methods & Delegates
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 50;
//}
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
//{
//    return dataSource.count;
//    
//}
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
//{
//    
//    return [dataSource objectAtIndex:row];
//    
//    
//}
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
//{
//    [self checkForCustomLabelForIndex:row];
//}
//-(void)checkForCustomLabelForIndex:(NSInteger)indexValue
//{
//    NSString *strValue = [dataSource objectAtIndex:[picker selectedRowInComponent:0]];
//    if ([strValue isEqualToString:[NSString stringWithFormat:@"%@",@"Custom Address"] ])
//    {
//        [txtTitle setHidden:NO];
//        [dropDownBtn setTitle:[dataSource objectAtIndex:indexValue] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [txtTitle setHidden:YES];
//        [dropDownBtn setTitle:[dataSource objectAtIndex:indexValue] forState:UIControlStateNormal];
//    }
//
//}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
