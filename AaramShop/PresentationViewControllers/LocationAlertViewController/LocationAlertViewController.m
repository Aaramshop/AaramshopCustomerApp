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
}
@end

@implementation LocationAlertViewController
@synthesize strAddress,delegate,scrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.scrollView contentSizeToFit];
    
    // Do any additional setup after loading the view.
    
    
    [picker selectRow:0 inComponent:0 animated:YES];
    viewBackAlert.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    subView.layer.cornerRadius = 5;
    subView.layer.masksToBounds = YES;

    txtVAddress.text = strAddress;
    dataSource=[[NSMutableArray alloc]initWithObjects:@"Home Address",@"Office Address",@"Custom Address", nil];
    [dropDownBtn setTitle:@"Home Address" forState:UIControlStateNormal];
    scrollView=[[AKKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, 0.01f)];
    
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [scrollView setContentSize:CGSizeMake(320, [UIScreen mainScreen].bounds.size.height+100)];
    [txtTitle setHidden:YES];
    [self ToolBarDesignes];
    [self PickerView];
    
}
#pragma mark OptionPatch

-(void)showOptionPatch:(BOOL)isShow
{
    if(isShow)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
         {
             keyBoardToolBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) -(196 + 20) , [[UIScreen mainScreen]bounds].size.width, 40 );
         }completion:nil];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
         {
             keyBoardToolBar.frame = CGRectMake(0, [[UIScreen mainScreen]bounds].size.height + 40, [[UIScreen mainScreen]bounds].size.width, 40);
         }
                         completion:nil];
    }
}

-(void)ToolBarDesignes
{
    if (keyBoardToolBar==nil)
    {
        keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 610 , [[UIScreen mainScreen]bounds].size.width, 40)];
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarBtnClicked:)];
        
        keyBoardToolBar.backgroundColor=[UIColor blackColor];
        UIBarButtonItem *tempDistance = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarBtnClicked:)];
        
        keyBoardToolBar.items = [NSArray arrayWithObjects:btnCancel,tempDistance,btnDone, nil];
    }
    else
    {
        [keyBoardToolBar removeFromSuperview];
    }
    
    [self.view addSubview:keyBoardToolBar];
    [self.view bringSubviewToFront:keyBoardToolBar];
}
-(void)toolBarBtnClicked:(UIBarButtonItem *)sender
{
    NSInteger indexValue = [picker selectedRowInComponent:0];
    
    if ([picker selectedRowInComponent:0] >=0) {
        [dropDownBtn setTitle:[dataSource objectAtIndex:indexValue] forState:UIControlStateNormal];
        [self checkForCustomLabelForIndex:indexValue];

    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Please Select Address Type" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];

    }
    [self showOptionPatch:NO];
    [self showPickerView:NO];
}
-(void)PickerView
{
    picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)+100, [[UIScreen mainScreen]bounds].size.width,196)];
    picker.delegate =self;
    picker.dataSource =self;
    picker.backgroundColor=[UIColor whiteColor];
    picker.showsSelectionIndicator = YES;
    [self.view addSubview:picker];
}

#pragma mark Show and Hide Picker View

-(void)showPickerView:(BOOL)isShow
{
    if(isShow)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            picker.frame = CGRectMake(0,CGRectGetHeight(self.view.bounds)-(196-20), [[UIScreen mainScreen]bounds].size.width, 196);
            
        }
                         completion:nil];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             picker.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)+100, [[UIScreen mainScreen]bounds].size.width,196);
                         }
                         completion:nil];
        
    }
}

-(void)saveIntoDataBase:(NSInteger) Value
{
    NSMutableArray *arrAddress = [[NSUserDefaults standardUserDefaults]valueForKey:kAddressForLocation];
    if (Value == 2) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:txtVAddress.text forKey:kAddressValue];
        [dict setObject:txtTitle.text forKey:kAddressTitle];
        [arrAddress addObject:dict];
    }
    else
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:txtVAddress.text forKey:kAddressValue];
        
        if (Value == 0) {
            [dict setObject:kHomeAddress forKey:kAddressTitle];

        }
        else if (Value == 1)
        {
            [dict setObject:kOfficeAddress forKey:kAddressTitle];
        }
        [arrAddress replaceObjectAtIndex:Value withObject:dict];

    }
    [[NSUserDefaults standardUserDefaults]setObject:arrAddress forKey:kAddressForLocation];
    [[NSUserDefaults standardUserDefaults]synchronize];

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
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(LocationAlertViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(saveAddress)])
    {
        [self.delegate saveAddress];
    }
//    if ([picker selectedRowInComponent:0] >= 0) {
//        if (![[NSUserDefaults standardUserDefaults] objectForKey:kAddressForLocation]) {
//            [[AppManager sharedManager] createDefaultValuesForDictionay];
//        }
//        [self saveIntoDataBase:[picker selectedRowInComponent:0]];
//    }
//    else
//        [Utils showAlertView:kAlertTitle message:@"Please Select Address Type" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
}

- (IBAction)btnDropDown:(id)sender
{
    [picker selectRow:0 inComponent:0 animated:YES];
    [dropDownBtn setTitle:[dataSource objectAtIndex:0] forState:UIControlStateNormal];
    [self showPickerView:YES];
    [self showOptionPatch:YES];
}
#pragma mark PickerView Methods & Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return dataSource.count;
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    
    return [dataSource objectAtIndex:row];
    
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    [self checkForCustomLabelForIndex:row];
}
-(void)checkForCustomLabelForIndex:(NSInteger)indexValue
{
    NSString *strValue = [dataSource objectAtIndex:[picker selectedRowInComponent:0]];
    if ([strValue isEqualToString:[NSString stringWithFormat:@"%@",@"Custom Address"] ])
    {
        [txtTitle setHidden:NO];
        [dropDownBtn setTitle:[dataSource objectAtIndex:indexValue] forState:UIControlStateNormal];
    }
    else
    {
        [txtTitle setHidden:YES];
        [dropDownBtn setTitle:[dataSource objectAtIndex:indexValue] forState:UIControlStateNormal];
    }

}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
