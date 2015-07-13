//
//  OrderHistViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OrderHistViewController.h"

@interface OrderHistViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
}
@end

@implementation OrderHistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];

    self.sideBar = [Utils createLeftBarWithDelegate:self];
    [self setNavigationBar];
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
    aaramShop_ConnectionManager.delegate = self;
    
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = tblView;
    refreshCustomerList = [[UIRefreshControl alloc] init];
    [refreshCustomerList addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshCustomerList;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	[self callWebserviceToGetOrderHist];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    titleView.text = @"Order History";
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

#pragma mark - UITableView Delegates & Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrOrderHist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderHistCell";
    OrderHistTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = (OrderHistTableCell *)[[OrderHistTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.indexPath = indexPath;
    [cell updateOrderHistCell:arrOrderHist];
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	OrderHistDetailViewCon *OrderHistDetailVc=[self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistDetailViewScene"];
	OrderHistDetailVc.orderHist = [arrOrderHist objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:OrderHistDetailVc animated:YES];
	
}

#pragma mark - Cell delegate methods
- (void)refreshTable
{
    [self performSelector:@selector(callWebserviceToGetOrderHist) withObject:nil afterDelay:2.0];
}

-(void)doCallToUser:(NSIndexPath *)indexPath
{
    CMOrderHist *cmOrderHist = [arrOrderHist objectAtIndex:indexPath.row];
    
    NSString *mobileNo = @"9910104975"; //pendingOrder.mobile_no;
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",mobileNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        [Utils showAlertView:kAlertTitle message:kAlertCallFacilityNotAvailable delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
}
-(void)doChatToUser:(NSIndexPath *)indexPath
{
    
}
#pragma mark - call Web Service to get initial pending orders list
-(void)callWebserviceToGetOrderHist
{
    NSMutableDictionary *aDict = [Utils setPredefindValueForWebservice];
    
    [aDict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
    
    //    [aDict setObject:@"4" forKey:kStore_id];
    
    
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kURLOrderHist withInput:aDict withCurrentTask:TASK_GET_ORDER_HISTORY andDelegate:self ];
}

- (void)responseReceived:(id)responseObject
{
    [AppManager stopStatusbarActivityIndicator];
    [refreshCustomerList endRefreshing];
    
    if (aaramShop_ConnectionManager.currentTask == TASK_GET_ORDER_HISTORY)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            [self parsePendingOrdersListData:[responseObject valueForKey:@"order_history"]];
        }
    }
    
}


- (void)didFailWithError:(NSError *)error
{
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}


#pragma mark - Parse Pending Orders List response data
-(void)parsePendingOrdersListData:(id)OrderHist
{
    if (![OrderHist isKindOfClass:[NSArray class]])
    {
        return;
    }
    
    if (!arrOrderHist)
    {
        arrOrderHist = [[NSMutableArray alloc]init];
    }
    [arrOrderHist removeAllObjects];
    
    [OrderHist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         CMOrderHist *orderHistModal = [[CMOrderHist alloc]init];
         
         orderHistModal.addresss = [obj valueForKey:@"addresss"];
         orderHistModal.chat_username = [obj valueForKey:@"chat_username"];
         orderHistModal.delivery_time = [obj valueForKey:@"delivery_time"];
         orderHistModal.latitude = [obj valueForKey:@"latitude"];
         orderHistModal.longitude = [obj valueForKey:@"longitude"];
         orderHistModal.mobile_no = [obj valueForKey:@"mobile_no"];
         orderHistModal.name = [obj valueForKey:@"name"];
         orderHistModal.order_amount = [obj valueForKey:@"order_amount"];
         orderHistModal.order_time = [obj valueForKey:@"order_time"];
         orderHistModal.quantity = [obj valueForKey:@"quantity"];
         orderHistModal.user_city = [obj valueForKey:@"user_city"];
         orderHistModal.user_image = [obj valueForKey:@"user_image"];
         orderHistModal.user_locality = [obj valueForKey:@"user_locality"];
         orderHistModal.user_pincode = [obj valueForKey:@"user_pincode"];
         orderHistModal.user_state = [obj valueForKey:@"user_state"];
         orderHistModal.order_id = [obj valueForKey:@"order_id"];
         
         [arrOrderHist addObject:orderHistModal];
         
     }];
    
    [tblView reloadData];
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
