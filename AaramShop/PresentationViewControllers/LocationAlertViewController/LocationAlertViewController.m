//
//  LocationAlertViewController.m
//  AaramShop
//
//  Created by Approutes on 16/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "LocationAlertViewController.h"

@interface LocationAlertViewController ()

@end

@implementation LocationAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewBackAlert.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    subView.layer.cornerRadius = 5;
    subView.layer.masksToBounds = YES;
    dataSource=[[NSMutableArray alloc]init];
    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Home",@"title",
                                                        @"djsjhkdshjksd",@"address",nil]];
    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Office",@"title",
                           @"djsjhkdshjksd",@"address",nil]];
    [dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Custom",@"title",
                           @"djsjhkdshjksd",@"address",nil]];
    
    
    pickerView =[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0,320, 150)];
    
    pickerView.hidden=NO;
//    [pickerView addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
    [subView addSubview:pickerView];
    UIBarButtonItem* rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    pickerView.dataSource = self;
    pickerView.delegate = self;
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

- (IBAction)btnCancel:(id)sender {
}

- (IBAction)btnSave:(id)sender {
}

- (IBAction)btnDropDown:(id)sender
{
    
    
    
    
}
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
    switch(row)
    {
            
        case 0:
            break;
            default:
            break;
    }
}
@end
