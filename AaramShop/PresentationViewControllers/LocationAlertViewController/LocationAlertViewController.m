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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewBackAlert.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    subView.layer.cornerRadius = 5;
    subView.layer.masksToBounds = YES;
    dataSource=[[NSMutableArray alloc]initWithObjects:
                @"Home",
                    @"Office",@"Custom", nil];
//    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Home",@"title",
//                                                        @"djsjhkdshjksd",@"address",nil]];
//    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Office",@"title",
//                           @"djsjhkdshjksd",@"address",nil]];
//    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Custom",@"title",
//                           @"djsjhkdshjksd",@"address",nil]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnCancel:(id)sender
{
        [self.view removeFromSuperview];
}

- (IBAction)btnSave:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnDropDown:(id)sender
{
    [self showPickerView:YES];
    [self showOptionPatch:YES];
//    [self.view endEditing:YES];
    
    
    
}
#pragma mark PickerView Methods & Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// returns the # of rows in each component..
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
    NSString *strValue = [dataSource objectAtIndex:[picker selectedRowInComponent:0]];
    if ([strValue isEqualToString:[NSString stringWithFormat:@"%@",@"Custom"] ])
    {
        [txtTitle setHidden:NO];
        [dropDownBtn setTitle:[dataSource objectAtIndex:row] forState:UIControlStateNormal];
    }
    else
    {
        [txtTitle setHidden:YES];
        [dropDownBtn setTitle:[dataSource objectAtIndex:row] forState:UIControlStateNormal];
    }
//    NSLog(@"%@", strValue);
    
    
}
@end
