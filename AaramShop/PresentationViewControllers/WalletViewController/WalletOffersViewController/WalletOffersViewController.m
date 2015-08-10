//
//  WalletOffersViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "WalletOffersViewController.h"

@interface WalletOffersViewController ()<ScanCodeVCDelegate>
{
	ScanCodeViewController *scanCodeVC;
}
@end

@implementation WalletOffersViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	appDel = APP_DELEGATE;
	totalNoOfPages = 0;
	pageno = 0;
	isLoading = NO;
	tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate = self;
	dataSource = [[NSMutableArray alloc] init];
	[self createDataToGetOffers];
	
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (IBAction)btnScan:(id)sender {
	
	
	[self showView];
	
}
- (void)showView
{
	
	scanCodeVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"ScanCodeView"];
	scanCodeVC.delegate = self;
	
	[appDel.window addSubview:scanCodeVC.view];
}
- (void)removeSuperviewWithModel: (CMWalletOffer *)walletOfferModel
{	
	[dataSource insertObject:walletOfferModel atIndex:0];
	[scanCodeVC.view removeFromSuperview];
	scanCodeVC = nil;
	
}
- (void)removeSuperview
{
	[scanCodeVC.view removeFromSuperview];
	scanCodeVC = nil;
	[self createDataToGetOffers];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CMOffers *cmOffers = [dataSource objectAtIndex: indexPath.row];
	if([cmOffers.offerType isEqualToString:@"6"])
	{
		return 110;
	}
	return 90;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CMOffers *offers = [dataSource objectAtIndex: indexPath.row];
	static NSString *cellIdentifier = nil;
	
	if([offers.offerType isEqualToString:@"6"])
	{
		cellIdentifier = @"CustomOffersCell";
		MyCustomOfferTableCell *cell = (MyCustomOfferTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[MyCustomOfferTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		}
		cell.indexPath=indexPath;
		cell.delegate = self;
		cell.offers= offers;
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
		cell.delegate = self;
		cell.offers= offers;
		[cell updateCellWithData: offers];
		return cell;
	}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tblView deselectRowAtIndexPath:indexPath animated:YES];
	CMOffers *offers  = [dataSource objectAtIndex:indexPath.row];
	if([offers.offerType isEqualToString:@"4"])
	{
		ComboDetailViewController *comboDetail = (ComboDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"comboDetailController"];
		comboDetail.offersModel = offers;
		[self.navigationController pushViewController:comboDetail animated:YES];
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
- (void)createDataToGetOffers
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
	[self performSelector:@selector(callWebServiceToGetOffer:) withObject:dict afterDelay:0.1];
}
- (void)callWebServiceToGetOffer:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetUserScans withInput:aDict withCurrentTask:TASK_TO_GET_OFFERS andDelegate:self ];
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
					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:@"result"]]];
				}
				else
				{
					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:@"result"]]];
				}
				[tblView reloadData];
				if (self.delegate && [self.delegate conformsToProtocol:@protocol(OffersVCDelegate)] && [self.delegate respondsToSelector:@selector(callWebService)])
				{
					[self.delegate callWebService];
				}
			}
			else
			{
				[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
			}
		}
			break;
			default:
			break;
	}
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	
	if ([dataSource count]==0) {
		return nil;
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

-(void)calledPullUp
{
	if(totalNoOfPages>pageno+1)
	{
		pageno++;
		[self createDataToGetOffers];
		return;
	}
	isLoading = NO;
	[self showFooterLoadMoreActivityIndicator:NO];
	
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
	offer = [dataSource objectAtIndex:inIndexPath.row];
	
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:offer] forStore:[NSDictionary dictionaryWithObjectsAndKeys:offer.store_id,kStore_id,offer.store_name,kStore_name,offer.store_image,kStore_image, nil] add:YES fromCart:NO];
	gAppManager.intCount++;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
}
-(void)minusValueByPriceAtIndexPath:(NSIndexPath *)inIndexPath
{
	CMOffers *offer = nil;
	offer = [dataSource objectAtIndex:inIndexPath.row];
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:offer] forStore:[NSDictionary dictionaryWithObjectsAndKeys:offer.store_id,kStore_id,offer.store_name,kStore_name,offer.store_image,kStore_image, nil] add:NO fromCart:NO];
	gAppManager.intCount--;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
}
#pragma mark - Parsing Data
-(void)createDataForFirstTimeGet:(NSMutableArray*)array{
	[dataSource removeAllObjects];
	for(int i = 0 ; i < [array count];i++)
	{
		CMOffers *offers = [array objectAtIndex:i];
		[dataSource addObject:offers];
	}
}
-(void)appendDataForPullDown:(NSMutableArray*)array{
	BOOL wasArrayEmpty = NO;
	
	if ([dataSource count]==0) {
		dataSource=[[NSMutableArray alloc]init];
		wasArrayEmpty=YES;
	}
	for(int i = 0 ; i < [array count];i++)
	{
		CMOffers *offers = [array objectAtIndex:i];
		if (wasArrayEmpty) {
			[dataSource addObject:offers];
		}else
			[dataSource insertObject:offers atIndex:i];
	}
}
-(void)appendDataForPullUp:(NSMutableArray*)array{
	for(int i = 0 ; i < [array count];i++)
	{
		CMOffers *offers = [array objectAtIndex:i];
		[dataSource addObject:offers];
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
			[array addObject:offers];
		}
	}
	return array;
}
#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && dataSource.count > 0 && scrollView.contentOffset.y>0){
		if (!isLoading) {
			isLoading=YES;
			[self showFooterLoadMoreActivityIndicator:YES];
			[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
		}
	}
}
@end
