//
//  GlobalSearchResultViewC.m
//  AaramShop
//
//  Created by Arbab Khan on 04/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "GlobalSearchResultViewC.h"

@interface GlobalSearchResultViewC ()
{
	 AppDelegate *appDeleg;
}
@end

@implementation GlobalSearchResultViewC

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	
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
	titleView.text = @"Global Search";
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
#pragma mark -- CallWebservices Methods
- (void)createDataToGetSearchResult
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:strProductId forKey:kProduct_id];
	[dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
	[self performSelector:@selector(callWebservicesToGetSearchResult:) withObject:dict afterDelay:0.1];
}
- (void)callWebservicesToGetSearchResult:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		//        [Utils stopActivityIndicatorInView:self.view];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kGetStorefromProductId withInput:aDict withCurrentTask:TASK_TO_GET_GLOBAL_SEARCH_RESULT andDelegate:self ];
}

- (void)responseReceived:(id)responseObject
{
	isLoading = NO;
	tblView.userInteractionEnabled = YES;
	[self showFooterLoadMoreActivityIndicator:NO];
	
	[AppManager stopStatusbarActivityIndicator];
	switch (aaramShop_ConnectionManager.currentTask) {
	case TASK_TO_GET_GLOBAL_SEARCH_RESULT:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
//				if(pageno==0)
//				{
////					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:@"store_data"]]];
//				}
//				else
//				{
//					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:@"store_data"]]];
//				}
//				[tblView reloadData];
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
	tblView.userInteractionEnabled = YES;
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}
#pragma mark -- Parsing
- (void)createDataForFirstTimeGet:(NSMutableArray*)array{
	if(!arrGlobalSearchResult)
	{
		arrGlobalSearchResult = [[NSMutableArray alloc] init];
	}
	[arrGlobalSearchResult removeAllObjects];
	for(int i = 0 ; i < [array count];i++)
	{
		CMGlobalSearch *globalSearchModel = [array objectAtIndex:i];
		[arrGlobalSearchResult addObject:globalSearchModel];
	}
}
- (void)appendDataForPullDown:(NSMutableArray*)array{
	BOOL wasArrayEmpty = NO;
	if ([arrGlobalSearchResult count]==0) {
		arrGlobalSearchResult=[[NSMutableArray alloc]init];
		wasArrayEmpty=YES;
	}
	for(int i = 0 ; i < [array count];i++)
	{
		CMGlobalSearch *globalSearchModel = [array objectAtIndex:i];
		if (wasArrayEmpty) {
			[arrGlobalSearchResult addObject:globalSearchModel];
		}else
			[arrGlobalSearchResult insertObject:globalSearchModel atIndex:i];
	}
}
- (void)appendDataForPullUp:(NSMutableArray*)array{
	for(int i = 0 ; i < [array count];i++)
	{
		CMGlobalSearch *globalSearchModel = [array objectAtIndex:i];
		[arrGlobalSearchResult addObject:globalSearchModel];
	}
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
		
//		SubCategoryModel *objSubCategory = [arrOnlySubCategoryPicker objectAtIndex:self.mainCategoryIndexPicker];
//		
//		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@ AND SELF.product_id MATCHES %@",strSelectedCategoryId,objSubCategory.sub_category_id,[dictProducts objectForKey:kProduct_id]];
//		NSArray *arrTemp ;
//		if (isSearching) {
//			arrTemp =[arrSearchGetStoreProducts filteredArrayUsingPredicate:predicate];
//		}
//		else
//		{
//			arrTemp =[arrGetStoreProducts filteredArrayUsingPredicate:predicate];
//		}
//		if (arrTemp.count == 0) {
//			if (isSearching) {
				[arrGlobalSearchResult addObject:[self addProductInArray:dictProducts]];
//			}
//			else
//			{
//				[arrGetStoreProducts addObject:[self addProductInArray:dictProducts]];
//			}
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
	objProductsModel.store_name = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kStore_name]];
	objProductsModel.store_image = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kStore_image]];
	objProductsModel.offer_id=[NSString stringWithFormat:@"%@",[dictProducts objectForKey:kOffer_id]];
	objProductsModel.offer_price = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kOffer_price]];
	objProductsModel.offer_type = [NSString stringWithFormat:@"%d",[[dictProducts objectForKey:@"offer_type"] intValue]];
	objProductsModel.strCount = @"0";
	
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

- (IBAction)btnSearch:(id)sender {
	globalSearchViewController = (GlobalSearchViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GlobalSearchView" ];
	[globalSearchViewController setDelegate:self];
	
	[[UIApplication sharedApplication].keyWindow addSubview:globalSearchViewController.view];
}

-(void)openSearchedUserPrroductFor:(CMGlobalSearch *)globalSearchModel
{
	strProductId= globalSearchModel.product_id;
	[self createDataToGetSearchResult];
}
- (void)pushToAnotherView:(CMGlobalSearch *)globalSearchModel
{
	StoreModel *objStoreModel = [[StoreModel alloc] init];
	objStoreModel.store_id	=	globalSearchModel.store_id;
	objStoreModel.store_name	=	globalSearchModel.store_name;
	objStoreModel.store_image	=	globalSearchModel.store_image;
	appDeleg.objStoreModel = objStoreModel;
	UITabBarController *tabBar = [appDeleg createTabBarRetailer];
	tabBar.hidesBottomBarWhenPushed = YES;
	self.navigationController.navigationBarHidden = YES;
	[self.navigationController pushViewController:tabBar animated:YES];
}
-(void)removeSearchViewFromParentView{
	[globalSearchViewController.view removeFromSuperview];
}

#pragma mark - UITableView Delegates & DataSource Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 68;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return arrGlobalSearchResult.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	ProductsModel *productModel = [arrGlobalSearchResult objectAtIndex:atIndexPath.section];
	UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 40)];
	secView.backgroundColor = [UIColor clearColor];
	UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, [[UIScreen mainScreen] bounds].size.width, 30)];
	thirdView.backgroundColor = [UIColor whiteColor];
	UIImageView *imgStore = [[UIImageView alloc] initWithFrame:CGRectMake(16, (thirdView.frame.size.height - 26)/2, 26, 26)];
	[imgStore sd_setImageWithURL:[NSURL URLWithString:productModel.store_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
	UILabel *lblStoreName = [[UILabel alloc] initWithFrame:CGRectMake(imgStore.frame.size.width + imgStore.frame.origin.x + 4, (thirdView.frame.size.height - 21)/2, [[UIScreen mainScreen] bounds].size.width - imgStore.frame.size.width - 28, 21)];
	lblStoreName.font = [UIFont fontWithName:kRobotoRegular size:15];
	lblStoreName.textColor = [UIColor colorWithRed:44/255.0f green:44/255.0f blue:44/255.0f alpha:1.0f];
	lblStoreName.text = productModel.store_name;
	[thirdView addSubview:lblStoreName];
	[thirdView addSubview:imgStore];
	[secView addSubview:thirdView];
	return secView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *cellIdentifier = @"Cell";
	HomeSecondCustomCell *cell = (HomeSecondCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[HomeSecondCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			cell.delegate=self;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		ProductsModel *objProductsModel = nil;
	
		objProductsModel = [self getObjectOfProductForIndexPath:indexPath];
		atIndexPath = indexPath;
		cell.indexPath=indexPath;
		cell.store_id	=	self.strStore_Id;
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
	cmProductModel = objProductsModel;
	return objProductsModel;
	
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	[tblView deselectRowAtIndexPath:indexPath animated:YES];
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
	int priceValue = [strTotalPrice intValue];
	
	if([objProductsModel.offer_type intValue]>0)
	{
		priceValue+=[objProductsModel.offer_price intValue];
	}
	else
	{
		priceValue+=[objProductsModel.product_price intValue];
	}
	strTotalPrice = [NSString stringWithFormat:@"%d",priceValue];
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:objProductsModel] forStore:[NSDictionary dictionaryWithObjectsAndKeys:appDeleg.objStoreModel.store_id,kStore_id,appDeleg.objStoreModel.store_name,kStore_name,appDeleg.objStoreModel.store_image,kStore_image, nil] add:YES];
	
	NSRange range = NSMakeRange(inIndexPath.section, 1);
	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
	
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	
}
-(void)minusValueByPrice:(NSString *)strPrice atIndexPath:(NSIndexPath *)inIndexPath
{
	ProductsModel *objProductsModel = nil;
	objProductsModel = [self getObjectOfProductForIndexPath:inIndexPath];
	int priceValue = [strTotalPrice intValue];
	
	if([objProductsModel.offer_type intValue]>0)
	{
		priceValue-=[objProductsModel.offer_price intValue];
	}
	else
	{
		priceValue-=[objProductsModel.product_price intValue];
	}
	strTotalPrice = [NSString stringWithFormat:@"%d",priceValue];
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:objProductsModel] forStore:[NSDictionary dictionaryWithObjectsAndKeys:appDeleg.objStoreModel.store_id,kStore_id,appDeleg.objStoreModel.store_name,kStore_name,appDeleg.objStoreModel.store_image,kStore_image, nil] add:NO];
	
	NSRange range = NSMakeRange(inIndexPath.section, 1);
	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
	
	
	//    [tblView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	
	
}

@end
