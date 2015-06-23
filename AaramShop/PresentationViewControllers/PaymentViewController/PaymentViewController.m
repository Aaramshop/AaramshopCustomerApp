//
//  PaymentViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 22/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    
}
@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self setNavigationBar];
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
    aaramShop_ConnectionManager.delegate = self;
    datasource = [[NSMutableArray alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
-(void)setNavigationBar
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
    titleView.text = @"Payment";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    UIImage *imgBack = [UIImage imageNamed:@"backBtn"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake( -10, 0, 30, 30);
    
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
#pragma mark - TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return 130;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 78;
            break;
        case 3:
            return 87;
            break;
        case 4:
            return 97;
            break;
            
        default:
            return 0;
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 1:
        case 2:
        {
            return CGFLOAT_MIN;
        }
            break;
        case 3:
        case 4:
        {
            return 10;
        }
        default:
            return CGFLOAT_MIN;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellIdentifier = @"TotalPriceCell";
            
            TotalPriceTableCell *cell = [self createCellTotalPrice:cellIdentifier];
            
            cell.indexPath = indexPath;
            //            [cell updateCellWithData:];
            
            tableCell = cell;
        }
            break;
        case 1:
        {
            
            static NSString *cellIdentifier = @"ApplyBtnCell";
            
            tableCell = [self createCell:cellIdentifier];
            
            UIButton *applyCoupon = (UIButton *)[tableCell.contentView viewWithTag:201];
            
            
        }
            break;
        case 2:
        {
            static NSString *cellIdentifier = @"DateTimeSlotCell";
            
            tableCell = [self createCell:cellIdentifier];
            
            UIButton *btnImmdediate = (UIButton *)[tableCell.contentView viewWithTag:301];
            UIButton *btnSlot = (UIButton *)[tableCell.contentView viewWithTag:302];
            
        }
            break;
            
        case 3:
        {
            static NSString *cellIdentifier = @"AddressCell";
            
            tableCell = [self createCell:cellIdentifier];
            
            UILabel *lblTitle = (UILabel *)[tableCell.contentView viewWithTag:401];
            
        }
            break;
        case 4:
        {
            static NSString *cellIdentifier = @"PickCollectionCell";
            
            tableCell = [self createCell:cellIdentifier];
            UILabel *lblTitle = (UILabel *)[tableCell.contentView viewWithTag:501];
            UIView *subView = (UIView *)[tableCell.contentView viewWithTag:502];
            
            pickCollectionViewC =  [self.storyboard instantiateViewControllerWithIdentifier :@"PickCollectionView"];
            CGRect pickCollectionViewRect = self.view.bounds;
            pickCollectionViewC.view.frame = pickCollectionViewRect;
            [subView addSubview:pickCollectionViewC.view];
            
        }
            break;
        default:
            break;
    }
    return tableCell;
}
-(UITableViewCell*)createCell:(NSString*)cellIdentifier{
    UITableViewCell *cell = (UITableViewCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}
-(TotalPriceTableCell*)createCellTotalPrice:(NSString*)cellIdentifier{
    TotalPriceTableCell *cell = (TotalPriceTableCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TotalPriceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
