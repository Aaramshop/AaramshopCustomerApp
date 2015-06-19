//
//  AccountSettingsViewC.m
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AccountSettingsViewC.h"

@interface AccountSettingsViewC ()

@end

@implementation AccountSettingsViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
    arrUserContact = [[NSMutableArray alloc] init];
    arrUserInfo = [[NSMutableArray alloc] init];
    dataDict=[[NSMutableDictionary alloc]init];
    allSections =[[NSMutableArray alloc]init];
    [arrUserInfo addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                             @"First Name",@"firstname",
                             @"Jessica",@"lastname",nil]];
    [arrUserInfo addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Last Name",@"firstname",
                             @"Johnson",@"lastname",nil]];
    [arrUserContact addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                                @"jessicajohnson@gmail.com",@"email",nil]];
    
    [arrUserContact addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                                @"********",@"email",nil]];
    
    [allSections addObject:@"UserInfo"];
    [allSections addObject:@"UserContact"];
    [dataDict setObject:arrUserInfo forKey:@"UserInfo"];
    [dataDict setObject:arrUserContact forKey:@"UserContact"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNavigationBar
{
    
    UIImage *imgBack = [UIImage imageNamed:@"backBtn.png"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake( -10, 0, 20, 20);
    
    [backBtn setImage:imgBack forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
}
-(void)backBtn
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    return 175;
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            return 55;
            break;
    }
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    switch (indexPath.section) {
        case eUserInfo:
        {
            switch (indexPath.row) {
                case 0:
                {
                    static NSString *cellIdentifier = @"FirstCell";
                    
                    UserInfoTableCell *cell =[self createCell:cellIdentifier];
                    
                    NSDictionary *dataDic = [[dataDict objectForKey: [allSections objectAtIndex: indexPath.section]] objectAtIndex: indexPath.row];
                    cell.indexPath=indexPath;
                    [cell updateCellWithData: dataDic];
                    tableCell = cell;
                }
                    break;
                    case 1:
                {
                    static NSString *cellIdentifier = @"LastCell";
                    
                    UserInfoTableCell *cell =[self createCell:cellIdentifier];
                    
                    NSDictionary *dataDic = [[dataDict objectForKey: [allSections objectAtIndex: indexPath.section]] objectAtIndex: indexPath.row];
                    cell.indexPath=indexPath;
                    [cell updateCellWithData: dataDic];
                    tableCell = cell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case eUserContact:
        {
            switch (indexPath.row) {
                case 0:
                {
                    static NSString *cellIdentifier = @"EmailCell";
                    
                    UserContactTableCell *cell =[self createCellCreate:cellIdentifier];
                    
                    NSDictionary *dataDic = [[dataDict objectForKey: [allSections objectAtIndex: indexPath.section]] objectAtIndex: indexPath.row];
                    cell.indexPath=indexPath;
                    [cell updateCellWithData: dataDic];
                    tableCell = cell;
                }
                    break;
                case 1:
                {
                    static NSString *cellIdentifier = @"ChangeCell";
                    
                    UserContactTableCell *cell =[self createCellCreate:cellIdentifier];
                    
                    NSDictionary *dataDic = [[dataDict objectForKey: [allSections objectAtIndex: indexPath.section]] objectAtIndex: indexPath.row];
                    cell.indexPath=indexPath;
                    [cell updateCellWithData: dataDic];
                    tableCell = cell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return tableCell;
}
#pragma mark - Calling Cell
-(UserInfoTableCell*)createCell:(NSString*)cellIdentifier{
    UserInfoTableCell *cell = (UserInfoTableCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UserInfoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
-(UserContactTableCell*)createCellCreate:(NSString*)cellIdentifier{
    UserContactTableCell *cell = (UserContactTableCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UserContactTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
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
