//
//  WalletOfferDetailViewController.m
//  AaramShop
//
//  Created by Neha Saxena on 12/08/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "WalletOfferDetailViewController.h"

@interface WalletOfferDetailViewController ()
{
	AppDelegate *appDeleg;
}
@end

@implementation WalletOfferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	totalNoOfPages = 0;
	pageno = 0;
	isLoading = NO;
	appDeleg = APP_DELEGATE;
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;
	arrGlobalSearchResult = [[NSMutableArray alloc] init];
	[self setUpNavigationBar];
	[Utils startActivityIndicatorInView:self.view withMessage:nil];
	[self performSelector:@selector(createDataToGetSearchResult) withObject:nil afterDelay:0.1];
}
#pragma mark Navigation
-(void)setUpNavigationBar
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
	titleView.numberOfLines = 0;
	titleView.text = @"Stores having this product";
	[_headerTitleSubtitleView addSubview:titleView];
	self.navigationItem.titleView = _headerTitleSubtitleView;
	
	
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createDataToGetSearchResult
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:self.strProductId forKey:kProduct_id];
	[dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
	[self performSelector:@selector(callWebservicesToGetSearchResult:) withObject:dict afterDelay:0.1];
}
- (void)callWebservicesToGetSearchResult:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[Utils stopActivityIndicatorInView:self.view];
		//        [Utils stopActivityIndicatorInView:self.view];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kGetStorefromProductId withInput:aDict withCurrentTask:TASK_TO_GET_GLOBAL_SEARCH_RESULT andDelegate:self ];
}

- (void)responseReceived:(id)responseObject
{
	[Utils stopActivityIndicatorInView:self.view];
	isLoading = NO;
	tblView.userInteractionEnabled = YES;
	[self showFooterLoadMoreActivityIndicator:NO];
	
	[AppManager stopStatusbarActivityIndicator];
	switch (aaramShop_ConnectionManager.currentTask) {
		case TASK_TO_GET_GLOBAL_SEARCH_RESULT:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				[self parseStoresProductsData:responseObject];
			}
		}
			break;
			
  default:
			break;
	}
	
}
- (void)didFailWithError:(NSError *)error
{
	[Utils stopActivityIndicatorInView:self.view];
	tblView.userInteractionEnabled = YES;
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void)parseStoresProductsData:(NSDictionary *)responseObject
{
	totalNoOfPages = [[responseObject valueForKey:@"total_page"] intValue];
	
	if (pageno == 0)
	{
		[arrGlobalSearchResult removeAllObjects];
	}
	
	
	NSArray *arrProductsTemp = [responseObject objectForKey:@"store_data"];
	for (NSDictionary *dictProducts in arrProductsTemp) {
		[arrGlobalSearchResult addObject:[self addProductInArray:dictProducts]];
	}
	
	
	[tblView reloadData];
}
- (ProductsModel *)addProductInArray:(NSDictionary *)dictProducts
{
	ProductsModel *objProductsModel = [[ProductsModel alloc]init];
	objProductsModel.category_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kCategory_id]];
	objProductsModel.product_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_id]];
	objProductsModel.product_image = [NSString stringWithFormat:@"%@",[[dictProducts objectForKey:kProduct_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	objProductsModel.product_name = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_name]];
	objProductsModel.product_price = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_actual_price]];
	objProductsModel.product_sku_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_sku_id]];
	objProductsModel.sub_category_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kSub_category_id]];
	objProductsModel.store_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kStore_id]];
	objProductsModel.store_name = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kStore_name]];
	objProductsModel.store_image = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kStore_image]];
	objProductsModel.offer_id=[NSString stringWithFormat:@"%@",[dictProducts objectForKey:kOffer_id]];
	objProductsModel.offer_price = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kOffer_price]];
	objProductsModel.offer_type = [NSString stringWithFormat:@"%d",[[dictProducts objectForKey:@"offer_type"] intValue]];
	if([objProductsModel.offer_type integerValue]>0)
	{
		objProductsModel.strCount = [AppManager getCountOfProduct:objProductsModel.offer_id withOfferType:objProductsModel.offer_type forStore_id:objProductsModel.store_id];
	}
	else
	{
		objProductsModel.strCount = [AppManager getCountOfProduct:objProductsModel.product_id withOfferType:objProductsModel.offer_type forStore_id:objProductsModel.store_id];
	}
	
	return objProductsModel;
}


#pragma mark - UITableView Delegates & DataSource Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 108;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return arrGlobalSearchResult.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *cellIdentifier = @"ResultCell";
	GlobalSearchResultTableCell *cell = (GlobalSearchResultTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[GlobalSearchResultTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	ProductsModel *objProductsModel = nil;
	
	objProductsModel = [self getObjectOfProductForIndexPath:indexPath];
	atIndexPath = indexPath;
	cell.delegate=self;
	cell.indexPath=indexPath;
	cell.objProductsModelMain = objProductsModel;
	[cell updateCellWithSubCategory:objProductsModel];
	return cell;
}
-(ProductsModel *)getObjectOfProductForIndexPath:(NSIndexPath *)IndexPath
{
	ProductsModel *objProductsModel = nil;
	
	//	if (isSearching) {
	//
	//		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
	//		NSArray *arrTemp = [arrGlobalSearchResult filteredArrayUsingPredicate:predicate];
	//		objProductsModel = [arrTemp objectAtIndex: IndexPath.row];
	//
	//	}
	//	else
	//	{
	//		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
	//		NSArray *arrTemp = [arrGlobalSearchResult filteredArrayUsingPredicate:predicate];
	objProductsModel = [arrGlobalSearchResult objectAtIndex: IndexPath.section];
	return objProductsModel;
	
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

-(void)updateTableAtIndexPath:(NSIndexPath *)inIndexPath
{
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (CartProductModel *)getCartProductFromOffer:(ProductsModel *)product
{
	CartProductModel *cart = [[CartProductModel alloc]init];
	cart.strOffer_type			= [NSString stringWithFormat:@"%d",[product.offer_type intValue]];
	cart.offer_price				=	product.offer_price;
	cart.offerTitle					=	product.product_name;
	cart.offer_id					=	product.offer_id;
	if([product.offer_type integerValue] >0)
	{
		cart.cartProductId		=	product.offer_id;
	}
	else
	{
		cart.cartProductId		=	product.product_id;
	}
	cart.strCount					=	product.strCount;
	cart.product_id				=	product.product_id;
	cart.product_sku_id		=	product.product_sku_id;
	cart.cartProductImage	= product.product_image;
	cart.product_name			=	product.product_name;
	cart.product_price			=	product.product_price;
	return cart;
}
-(void)addedValueByPrice:(NSString *)strPrice atIndexPath:(NSIndexPath *)inIndexPath
{
	ProductsModel *objProductsModel = nil;
	objProductsModel = [self getObjectOfProductForIndexPath:inIndexPath];
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:objProductsModel] forStore:[NSDictionary dictionaryWithObjectsAndKeys:objProductsModel.store_id,kStore_id,objProductsModel.store_name,kStore_name,objProductsModel.store_image,kStore_image, nil] add:YES fromCart:NO];
	gAppManager.intCount++;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
	NSRange range = NSMakeRange(inIndexPath.section, 1);
	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
	
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	
}
-(void)minusValueByPrice:(NSString *)strPrice atIndexPath:(NSIndexPath *)inIndexPath
{
	ProductsModel *objProductsModel = nil;
	objProductsModel = [self getObjectOfProductForIndexPath:inIndexPath];
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:objProductsModel] forStore:[NSDictionary dictionaryWithObjectsAndKeys:objProductsModel.store_id,kStore_id,objProductsModel.store_name,kStore_name,objProductsModel.store_image,kStore_image, nil] add:NO fromCart:NO];
	gAppManager.intCount--;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
	NSRange range = NSMakeRange(inIndexPath.section, 1);
	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
	
	
	//    [tblView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	
	
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
