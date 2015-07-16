//
//  OffersViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OffersViewController.h"

@interface OffersViewController ()
{
	AppDelegate *appDelegate;
}
@end

@implementation OffersViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	totalNoOfPages = 0;
	pageno = 0;
	isLoading = NO;
	appDelegate = APP_DELEGATE;
	tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
	self.sideBar = [Utils createLeftBarWithDelegate:self];
	[self setNavigationBar];
	
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;
	
	arrOffers = [[NSMutableArray alloc] init];
	
//	[arrOffers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Hello",@"name",@"599",@"mrp",@"499",@"offer",@"43-43-2345",@"date", nil]];
//	[arrOffers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Hello",@"name",@"599",@"mrp",@"499",@"offer",@"43-43-2345",@"date", nil]];
//	[arrOffers addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Hello",@"name",@"599",@"mrp",@"499",@"offer",@"43-43-2345",@"date", nil]];
	
	
	
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self createDateToGetOffer];
}
#pragma mark -- Navigation bar Methods
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
	titleView.text = @"Offers";
	titleView.adjustsFontSizeToFitWidth = YES;
	[_headerTitleSubtitleView addSubview:titleView];
	self.navigationItem.titleView = _headerTitleSubtitleView;
	
//	UIButton *sideMenu = [UIButton buttonWithType:UIButtonTypeCustom];
//	sideMenu.bounds = CGRectMake( 0, 0, 30, 30 );
//	[sideMenu setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
//	[sideMenu addTarget:self action:@selector(SideMenuClicked) forControlEvents:UIControlEventTouchUpInside];
//	UIBarButtonItem *btnHome = [[UIBarButtonItem alloc] initWithCustomView:sideMenu];
//	
//	
//	NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:btnHome, nil];
//	self.navigationItem.leftBarButtonItems = arrBtnsLeft;
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

#pragma mark -- Table Delegates & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return arrOffers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"OffersCell";
	
	OffersTableCell *cell = (OffersTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[OffersTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	CMOffers *offers = [arrOffers objectAtIndex:indexPath.row];
	cell.indexPath=indexPath;
	[cell updateCellWithData: offers];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[tableView setLayoutMargins:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	
	
	if ([arrOffers count]==0) {
		return nil;
	}else{
		UIView *subView=[[UIView alloc]initWithFrame:CGRectMake(0, -10, 320, 44)];
		[subView setBackgroundColor:[UIColor clearColor]];
		[subView setTag:111112];
		UIActivityIndicatorView *activitIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
		[activitIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		activitIndicator.tag=111111;
		[activitIndicator setCenter:subView.center];
		[subView addSubview:activitIndicator];
		
		return subView;
	}
	
	
}

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
	
	
	if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrOffers.count > 0 && scrollView.contentOffset.y>0){
		if (!isLoading) {
			isLoading=YES;
			[self showFooterLoadMoreActivityIndicator:YES];
			[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
		}
	}
}

-(void)calledPullUp
{
	
	if(totalNoOfPages>pageno)
	{
		pageno++;
		[self createDateToGetOffer];
	}
	else
	{
		isLoading = NO;
		[self showFooterLoadMoreActivityIndicator:NO];
	}
	
}




- (void)createDateToGetOffer
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
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

	[self performSelector:@selector(callWebServiceToOffer:) withObject:dict afterDelay:0.1];
}


- (void)callWebServiceToOffer:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetOffers withInput:aDict withCurrentTask:TASK_TO_GET_OFFERS andDelegate:self ];
}


- (void)responseReceived:(id)responseObject
{
	isLoading = NO;
	[AppManager stopStatusbarActivityIndicator];
	switch (aaramShop_ConnectionManager.currentTask) {
		case TASK_TO_GET_OFFERS:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				if(pageno==0)
				{
					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:@"offers"]]];
				}
				else
				{
					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:@"offers"]]];
				}
				 [tblView reloadData];
			}
		}
			break;
			
		default:
			break;
	}
	
}
- (void)didFailWithError:(NSError *)error
{
	//    [Utils stopActivityIndicatorInView:self.view];
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}

#pragma mark - Parsing Data

#pragma mark - Parsing Data
-(void)createDataForFirstTimeGet:(NSMutableArray*)array{
	[arrOffers removeAllObjects];
	for(int i = 0 ; i < [array count];i++)
	{
		CMOffers *offers = [array objectAtIndex:i];
		[arrOffers addObject:offers];
	}
}
-(void)appendDataForPullDown:(NSMutableArray*)array{
	BOOL wasArrayEmpty = NO;
	
	if ([arrOffers count]==0) {
		arrOffers=[[NSMutableArray alloc]init];
		wasArrayEmpty=YES;
	}
	for(int i = 0 ; i < [array count];i++)
	{
		CMOffers *offers = [array objectAtIndex:i];
		if (wasArrayEmpty) {
			[arrOffers addObject:offers];
		}else
			[arrOffers insertObject:offers atIndex:i];
	}
}
-(void)appendDataForPullUp:(NSMutableArray*)array{
	for(int i = 0 ; i < [array count];i++)
	{
		CMOffers *offers = [array objectAtIndex:i];
		[arrOffers addObject:offers];
	}
}
- (NSMutableArray *)parseData:(id)data
{
	
	NSMutableArray *array = [[NSMutableArray alloc]init];
	
	if([data count]>0)
	{
		for(int i =0 ; i < [data count] ; i++)
		{
			NSDictionary *dict = [data objectAtIndex:i];
			CMOffers *offers  = [[CMOffers alloc] init];
			
			offers.offerType					= [dict objectForKey:kOfferType];
			offers.product_id					= [dict objectForKey:kProduct_id];
			offers.product_sku_id			= [dict objectForKey:kProduct_sku_id];
			offers.product_image			= [dict objectForKey:kProduct_image];
			offers.product_actual_price	= [dict objectForKey:kProduct_actual_price];
			offers.offer_price					= [dict objectForKey:kOffer_price];
			offers.isBroadcast					= [NSString stringWithFormat:@"%@",[dict objectForKey:kIsBroadcast]];
			offers.product_name				= [dict objectForKey:kProduct_name];
			offers.offerTitle					= [dict objectForKey:kOfferTitle];
			offers.offer_id						= [dict objectForKey:kOffer_id];
			offers.overall_purchase_value= [dict objectForKey:kOverall_purchase_value];
			offers.discount_percentage	= [dict objectForKey:kDiscount_percentage];
			offers.free_item					= [dict objectForKey:kFree_item];
			offers.combo_mrp				= [dict objectForKey:kCombo_mrp];
			offers.combo_offer_price		= [dict objectForKey:kCombo_offer_price];
			offers.offerDetail					= [dict objectForKey:kOfferDetail];
			offers.offerDescription			= [dict objectForKey:kOfferDescription];
			offers.offerImage					= [dict objectForKey:kOfferImage];
			offers.start_date					= [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kStart_date] doubleValue]]];
			offers.end_date						= [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kEnd_date] doubleValue]]];
			totalNoOfPages						=      [[dict objectForKey:kTotal_page] intValue];
			[array addObject:offers];
		}
	}
	return array;

}


@end
