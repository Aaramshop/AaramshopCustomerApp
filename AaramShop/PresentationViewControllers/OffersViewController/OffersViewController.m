
//
//  OffersViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OffersViewController.h"
//#import "ComboDetailViewController.h"
@interface OffersViewController ()
{
	AppDelegate *appDelegate;
	NSInteger segmentIndex;
	NSString *bannerURL;
	NSString *couponBannerURL;
}
@end

@implementation OffersViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	totalNoOfPages = 0;
	pageno = 0;
	couponPageNo = 0;
	couponTotalNoOfPages = 0;
	segmentIndex = 0;
	isLoading = NO;
	appDelegate = APP_DELEGATE;
	tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
	self.sideBar = [Utils createLeftBarWithDelegate:self];
	
	
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;
	
	arrOffers = [[NSMutableArray alloc] init];
	arrCoupon = [[NSMutableArray alloc]init];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self setNavigationBar];
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
	

	UIButton *sideMenu = [UIButton buttonWithType:UIButtonTypeCustom];
	sideMenu.bounds = CGRectMake( 0, 0, 30, 30 );
	[sideMenu setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
	[sideMenu addTarget:self action:@selector(SideMenuClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *btnHome = [[UIBarButtonItem alloc] initWithCustomView:sideMenu];
	
	
	NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:btnHome, nil];
	self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	
	UIView *rightContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 26, 44)];
	[rightContainer setBackgroundColor:[UIColor clearColor]];
	UIImage *imgCart = [UIImage imageNamed:@"addToCartIcon.png"];
	UIButton *btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
	btnCart.frame = CGRectMake((rightContainer.frame.size.width - 20)/2, (rightContainer.frame.size.height - 20)/2, 20, 20);
	
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 122;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *viewSec = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 122)];
	UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 122)];
	UIActivityIndicatorView *activitIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
	[activitIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
	[activitIndicator setCenter:viewSec.center];
	[activitIndicator startAnimating];

	[imgView sd_setImageWithURL:[NSURL URLWithString:bannerURL] placeholderImage:[UIImage imageNamed:@"offersBg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		[activitIndicator stopAnimating];
	}];
	[viewSec addSubview:imgView];
	return viewSec;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(segmentIndex == 0)
	{
		return arrOffers.count;
	}
	else
	{
		return arrCoupon.count;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CMOffers *cmOffers = [arrOffers objectAtIndex: indexPath.row];
	if([cmOffers.offerType isEqualToString:@"6"])
	{
		return 110;
	}
	return 90;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(segmentIndex ==0)
	{
		CMOffers *offers = [arrOffers objectAtIndex: indexPath.row];
		static NSString *cellIdentifier = nil;
		
		if([offers.offerType isEqualToString:@"6"])
		{
			cellIdentifier = @"CustomOffersCell";
			MyCustomOfferTableCell *cell = (MyCustomOfferTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if (cell == nil) {
				cell = [[MyCustomOfferTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			}
			cell.indexPath=indexPath;
			cell.offers	=	offers;
			cell.delegate = self;
			[cell updateCellWithData: offers];
			return cell;
		}
		else
		{
			cellIdentifier = @"OffersCell";
			OffersTableCell *cell = (OffersTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if (cell == nil) {
				cell = [[OffersTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			}
			cell.indexPath=indexPath;
			cell.offers		=offers;
			cell.delegate = self;
			[cell updateCellWithData: offers];
			return cell;
		}

	}
	else
	{
		static NSString *cellIdentifier = @"couponCellView";
		
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		}
		
		CouponModel *coupon = [arrCoupon objectAtIndex:indexPath.row];
		
		UIImageView *imgView		= (UIImageView *)[cell.contentView viewWithTag:100];
		UILabel *lblTitle					= (UILabel *)[cell.contentView viewWithTag:101];
		UILabel *lblCode				= (UILabel *)[cell.contentView viewWithTag:102];
		UILabel *lblDate					= (UILabel *) [cell.contentView viewWithTag:103];
		
		[imgView sd_setImageWithURL:[NSURL URLWithString:coupon.coupon_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			//
		}];
		
		lblTitle.text							=	coupon.coupon_title;
		lblCode.text						=	coupon.coupon_code;
		lblDate.text							=	coupon.coupon_expiry;
		return cell;
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(segmentIndex ==0)
	{
		CMOffers *offers  = [arrOffers objectAtIndex:indexPath.row];
		if([offers.offerType isEqualToString:@"4"])
		{
			ComboDetailViewController *comboDetail = (ComboDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"comboDetailController"];
			comboDetail.offersModel = offers;
			[self.navigationController pushViewController:comboDetail animated:YES];
		}

	}
	else
	{
//		offers = [arrCoupon objectAtIndex:indexPath.row];
	}

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
	
	if(segmentIndex == 0)
	{
		if ([arrOffers count]==0) {
			return nil;
		}
	}
	else
	{
		if ([arrCoupon count]==0) {
			return nil;
		}
	}
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

-(void)showFooterLoadMoreActivityIndicator:(BOOL)show{
	UIView *view=[tblView viewWithTag:111112];
	UIActivityIndicatorView *activity=(UIActivityIndicatorView*)[view viewWithTag:111111];
	
	if (show) {
		[activity startAnimating];
	}else
		[activity stopAnimating];
}
#pragma mark - table cell delegate methods
- (CartProductModel *)getCartProductFromOffer:(CMOffers *)offer
{
	CartProductModel *cart = [[CartProductModel alloc]init];
	
	cart.strOffer_type	= [NSString stringWithFormat:@"%d",[offer.offerType intValue]];
	cart.offer_price		=	offer.offer_price;
	cart.offerTitle			=	offer.offerTitle;
	cart.offer_id			=	offer.offer_id;
	cart.cartProductId	=	offer.offer_id;
	cart.strCount			=	offer.strCount;
	if([offer.offerType intValue]== 1)// discount
	{
		cart.product_id				=	offer.product_id;
		cart.product_sku_id		=	offer.product_sku_id;
		cart.cartProductImage	= offer.product_image;
		cart.product_name			=	offer.product_name;
		cart.product_price			=	offer.product_actual_price;
	}
	else if([offer.offerType intValue] == 4)//combo
	{
		cart.product_id				=	@"0";
		cart.product_sku_id		=	@"0";
		cart.cartProductImage	= offer.offerImage;
		cart.product_price			=	offer.combo_mrp;
		cart.offer_price				=	offer.combo_offer_price;
	}
	else//custom
	{
		cart.product_id				=	offer.product_id;
		cart.product_sku_id		=	offer.product_sku_id;
		cart.cartProductImage	= offer.offerImage;
		cart.product_price			=	@"0";
	}
	return cart;
}
-(void)addedValueByPriceAtIndexPath:(NSIndexPath *)inIndexPath
{
	CMOffers *offer = nil;
	offer = [arrOffers objectAtIndex:inIndexPath.row];
	
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:offer] forStore:[NSDictionary dictionaryWithObjectsAndKeys:offer.store_id,kStore_id,offer.store_name,kStore_name,offer.store_image,kStore_image, nil] add:YES];
	gAppManager.intCount++;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
	[self setNavigationBar];
}
-(void)minusValueByPriceAtIndexPath:(NSIndexPath *)inIndexPath
{
	CMOffers *offer = nil;
	offer = [arrOffers objectAtIndex:inIndexPath.row];
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:offer] forStore:[NSDictionary dictionaryWithObjectsAndKeys:offer.store_id,kStore_id,offer.store_name,kStore_name,offer.store_image,kStore_image, nil] add:YES];
	gAppManager.intCount--;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
	[self setNavigationBar];
}

#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	if(segmentIndex ==0 )
	{
		if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrOffers.count > 0 && scrollView.contentOffset.y>0){
			if (!isLoading) {
				isLoading=YES;
				[self showFooterLoadMoreActivityIndicator:YES];
				[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
			}
		}
	}
	else
	{
		if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrCoupon.count > 0 && scrollView.contentOffset.y>0){
			if (!isLoading) {
				isLoading=YES;
				[self showFooterLoadMoreActivityIndicator:YES];
				[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
			}
		}
	}
}

-(void)calledPullUp
{
	if(segmentIndex == 0)
	{
		if(totalNoOfPages>pageno+1)
		{
			pageno++;
			[self createDateToGetOffer];
			return;
		}
	}
	else
	{
		if(couponTotalNoOfPages>couponPageNo+1)
		{
			pageno++;
			[self getCouponList];
			return;
		}
	}
	isLoading = NO;
	[self showFooterLoadMoreActivityIndicator:NO];
	
}




- (void)createDateToGetOffer
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
	[dict setObject:@"0" forKey:kStore_id];
	[self performSelector:@selector(callWebServiceToOffer:) withObject:dict afterDelay:0.1];
}
- (void)getCouponList
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:[NSString stringWithFormat:@"%d",couponPageNo] forKey:kPage_no];
	[self performSelector:@selector(callWebServiceToGetCoupons:) withObject:dict afterDelay:0.1];
}
- (void)callWebServiceToGetCoupons:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetCoupons withInput:aDict withCurrentTask:TASK_TO_GET_COUPONS andDelegate:self ];
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
				if(IS_IPHONE_5)
				{
					bannerURL		= [responseObject objectForKey:@"banner_2x"];
				}
				else if(IS_IPHONE_6 || IS_IPHONE_6P)
				{
					bannerURL		= [responseObject objectForKey:@"banner_3x"];
				}
				else
				{
					bannerURL		= [responseObject objectForKey:@"banner"];
				}
				totalNoOfPages	=	[[responseObject objectForKey:kTotal_page] intValue];

				tblView.hidden = NO;

				 [tblView reloadData];
			}
		}
			break;
		case TASK_TO_GET_COUPONS:
		{
			if(couponPageNo==0)
			{
				[self createCouponDataForFirstTimeGet:[self parseCouponData:[responseObject objectForKey:kCoupons]]];
			}
			else
			{
				[self appendCouponDataForPullUp:[self parseCouponData:[responseObject objectForKey:kCoupons]]];
			}
			if(IS_IPHONE_5)
			{
				couponBannerURL		= [responseObject objectForKey:@"banner_2x"];
			}
			else if(IS_IPHONE_6 || IS_IPHONE_6P)
			{
				couponBannerURL		= [responseObject objectForKey:@"banner_3x"];
			}
			else
			{
				couponBannerURL		= [responseObject objectForKey:@"banner"];
			}

			couponTotalNoOfPages	=	[[responseObject objectForKey:kTotal_page] intValue];

			tblView.hidden = NO;

			[tblView reloadData];
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
-(void)createCouponDataForFirstTimeGet:(NSMutableArray*)array
{
	[arrCoupon removeAllObjects];
	for(int i = 0 ; i < [array count];i++)
	{
		CouponModel *coupon = [array objectAtIndex:i];
		[arrCoupon addObject:coupon];
	}
}
-(void)createDataForFirstTimeGet:(NSMutableArray*)array{
	[arrOffers removeAllObjects];
	for(int i = 0 ; i < [array count];i++)
	{
		CMOffers *offers = [array objectAtIndex:i];
		[arrOffers addObject:offers];
	}
}
-(void)appendCouponDataForPullDown:(NSMutableArray*)array
{
	BOOL wasArrayEmpty = NO;
	
	if ([arrCoupon count]==0) {
		arrCoupon=[[NSMutableArray alloc]init];
		wasArrayEmpty=YES;
	}
	for(int i = 0 ; i < [array count];i++)
	{
		CouponModel *coupon = [array objectAtIndex:i];
		if (wasArrayEmpty) {
			[arrCoupon addObject:coupon];
		}else
			[arrCoupon insertObject:coupon atIndex:i];
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
-(void)appendCouponDataForPullUp:(NSMutableArray*)array
{
	for(int i = 0 ; i < [array count];i++)
	{
		CouponModel *coupon = [array objectAtIndex:i];
		[arrCoupon addObject:coupon];
	}
}
-(void)appendDataForPullUp:(NSMutableArray*)array{
	for(int i = 0 ; i < [array count];i++)
	{
		CMOffers *offers = [array objectAtIndex:i];
		[arrOffers addObject:offers];
	}
}
- (NSMutableArray *)parseCouponData:(id)data
{
	NSMutableArray *array = [[NSMutableArray alloc]init];
	
	if([data count]>0)
	{
		for(int i =0 ; i < [data count] ; i++)
		{
			NSDictionary *dict = [data objectAtIndex:i];
			CouponModel *coupon  = [[CouponModel alloc] init];
			
			coupon.coupon_id					= [NSString stringWithFormat:@"%@",[dict objectForKey:@"coupon_id"]];
			coupon.coupon_code				= [NSString stringWithFormat:@"%@",[dict objectForKey:@"coupon_code"]];;
			coupon.coupon_image			= [dict objectForKey:@"coupon_image"];
			coupon.coupon_title				=	[dict objectForKey:@"coupon_title"];
			coupon.coupon_expiry			= [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"coupon_expiry"] doubleValue]]];
			[array addObject:coupon];
		}
	}
	return array;
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
			
			offers.offerType							= [NSString stringWithFormat:@"%@",[dict objectForKey:kOfferType]];
			offers.product_id						= [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_id]];
			offers.product_sku_id					= [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_sku_id]];
			offers.product_image					=	[NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_image]];
			offers.product_actual_price		= [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_actual_price]];
			offers.offer_price						= [NSString stringWithFormat:@"%@",[dict objectForKey:kOffer_price]];
			offers.isBroadcast						= [NSString stringWithFormat:@"%@",[dict objectForKey:kIsBroadcast]];
			offers.product_name					= [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_name]];
			offers.offerTitle							= [NSString stringWithFormat:@"%@",[dict objectForKey:kOfferTitle]];
			offers.offer_id								= [NSString stringWithFormat:@"%@",[dict objectForKey:kOffer_id]];
			offers.overall_purchase_value	= [NSString stringWithFormat:@"%@",[dict objectForKey:kOverall_purchase_value]];
			offers.discount_percentage			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kDiscount_percentage]];
			offers.free_item							= [NSString stringWithFormat:@"%@",[dict objectForKey:kFree_item]];
			offers.combo_mrp						= [NSString stringWithFormat:@"%@",[dict objectForKey:kCombo_mrp]];
			offers.combo_offer_price			= [NSString stringWithFormat:@"%@",[dict objectForKey:kCombo_offer_price]];
			offers.offerDetail							= [NSString stringWithFormat:@"%@",[dict objectForKey:kOfferDetail]];
			offers.offerDescription				= [NSString stringWithFormat:@"%@",[dict objectForKey:kOfferDescription]];
			offers.offerImage							= [NSString stringWithFormat:@"%@",[dict objectForKey:kOfferImage]];
			offers.store_id								=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_id]];
			offers.store_name						=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_name]];
			offers.store_image						=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_image]];
			offers.start_date							= [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kStart_date] doubleValue]]];
			offers.end_date							= [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kEnd_date] doubleValue]]];
			offers.strCount							= [AppManager getCountOfProduct:offers.offer_id withOfferType:offers.offerType forStore_id:offers.store_id];
//			[self getCountOfOfferProduct:offers];
			[array addObject:offers];
		}
	}
	return array;

}
//- (NSString *)getCountOfOfferProduct:(CMOffers *)offers
//{
//	NSMutableArray *arrCartProduct	= [NSMutableArray arrayWithArray:[AppManager getCartProductsByStoreId:offers.store_id]];
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF. cartProductId == %@ and SELF.strOffer_type == %@",offers.offer_id,offers.offerType];
//	NSArray *array	=	[arrCartProduct filteredArrayUsingPredicate:predicate];
//	if([array count]>0)
//	{
//		return [[array objectAtIndex:0] strCount];
//	}
//	return @"0";
//}

- (IBAction)selectionChanged:(id)sender {
	UISegmentedControl *segCtrl = (UISegmentedControl *)sender;
	segmentIndex = segCtrl.selectedSegmentIndex;
	if(segmentIndex ==1)
	{
		if([arrCoupon count]==0)
		{
			[tblView setHidden:YES];
			[self getCouponList];
		}
		else
		{
			[tblView setHidden:NO];
			[tblView reloadData];
		}
	}
	else
	{
		if([arrOffers count]==0)
		{
			[tblView setHidden:YES];
			[self createDateToGetOffer];
		}
		else
		{
			[tblView setHidden:NO];
			[tblView reloadData];
		}
	}
}

@end
