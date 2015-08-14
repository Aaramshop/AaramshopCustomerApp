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
    appDeleg = APP_DELEGATE;
    self.automaticallyAdjustsScrollViewInsets = NO;
	self.navigationItem.hidesBackButton = YES;
    tblVwCategory = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49-64) style:UITableViewStyleGrouped];
    tblVwCategory.delegate = self;
    tblVwCategory.dataSource = self;
    tblVwCategory.backgroundView = nil;
    tblVwCategory.backgroundColor = [UIColor clearColor];
    tblVwCategory.sectionHeaderHeight = 0.0;
    tblVwCategory.sectionFooterHeight = 0.0;
    tblVwCategory.alwaysBounceVertical = NO;
    tblVwCategory.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    
    [self.view addSubview:tblVwCategory];
    
    
    ////
    
    totalNoOfPages = 0;
    pageno = 0;
    isLoading = NO;
    
    tblVwCategory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = tblVwCategory;
    refreshShoppingList = [[UIRefreshControl alloc] init];
    [refreshShoppingList addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshShoppingList;
    
    ////
    

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
        
        [arrGetStoreProductCategories addObject:objCategoryModel];
    }
    if (arrGetStoreProductCategories.count>0) {
        CategoryModel *objCategoryModel = [arrGetStoreProductCategories objectAtIndex:0];
        strSelectedCategoryId = objCategoryModel.category_id;
    }
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
    rightCollectionVwContrllr.strStore_Id= strStore_Id;
     [rightCollectionVwContrllr.arrCategories addObjectsFromArray:arrGetStoreProductCategories];
    [self.view addSubview:rightCollectionVwContrllr.view];
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
	
	
	
	UIImage *imgBroadcast = [UIImage imageNamed:@"bellIcon"];
	
	UIButton *btnBroadcast = [UIButton buttonWithType:UIButtonTypeCustom];
	btnBroadcast.bounds = CGRectMake( 0, 0, 24, 24);
	
	[btnBroadcast setImage:imgBroadcast forState:UIControlStateNormal];
	[btnBroadcast addTarget:self action:@selector(btnBroadcastClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnBroadcast = [[UIBarButtonItem alloc] initWithCustomView:btnBroadcast];
	
	
	NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnCart,barBtnSearch,barBtnBroadcast, nil];
	self.navigationItem.rightBarButtonItems = arrBtnsRight;

	NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack,barBtnFav, nil];
	self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    self.navigationItem.rightBarButtonItems = arrBtnsRight;
	
}
-(void)btnBackClicked
{
    isViewActive = NO;
	[arrGetStoreProducts removeAllObjects];
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
    if (arrGetStoreProducts.count >0) {
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
        NSArray *arrTemp = [arrSearchGetStoreProducts filteredArrayUsingPredicate:predicate];
        objProductsModel = [arrTemp objectAtIndex: IndexPath.row];

    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
        NSArray *arrTemp = [arrGetStoreProducts filteredArrayUsingPredicate:predicate];
        objProductsModel = [arrTemp objectAtIndex: IndexPath.row];

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
-(NSInteger )getArrayCountForProducts
{
    NSInteger rowsNum = 0;
    if (isSearching)
    {
        if (arrGetStoreProductSubCategory.count>0 && arrSearchGetStoreProducts.count>0 && arrGetStoreProductCategories.count>0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category_id MATCHES %@ AND SELF.sub_category_id MATCHES %@",strSelectedCategoryId,strSelectedSubCategoryId];
            NSArray *arrTemp = [arrSearchGetStoreProducts filteredArrayUsingPredicate:predicate];
            rowsNum = arrTemp.count;
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
        }
        else
            rowsNum = 0;

    }
    return  rowsNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0.0;
    if (section == 0) {
        headerHeight = 170;
    }
    else if (section == 1)
    {
        headerHeight = 82;
    }
    return headerHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView *tempView = nil;
        
        tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170)];
        
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CategoryView"
                                                         owner:self options:nil];
        UIView * secView = (UIView *)[objects objectAtIndex:0];
//        UIView *smallview = (UIView*)[secView.subviews objectAtIndex:0];
//        UIView *smallview1 = (UIView*)[smallview.subviews objectAtIndex:1];
		UIView *arrowView = (UIView *)[secView viewWithTag:100];
		UIButton *btnCategory = (UIButton *)[arrowView viewWithTag:1000];

//        if (!btnCategory) {
//            for (UIButton *btn in smallview1.subviews) {
//                if ([btn isKindOfClass:[UIButton class]]) {
//                    btnCategory = (UIButton *)btn;
//                }
//            }

//        }
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
                UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[secView viewWithTag:998];
                
//                [activity startAnimating];
                [imgVCategoryBanner sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objCategoryModel.category_banner]] placeholderImage:[UIImage imageNamed:@"homeDetailDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    if (image) {
//                        [activity stopAnimating];
//                    }
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
        return tempView;
    }
    else
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SubCategoryView"
                                                         owner:self options:nil];
        UIView * secView = (UIView *)[objects objectAtIndex:0];
        UIView *secSubView1 = (UIView *)[secView viewWithTag:23237];
        
//        UISearchBar *searchBarProducts = (UISearchBar *)[secSubView1 viewWithTag:102];
        searchBarProducts = (UISearchBar *)[secSubView1 viewWithTag:102];

        searchBarProducts.delegate = self;
        
   [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f]];
        searchBarProducts.placeholder = @"Search";
        searchBarProducts.text = strSearchTxt;
        
        if (strSearchTxt.length>0) {
            [searchBarProducts becomeFirstResponder];
        }
        
        UIView *secSubView2 = (UIView *)[secView viewWithTag:23235];
        
        UIButton *btn = (UIButton *)[secSubView2 viewWithTag:101];
        UILabel *lblPrice = (UILabel *)[secSubView2 viewWithTag:100];
        lblPrice.text =strTotalPrice;
        [btn addTarget:self action:@selector(btnGoToCheckOutScreen) forControlEvents:UIControlEventTouchUpInside];
        
        return secView;
    }
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
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:objProductsModel] forStore:[NSDictionary dictionaryWithObjectsAndKeys:appDeleg.objStoreModel.store_id,kStore_id,appDeleg.objStoreModel.store_name,kStore_name,appDeleg.objStoreModel.store_image,kStore_image, nil] add:YES fromCart:NO];
	gAppManager.intCount++;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
	[self setUpNavigationBar];
	NSRange range = NSMakeRange(inIndexPath.section, 1);
	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblVwCategory reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];

//    [tblVwCategory reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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
	[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:objProductsModel] forStore:[NSDictionary dictionaryWithObjectsAndKeys:appDeleg.objStoreModel.store_id,kStore_id,appDeleg.objStoreModel.store_name,kStore_name,appDeleg.objStoreModel.store_image,kStore_image, nil] add:NO fromCart:NO];
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
    NSIndexPath *indexPath;
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
        [self createDataToGetStoreProducts];
    }
    
}

-(void)selectCategory:(NSDictionary *)dict
{
    strSelectedCategoryId = [dict objectForKey:kCategory_id];
    
    if ([strSelectedCategoryId integerValue] == 496) // value for medicine
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
    
    [aaramShop_ConnectionManager getDataForFunction:kPOSTGetStoreProductsURL withInput:aDict withCurrentTask:TASK_GET_STORE_PRODUCTS andDelegate:self ];
}

#pragma mark - Search Bar Delegates

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
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
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length]==0)
    {
        strSearchTxt = searchText;
        isSearching =NO;
        [arrSearchGetStoreProducts removeAllObjects];
        [tblVwCategory reloadData];
        return;
    }
    
//    strSearchTxt = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    strSearchTxt = searchText;
    isSearching=YES;
    if ([searchText length]>0)
    {
        [arrSearchGetStoreProducts removeAllObjects];
//        [tblVwCategory reloadData];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.product_name contains[cd] %@",strSearchTxt];
        [arrSearchGetStoreProducts addObjectsFromArray:[arrGetStoreProducts filteredArrayUsingPredicate:predicate]];

		[tblVwCategory reloadData];
        
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
    
//    if (isSearching)
//    {
//        isLoading = NO;
//        [self showFooterLoadMoreActivityIndicator:NO];
//        [refreshShoppingList endRefreshing];
//    }
//    else
//    {
    
    // crash occured without using this code
        ///// begin
        isSearching = NO;
        strSearchTxt = @"";
        searchBarProducts.text = strSearchTxt;
    
    ///// end
    
        [self performSelector:@selector(createDataToGetStoreProducts) withObject:nil afterDelay:0.4];
//    }
    
}


-(void)calledPullUp
{
    if( !isSearching && totalNoOfPages>pageno + 1)
    {
        pageno++;
        [self createDataToGetStoreProducts];
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


/*

{

    "sub_categories" =     (
                            {
                                "category_id" = 1;
                                "page_no" = 0;
                                products =             (
                                                        {
                                                            "category_id" = 1;
                                                            "offer_id" = 0;
                                                            "offer_price" = "0.00";
                                                            "offer_type" = 0;
                                                            "product_id" = 292;
                                                            "product_image" = "https://www.aaramshop.com/uploaded_files/product/100x100/17-17-53876631435.jpg";
                                                            "product_name" = "Center Fresh 3.7gms";
                                                            "product_price" = "1.00";
                                                            "product_sku_id" = 360;
                                                            "sub_category_id" = 187;
                                                        },
                                                        {
                                                            "category_id" = 1;
                                                            "offer_id" = 0;
                                                            "offer_price" = "0.00";
                                                            "offer_type" = 0;
                                                            "product_id" = 308;
                                                            "product_image" = "https://www.aaramshop.com/uploaded_files/product/100x100/07-59-412036627924.jpg";
                                                            "product_name" = "Happydent White 21gms";
                                                            "product_price" = "10.00";
                                                            "product_sku_id" = 382;
                                                            "sub_category_id" = 187;
                                                        },
                                                        {
                                                            "category_id" = 1;
                                                            "offer_id" = 0;
                                                            "offer_price" = "0.00";
                                                            "offer_type" = 0;
                                                            "product_id" = 310;
                                                            "product_image" = "https://www.aaramshop.com/uploaded_files/product/100x100/08-09-011742970428.jpg";
                                                            "product_name" = "Happydent with Xylitol-Protex 27.5gms";
                                                            "product_price" = "50.00";
                                                            "product_sku_id" = 385;
                                                            "sub_category_id" = 187;
                                                        },
                                                        {
                                                            "category_id" = 1;
                                                            "offer_id" = 0;
                                                            "offer_price" = "0.00";
                                                            "offer_type" = 0;
                                                            "product_id" = 2943;
                                                            "product_image" = "https://www.aaramshop.com/uploaded_files/product/100x100/17-52-25213682124.jpg";
                                                            "product_name" = "Happydent Wave 2.5gms";
                                                            "product_price" = "1.00";
                                                            "product_sku_id" = 4508;
                                                            "sub_category_id" = 187;
                                                        },
                                                        {
                                                            "category_id" = 1;
                                                            "offer_id" = 0;
                                                            "offer_price" = "0.00";
                                                            "offer_type" = 0;
                                                            "product_id" = 310;
                                                            "product_image" = "https://www.aaramshop.com/uploaded_files/product/100x100/08-09-011742970428.jpg";
                                                            "product_name" = "Happydent with Xylitol-Protex 27.5gms";
                                                            "product_price" = "50.00";
                                                            "product_sku_id" = 385;
                                                            "sub_category_id" = 187;
                                                        },
                                                        {
                                                            "category_id" = 1;
                                                            "offer_id" = 0;
                                                            "offer_price" = "0.00";
                                                            "offer_type" = 0;
                                                            "product_id" = 310;
                                                            "product_image" = "https://www.aaramshop.com/uploaded_files/product/100x100/08-09-011742970428.jpg";
                                                            "product_name" = "Happydent with Xylitol-Protex 27.5gms";
                                                            "product_price" = "50.00";
                                                            "product_sku_id" = 385;
                                                            "sub_category_id" = 187;
                                                        },
                                                        {
                                                            "category_id" = 1;
                                                            "offer_id" = 0;
                                                            "offer_price" = "0.00";
                                                            "offer_type" = 0;
                                                            "product_id" = 286;
                                                            "product_image" = "https://www.aaramshop.com/uploaded_files/product/100x100/06-44-361276461536.jpg";
                                                            "product_name" = "Big Babol 1nos.";
                                                            "product_price" = "10.00";
                                                            "product_sku_id" = 347;
                                                            "sub_category_id" = 187;
                                                        }
                                                        );
                                "sub_category_id" = 187;
                                "sub_category_name" = "Chewing Gums";
                                "total_pages" = 7;
                            },
                            {
                                "category_id" = 1;
                                "sub_category_id" = 189;
                                "sub_category_name" = "Toffees & Candies";
                            },
                            
                            );
}



//*/


@end
