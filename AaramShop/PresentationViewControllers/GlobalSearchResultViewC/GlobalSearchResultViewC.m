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
				if(pageno==0)
				{
					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:@"store_data"]]];
				}
				else
				{
					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:@"store_data"]]];
				}
				[tblView reloadData];
		}
			break;
			
  default:
			break;
	}
	
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
- (NSMutableArray *)parseData:(id)data{
	
	NSMutableArray *array = [[NSMutableArray alloc]init];
	
	if([data count]>0)
	{
		for(int i =0 ; i < [data count] ; i++)
		{
			NSDictionary *dict = [data objectAtIndex:i];
			CMGlobalSearch *globalSearchModel = [[CMGlobalSearch alloc] init];
			
				globalSearchModel.store_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_id]];
				globalSearchModel.store_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_name]];
				globalSearchModel.store_image = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_image]];
				globalSearchModel.product_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_id]];
				globalSearchModel.product_sku_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_sku_id]];
				globalSearchModel.product_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_name]];
				globalSearchModel.product_image = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_image]];
				globalSearchModel.product_price = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_price]];
				totalNoOfPages = [[dict objectForKey:kTotal_pages] intValue];
				
				[array addObject:globalSearchModel];
			
		}
		
	}
	return array;
	
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

-(void)removeSearchViewFromParentView{
	[globalSearchViewController.view removeFromSuperview];
}

#pragma mark - UITableView Delegates & DataSource Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	return arrGlobalSearchResult.count;
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
	cell.indexPath=indexPath;
	cell.store_id	=	self.strStore_Id;
	cell.objProductsModelMain = objProductsModel;
	[cell updateCellWithSubCategory:objProductsModel];
	return cell;
}
-(ProductsModel *)getObjectOfProductForIndexPath:(NSIndexPath *)IndexPath
{
	ProductsModel *objProductsModel = nil;
	
	if (isSearching) {
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
		NSArray *arrTemp = [arrGlobalSearchResult filteredArrayUsingPredicate:predicate];
		objProductsModel = [arrTemp objectAtIndex: IndexPath.row];
		
	}
	else
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
		NSArray *arrTemp = [arrGlobalSearchResult filteredArrayUsingPredicate:predicate];
		objProductsModel = [arrTemp objectAtIndex: IndexPath.row];
		
	}
	
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
	
	//    [tblView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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
