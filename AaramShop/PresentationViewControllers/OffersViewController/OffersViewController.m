//
//  OffersViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OffersViewController.h"

@interface OffersViewController ()

@end

@implementation OffersViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	totalNoOfPages = 0;
	pageno = 0;
	isLoading = NO;
	tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
	self.sideBar = [Utils createLeftBarWithDelegate:self];
	[self setNavigationBar];
	
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;
	
	arrCoupon = [[NSMutableArray alloc] init];
	arrDiscount = [[NSMutableArray alloc] init];
	
	[arrDiscount addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Hello",@"name",@"599",@"mrp",@"499",@"offer",@"43-43-2345",@"date", nil]];
	[arrDiscount addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Hello",@"name",@"599",@"mrp",@"499",@"offer",@"43-43-2345",@"date", nil]];
	[arrDiscount addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Hello",@"name",@"599",@"mrp",@"499",@"offer",@"43-43-2345",@"date", nil]];
	
	[arrCoupon addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Hello",@"name",@"499",@"offer",@"43-43-2345",@"date", nil]];
	[arrCoupon addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Hello",@"name",@"499",@"offer",@"43-43-2345",@"date", nil]];
	[arrCoupon addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Hello",@"name",@"499",@"offer",@"43-43-2345",@"date", nil]];
	
	[discountBtn setSelected:![discountBtn isSelected]];
	[self setSelectedBtnState: eSelectedDiscount];
	selectedOffer = eSelectedDiscount;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	switch (selectedOffer) {
		case eSelectedDiscount:
//				[self createDateToGetDiscountOffer];
			break;
		case eSelectedCoupon:
//				[self createDateToGetCouponOffer];
			break;
		default:
			break;
	}
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

#pragma mark -- Table Delegates & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (selectedOffer) {
		case eSelectedDiscount:
				return arrDiscount.count;
			break;
		case eSelectedCoupon:
				return arrCoupon.count;
			break;
		default:
				return 0;
			break;
	}
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 82;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *tableCell = nil;
	switch (selectedOffer) {
		case eSelectedDiscount:
		{
			static NSString *cellIdentifier = @"DiscountCell";
			
			DiscountTableCell *cell = (DiscountTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if (cell == nil) {
				cell = [[DiscountTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			}
//			CMDiscountOffer *discountOffer = [arrDiscount objectAtIndex: indexPath.row];
			NSDictionary *aDic = [arrDiscount objectAtIndex:indexPath.row];
			cell.indexPath=indexPath;
			[cell updateCellWithData: aDic];
			
			tableCell = cell;
		}
			break;
		case eSelectedCoupon:
		{
			static NSString *cellIdentifier = @"CouponCell";
			
			CouponTableCell *cell = (CouponTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if (cell == nil) {
				cell = [[CouponTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			}
//			CMCouponOffer *couponOffer = [arrCoupon objectAtIndex: indexPath.row];
			NSDictionary *aDic = [arrCoupon objectAtIndex:indexPath.row];

			cell.indexPath=indexPath;
			[cell updateCellWithData: aDic];
			
			tableCell = cell;
		}
			break;
		default:
			break;
	}
	return tableCell;
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
	UIView *view;
	switch (selectedOffer) {
		case eSelectedDiscount:
		{
			if ([arrDiscount count]==0) {
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
				
				view	=	subView;
			}

		}
			break;
		case eSelectedCoupon:
		{
			if ([arrCoupon count]==0) {
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
				
				view	=	subView;
			}
		}
			break;
		default:
			
			break;
	}
	return view;
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
	
	//To do Call the parent delegates
	
	if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:onTableView:)]) {
		[self.delegate scrollViewDidScroll:scrollView onTableView:tblView];
	}
	
	
	switch (selectedOffer) {
		case eSelectedDiscount:
		{
			if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrDiscount.count > 0 && scrollView.contentOffset.y>0){
				if (!isLoading) {
					isLoading=YES;
					[self showFooterLoadMoreActivityIndicator:YES];
					[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
				}
			}
		}
			break;
		case eSelectedCoupon:
		{
			if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrCoupon.count > 0 && scrollView.contentOffset.y>0){
				if (!isLoading) {
					isLoading=YES;
					[self showFooterLoadMoreActivityIndicator:YES];
					[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
				}
			}
		}
			break;
		default:
			break;
	}
	
}

-(void)calledPullUp
{
	switch (selectedOffer) {
	case eSelectedDiscount:
		{
			if(totalNoOfPages>pageno)
			{
				pageno++;
				[self createDateToGetDiscountOffer];
			}
			else
			{
				isLoading = NO;
				[self showFooterLoadMoreActivityIndicator:NO];
			}
		}
			break;
		case eSelectedCoupon:
		{
			if(totalNoOfPages>pageno)
			{
				pageno++;
				[self createDateToGetCouponOffer];
			}
			else
			{
				isLoading = NO;
				[self showFooterLoadMoreActivityIndicator:NO];
			}
		}
			break;
	default:
			break;
	}
	
}
- (IBAction)btnDiscount:(id)sender {
	[discountBtn setSelected:![discountBtn isSelected]];
	[self setSelectedBtnState: eSelectedDiscount];
	selectedOffer = eSelectedDiscount;
//	[self createDateToGetDiscountOffer];
	[tblView reloadData];
}
- (IBAction)btnCoupon:(id)sender {
	[couponBtn setSelected:![couponBtn isSelected]];
	[self setSelectedBtnState: eSelectedCoupon];
	selectedOffer = eSelectedCoupon;
//	[self createDateToGetCouponOffer];
	[tblView reloadData];
}

-(void)setSelectedBtnState:(enSelectedOfferBtn)inSelectedState
{
	switch (inSelectedState)
	{
		case eSelectedTypeNone:
			//            [btn1 setSelected: YES];
			break;
			
		case eSelectedDiscount:
		{
			[discountBtn setSelected: YES];
			[couponBtn setSelected:NO];
		}
			break;
			
		case eSelectedCoupon:
		{
			[discountBtn setSelected: NO];
			[couponBtn setSelected:YES];
		}
			break;
		default:
			break;
	}
}


- (void)createDateToGetDiscountOffer
{
	
	//    [Utils startActivityIndicatorInView:self.view withMessage:nil];
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	//    [dict setObject:@"6951" forKey:kAaramshopId];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kStore_id] forKey:kStore_id];
	
	[self performSelector:@selector(callWebServiceToDiscountOffer:) withObject:dict afterDelay:0.1];
}

- (void)createDateToGetCouponOffer
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	//    [dict setObject:@"6951" forKey:kAaramshopId];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kStore_id] forKey:kStore_id];
	
	[self performSelector:@selector(callWebServiceToCouponOffer:) withObject:dict afterDelay:0.1];
}

- (void)callWebServiceToDiscountOffer:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		//        [Utils stopActivityIndicatorInView:self.view];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLDiscountOffer withInput:aDict withCurrentTask:TASK_TO_GET_DISCOUNT_OFFERS andDelegate:self ];
}

- (void)callWebServiceToCouponOffer:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		//        [Utils stopActivityIndicatorInView:self.view];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLCouponOffer withInput:aDict withCurrentTask:TASK_TO_GET_COUPON_OFFERS andDelegate:self ];
}

- (void)responseReceived:(id)responseObject
{
	isLoading = NO;
	[AppManager stopStatusbarActivityIndicator];
	switch (aaramShop_ConnectionManager.currentTask) {
		case TASK_TO_GET_DISCOUNT_OFFERS:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				if(pageno==0)
				{
					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:@""]]];
				}
				else
				{
					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:@""]]];
				}

			}
		}
			break;
		case TASK_TO_GET_COUPON_OFFERS:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				if(pageno==0)
				{
					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:@""]]];
				}
				else
				{
					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:@""]]];
				}

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
	for(int i = 0 ; i < [array count];i++)
	{
		switch (selectedOffer) {
			case eSelectedDiscount:
			{
				CMDiscountOffer *discountOffer = [array objectAtIndex:i];
				[arrDiscount addObject:discountOffer];
			}
				break;
			case eSelectedCoupon:
			{
				CMCouponOffer *couponOffer = [array objectAtIndex:i];
				[arrDiscount addObject:couponOffer];
			}
				break;
			default:
				break;
		}
		
	}
}
-(void)appendDataForPullDown:(NSMutableArray*)array{
	BOOL wasArrayEmpty = NO;
	switch (selectedOffer) {
		case eSelectedDiscount:
		{
			if ([arrDiscount count]==0) {
				arrDiscount=[[NSMutableArray alloc]init];
				wasArrayEmpty=YES;
			}
			for(int i = 0 ; i < [array count];i++)
			{
				CMDiscountOffer *discountOffer = [array objectAtIndex:i];
				if (wasArrayEmpty) {
					[arrDiscount addObject:discountOffer];
				}else
					[arrDiscount insertObject:discountOffer atIndex:i];
			}
		}
			break;
		case eSelectedCoupon:
		{
			if ([arrCoupon count]==0) {
				arrCoupon=[[NSMutableArray alloc]init];
				wasArrayEmpty=YES;
			}
			for(int i = 0 ; i < [array count];i++)
			{
				CMCouponOffer *couponOffer = [array objectAtIndex:i];
				if (wasArrayEmpty) {
					[arrCoupon addObject:couponOffer];
				}else
					[arrCoupon insertObject:couponOffer atIndex:i];
			}
		}
			break;
		default:
			break;
	}
	
}
-(void)appendDataForPullUp:(NSMutableArray*)array{
	for(int i = 0 ; i < [array count];i++)
	{
		switch (selectedOffer) {
			case eSelectedDiscount:
			{
				CMDiscountOffer *discountOffer = [array objectAtIndex:i];
				[arrDiscount addObject:discountOffer];
			}
				break;
			case eSelectedCoupon:
			{
				CMCouponOffer *couponOffer = [array objectAtIndex:i];
				[arrCoupon addObject:couponOffer];
			}
				break;
			default:
				break;
		}
		
	}
}
- (NSMutableArray *)parseData:(id)data
{
	switch (selectedOffer) {
		case eSelectedDiscount:
		{
			NSMutableArray *array = [[NSMutableArray alloc]init];

			if([data count]>0)
			{
				for(int i =0 ; i < [data count] ; i++)
				{
					NSDictionary *dict = [data objectAtIndex:i];
					CMDiscountOffer *discountOffer = [[CMDiscountOffer alloc] init];
//					brandR.activity_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kActivity_id]];
//					brandR.activity_name =[NSString stringWithFormat:@"%@", [dict objectForKey:kActivity_name]];
//					brandR.company_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kCompany_name]];
//					brandR.brand_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kBrand_name]];
//					brandR.activity_details = [NSString stringWithFormat:@"%@",[dict objectForKey:kActivity_details]];
//					brandR.image = [NSString stringWithFormat:@"%@",[dict objectForKey:kBrandImage]];
//					brandR.start_date = [NSString stringWithFormat:@"%@",[dict objectForKey:kStart_date]];
//					brandR.end_date= [NSString stringWithFormat:@"Valid till %@",[dict objectForKey:kEnd_date]];
//					brandR.redemption = [NSString stringWithFormat:@"Redemption %@",[dict objectForKey:kRedemption]];
//					totalNoOfPages = [[dict objectForKey:kTotal_page] intValue];

					[array addObject:discountOffer];
				}
				

//				[tblView reloadData];
			}
			return array;
		}
			break;
		case eSelectedCoupon:
		{
			NSMutableArray *array = [[NSMutableArray alloc]init];
			if([data count]>0)
			{
				for(int i =0 ; i < [data count] ; i++)
				{
					NSDictionary *dict = [data objectAtIndex:i];
					CMCouponOffer *couponOffer = [[CMCouponOffer alloc] init];
//					brandR.activity_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kActivity_id]];
//					brandR.activity_name =[NSString stringWithFormat:@"%@", [dict objectForKey:kActivity_name]];
//					brandR.company_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kCompany_name]];
//					brandR.brand_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kBrand_name]];
//					brandR.activity_details = [NSString stringWithFormat:@"%@",[dict objectForKey:kActivity_details]];
//					brandR.image = [NSString stringWithFormat:@"%@",[dict objectForKey:kBrandImage]];
//					brandR.start_date = [NSString stringWithFormat:@"%@",[dict objectForKey:kStart_date]];
//					brandR.end_date= [NSString stringWithFormat:@"Valid till %@",[dict objectForKey:kEnd_date]];
//					brandR.redemption = [NSString stringWithFormat:@"Redemption %@",[dict objectForKey:kRedemption]];
//					totalNoOfPages = [[dict objectForKey:kTotal_page] intValue];

					[array addObject:couponOffer];
				}
				

//				[tblView reloadData];
			}
			return array;
		}
			break;
		default:
			return nil;
			break;
	}
	

}


@end
