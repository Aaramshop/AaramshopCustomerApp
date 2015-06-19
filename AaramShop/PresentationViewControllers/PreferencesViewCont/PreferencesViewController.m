//
//  PreferencesViewController.m
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController ()
{
    NSMutableArray *arrNotification;
    NSMutableArray *arrLocation;
    NSMutableArray *allSections;
    NSMutableDictionary *dataDict;
}
@end

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrNotification = [[NSMutableArray alloc] init];
    arrLocation = [[NSMutableArray alloc] init];
    dataDict=[[NSMutableDictionary alloc]init];
    allSections =[[NSMutableArray alloc]init];
    [arrNotification addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"preferencesOffersIcon",@"images",
                                 @"Offers",@"name",nil]];
    [arrNotification addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"preferencesDeleveryStatusIcon",@"images",
                                 @"Delivery Status",@"name",nil]];
    [arrNotification addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"preferencesChatIcon",@"images",
                                 @"Chat",@"name",nil]];
    
    [arrLocation addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                             @"preferencesLocationIcon",@"images",
                             @"9996866907",@"name",nil]];
    
    [allSections addObject:@"Notification"];
    [allSections addObject:@"Current Location"];
    [dataDict setObject:arrNotification forKey:@"Notification"];
    [dataDict setObject:arrLocation forKey:@"Current Location"];
    [self setUpNavigationView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Navigation

-(void)setUpNavigationView
{
    CustomNavigationView* navView =[[CustomNavigationView alloc]init];
    [navView setCustomNavigationLeftArrowImageWithImageName:@"backBtn"];
    navView.delegate=self;
    [self.view addSubview:navView];
}
-(void)customNavigationLeftButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView Delegates & Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    NSInteger toReturn = 0;
    
    if (allSections && allSections.count > 0)
    {
        toReturn = allSections.count;
    }
    return toReturn;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger toReturn = 0;
    NSArray *sectionArr = [dataDict objectForKey: [allSections  objectAtIndex: section]];
    
    if (sectionArr && sectionArr.count > 0)
    {
        toReturn = sectionArr.count;
    }
    return toReturn;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *tempLabel=[[UILabel alloc]init];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor blackColor];
    [tempLabel setFont:[UIFont systemFontOfSize:15]];
    
    switch (section)
    {
        case 0:
            tempLabel.text =@"     Notification";
            
            break;
        case 1:
            tempLabel.text = @"     Current Location";
            break;
    }
    return tempLabel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellIdentifier = @"Cell";
            
            PreferenceTableCell *cell =[self createCellSwitch:cellIdentifier];
            
            NSDictionary *dataDic = [[dataDict objectForKey: [allSections objectAtIndex: indexPath.section]] objectAtIndex: indexPath.row];
            cell.delegateSwitchValue = self;
            cell.indexPath=indexPath;
            [cell updateCellWithData: dataDic];
            tableCell = cell;
        }
            break;
            case 1:
        {
            static NSString *cellIdentifier = @"Current Cell";
            
            CurLocationTableCell *cell =[self createCell:cellIdentifier];
            
            NSDictionary *dataDic = [[dataDict objectForKey: [allSections objectAtIndex: indexPath.section]] objectAtIndex: indexPath.row];
           
            cell.indexPath=indexPath;
            [cell updateCellWithData: dataDic];
            tableCell = cell;
        }
            break;
        default:
            break;
    }
    
    
    
    return tableCell;
}
#pragma mark - Calling Cell
-(PreferenceTableCell*)createCellSwitch:(NSString*)cellIdentifier{
    PreferenceTableCell *cell = (PreferenceTableCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PreferenceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
-(CurLocationTableCell*)createCell:(NSString*)cellIdentifier{
    CurLocationTableCell *cell = (CurLocationTableCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CurLocationTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Delegate for switch state
-(void)getSwitchValue:(NSString *)switchBtnText indexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row)
            {
                if ([switchBtnText isEqualToString:@"ON"])
                {

                }
                else if ([switchBtnText isEqualToString:@"OFF"])
                {

                }
            }
            else
            {
//                [dicOnBoardingData setObject:switchBtnText forKey:[[dicDataKeys valueForKey:kOnBoardingUserInfo] objectAtIndex:indexPath.row]];
            }
        }
            break;
            
       
            
        default:
            break;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
