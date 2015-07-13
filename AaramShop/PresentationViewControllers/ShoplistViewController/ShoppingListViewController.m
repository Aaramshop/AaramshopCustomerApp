//
//  ShoplistViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListViewController.h"

@interface ShoppingListViewController ()

@end

@implementation ShoppingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    arrShoppingList = [[NSMutableArray alloc]init];
    self.sideBar = [Utils createLeftBarWithDelegate:self];
    [self setNavigationBar];
    
    tblView.backgroundColor = [UIColor whiteColor];
}

#pragma mark Navigation
-(void)setNavigationBar
{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
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
    titleView.text = @"Shopping List";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    
    UIButton *sideMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    sideMenu.bounds = CGRectMake( 0, 0, 30, 30 );
    [sideMenu setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
    [sideMenu addTarget:self action:@selector(SideMenuClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnHome = [[UIBarButtonItem alloc] initWithCustomView:sideMenu];
    
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:btnHome, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
    
}
-(void)SideMenuClicked
{
    [self.sideBar show];
}
- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
    [self.navigationController pushViewController:viewC animated:YES];
}

-(void)btnCreateShoppingListClick
{
    
}

#pragma mark - UITableView Delegates & Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 68;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 68)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *btnCreateShoppingList = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 68)];
    [btnCreateShoppingList setTitle:@"Create New Shopping List" forState:UIControlStateNormal];
    [btnCreateShoppingList setBackgroundImage:[UIImage imageNamed:@"shoppingListCoverImage.png"] forState:UIControlStateNormal];
    [btnCreateShoppingList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCreateShoppingList.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:14.0]];
    [btnCreateShoppingList setImage:[UIImage imageNamed:@"shoppingListAddCircle.png"] forState:UIControlStateNormal];
    [btnCreateShoppingList setTitleEdgeInsets:UIEdgeInsetsMake(44, -30, 0, 0)];
    [btnCreateShoppingList setImageEdgeInsets:UIEdgeInsetsMake(0, 135, 15, 0)];
    [btnCreateShoppingList addTarget:self action:@selector(btnCreateShoppingListClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnCreateShoppingList];
    
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNumber = 0;
    rowNumber = arrShoppingList.count;
    return rowNumber;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    rowHeight = 198;
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"LineJumpsList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=NO;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor =[UIColor clearColor];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
//    PurchaseInfoModal *purchaseInfoObj = [arrLineJumpsList objectAtIndex:indexPath.row];
//    
//    UILabel *lblClubName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 180, 30)];
//    lblClubName.textColor = [UIColor whiteColor];
//    lblClubName.textAlignment = NSTextAlignmentLeft;
//    lblClubName.font = [UIFont fontWithName:kYanoneKaffeesatzRegular size:22.0];
//    lblClubName.text = [NSString stringWithFormat:@"Club : %@",purchaseInfoObj.clubName];
//    [cell.contentView addSubview:lblClubName];
//    
//    UILabel *lblAmount = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 180, 20)];
//    lblAmount.textColor = [UIColor whiteColor];
//    lblAmount.textAlignment = NSTextAlignmentLeft;
//    lblAmount.font = [UIFont fontWithName:kYanoneKaffeesatzRegular size:20.0];
//    lblAmount.text = [NSString stringWithFormat:@"Amount : %@",purchaseInfoObj.amount];
//    [cell.contentView addSubview:lblAmount];
//    
//    
//    UILabel *lblEventDate = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 180, 20)];
//    lblEventDate.textColor = [UIColor whiteColor];
//    lblEventDate.textAlignment = NSTextAlignmentLeft;
//    lblEventDate.font = [UIFont fontWithName:kYanoneKaffeesatzRegular size:20.0];
//    lblEventDate.text = [NSString stringWithFormat:@"Event Date : %@",purchaseInfoObj.eventDate];
//    [cell.contentView addSubview:lblEventDate];
//    
//    UILabel *lblLine =[[ UILabel alloc]initWithFrame:CGRectMake(0, 79, [UIScreen mainScreen].bounds.size.width, 1)];
//    lblLine.backgroundColor = [UIColor colorWithRed:43.0/255.0 green:44.0/255.0 blue:48.0/255.0 alpha:1.0];
//    [cell.contentView addSubview:lblLine];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view;
    if ([arrShoppingList count]==0) {
        return nil;
    }else{
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTag:111112];
        UIActivityIndicatorView *activitIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [activitIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        activitIndicator.tag=111111;
        [activitIndicator setCenter:view.center];
        [view addSubview:activitIndicator];
        
        return view;
    }
    
}



#pragma mark -

 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }

@end
