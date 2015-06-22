//
//  HomeViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeViewController.h"
#import "LocationEnterViewController.h"
#import "HomeSecondViewController.h"
#import "HomeTableCell.h"
#import "ForgotPasswordViewController.h"

@interface HomeViewController ()
{
    AppDelegate *appDeleg;
    BOOL isOffEffect;
    UIView *viewTable ;
    UIImageView *imgVBg;
    UIButton *btnArrow;
}
@end

@implementation HomeViewController
@synthesize mainCategoryIndex,aaramShop_ConnectionManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    appDeleg = APP_DELEGATE;
    isOffEffect = YES;
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;
    self.sideBar = [Utils createLeftBarWithDelegate:self];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49)];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.alwaysBounceVertical= YES;
    [self.view addSubview:mainScrollView];
    

    viewTable = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 337)];
    viewTable.backgroundColor = [UIColor whiteColor];
    
    tblVwCategory = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 337) style:UITableViewStyleGrouped];
    tblVwCategory.delegate = self;
    tblVwCategory.dataSource = self;
    tblVwCategory.alwaysBounceVertical = NO;
    tblVwCategory.backgroundView = nil;
    tblVwCategory.backgroundColor = [UIColor clearColor];
    tblVwCategory.sectionHeaderHeight = 0.0;
    tblVwCategory.sectionFooterHeight = 0.0;
    tblVwCategory.scrollEnabled = NO;
    [self setUpNavigationBar];

    tblStores = [[UITableView alloc]initWithFrame:CGRectMake(0, 337, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-337-49)];
    tblStores.delegate = self;
    tblStores.dataSource = self;
    tblStores.backgroundColor = [UIColor clearColor];
    tblStores.scrollEnabled = YES;

    [mainScrollView addSubview:tblStores];
    [mainScrollView addSubview:viewTable];
    
    imgVBg = [[UIImageView alloc]initWithFrame:CGRectMake(0,viewTable.frame.size.height-78, [UIScreen mainScreen].bounds.size.width, 85)];
    imgVBg.image = [UIImage imageNamed:@"homeScreenArrowBox.png"];
    [viewTable addSubview:imgVBg];
    
    [viewTable addSubview:tblVwCategory];

    btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    btnArrow.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-40)/2, viewTable.frame.size.height-10, 40, 25);
    btnArrow.backgroundColor = [UIColor clearColor];
    [btnArrow setImage:[UIImage imageNamed:@"homeDownArrow.png"] forState:UIControlStateNormal];
    [btnArrow addTarget:self action:@selector(btnArrowClick) forControlEvents:UIControlEventTouchUpInside];
    [viewTable addSubview:btnArrow];

    
    
    arrSubCategory = [[NSMutableArray alloc]init];
    arrCategory = [[NSMutableArray alloc]init];
    arrRecommendedStores = [[NSMutableArray alloc]init];
    
    arrSubCategoryMyStores = [[NSMutableArray alloc]init];
    arrRecommendedStoresMyStores = [[NSMutableArray alloc]init];

    
    self.mainCategoryIndex = 0;
    tblVwCategory.hidden = YES;
    tblStores.hidden = YES;
    mainScrollView.hidden = YES;
    [self createDataToGetStores];
}

-(void)setViewForRecomendedCells
{
    StoreModel *objStoreModel = nil;
    
    if (self.mainCategoryIndex != 0) {
        objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
        NSArray *arrTemp = [arrRecommendedStores filteredArrayUsingPredicate:predicate];
        objStoreModel = [arrTemp objectAtIndex:0];
    }
    else
    {
        objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:0];
    }
    
    CGSize size= [Utils getLabelSizeByText:objStoreModel.store_category_name font:[UIFont fontWithName:kRobotoRegular size:14.0] andConstraintWith:[UIScreen mainScreen].bounds.size.width-110];
    
    if (size.height < 20) {
        size.height = 83;
    }
    else
        size.height+= 63;


    tblVwCategory.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 254+size.height);
    viewTable.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 254+size.height);
    btnArrow.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-40)/2, viewTable.frame.size.height-15, 40, 25);
    imgVBg.frame = CGRectMake(0,viewTable.frame.size.height-78, [UIScreen mainScreen].bounds.size.width, 85);
    
    tblStores.frame = CGRectMake(0, 254+size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(254+size.height+49));



}
-(void)btnArrowClick
{
    isOffEffect = !isOffEffect;
    
    if (!isOffEffect) {
        tblVwCategory.scrollEnabled = YES;
        tblStores.hidden = YES;
        imgVBg.hidden = YES;
        tblVwCategory.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49-20);
        viewTable.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49);
        btnArrow.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-40)/2, viewTable.frame.size.height-15, 40, 15);
        [btnArrow setImage:[UIImage imageNamed:@"upArr.png"] forState:UIControlStateNormal];

        
        [tblVwCategory reloadData];
    }
    else if (isOffEffect)
    {
        tblStores.hidden = NO;
        imgVBg.hidden = NO;
        tblVwCategory.scrollEnabled = NO;

        [self setViewForRecomendedCells];
        [btnArrow setImage:[UIImage imageNamed:@"homeDownArrow.png"] forState:UIControlStateNormal];
        [tblVwCategory reloadData];

    }
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - createDataToGetStores

-(void)createDataToGetStores
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    
    [self callWebserviceToGetStores:dict];
}

-(void)callWebserviceToGetStores:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kGetStoresURL withInput:aDict withCurrentTask:TASK_TO_GET_STORES andDelegate:self ];
}

#pragma mark - createDataToGetStoresFromCategories

-(void)createDataToGetStoresFromCategories
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    StoreModel *objStore = [arrCategory objectAtIndex:self.mainCategoryIndex];
    [dict setObject:objStore.store_main_category_id forKey:kCategory_id];
    [self callWebserviceToGetStoresFromCategories:dict];
}

-(void)callWebserviceToGetStoresFromCategories:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kGetStoresfromCategoryIdURL withInput:aDict withCurrentTask:TASK_TO_GET_STORES_FROM_CATEGORIES_ID andDelegate:self ];
}

#pragma mark - createDataToGetStoresPagination

-(void)createDataToGetStoresPagination
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    
    StoreModel *objStore = nil;
    if (self.mainCategoryIndex !=0) {
        
    }
    objStore = [arrCategory objectAtIndex:self.mainCategoryIndex];
    
    [dict setObject:objStore.store_main_category_id forKey:kCategory_id];
    [self callWebserviceToGetStoresPagination:dict];
}
-(void)callWebserviceToGetStoresPagination:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kGetStoresPaginationURL withInput:aDict withCurrentTask:TASK_TO_GET_STORES_PAGINATION andDelegate:self ];

}
-(void) didFailWithError:(NSError *)error
{
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_STORES) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            [self parseStoreData:responseObject];
        }
        else
        {
              [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
    else if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_STORES_FROM_CATEGORIES_ID) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            [self  parseStoreNextData:responseObject];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
    else if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_STORES_PAGINATION) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            [self parseStoreData:responseObject];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }


}

-(void)parseStoreData:(NSMutableDictionary *)responseObject
{
    NSArray *categories = [responseObject objectForKey:@"categories"];
    
    for (NSDictionary *dict in categories) {
        
        StoreModel *objStoreModel = [[StoreModel alloc]init];
        objStoreModel.store_main_category_banner_1 = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_main_category_banner_1]];
        objStoreModel.store_main_category_banner_2 = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_main_category_banner_2]];
        objStoreModel.store_main_category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_main_category_id]];
        objStoreModel.store_main_category_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_main_category_name]];

        NSArray *arrRecomendedStores = [dict objectForKey:@"recommended_stores"];
        NSArray *arrHomeStores = [dict objectForKey:@"home_stores"];
        NSArray *arrshoppingStores = [dict objectForKey:@"shopping_store"];
        
        
        for (NSDictionary *dictRecommended in arrRecomendedStores) {
            
            StoreModel *objStore = [[StoreModel alloc]init];
            objStore.chat_username = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kChat_username]];
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kHome_delivey]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_category_icon]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_image]];
            objStore.store_latitude = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_latitude]];
            objStore.store_longitude = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_longitude]];
            objStore.store_mobile = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_mobile]];
            objStore.store_name = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_name]];
            objStore.store_rating = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_rating]];
            objStore.total_orders = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kTotal_orders]];
            objStore.store_category_id = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_category_id]];

            [arrRecommendedStoresMyStores addObject:objStore];
        }
        for (NSDictionary *dictHome in arrHomeStores) {
            
            StoreModel *objStore = [[StoreModel alloc]init];
            objStore.chat_username = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kChat_username]];
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kHome_delivey]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_category_icon]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_image]];
            objStore.store_latitude = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_latitude]];
            objStore.store_longitude = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_longitude]];
            objStore.store_mobile = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_mobile]];
            objStore.store_name = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_name]];
            objStore.store_rating = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_rating]];
            objStore.total_orders = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kTotal_orders]];
            objStore.store_category_id = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_category_id]];

            [arrSubCategoryMyStores addObject:objStore];
        }

        for (NSDictionary *dictShopping in arrshoppingStores) {
            
            StoreModel *objStore = [[StoreModel alloc]init];
            objStore.chat_username = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kChat_username]];
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kHome_delivey]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_category_icon]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_image]];
            objStore.store_latitude = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_latitude]];
            objStore.store_longitude = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_longitude]];
            objStore.store_mobile = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_mobile]];
            objStore.store_name = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_name]];
            objStore.store_rating = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_rating]];
            objStore.total_orders = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kTotal_orders]];
            objStore.store_category_id = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_category_id]];

            [arrSubCategoryMyStores addObject:objStore];
        }

        [arrCategory addObject:objStoreModel];
    }
    
    objCategoryVwController = (CategoryViewController *) [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"categoryScreen"];
    
    objCategoryVwController.delegate = self;

    objCategoryVwController.arrCategory  = [[NSMutableArray alloc]init];
    [objCategoryVwController.arrCategory addObjectsFromArray:arrCategory];
    
    tblVwCategory.hidden = NO;
    tblStores.hidden = NO;
    mainScrollView.hidden = NO;
    
    [tblVwCategory reloadData];
    if (arrCategory.count>0) {
        [self setViewForRecomendedCells];
    }
    [tblStores reloadData];
}

-(void)parseStoreNextData:(NSMutableDictionary *)responseObject
{
    NSArray *arrRecomendedStoresTemp = [responseObject objectForKey:@"recommended_stores"];
    NSArray *arrHomeStoresTemp = [responseObject objectForKey:@"home_stores"];
    NSArray *arrshoppingStoresTemp = [responseObject objectForKey:@"shopping_store"];
    
        for (NSDictionary *dictRecommended in arrRecomendedStoresTemp) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_id MATCHES %@ AND SELF.store_category_id MATCHES %@",[dictRecommended objectForKey:kStore_id],[dictRecommended objectForKey:kStore_category_id]];
            NSArray *arrTemp =[arrRecommendedStores filteredArrayUsingPredicate:predicate];
            if (arrTemp.count == 0) {
                StoreModel *objStore = [[StoreModel alloc]init];

            objStore.chat_username = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kChat_username]];
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kHome_delivey]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_category_icon]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_image]];
            objStore.store_latitude = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_latitude]];
            objStore.store_longitude = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_longitude]];
            objStore.store_mobile = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_mobile]];
            objStore.store_name = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_name]];
            objStore.store_rating = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_rating]];
            objStore.total_orders = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kTotal_orders]];
            objStore.store_category_id = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_category_id]];

            [arrRecommendedStores addObject:objStore];
            }
        }
        for (NSDictionary *dictHome in arrHomeStoresTemp) {

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_id MATCHES %@ AND SELF.store_category_id MATCHES %@",[dictHome objectForKey:kStore_id],[dictHome objectForKey:kStore_category_id]];
            NSArray *arrTemp =[arrSubCategory filteredArrayUsingPredicate:predicate];
            if (arrTemp.count == 0) {

            StoreModel *objStore = [[StoreModel alloc]init];
            objStore.chat_username = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kChat_username]];
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kHome_delivey]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_category_icon]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_image]];
            objStore.store_latitude = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_latitude]];
            objStore.store_longitude = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_longitude]];
            objStore.store_mobile = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_mobile]];
            objStore.store_name = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_name]];
            objStore.store_rating = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_rating]];
            objStore.total_orders = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kTotal_orders]];
            objStore.store_category_id = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_category_id]];

            [arrSubCategory addObject:objStore];
            }
        }
        
        for (NSDictionary *dictShopping in arrshoppingStoresTemp) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_id MATCHES %@ AND SELF.store_category_id MATCHES %@",[dictShopping objectForKey:kStore_id],[dictShopping objectForKey:kStore_category_id]];
            NSArray *arrTemp =[arrSubCategory filteredArrayUsingPredicate:predicate];

            if (arrTemp.count == 0) {
            StoreModel *objStore = [[StoreModel alloc]init];
            objStore.chat_username = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kChat_username]];
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kHome_delivey]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_category_icon]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_image]];
            objStore.store_latitude = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_latitude]];
            objStore.store_longitude = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_longitude]];
            objStore.store_mobile = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_mobile]];
            objStore.store_name = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_name]];
            objStore.store_rating = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_rating]];
            objStore.total_orders = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kTotal_orders]];
            objStore.store_category_id = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_category_id]];

            [arrSubCategory addObject:objStore];
            }
        }
    
    [tblVwCategory reloadData];
    if (arrCategory.count>0) {
        [self setViewForRecomendedCells];
    }

    [tblStores reloadData];
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
    titleView.text = @"";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    UIImage *imgBack = [UIImage imageNamed:@"menuIcon.png"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake( -10, 0, 30, 30);
    
    [backBtn setImage:imgBack forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnMenuClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
    UIImage *imgCart = [UIImage imageNamed:@"addToCartIcon.png"];
    
    UIImage *imgSearch = [UIImage imageNamed:@"searchIcon.png"];
    
    UIButton *btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCart.bounds = CGRectMake( -10, 0, 30, 30);
    
    [btnCart setImage:imgCart forState:UIControlStateNormal];
    [btnCart addTarget:self action:@selector(btnCartClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnCart = [[UIBarButtonItem alloc] initWithCustomView:btnCart];
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.bounds = CGRectMake( -10, 0, 30, 30);
    
    [btnSearch setImage:imgSearch forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(btnSearchClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    
    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnCart,barBtnSearch, nil];
    self.navigationItem.rightBarButtonItems = arrBtnsRight;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        
        UIImage *image = [UIImage imageNamed:@"navigation.png"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}
-(void)btnMenuClicked
{
    [self.sideBar show];
}
-(void)btnSearchClicked
{
    
}
-(void)btnCartClicked
{
    
}
- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
    [self.navigationController pushViewController:viewC animated:YES];
}

#pragma mark - TableView Datasource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 0;
    if (tableView == tblVwCategory) {
        sectionNum = 2;
    }
    else if (tableView == tblStores)
        sectionNum = 1;
    return sectionNum;;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsNum = 0;
    if (tableView == tblVwCategory) {
        if (section == 1) {
            if (isOffEffect) {
                if (self.mainCategoryIndex !=0) {
                    if (arrRecommendedStores.count == 0) {
                        rowsNum = 0;
                    }
                    else
                        rowsNum = 1;
                }
                else
                {
                    if (arrRecommendedStoresMyStores.count == 0) {
                        rowsNum = 0;
                    }
                    else
                        rowsNum = 1;
   
                }
            }
            else
            {
                StoreModel *objStore = nil;
                
                if (self.mainCategoryIndex != 0) {
                    objStore = [arrCategory objectAtIndex:self.mainCategoryIndex];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStore.store_main_category_id];
                    NSArray *arrTemp = [arrRecommendedStores filteredArrayUsingPredicate:predicate];
                    rowsNum = arrTemp.count;
                }
                else
                    rowsNum = arrRecommendedStoresMyStores.count;

            }
        }
        else if (section == 0)
            rowsNum = 0;
    }
    else if (tableView == tblStores) {
        if (arrCategory.count>0) {
            StoreModel *objStore = nil;
            
            if (self.mainCategoryIndex != 0) {
                objStore = [arrCategory objectAtIndex:self.mainCategoryIndex];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStore.store_main_category_id];
                NSArray *arrTemp = [arrSubCategory filteredArrayUsingPredicate:predicate];
                rowsNum = arrTemp.count;

            }
            else
                rowsNum = arrSubCategoryMyStores.count;
        }
        else
            rowsNum = 0;
    }

    return rowsNum;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0.0;
    if (tableView == tblVwCategory) {
        if (section == 0) {
            headerHeight = 234;
        }
        else if (section == 1){
            if (self.mainCategoryIndex !=0) {
                if (arrRecommendedStores.count == 0) {
                    headerHeight = 0;
                }
                else
                    headerHeight = 20;
            }
            else
            {
                if (arrRecommendedStoresMyStores.count == 0) {
                    headerHeight = 0;
                }
                else
                    headerHeight = 20;

            }
        }
    }
    else if (tableView == tblStores) {
        headerHeight = CGFLOAT_MIN;
    }
    
    return headerHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *secView ;
    if (tableView == tblVwCategory) {
        if (section == 0) {
            secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 234)];
            secView.backgroundColor = [UIColor clearColor];
            [secView addSubview:objCategoryVwController.view];
        }
        else if (section == 1)
        {
            secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 20)];
            secView.backgroundColor = [UIColor redColor];
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 20)];
            lbl.textColor = [UIColor whiteColor];
            lbl.font = [UIFont fontWithName:kRobotoMedium size:16];
            lbl.text = @"Recommended stores";
            [secView addSubview:lbl];
        }
    }
    else if (tableView == tblStores)
    {
        secView = nil;
    }
    return secView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0.0;
    if (tableView == tblVwCategory) {
        if (indexPath.section == 1) {
            StoreModel *objStoreModel = nil;
            if (self.mainCategoryIndex != 0) {
                objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
                NSArray *arrTemp = [arrRecommendedStores filteredArrayUsingPredicate:predicate];
                objStoreModel = [arrTemp objectAtIndex:indexPath.row];

            }
            else
                objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:indexPath.row];
            
            CGSize size= [Utils getLabelSizeByText:objStoreModel.store_category_name font:[UIFont fontWithName:kRobotoRegular size:14.0] andConstraintWith:[UIScreen mainScreen].bounds.size.width-110];
            
            if (size.height < 20) {
                rowHeight = 83;
            }
            else
                rowHeight = size.height+63;
        }
        else if (indexPath.section == 0)
            rowHeight = 0;
    }
    else if (tableView == tblStores) {
        
        StoreModel *objStoreModel = nil;
        if (self.mainCategoryIndex != 0) {

       objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
        NSArray *arrTemp = [arrSubCategory filteredArrayUsingPredicate:predicate];
        
        objStoreModel = [arrTemp objectAtIndex:indexPath.row];
        }
        else
            objStoreModel = [arrSubCategoryMyStores objectAtIndex:indexPath.row];
        
        CGSize size= [Utils getLabelSizeByText:objStoreModel.store_category_name font:[UIFont fontWithName:kRobotoRegular size:14.0] andConstraintWith:[UIScreen mainScreen].bounds.size.width-110];
        
        if (size.height < 20) {
            rowHeight = 80;
        }
        else
            rowHeight = size.height+60;
    }
    
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
        HomeTableCell *cell = (HomeTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setRightUtilityButtons: [self leftButtons] WithButtonWidth:225];

    cell.selectedCategory = self.mainCategoryIndex;
    cell.delegate=self;
    cell.delegateHomeCell = self;
    StoreModel *objStoreModel = nil;

    if (tableView == tblVwCategory) {
        if (self.mainCategoryIndex != 0) {
            objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
            NSArray *arrTemp = [arrRecommendedStores filteredArrayUsingPredicate:predicate];
            objStoreModel = [arrTemp objectAtIndex:indexPath.row];
        }
        else
            objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];

    }
    else if (tableView == tblStores) {
        if (self.mainCategoryIndex !=0) {
            objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
            NSArray *arrTemp = [arrSubCategory filteredArrayUsingPredicate:predicate];
            
            objStoreModel = [arrTemp objectAtIndex:indexPath.row];

        }
        else
            objStoreModel = [arrSubCategoryMyStores objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];

    }
    cell.objStoreModel = objStoreModel;

    cell.indexPath=indexPath;
    [cell updateCellWithData:objStoreModel];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeSecondViewController *homeSecondVwController = (HomeSecondViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeSecondScreen"];
    StoreModel *objStoreModel = nil;
    if (mainCategoryIndex != 0)
    {
        if (tableView == tblStores)
            objStoreModel = [arrSubCategory objectAtIndex:indexPath.row];
        else if (tableView == tblVwCategory)
            objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
    }
    else
    {
        if (tableView == tblStores)
            objStoreModel = [arrSubCategoryMyStores objectAtIndex:indexPath.row];
        else if (tableView == tblVwCategory)
            objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:indexPath.row];
    }
    
    homeSecondVwController.strStore_Id = objStoreModel.store_id;
    homeSecondVwController.strStore_CategoryName = objStoreModel.store_category_name;
    [self.navigationController pushViewController:homeSecondVwController animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
-(void)refreshSubCategoryData:(NSInteger)selectedCategory
{
    self.mainCategoryIndex = selectedCategory;
    [self createDataToGetStoresFromCategories];

}
-(void)refreshBtnFavouriteStatus:(NSIndexPath *)indexPath
{
    [tblVwCategory reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - Custom Methods for SwipeCell

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableAttributedString * call = [[NSMutableAttributedString alloc] initWithString:@"Call"];
    NSMutableAttributedString * chat = [[NSMutableAttributedString alloc] initWithString:@"Chat"];
    NSMutableAttributedString * shop = [[NSMutableAttributedString alloc] initWithString:@"Shop"];

    [leftUtilityButtons sw_addUtilityButtonWithBackgroundImage:[UIImage imageNamed:@"homeRecomondedStoreCallIcon"] attributedTitle: call ];
    [leftUtilityButtons sw_addUtilityButtonWithBackgroundImage:[UIImage imageNamed:@"homeRecomondedStoreChatIcon"] attributedTitle: chat ];
    [leftUtilityButtons sw_addUtilityButtonWithBackgroundImage:[UIImage imageNamed:@"homeRecomondedStoreShopIcon"] attributedTitle: shop ];

    
    return leftUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call"
                                                            message:@"message"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chat"
                                                            message:@"message"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }break;
        case 2:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shop"
                                                            message:@"message"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }break;
            
    
            
            
        default:
            break;
    }
}


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
