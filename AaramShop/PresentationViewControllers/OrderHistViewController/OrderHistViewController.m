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
	AppDelegate *appDelegate;
	BOOL isLoading;
}
@end

@implementation OrderHistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
	appDelegate = APP_DELEGATE;

	totalNoOfPages = 0;
	pageno = 0;
	isLoading = NO;
	strPacked	= @"";
	strDispached = @"";
	strCompleted = @"";
    self.sideBar = [Utils createLeftBarWithDelegate:self];
	
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
    aaramShop_ConnectionManager.delegate = self;
    
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	UITableViewController *tableViewController = [[UITableViewController alloc] init];
	tableViewController.tableView = tblView;
	refreshOrderList = [[UIRefreshControl alloc] init];
	[refreshOrderList addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
	tableViewController.refreshControl = refreshOrderList;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
    
    lblMessage.hidden = YES;
    [self setNavigationBar];
	[self callWebServiceToGetOrderHistory];
}


- (void)refreshTable
{
	pageno = 0;
	[self performSelector:@selector(callWebServiceToGetOrderHistory) withObject:nil afterDelay:1.0];
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
	if(appDelegate.objStoreModel == nil)
	{
		titleView.text = @"Order History";
	}
	else
	{
		titleView.text = appDelegate.objStoreModel.store_name;
	}

    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
	if(appDelegate.objStoreModel == nil)
	{
		UIButton *sideMenu = [UIButton buttonWithType:UIButtonTypeCustom];
		sideMenu.bounds = CGRectMake( 0, 0, 30, 30 );
		[sideMenu setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
		[sideMenu addTarget:self action:@selector(SideMenuClicked) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *btnHome = [[UIBarButtonItem alloc] initWithCustomView:sideMenu];
		
		
		NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:btnHome, nil];
		self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	}
	else
	{
		UIImage *imgBack = [UIImage imageNamed:@"backBtn.png"];
		
		UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		backBtn.bounds = CGRectMake( -10, 0, 30, 30);
		
		[backBtn setImage:imgBack forState:UIControlStateNormal];
		[backBtn addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
		
		NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
		self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	}

    
	UIView *rightContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 26, 44)];
	[rightContainer setBackgroundColor:[UIColor clearColor]];
	UIImage *imgCart = [UIImage imageNamed:@"addToCartIcon.png"];
	UIButton *btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
	btnCart.frame = CGRectMake((rightContainer.frame.size.width - 26)/2, (rightContainer.frame.size.height - 26)/2, 26, 26);
	
	[btnCart setImage:imgCart forState:UIControlStateNormal];
	[btnCart addTarget:self action:@selector(btnCartClicked) forControlEvents:UIControlEventTouchUpInside];
	
	[rightContainer addSubview:btnCart];
	
	UIButton *badgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	badgeBtn.frame = CGRectMake(16, 5, 23, 23);
	[badgeBtn addTarget:self action:@selector(btnCartClicked) forControlEvents:UIControlEventTouchUpInside];
	[badgeBtn setBackgroundImage:[UIImage imageNamed:@"addToCardNoBox"] forState:UIControlStateNormal];
	
	UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(badgeBtn.frame.origin.x+1	, 13, 20, 8)];
	lab.font = [UIFont fontWithName:kRobotoRegular size:9];
	[lab setTextAlignment:NSTextAlignmentCenter];
	[lab setTextColor:[UIColor whiteColor]];
	[lab setBackgroundColor:[UIColor clearColor]];
	NSInteger count = [AppManager getCountOfProductsInCart];
	if (count > 0) {
		gAppManager.intCount = count;
		if (count>99) {
			lab.text = @"99+";
		}
		else
			lab.text = [NSString stringWithFormat:@"%ld",(long)count];
		[rightContainer addSubview:badgeBtn];
		[rightContainer addSubview:lab];
	}
	
	UIImage *imgSearch = [UIImage imageNamed:@"searchIcon.png"];
	
	
	UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
	btnSearch.bounds = CGRectMake( 0, 0, 24, 24);
	
	[btnSearch setImage:imgSearch forState:UIControlStateNormal];
	[btnSearch addTarget:self action:@selector(btnSearchClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
	UIBarButtonItem* barBtnCart  = [[UIBarButtonItem alloc] initWithCustomView:rightContainer];
	NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnCart,
							 barBtnSearch, nil];
	self.navigationItem.rightBarButtonItems = arrBtnsRight;
	
	
	
}
-(void)btnCartClicked
{
	CartViewController *cartView = (CartViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CartViewScene"];
	[self.navigationController pushViewController:cartView animated:YES];
	
}
-(void)btnSearchClicked
{
	GlobalSearchResultViewC *globalSearchResultViewC = (GlobalSearchResultViewC *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GlobalSearchResultView" ];
	[self.navigationController pushViewController:globalSearchResultViewC animated:YES];
}

- (void)btnBackClicked
{
	[appDelegate removeTabBarRetailer];
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


-(void)doCallToMerchant:(NSIndexPath *)indexPath
{
//    CMOrderHist *cmOrderHist = [arrOrderHist objectAtIndex:indexPath.row];
//    
//    NSString *mobileNo = @"9910104975"; //pendingOrder.mobile_no;
//    
//    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",mobileNo]];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
//        [[UIApplication sharedApplication] openURL:phoneUrl];
//    } else
//    {
//        [Utils showAlertView:kAlertTitle message:kAlertCallFacilityNotAvailable delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//    }
}
-(void)doChatToMerchant:(NSIndexPath *)indexPath
{
    
}
#pragma mark - call Web Service to get initial pending orders list
-(void)callWebServiceToGetOrderHistory
{
    lblMessage.hidden = YES;

	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];

	[dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
	if(appDelegate.objStoreModel == nil)
	{
		[dict setObject:@"0" forKey:kStore_id];
	}
	else
	{
		[dict setObject:appDelegate.objStoreModel.store_id forKey:kStore_id];
	}
	if (![Utils isInternetAvailable])
	{
		[AppManager stopStatusbarActivityIndicator];
		isLoading = NO;
		[refreshOrderList endRefreshing];
		
		[self showFooterLoadMoreActivityIndicator:NO];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	
	[aaramShop_ConnectionManager getDataForFunction:kURLOrderHistory withInput:dict withCurrentTask:TASK_TO_GET_ORDER_HISTORY andDelegate:self];
}
-(void)calledPullUp
{
	if(totalNoOfPages>pageno)
	{
		pageno++;
		[self callWebServiceToGetOrderHistory];
	}
	else
	{
		isLoading = NO;
		[self showFooterLoadMoreActivityIndicator:NO];
	}
}
- (void)responseReceived:(id)responseObject
{
	isLoading = NO;
	[self showFooterLoadMoreActivityIndicator:NO];
	[refreshOrderList endRefreshing];
	[AppManager stopStatusbarActivityIndicator];
	if(aaramShop_ConnectionManager.currentTask == TASK_TO_GET_ORDER_HISTORY)
	{
		if([[responseObject objectForKey:kstatus] intValue] == 1)
		{
			if(pageno==0)
			{
				[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:@"order_history"]]];
			}
			else
			{
				[self appendDataForPullUp:[self parseData:[responseObject objectForKey:@"order_history"]]];
			}
			[tblView reloadData];
		}
        else
        {
            lblMessage.hidden = NO;
        }
	}

	
}


- (void)didFailWithError:(NSError *)error
{
	
	isLoading = NO;
	[self showFooterLoadMoreActivityIndicator:NO];
	[refreshOrderList endRefreshing];
	
	//    [Utils stopActivityIndicatorInView:self.view];
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}

#pragma mark - to refreshing a view

-(void)showFooterLoadMoreActivityIndicator:(BOOL)show{
	UIView *view=[tblView viewWithTag:111112];
	UIActivityIndicatorView *activity=(UIActivityIndicatorView*)[view viewWithTag:111111];
	
	if (show) {
		[activity startAnimating];
	}else
		[activity stopAnimating];
}

#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	//To do Call the parent delegates
	
	if ([_delegate respondsToSelector:@selector(scrollViewDidScroll:onTableView:)]) {
		[_delegate scrollViewDidScroll:scrollView onTableView:tblView];
	}
	
	
	if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrOrderHist.count > 0 && scrollView.contentOffset.y>0){
		if (!isLoading) {
			isLoading=YES;
			[self showFooterLoadMoreActivityIndicator:YES];
			[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
		}
	}
	
}
#pragma mark - Parse Orders List response data

- (void)createDataForFirstTimeGet:(NSMutableArray*)array{
	if(!arrOrderHist)
	{
		arrOrderHist = [[NSMutableArray alloc] init];
	}
	[arrOrderHist removeAllObjects];
	for(int i = 0 ; i < [array count];i++)
	{
		CMOrderHist *cmOrderHist = [array objectAtIndex:i];
		[arrOrderHist addObject:cmOrderHist];
	}
}


-(void)appendDataForPullUp:(NSMutableArray*)array{
	for(int i = 0 ; i < [array count];i++)
	{
		CMOrderHist *cmOrderHist = [array objectAtIndex:i];
		[arrOrderHist addObject:cmOrderHist];
	}
}


-(NSMutableArray *)parseData:(id)data
{
	
	NSMutableArray *array = [[NSMutableArray alloc]init];
	if([data count]>0)
	{
		for(int i =0 ; i < [data count] ; i++)
		{
			NSDictionary *dict = [data objectAtIndex:i];
			CMOrderHist *cmOrderHist				=	[[CMOrderHist alloc] init];
			
			cmOrderHist.store_id						=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_id]];
			cmOrderHist.store_name					=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_name]];
			cmOrderHist.store_mobile				=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_mobile]];
			cmOrderHist.store_city						=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_city]];
			cmOrderHist.store_latitude				=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_latitude]];
			cmOrderHist.store_longitude			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_longitude]];
			cmOrderHist.customer_latitude			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kCustomer_latitude]];
			cmOrderHist.customer_longitude			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kCustomer_longitude]];
			cmOrderHist.store_image					=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_image]];
			cmOrderHist.delivery_time				=	[Utils stringFromDateForExactTime:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kDelivery_time] doubleValue]]];
			cmOrderHist.order_time					=	[Utils stringFromDateForExactTime:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kOrder_time] doubleValue]]];
			cmOrderHist.order_date					=	[Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kOrder_time] doubleValue]]];
			cmOrderHist.quantity						=	[NSString stringWithFormat:@"%@",[dict objectForKey:kQuantity]];
			cmOrderHist.total_cart_value			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kTotal_cart_value]];
			cmOrderHist.order_id						=	[NSString stringWithFormat:@"%@",[dict objectForKey:kOrder_id]];
			cmOrderHist.delivery_slot					=	[NSString stringWithFormat:@"%@",[dict objectForKey:kDelivery_slot]];
			cmOrderHist.deliveryboy_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kDeliveryboy_name]];
			cmOrderHist.payment_mode				=	[NSString stringWithFormat:@"%@",[dict objectForKey:kPayment_mode]];
			cmOrderHist.store_chatUserName		=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_chatUserName]];
			strPacked =[NSString stringWithFormat:@"%d",[[dict objectForKey:kPacked_timing] intValue]];
			if ([strPacked isEqualToString:@"0"]) {
				cmOrderHist.packed_timing = @"";
			}
			else
			{
				cmOrderHist.packed_timing						=		[Utils stringFromDateForExactTime:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kPacked_timing] doubleValue]]];
			}
			strDispached = [NSString stringWithFormat:@"%d",[[dict objectForKey:kDispached_timing] intValue]];
			if ([strDispached isEqualToString:@"0"]) {
				cmOrderHist.dispached_timing = @"";
			}
			else
			{
				cmOrderHist.dispached_timing					=		[Utils stringFromDateForExactTime:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kDispached_timing] doubleValue]]];
			}
			strCompleted = [NSString stringWithFormat:@"%d",[[dict objectForKey:kDelivered_timing] intValue]];
			if ([strCompleted isEqualToString:@"0"]) {
				cmOrderHist.delivered_timing = @"";
			}
			else
			{
				cmOrderHist.delivered_timing					=		[Utils stringFromDateForExactTime:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kDelivered_timing] doubleValue]]];
			}
			totalNoOfPages									=	[[dict objectForKey:kTotal_page] intValue];
			
			[array addObject:cmOrderHist];
		}
	}
    
    if (array.count==0 && pageno==0)
    {
        lblMessage.hidden = NO;
    }
    else
    {
        lblMessage.hidden = YES;
    }

    
    
	return array;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *view;
	if ([arrOrderHist count]==0) {
		return nil;
	}else{
		view=[[UIView alloc]initWithFrame:CGRectMake(0, -10, 320, 44)];
		[view setBackgroundColor:[UIColor clearColor]];
		[view setTag:111112];
		UIActivityIndicatorView *activitIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
		[activitIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		activitIndicator.tag=111111;
		[activitIndicator setCenter:view.center];
		[view addSubview:activitIndicator];
		
		return view;
	}
}



@end
