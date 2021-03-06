//
//  HomeSecondViewController.m
//  AaramShop
//
//  Created by Approutes on 08/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeSecondViewController.h"
#import "CategoryModel.h"
#import "ProductsModel.h"
#import "SubCategoryModel.h"
#import "PaymentViewController.h"
#import "CartModel.h"
#import "CartViewController.h"
#import "BroadcastViewController.h"

#import "PrescriptionViewController.h"


@interface HomeSecondViewController ()
{
	AppDelegate *appDeleg;
	BOOL isSelected;
	NSString *strSelectedCategoryName;
	NSString *strSelectedCategoryId;
	NSString *strSelectedSubCategoryId;
	NSString *strTotalPrice;
	NSString *strSearchTxt;
	NSMutableArray *arrOnlySubCategoryPicker;
	BOOL isSearching;
	NSMutableArray *arrCartProductIds;
	NSMutableArray *arrCartProducts;
	NSInteger selectedIndex;
	int pageno;
	int totalNoOfPages;
    //UIButton *btnFav;
	NSUInteger makeFovouriteCount;
	
}
@end

@implementation HomeSecondViewController
@synthesize mainCategoryIndexPicker,strStore_Id,aaramShop_ConnectionManager,strStore_CategoryName,strStoreImage;
- (void)viewDidLoad {
	[super viewDidLoad];
	
	isSelected = YES;
	strSearchTxt = @"";
	strTotalPrice = @"0";
	isSearching=NO;
	strSelectedCategoryId = @"0";
	appDeleg = APP_DELEGATE;
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.navigationItem.hidesBackButton = YES;

	
	
	////
	
	totalNoOfPages = 0;
	pageno = 0;
	isLoading = NO;
	
	tblVwCategory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	

	
	
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate= self;
	self.mainCategoryIndexPicker = 0;
	
	arrGetStoreProductCategories = [[NSMutableArray alloc]init];
	arrGetStoreProducts = [[NSMutableArray alloc]init];
	arrGetStoreProductSubCategory = [[NSMutableArray alloc]init];
	arrSearchGetStoreProducts = [[NSMutableArray alloc]init];
	arrOnlySubCategoryPicker = [[NSMutableArray alloc]init];
	
	
	
	//================ check global cart ===============
	arrCartProducts						= [[NSMutableArray alloc]init];
	arrCartProductIds					= [[NSMutableArray alloc]init];
	arrCartProducts						= [NSMutableArray arrayWithArray:[AppManager getCartProductsByStoreId:self.strStore_Id]];
	arrCartProductIds					=	[arrCartProducts valueForKey:kProduct_id];
	//==============================================
	
	[[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f]];
	searchBarr.placeholder = @"Search";
	searchBarr.text = strSearchTxt;
	
	if (strSearchTxt.length>0) {
		[searchBarr becomeFirstResponder];
	}
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kBroadcastNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBroadCastMessage:) name:kBroadcastNotification object:nil];
	[self callCategoryView];
	[self callRightCollection];
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"ChooseStoreCategory"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
	
	
}
-(void)callRightCollection
{
	if(rightCollectionVwContrllr)
	{
		[rightCollectionVwContrllr.view removeFromSuperview];
		rightCollectionVwContrllr = nil;
	}
	
	rightCollectionVwContrllr = (RightCollectionViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"rightCollectionView"];
	rightCollectionVwContrllr.arrCategories = [[NSMutableArray alloc]init];
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	rightCollectionVwContrllr.view.frame = CGRectMake(0, 93, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-93);
	rightCollectionVwContrllr.delegate=self;
	[self.view addSubview:rightCollectionVwContrllr.view];
	
	if ([arrGetStoreProductCategories count]>0) {
		rightCollectionVwContrllr.strStore_Id= strStore_Id;
		[rightCollectionVwContrllr.arrCategories addObjectsFromArray:arrGetStoreProductCategories];
		rightCollectionVwContrllr.selectedId = strSelectedCategoryId;
		
	}
	
}
- (void)callCategoryView
{
	UIView *tempView = nil;
	
	tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170)];
	
	NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:self options:nil];
	UIView * secView = (UIView *)[objects objectAtIndex:0];
    secView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170);
	UIView *arrowView = (UIView *)[secView viewWithTag:100];
	UIButton *btnCategory = (UIButton *)[arrowView viewWithTag:1000];
	
	[btnCategory addTarget:self action:@selector(btnCategoryClick) forControlEvents:UIControlEventTouchUpInside];
	
	UILabel *lblCategory = (UILabel *)[arrowView viewWithTag:1001];
	
	lblCategory.text = strSelectedCategoryName;
	if (isSelected)
		[btnCategory setImage:[UIImage imageNamed:@"homeDeatilsGreyArrowBack.png"] forState:UIControlStateNormal];
	else
		[btnCategory setImage:[UIImage imageNamed:@"homeDeatilsGreyArrow.png"] forState:UIControlStateNormal];
	
	UIImageView *imgVCategoryBanner = (UIImageView *)[secView viewWithTag:999];
	
	UIImageView *imgVPerson = (UIImageView *)[secView viewWithTag:1002];
	
	imgVPerson.layer.cornerRadius =  imgVPerson.frame.size.width / 2;
	imgVPerson.clipsToBounds = YES;
	
	UIImageView *imgVBg = (UIImageView *)[secView viewWithTag:1110];
	imgVBg.hidden = YES;
	if (arrOnlySubCategoryPicker.count>0) {
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@",strSelectedCategoryId];
		NSArray *arrTemp = [arrGetStoreProductCategories filteredArrayUsingPredicate:predicate];
		
		imgVBg.hidden = NO;
		if (arrTemp.count == 1) {
			CategoryModel *objCategoryModel = [arrTemp objectAtIndex:0];
			//                UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[secView viewWithTag:998];
			//                [activity startAnimating];
			[imgVCategoryBanner sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objCategoryModel.category_banner]] placeholderImage:[UIImage imageNamed:@"homeDetailDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
				if (image) {
					//                        [activity stopAnimating];
				}
			}];
			
			[imgVPerson sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strStoreImage]] placeholderImage:[UIImage imageNamed:@"defaultProfilePic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
				if (image) {
				}
			}];
			
		}
		
	}
	
	if (arrOnlySubCategoryPicker.count>0) {
		
		V8HorizontalPickerView *pickerViewOfCategory = (V8HorizontalPickerView *)[secView viewWithTag:23210];
		pickerViewOfCategory.currentSelectedIndex = self.mainCategoryIndexPicker;
		pickerViewOfCategory.delegate =self;
		pickerViewOfCategory.dataSource = self;
		pickerViewOfCategory.selectedTextColor = [UIColor whiteColor];
		pickerViewOfCategory.textColor   = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] colorWithAlphaComponent:0.75];
		pickerViewOfCategory.elementFont = [UIFont fontWithName:kRobotoMedium size:14.0];
		
		pickerViewOfCategory.selectionPoint = CGPointMake([UIScreen mainScreen].bounds.size.width/3, 0);
		[pickerViewOfCategory scrollToElement:self.mainCategoryIndexPicker animated:YES];
  
	}
	[tempView addSubview:secView];
	[subView addSubview:tempView];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	self.navigationController.navigationBarHidden = NO;
	[self setUpNavigationBar];
	strTotalPrice = [self getTotalPrice];
	[arrGetStoreProducts removeAllObjects];
	if([arrOnlySubCategoryPicker count]>0&&[strSelectedCategoryId integerValue]>0 && self.mainCategoryIndexPicker>=0)
	{
		[self createDataToGetStoreProducts];
	}
	else
	{
		[arrGetStoreProductCategories removeAllObjects];
		[self createDataToGetStoreProductCategories];
	}
	[tblVwCategory reloadData];
	isViewActive = YES;
	
}


-(void)viewWillDisappear:(BOOL)animated
{
	
	isViewActive = NO;
	[super viewWillDisappear:YES];
}



-(void)createDataToGetStoreProductCategories
{
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict removeObjectForKey:kUserId];
	
	[dict setObject:strStore_Id forKey:kStore_id];
	NSLog(@"My store id :%@",[dict objectForKey:kStore_id]);
	[Utils stopActivityIndicatorInView:self.view];
	[Utils startActivityIndicatorInView:self.view withMessage:nil];
	[self performSelector:@selector(callWebserviceTogetStoreProductCategories:) withObject:dict afterDelay:0.1];
}
-(void)callWebserviceTogetStoreProductCategories:(NSMutableDictionary *)aDict
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	if (![Utils isInternetAvailable])
	{
		[Utils stopActivityIndicatorInView:self.view];
		[AppManager stopStatusbarActivityIndicator];
		
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	
	[aaramShop_ConnectionManager getDataForFunction:kGetStoreProductCategoriesURL withInput:aDict withCurrentTask:TASK_GET_STORE_PRODUCT_CATEGORIES andDelegate:self ];
}
-(void)createDataToGetStoreProductSubCategory:(NSString *)strCategoryId
{
	self.mainCategoryIndexPicker = 0;
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict removeObjectForKey:kUserId];
	[dict setObject:strStore_Id forKey:kStore_id];
	[dict setObject:strCategoryId forKey:kCategory_id];
	
	[dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
	[Utils stopActivityIndicatorInView:self.view];
	[Utils startActivityIndicatorInView:self.view withMessage:nil];
	[self performSelector:@selector(callWebserviceTogetStoreProductSubCategories:) withObject:dict afterDelay:0.1];
}
-(void)callWebserviceTogetStoreProductSubCategories:(NSMutableDictionary *)aDict
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	if (![Utils isInternetAvailable])
	{
		[AppManager stopStatusbarActivityIndicator];
		[Utils stopActivityIndicatorInView:self.view];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	
	[aaramShop_ConnectionManager getDataForFunction:kPOSTGetStoreProductSubCategoryURL withInput:aDict withCurrentTask:TASK_GET_STORE_PRODUCT_SUB_CATEGORIES andDelegate:self ];
}

-(void) didFailWithError:(NSError *)error
{
	[AppManager stopStatusbarActivityIndicator];
	[Utils stopActivityIndicatorInView:self.view];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
	[Utils stopActivityIndicatorInView:self.view];
	isLoading = NO;
	[self showFooterLoadMoreActivityIndicator:NO];
	[refreshShoppingList endRefreshing];
	
	[AppManager stopStatusbarActivityIndicator];
	
	
	if (!isViewActive)
	{
		return;
	}
	
	
	if (aaramShop_ConnectionManager.currentTask == TASK_GET_STORE_PRODUCT_CATEGORIES) {
		
		if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
			
			[self parseStoresCategoryData:responseObject];
		}
		else
		{
			//   [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}
	}
	else if (aaramShop_ConnectionManager.currentTask == TASK_GET_STORE_PRODUCT_SUB_CATEGORIES) {
		
		if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
			
			[self parseStoresSubCategoryCategoryData:responseObject];
		}
		else
		{
			// [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}
	}
	else if (aaramShop_ConnectionManager.currentTask == TASK_GET_STORE_PRODUCTS) {
		
		if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
			
			strSearchTxt = @"";
			[self parseStoresProductsData:responseObject];
		}
		else
		{
			//  [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}
	}
	else if (aaramShop_ConnectionManager.currentTask == TASK_TO_MAK_FAVORITE)
	{
		[Utils stopActivityIndicatorInView:self.view];
		if([[responseObject objectForKey:kstatus]intValue]==1)
		{
			appDeleg.objStoreModel.is_favorite = [NSString stringWithFormat:@"%d",[[responseObject objectForKey:@"isFavorite"] intValue]];
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
			[self setUpNavigationBar];
		}
		else
		{
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}
	}
	else if (aaramShop_ConnectionManager.currentTask == TASK_TO_SEARCH_HOME_STORE_PRODUCTS) {
		
		if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
			
			[self parseStoresProductsDataSearch:responseObject];
		}
		else
		{
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
			
		}
		[tblVwCategory reloadData];
	}
	
	
}
-(void)parseStoresCategoryData:(id)responseObject
{
	NSArray *categories = [responseObject objectForKey:@"categories"];
	
	for (NSDictionary *dict in categories) {
		
		CategoryModel *objCategoryModel = [[CategoryModel alloc]init];
		objCategoryModel.category_banner = [NSString stringWithFormat:@"%@",[[dict objectForKey:kCategory_banner]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		objCategoryModel.category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_id]];
		objCategoryModel.category_image = [NSString stringWithFormat:@"%@",[[dict objectForKey:kCategory_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		objCategoryModel.category_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_name]];
		objCategoryModel.categroy_image_active = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategroy_image_active]];
		objCategoryModel.categroy_image_inactive = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategroy_image_inactive]];
		
		[arrGetStoreProductCategories addObject:objCategoryModel];
	}
	if (arrGetStoreProductCategories.count>0) {
		CategoryModel *objCategoryModel = [arrGetStoreProductCategories objectAtIndex:0];
		strSelectedCategoryId = objCategoryModel.category_id;
	}
	[self callRightCollection];
}
- (ProductsModel *)addProductInArray:(NSDictionary *)dictProducts
{
	ProductsModel *objProductsModel = [[ProductsModel alloc]init];
	objProductsModel.category_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kCategory_id]];
	objProductsModel.product_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_id]];
	objProductsModel.product_image = [NSString stringWithFormat:@"%@",[[dictProducts objectForKey:kProduct_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	objProductsModel.product_name = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_name]];
	objProductsModel.product_price = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_price]];
	objProductsModel.product_sku_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_sku_id]];
	objProductsModel.sub_category_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kSub_category_id]];
	
	objProductsModel.offer_id=[NSString stringWithFormat:@"%@",[dictProducts objectForKey:kOffer_id]];
	objProductsModel.offer_price = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kOffer_price]];
	objProductsModel.offer_type = [NSString stringWithFormat:@"%d",[[dictProducts objectForKey:@"offer_type"] intValue]];
	if ([[dictProducts objectForKey:kEnd_date] intValue]!=0) {
		objProductsModel.end_date = [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dictProducts objectForKey:kEnd_date] doubleValue]]];
	}
	else
	{
		objProductsModel.end_date = @"";
	}
	
	
	objProductsModel.isStoreProduct = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:@"isStoreProduct"]];
	
	
	if([objProductsModel.offer_type  integerValue]>0)
	{
		objProductsModel.strCount = [AppManager getCountOfProduct:objProductsModel.offer_id withOfferType:objProductsModel.offer_type forStore_id:appDeleg.objStoreModel.store_id];
	}
	else
	{
		objProductsModel.strCount = [AppManager getCountOfProduct:objProductsModel.product_id withOfferType:objProductsModel.offer_type forStore_id:appDeleg.objStoreModel.store_id];
	}
	
	return objProductsModel;
}
#pragma mark - Get Total Price
- (NSString *)getTotalPrice
{
	NSInteger strAmount = 0;
	NSMutableArray *arrProductList = [NSMutableArray arrayWithArray:[AppManager getCartProductsByStoreId:self.strStore_Id]];
	
	for(CartProductModel *product in arrProductList)
	{
		if([product.strOffer_type integerValue]>0)
		{
			strAmount = strAmount + ([product.strCount integerValue] * [product.offer_price integerValue]);
		}
		else
		{
			strAmount = strAmount + ([product.strCount integerValue] * [product.product_price integerValue]);
		}
	}
	
	return [NSString stringWithFormat:@"%ld",(long)strAmount];
}


-(void)parseStoresSubCategoryCategoryData:(id)responseObject
{
//	[arrSearchGetStoreProducts removeAllObjects];

	[arrOnlySubCategoryPicker removeAllObjects];
	
	NSArray *subCategories = [responseObject objectForKey:@"sub_categories"];
	
	if (subCategories.count>0) {
		
		NSDictionary *dict = [subCategories objectAtIndex:0];
		strSelectedSubCategoryId = [dict objectForKey:kSub_category_id];
	}
	for (NSDictionary *dict in subCategories) {
		if (arrGetStoreProductSubCategory.count>0) {
			
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@ ",strSelectedCategoryId,[dict objectForKey:kSub_category_id]];
			NSArray *arrTemp ;
			
			arrTemp =[arrGetStoreProductSubCategory filteredArrayUsingPredicate:predicate];
			
			if (arrTemp.count == 0) {
				SubCategoryModel *objSubCategoryModel = [[SubCategoryModel alloc]init];
				objSubCategoryModel.sub_category_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_name]];
				objSubCategoryModel.sub_category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_id]];
				objSubCategoryModel.category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_id]];
				[arrGetStoreProductSubCategory addObject:objSubCategoryModel];
				
			}
		}
		
		else
		{
			for (NSDictionary *dict in subCategories) {
				
				SubCategoryModel *objSubCategoryModel = [[SubCategoryModel alloc]init];
				objSubCategoryModel.sub_category_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_name]];
				objSubCategoryModel.sub_category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kSub_category_id]];
				objSubCategoryModel.category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kCategory_id]];
				
				[arrGetStoreProductSubCategory addObject:objSubCategoryModel];
				
			}
		}
	}
	for (NSDictionary *dict in subCategories) {
		
		if (arrGetStoreProductSubCategory.count>0 && arrGetStoreProducts.count>0) {
			NSArray *arrProductsTemp = [dict objectForKey:@"products"];
			
			for (NSDictionary *dictProducts in arrProductsTemp) {
				
				NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@ AND SELF.product_id MATCHES %@",strSelectedCategoryId, strSelectedSubCategoryId,[dictProducts objectForKey:kProduct_id]];
				NSArray *arrTemp = [arrGetStoreProducts filteredArrayUsingPredicate:predicate1];
				
				if (arrTemp.count == 0) {
					
					[arrGetStoreProducts addObject:[self addProductInArray:dictProducts]];
					
				}
				
			}
		}
		else
		{
			NSArray *arrProductsTemp = [dict objectForKey:@"products"];
			
			for (NSDictionary *dictProducts in arrProductsTemp) {
				
				[arrGetStoreProducts addObject:[self addProductInArray:dictProducts]];
			}
		}
	}
	NSPredicate *predicateCategory = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ ",strSelectedCategoryId];
	
	[arrOnlySubCategoryPicker addObjectsFromArray:[arrGetStoreProductSubCategory filteredArrayUsingPredicate:predicateCategory]];
	tblVwCategory.hidden = NO;
	[self callCategoryView];
	[tblVwCategory reloadData];
}
-(void)parseStoresProductsDataSearch:(NSDictionary *)responseObject
{
	totalNoOfPages = [[responseObject valueForKey:@"total_page"] intValue];
	
	if (pageno == 0)
	{
		[arrSearchGetStoreProducts removeAllObjects];
		[arrGetStoreProducts removeAllObjects];
	}
	
	
	NSArray *arrProductsTemp = [responseObject objectForKey:@"products"];
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
		
			if (isSearching) {
				[arrSearchGetStoreProducts addObject:[self addProductInArray:dictProducts]];
			}
			else
			{
				[arrGetStoreProducts addObject:[self addProductInArray:dictProducts]];
			}
//		}
	}
	[tblVwCategory reloadData];
	
}
-(void)parseStoresProductsData:(NSDictionary *)responseObject
{
	totalNoOfPages = [[responseObject valueForKey:@"total_page"] intValue];
	
	if (pageno == 0)
	{
		[arrSearchGetStoreProducts removeAllObjects];
		[arrGetStoreProducts removeAllObjects];
	}
	
	
	NSArray *arrProductsTemp = [responseObject objectForKey:@"products"];
	for (NSDictionary *dictProducts in arrProductsTemp) {
		
		SubCategoryModel *objSubCategory = [arrOnlySubCategoryPicker objectAtIndex:self.mainCategoryIndexPicker];
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@ AND SELF.product_id MATCHES %@",strSelectedCategoryId,objSubCategory.sub_category_id,[dictProducts objectForKey:kProduct_id]];
		NSArray *arrTemp ;
		if (isSearching) {
			arrTemp =[arrSearchGetStoreProducts filteredArrayUsingPredicate:predicate];
		}
		else
		{
			arrTemp =[arrGetStoreProducts filteredArrayUsingPredicate:predicate];
		}
		if (arrTemp.count == 0) {
			if (isSearching) {
				[arrSearchGetStoreProducts addObject:[self addProductInArray:dictProducts]];
			}
			else
			{
				[arrGetStoreProducts addObject:[self addProductInArray:dictProducts]];
			}
		}
	}
	[tblVwCategory reloadData];
	
}
#pragma mark Navigation

-(void)setUpNavigationBar
{
	CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 150, 44);
	UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
	_headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
	_headerTitleSubtitleView.autoresizesSubviews = NO;
	
	CGRect titleFrame = CGRectMake(0,0, 120, 44);
	UILabel* titleView = [[UILabel alloc] initWithFrame:titleFrame];
	titleView.backgroundColor = [UIColor clearColor];
	titleView.font = [UIFont fontWithName:kRobotoRegular size:15];
	titleView.textAlignment = NSTextAlignmentCenter;
	titleView.textColor = [UIColor whiteColor];
	titleView.numberOfLines = 0;
	titleView.text = strStore_CategoryName;
	[_headerTitleSubtitleView addSubview:titleView];
	self.navigationItem.titleView = _headerTitleSubtitleView;
	
	
	UIImage *imgBack = [UIImage imageNamed:@"backBtn.png"];
	
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.bounds = CGRectMake( -10, 0, 30, 30);
	
	[backBtn setImage:imgBack forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	
	UIImage *imgFav = nil;
	if([appDeleg.objStoreModel.is_favorite intValue]==0)
	{
		imgFav = [UIImage imageNamed:@"homeDetailTabStarIcon"];
	}
	else
	{
		imgFav = [UIImage imageNamed:@"favorateIconActive"];
	}
	UIButton *btnFav = [UIButton buttonWithType:UIButtonTypeCustom];
	btnFav.bounds = CGRectMake( -10, 0, 20, 20);
	
	[btnFav setImage:imgFav forState:UIControlStateNormal];
	[btnFav addTarget:self action:@selector(btnFavClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnFav = [[UIBarButtonItem alloc] initWithCustomView:btnFav];
	
	
	
	
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
	
	
	UIImage *imgBroadcast = nil;
	if([[NSUserDefaults standardUserDefaults] boolForKey:kBroadcastNotificationAvailable])
	{
		imgBroadcast = [UIImage imageNamed:@"bellIconRed"];
	}
	else
	{
		imgBroadcast = [UIImage imageNamed:@"bellIcon"];
	}
	
	UIButton *btnBroadcast = [UIButton buttonWithType:UIButtonTypeCustom];
	btnBroadcast.bounds = CGRectMake( 0, 0, 24, 24);
	
	[btnBroadcast setImage:imgBroadcast forState:UIControlStateNormal];
	[btnBroadcast addTarget:self action:@selector(btnBroadcastClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnBroadcast = [[UIBarButtonItem alloc] initWithCustomView:btnBroadcast];
	
	
	NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnCart,barBtnSearch,barBtnBroadcast, nil];
	self.navigationItem.rightBarButtonItems = arrBtnsRight;
	//comment by ashish
	NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack,barBtnFav, nil];
	self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	self.navigationItem.rightBarButtonItems = arrBtnsRight;
	
}
-(void)btnBackClicked
{
	isViewActive = NO;
	[arrGetStoreProducts removeAllObjects];
	[arrSearchGetStoreProducts removeAllObjects];
	
	[rightCollectionVwContrllr.view removeFromSuperview];
	//    [self.navigationController popViewControllerAnimated:YES];
	
	[appDeleg removeTabBarRetailer];
}
- (void)btnCartClicked{
	CartViewController *cartView = (CartViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CartViewScene"];
	[self.navigationController pushViewController:cartView animated:YES];
}
-(void)btnFavClicked{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	[Utils stopActivityIndicatorInView:self.view];
	[Utils startActivityIndicatorInView:self.view withMessage:nil];
	if([Utils isInternetAvailable])
	{
		NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
		[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
		[dict setObject:appDeleg.objStoreModel.store_id forKey:kStore_id];
		[aaramShop_ConnectionManager getDataForFunction:kURLMakeFavorite withInput:dict withCurrentTask:TASK_TO_MAK_FAVORITE andDelegate:self];
	}
	else
	{
		[AppManager stopStatusbarActivityIndicator];
		
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
		
	}
//    if ([btnFav isSelected] ) {
//        NSLog(@"selected");
//    }
//         else{
//              NSLog(@"nnnoselected");
//             
//         }
}
-(void)btnSearchClicked{
	GlobalSearchResultViewC *globalSearchResultViewC = (GlobalSearchResultViewC *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GlobalSearchResultView" ];
	[self.navigationController pushViewController:globalSearchResultViewC animated:YES];
}

- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
	[self.navigationController pushViewController:viewC animated:YES];
}

- (void)btnBroadcastClicked
{
	BroadcastViewController *broadcastView = (BroadcastViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"broadcastView"];
	[self.navigationController pushViewController:broadcastView animated:YES];
}
#pragma mark - TableView Datasource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger secNum = 0;
	if (arrGetStoreProducts.count >0 || arrSearchGetStoreProducts.count>0) {
		secNum = 2;
	}
	else
		secNum = 1;
	return secNum;
}
-(ProductsModel *)getObjectOfProductForIndexPath:(NSIndexPath *)IndexPath
{
	ProductsModel *objProductsModel = nil;
	
	if (isSearching) {
		
//		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
//		NSArray *arrTemp = [arrSearchGetStoreProducts filteredArrayUsingPredicate:predicate];
//		objProductsModel = [arrTemp objectAtIndex: IndexPath.row];
		
				objProductsModel = [arrSearchGetStoreProducts objectAtIndex:IndexPath.row];
		
	}
	else
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
		NSArray *arrTemp = [arrGetStoreProducts filteredArrayUsingPredicate:predicate];
		objProductsModel = [arrTemp objectAtIndex: IndexPath.row];
		
		//		objProductsModel = [arrGetStoreProducts objectAtIndex:IndexPath.row];
		
	}
	
	return objProductsModel;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rowsNum = 0;
	if (section == 0)
		rowsNum = 0;
	else if (section == 1)
	{
		rowsNum = [self getArrayCountForProducts];
	}
	
	return rowsNum;
}
- (NSInteger )getArrayCountForProducts
{
	NSInteger rowsNum = 0;
	if (isSearching)
	{
		if (arrGetStoreProductSubCategory.count>0 && arrSearchGetStoreProducts.count>0 && arrGetStoreProductCategories.count>0) {
			
//			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
//			NSArray *arrTemp = [arrSearchGetStoreProducts filteredArrayUsingPredicate:predicate];
//			rowsNum = arrTemp.count;
						rowsNum = [arrSearchGetStoreProducts count];
		}
		else
			rowsNum = 0;
  
	}
	else
	{
		if (arrGetStoreProductSubCategory.count>0 && arrGetStoreProducts.count>0 && arrGetStoreProductCategories.count>0) {
			
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
			NSArray *arrTemp = [arrGetStoreProducts filteredArrayUsingPredicate:predicate];
			rowsNum = arrTemp.count;
			//			rowsNum = [arrGetStoreProducts count];
		}
		else
			rowsNum = 0;
		
	}
	return  rowsNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	CGFloat headerHeight = 0.0;
	if (section == 1)
	{
		headerHeight = 41;
	}
	return headerHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	
	NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SubCategoryView"
													 owner:self options:nil];
	UIView * secView = (UIView *)[objects objectAtIndex:0];
	
	
	
	UIView *secSubView2 = (UIView *)[secView viewWithTag:23235];
	
	UIButton *btn = (UIButton *)[secSubView2 viewWithTag:101];
	UILabel *lblPrice = (UILabel *)[secSubView2 viewWithTag:100];
	lblPrice.text =strTotalPrice;
	[btn addTarget:self action:@selector(btnGoToCheckOutScreen) forControlEvents:UIControlEventTouchUpInside];
	
	return secView;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat rowHeight = 0.0;
	if (indexPath.section == 0) {
		rowHeight = 0.0;
	}
	else
	{
		ProductsModel *objProductsModel = nil;
		objProductsModel = [self getObjectOfProductForIndexPath:indexPath];
		CGSize size= [Utils getLabelSizeByText:objProductsModel.product_name font:[UIFont fontWithName:kRobotoRegular size:14.0f] andConstraintWith:[UIScreen mainScreen].bounds.size.width-175];
		if (size.height<24) {
			rowHeight = 68.0;
		}
		else
			
			rowHeight = 44+size.height;
		
	}
	return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	
	UITableViewCell *cell ;
	
	if (indexPath.section == 1) {
		HomeSecondCustomCell *cell = (HomeSecondCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[HomeSecondCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			cell.delegate=self;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		ProductsModel *objProductsModel = nil;
		objProductsModel = [self getObjectOfProductForIndexPath:indexPath];
		cell.indexPath=indexPath;
		cell.fromCart = YES;
		cell.store_id	=	self.strStore_Id;
		cell.objProductsModelMain = objProductsModel;
		[cell updateCellWithSubCategory:objProductsModel];
		return cell;
	}
	else
	{
		return cell;
		
	}
	
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)updateTableAtIndexPath:(NSIndexPath *)inIndexPath
{
	[tblVwCategory reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
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
	cart.end_date				=	product.end_date;
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
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:objProductsModel] forStore:[NSDictionary dictionaryWithObjectsAndKeys:appDeleg.objStoreModel.store_id,kStore_id,appDeleg.objStoreModel.store_name,kStore_name,appDeleg.objStoreModel.store_image,kStore_image, nil] add:YES fromCart:NO fromReorder:NO];
	gAppManager.intCount++;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
	[self setUpNavigationBar];
	NSRange range = NSMakeRange(inIndexPath.section, 1);
	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblVwCategory reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
	[tblVwCategory reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	
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
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:objProductsModel] forStore:[NSDictionary dictionaryWithObjectsAndKeys:appDeleg.objStoreModel.store_id,kStore_id,appDeleg.objStoreModel.store_name,kStore_name,appDeleg.objStoreModel.store_image,kStore_image, nil] add:NO fromCart:NO fromReorder:NO];
	gAppManager.intCount--;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
	[self setUpNavigationBar];
	NSRange range = NSMakeRange(inIndexPath.section, 1);
	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblVwCategory reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
	
	
	//    [tblVwCategory reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
	[tblVwCategory reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	
	
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	//    NSIndexPath *indexPath;
	//    for (UICollectionViewCell *cell in [collectionViewCategory visibleCells])
	//    {
	//        indexPath = [collectionViewCategory indexPathForCell:cell];
	//    }
	//    if (self.mainCategoryIndex != indexPath.row)
	//    {
	//        self.mainCategoryIndex = indexPath.row;
	//        if (self.delegate && [self.delegate conformsToProtocol:@protocol(CategoryViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(refreshSubCategoryData)])
	//        {
	//            [self.delegate refreshSubCategoryData];
	//        }
	//    }
}
- (void)btnCategoryClick
{
	//    isSelected = !isSelected;
	if (!isSelected) {
		isSelected = YES;
		
		if (strSelectedCategoryId.length>0) {
			[self.view endEditing:YES];
//			searchBarr.text = @"";
//			[self createDataToGetStoreProducts];
			//			[self searchBarCancelButtonClicked:searchBarr];
			rightCollectionVwContrllr.selectedId = strSelectedCategoryId;
			[self.view addSubview:rightCollectionVwContrllr.view];
		}
	}
	else
	{
		isSelected = NO;
		[rightCollectionVwContrllr.view removeFromSuperview];
	}
	[tblVwCategory reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)btnGoToCheckOutScreen
{
	[self btnCartClicked];
}
#pragma mark - HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker
{
	NSInteger numberOfElements=0;
	numberOfElements = arrOnlySubCategoryPicker.count;
	return numberOfElements;
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index
{
	SubCategoryModel *objSubCategoryModel = [arrOnlySubCategoryPicker objectAtIndex:index];
	NSString *strValue = objSubCategoryModel.sub_category_name;
	return strValue;
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index
{
	NSInteger widthValue=0;
	widthValue=[UIScreen mainScreen].bounds.size.width/3;
	return widthValue ;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
	
	if (self.mainCategoryIndexPicker != index) {
		self.mainCategoryIndexPicker = index;
		pageno = 0;
		searchBarr.text = @"";
//		[searchBarr resignFirstResponder];
		
//		[self searchBar:searchBarr textDidChange:@""];
//	[self searchBarCancelButtonClicked:searchBarr];
		[self createDataToGetStoreProducts];
	}
	
	//    [dict setObject:strCategoryId forKey:kCategory_id];
	
	
}

-(void)selectCategory:(NSDictionary *)dict
{
	strSelectedCategoryId = [dict objectForKey:kCategory_id];
	
	NSString *strCategoryName = [dict objectForKey:kCategory_name];
	
	//    if ([strSelectedCategoryId integerValue] == 496) // value for medicine
	if ([strCategoryName isEqualToString:@"Medicine"]) // Change done .. according to Dinesh - (ID can vary but name will never change ..)
	{
		self.mainCategoryIndexPicker = 0;
		strSelectedCategoryId = @"0";
		PrescriptionViewController *prescriptionView = (PrescriptionViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PrescriptionViewController"];
		
		prescriptionView.strStoreId = strStore_Id;
		prescriptionView.strStoreName = strStore_CategoryName;
		
		
		[self.navigationController pushViewController:prescriptionView animated:YES];
	}
	else
	{
		strSelectedCategoryName = [dict objectForKey:kCategory_name];
		isSelected = NO;
		tblVwCategory.hidden = YES;
		[self createDataToGetStoreProductSubCategory:strSelectedCategoryId];
	}
	
}

-(void)createDataToGetStoreProducts
{
	
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict removeObjectForKey:kUserId];
	[dict setObject:strStore_Id forKey:kStore_id];
	[dict setObject:strSelectedCategoryId forKey:kCategory_id];
	
	SubCategoryModel *objSubCategory = [arrOnlySubCategoryPicker objectAtIndex:self.mainCategoryIndexPicker];
	[dict setObject:objSubCategory.sub_category_id forKey:kSub_category_id];
	
	strSelectedSubCategoryId = objSubCategory.sub_category_id;
	[dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:@"page_no"];
	[Utils stopActivityIndicatorInView:self.view];
	[Utils startActivityIndicatorInView:self.view withMessage:nil];
	[self performSelector:@selector(callWebserviceToGetStoreProducts:) withObject:dict afterDelay:0.1];
}
-(void)callWebserviceToGetStoreProducts:(NSMutableDictionary *)aDict
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	if (![Utils isInternetAvailable])
	{
		[AppManager stopStatusbarActivityIndicator];
		[Utils stopActivityIndicatorInView:self.view];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[self.view endEditing:YES];
	[aaramShop_ConnectionManager getDataForFunction:kPOSTGetStoreProductsURL withInput:aDict withCurrentTask:TASK_GET_STORE_PRODUCTS andDelegate:self ];
}

#pragma mark - Search Bar Delegates

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = YES;
//	isSearching =YES;
	//	scrollViewMain setContentOffset:<#(CGPoint)#>
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	searchBar.text=@"";
	searchBar.showsCancelButton = NO;
//	if (isSearching==NO) {
//		[self createDataToGetStoreProducts];
//	}
	isSearching = NO;
	[searchBar resignFirstResponder];
	[self.view endEditing:YES];
	[self createDataToGetStoreProducts];
	
	
	
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	// called only once
	
	[Utils stopActivityIndicatorInView:self.view];
	
	
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[arrSearchGetStoreProducts removeAllObjects];
	
	strSearchTxt = searchText;
	
	if ([searchText length] ==0 )
	{
		isSearching = NO;
		pageno = 0;
		[searchBar resignFirstResponder];
		[self.view endEditing:YES];
		[self createDataToGetStoreProducts];
	}
	else if ([[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] >=3 ) {
		
		isSearching = YES;
		pageno = 0;
		[self callWebserviceToSearchText:searchText];
	}
	
}


#pragma mark -
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}



#pragma mark - Pagination

- (void)refreshTable
{
	pageno = 0;
	
	if (isSearching)
	{
		[self performSelector:@selector(callWebserviceToSearchText:) withObject:strSearchTxt afterDelay:0.4];
		
	}
	else
	{
		[self performSelector:@selector(createDataToGetStoreProducts) withObject:nil afterDelay:0.4];
		
	}
	
	//    if (isSearching)
	//    {
	//        isLoading = NO;
	//        [self showFooterLoadMoreActivityIndicator:NO];
	//        [refreshShoppingList endRefreshing];
	//    }
	//    else
	//    {
	
	//    }
	
}

-(void)calledPullUp
{
	if( !isSearching && totalNoOfPages>pageno + 1)
	{
		pageno++;
		[self createDataToGetStoreProducts];
	}
	else if( isSearching && totalNoOfPages>pageno + 1)
	{
		pageno++;
		[self callWebserviceToSearchText:strSearchTxt];
	}
	else
	{
		isLoading = NO;
		[self showFooterLoadMoreActivityIndicator:NO];
	}
}


#pragma mark - to refreshing a view

-(void)showFooterLoadMoreActivityIndicator:(BOOL)show{
	UIView *view=[tblVwCategory viewWithTag:111112];
	UIActivityIndicatorView *activity=(UIActivityIndicatorView*)[view viewWithTag:111111];
	
	if (show) {
		[activity startAnimating];
	}else
		[activity stopAnimating];
}


#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	NSInteger arrTempCount = 0;
	
	if (isSearching) {
		
		arrTempCount = [arrSearchGetStoreProducts count];
	}
	else
	{
		arrTempCount = [arrGetStoreProducts count];
	}
	
	
	if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrTempCount > 0 && scrollView.contentOffset.y>0){
		if (!isLoading) {
			isLoading=YES;
			[self showFooterLoadMoreActivityIndicator:YES];
			[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
		}
	}
	
}

- (void)gotBroadCastMessage:(NSNotification *)notification
{
	[self setUpNavigationBar];
}



///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

// added on 17 Sep 2015 .. begins ... by chetan


-(void)callWebserviceToSearchText:(NSString *)searchText
{
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	
	[dict setObject:strStore_Id forKey:kStore_id];
	
	[dict setObject:searchText forKey:@"search_term"];
	[dict setObject:[NSString stringWithFormat:@"%ld",(long)pageno] forKey:kPage_no];
	
	
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	if (![Utils isInternetAvailable])
	{
		[AppManager stopStatusbarActivityIndicator];
		
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	
	
	[aaramShop_ConnectionManager getDataForFunction:KURLSerachStoreProducts withInput:dict withCurrentTask:TASK_TO_SEARCH_HOME_STORE_PRODUCTS andDelegate:self ];
	
}
///////////////////////////////////////////////////////////////////////////////////////////




// added on 17 Sep 2015 .. ends ...


@end
