//
//  BroadcastViewController.m
//  AaramShop
//
//  Created by Neha Saxena on 28/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "BroadcastViewController.h"
#import "CMOffers.h"
@interface BroadcastViewController ()
{
	AppDelegate *appDelegate;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
}
@end

@implementation BroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	broadcastPageNo = 0;
	broadcastTotalNoOfPages = 0;
	isLoading = NO;
	appDelegate = APP_DELEGATE;
	tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
	[self setNavigationBar];
	
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;
	
	arrBroadcast = [[NSMutableArray alloc]init];
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	tblView.showsVerticalScrollIndicator = YES;
	
	tblView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
 

}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self getBroadcastList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
	titleView.text = @"Broadcast Messages";
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
	UIImage *imgBack = [UIImage imageNamed:@"backBtn.png"];
	
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.bounds = CGRectMake( -10, 0, 30, 30);
	
	[backBtn setImage:imgBack forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	
	NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
	self.navigationItem.leftBarButtonItems = arrBtnsLeft;
}
- (void)btnBackClicked
{
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- Table Delegates & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return arrBroadcast.count;
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
	
	CMOffers *offers = [arrBroadcast objectAtIndex:indexPath.row];
	cell.indexPath=indexPath;
	[cell updateCellWithData: offers];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	CMOffers *offers = [arrBroadcast objectAtIndex:indexPath.row];
	if([offers.offerType isEqualToString:@"4"])
	{
		//		ComboDetailViewController *comboDetail = (ComboDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"comboDetailController"];
		//		comboDetail.cmMyOffers = offers;
		//		[self.navigationController pushViewController:comboDetail animated:YES];
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
	
	
	if ([arrBroadcast count]==0) {
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
	
	
	if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrBroadcast.count > 0 && scrollView.contentOffset.y>0){
		if (!isLoading) {
			isLoading=YES;
			[self showFooterLoadMoreActivityIndicator:YES];
			[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
		}
	}
}

-(void)calledPullUp
{
	if(broadcastTotalNoOfPages>broadcastPageNo+1)
	{
		broadcastPageNo++;
		[self getBroadcastList];
	}
	else
	{
		isLoading = NO;
		[self showFooterLoadMoreActivityIndicator:NO];
	}
	
}

- (void)getBroadcastList
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:[NSString stringWithFormat:@"%d",broadcastPageNo] forKey:kPage_no];
	if(appDelegate.objStoreModel == nil)
	{
		[dict setObject:@"0" forKey:kStore_id];
	}
	else
	{
		[dict setObject:appDelegate.objStoreModel.store_id forKey:kStore_id];
	}
	
	[self performSelector:@selector(callWebServiceToGetBroadcast:) withObject:dict afterDelay:0.1];
}
- (void)callWebServiceToGetBroadcast:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetBroadCast withInput:aDict withCurrentTask:TASK_TO_GET_BROADCAST andDelegate:self ];
}

- (void)responseReceived:(id)responseObject
{
	isLoading = NO;
	[AppManager stopStatusbarActivityIndicator];
	switch (aaramShop_ConnectionManager.currentTask) {
		case TASK_TO_GET_BROADCAST:
		{
			if(broadcastPageNo==0)
			{
				[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:@"broadcast_data"]]];
			}
			else
			{
				[self appendDataForPullUp:[self parseData:[responseObject objectForKey:@"broadcast_data"]]];
			}
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

#pragma mark - Parsing Data
-(void)createDataForFirstTimeGet:(NSMutableArray*)array{
		[arrBroadcast removeAllObjects];
		for(int i = 0 ; i < [array count];i++)
		{
			CMOffers *offers = [array objectAtIndex:i];
			[arrBroadcast addObject:offers];
		}
}
-(void)appendDataForPullDown:(NSMutableArray*)array{
	BOOL wasArrayEmpty = NO;
	
	if ([arrBroadcast count]==0) {
		arrBroadcast=[[NSMutableArray alloc]init];
		wasArrayEmpty=YES;
	}
	for(int i = 0 ; i < [array count];i++)
	{
		CMOffers *offers = [array objectAtIndex:i];
		if (wasArrayEmpty) {
			[arrBroadcast addObject:offers];
		}else
			[arrBroadcast insertObject:offers atIndex:i];
	}
}
-(void)appendDataForPullUp:(NSMutableArray*)array{
	for(int i = 0 ; i < [array count];i++)
	{
		CMOffers *offers = [array objectAtIndex:i];
		[arrBroadcast addObject:offers];
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
			
			offers.offerType							= [dict objectForKey:kOfferType];
			offers.product_id						= [dict objectForKey:kProduct_id];
			offers.product_sku_id					= [dict objectForKey:kProduct_sku_id];
			offers.product_image					=	[dict objectForKey:kProduct_image];
			offers.product_actual_price		= [dict objectForKey:kProduct_actual_price];
			offers.offer_price						= [dict objectForKey:kOffer_price];
			offers.isBroadcast						= [NSString stringWithFormat:@"%@",[dict objectForKey:kIsBroadcast]];
			offers.product_name					= [dict objectForKey:kProduct_name];
			offers.offerTitle							= [dict objectForKey:kOfferTitle];
			offers.offer_id								= [dict objectForKey:kOffer_id];
			offers.overall_purchase_value	= [dict objectForKey:kOverall_purchase_value];
			offers.discount_percentage			= [dict objectForKey:kDiscount_percentage];
			offers.free_item							= [dict objectForKey:kFree_item];
			offers.combo_mrp						= [dict objectForKey:kCombo_mrp];
			offers.combo_offer_price			= [dict objectForKey:kCombo_offer_price];
			offers.offerDetail							= [dict objectForKey:kOfferDetail];
			offers.offerDescription				= [dict objectForKey:kOfferDescription];
			offers.offerImage							= [dict objectForKey:kOfferImage];
			offers.start_date							= [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kStart_date] doubleValue]]];
			offers.end_date							= [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kEnd_date] doubleValue]]];
			broadcastPageNo						=	[[dict objectForKey:kTotal_page] intValue];
			[array addObject:offers];
		}
	}
	return array;
	
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
