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
    BOOL isRefreshing;
}
@end

@implementation HomeViewController
@synthesize mainCategoryIndex,aaramShop_ConnectionManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    appDeleg = APP_DELEGATE;
    isOffEffect = YES;
    isRefreshing= NO;
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
    tblStores.sectionHeaderHeight = 0.0;
    tblStores.sectionFooterHeight = 0.0;


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
    NSInteger rowCount = 0;
    
    if (self.mainCategoryIndex != 0 && arrRecommendedStores.count>0) {
        objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
        
        NSArray *arrTemp = [arrRecommendedStores filteredArrayUsingPredicate:predicate];
        rowCount = arrTemp.count;
    }
    else
    {
        rowCount = arrRecommendedStoresMyStores.count;
    }

    CGSize size = CGSizeZero;
    if (rowCount>0) {
        if(self.mainCategoryIndex != 0 && arrRecommendedStores.count>0)
        {
            objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
            
            NSArray *arrTemp = [arrRecommendedStores filteredArrayUsingPredicate:predicate];
            objStoreModel = [arrTemp objectAtIndex:0];
        }
        else
        {
            objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:0];
            
        }
        
        size= [Utils getLabelSizeByText:objStoreModel.store_category_name font:[UIFont fontWithName:kRobotoRegular size:14.0] andConstraintWith:[UIScreen mainScreen].bounds.size.width-110];
        
        if (size.height < 20) {
            size.height = 83;
        }
        else
            size.height+= 63;
        
        size.height+=20;
    }

    [tblVwCategory scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

    tblVwCategory.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 234+size.height);
    viewTable.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 234+size.height);
    if (rowCount>0) {
        btnArrow.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-40)/2, viewTable.frame.size.height-15, 40, 25);
        imgVBg.frame = CGRectMake(0,viewTable.frame.size.height-78, [UIScreen mainScreen].bounds.size.width, 85);
        btnArrow.hidden = NO;
        imgVBg.hidden = NO;
    }
    else
    {
        btnArrow.hidden = YES;
        imgVBg.hidden = YES;
    }
    
    tblStores.frame = CGRectMake(0, 234+size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(234+size.height+49));
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
        [btnArrow setImage:[UIImage imageNamed:@"upArrow.png"] forState:UIControlStateNormal];

        
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
    if(![gCXMPPController isConnected])
    {
        [gCXMPPController connect];
    }
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
        objStoreModel.store_main_category_banner_1 = [NSString stringWithFormat:@"%@",[[dict objectForKey:kStore_main_category_banner_1]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        

        objStoreModel.store_main_category_banner_2 = [NSString stringWithFormat:@"%@",[[dict objectForKey:kStore_main_category_banner_2]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        objStoreModel.store_main_category_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_main_category_id]];
        objStoreModel.store_main_category_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_main_category_name]];

        NSArray *arrRecomendedStores = [dict objectForKey:@"recommended_stores"];
        NSArray *arrHomeStores = [dict objectForKey:@"home_stores"];
        NSArray *arrshoppingStores = [dict objectForKey:@"shopping_store"];
        
        
        for (NSDictionary *dictRecommended in arrRecomendedStores) {
            
            StoreModel *objStore = [[StoreModel alloc]init];
            objStore.chat_username = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kChat_username]];
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kHome_delivery]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[[dictRecommended objectForKey:kStore_category_icon]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[[dictRecommended objectForKey:kStore_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kHome_delivery]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[[dictHome objectForKey:kStore_category_icon]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[[dictHome objectForKey:kStore_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kHome_delivery]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[[dictShopping objectForKey:kStore_category_icon]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[[dictShopping objectForKey:kStore_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    if (arrCategory.count>0 && isOffEffect) {
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
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kHome_delivery]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[[dictRecommended objectForKey:kStore_category_icon]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[[dictRecommended objectForKey:kStore_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kHome_delivery]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[[dictHome objectForKey:kStore_category_icon]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictHome objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[[dictHome objectForKey:kStore_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
            objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kHome_delivery]];
            objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_favorite]];
            objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_home_store]];
            objStore.is_open = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kIs_open]];
            objStore.store_category_icon = [NSString stringWithFormat:@"%@",[[dictShopping objectForKey:kStore_category_icon]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_category_name]];
            objStore.store_id = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:kStore_id]];
            objStore.store_image = [NSString stringWithFormat:@"%@",[[dictShopping objectForKey:kStore_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
    isRefreshing = NO;
    [tblVwCategory reloadData];
    if (arrCategory.count>0 && isOffEffect && arrRecommendedStores.count>0) {
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
-(NSInteger )getArrayCountForRecommendedStores
{
    NSInteger rowsNum = 0;
    if (self.mainCategoryIndex !=0 && arrRecommendedStores.count>0) {
        StoreModel *objStore = [arrCategory objectAtIndex:self.mainCategoryIndex];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStore.store_main_category_id];
        NSArray *arrTemp = [arrRecommendedStores filteredArrayUsingPredicate:predicate];
        rowsNum = arrTemp.count;
    }
    else
    {
        rowsNum = arrRecommendedStoresMyStores.count;
    }
    return  rowsNum;
}
-(NSInteger )getArrayCountForOtherStores
{
    NSInteger rowsNum = 0;
    if (self.mainCategoryIndex != 0) {
        StoreModel *objStore = [arrCategory objectAtIndex:self.mainCategoryIndex];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStore.store_main_category_id];
        NSArray *arrTemp = [arrSubCategory filteredArrayUsingPredicate:predicate];
        rowsNum = arrTemp.count;
        
    }
    else
        rowsNum = arrSubCategoryMyStores.count;
    return rowsNum;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsNum = 0;
    if (tableView == tblVwCategory) {
        if (section == 1) {
            if (isRefreshing) {
                rowsNum = 0;
            }
            else
            {
                if (arrCategory.count>0) {
                    rowsNum = [self getArrayCountForRecommendedStores];
                }
                else
                    rowsNum = 0;
   
            }
        }
        else if (section == 0)
            rowsNum = 0;
    }
    else if (tableView == tblStores) {
        if (arrCategory.count>0) {
            if (isRefreshing) {
                rowsNum = 0;
            }
            else
            {
                rowsNum =  [self getArrayCountForOtherStores];
            }
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
            lbl.font = [UIFont fontWithName:kRobotoMedium size:18];
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
            objStoreModel = [self getObjectOfStoreForRecommendedStoresForIndexPath:indexPath];
            
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
        objStoreModel = [self getObjectOfStoreForOtherStoreForIndexPath:indexPath];
        
        CGSize size= [Utils getLabelSizeByText:objStoreModel.store_category_name font:[UIFont fontWithName:kRobotoRegular size:14.0] andConstraintWith:[UIScreen mainScreen].bounds.size.width-110];
        
        if (size.height < 20) {
            rowHeight = 80;
        }
        else
            rowHeight = size.height+60;
    }
    
    return rowHeight;
}

-(StoreModel *)getObjectOfStoreForRecommendedStoresForIndexPath:(NSIndexPath *)IndexPath
{
    StoreModel *objStoreModel = nil;
    if (self.mainCategoryIndex != 0 && arrRecommendedStores.count>0) {
        objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
        NSArray *arrTemp = [arrRecommendedStores filteredArrayUsingPredicate:predicate];
        objStoreModel = [arrTemp objectAtIndex:IndexPath.row];
    }
    else
        objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:IndexPath.row];
    return objStoreModel;

}

-(StoreModel*)getObjectOfStoreForOtherStoreForIndexPath:(NSIndexPath *)IndexPath
{
    StoreModel *objStoreModel = nil;

    if (self.mainCategoryIndex !=0) {
        objStoreModel = [arrCategory objectAtIndex:self.mainCategoryIndex];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.store_category_id MATCHES %@",objStoreModel.store_main_category_id];
        NSArray *arrTemp = [arrSubCategory filteredArrayUsingPredicate:predicate];
        
        objStoreModel = [arrTemp objectAtIndex:IndexPath.row];
        
    }
    else
        objStoreModel = [arrSubCategoryMyStores objectAtIndex:IndexPath.row];
    
    return objStoreModel;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
        HomeTableCell *cell = (HomeTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setRightUtilityButtons:[self leftButtons] WithButtonWidth:225];

    cell.selectedCategory = self.mainCategoryIndex;
    cell.delegate=self;
    StoreModel *objStoreModel = nil;

    if (tableView == tblVwCategory) {
        cell.backgroundColor = [UIColor whiteColor];
        objStoreModel = [self getObjectOfStoreForRecommendedStoresForIndexPath:indexPath];
        cell.isRecommendedStore = YES;

    }
    else if (tableView == tblStores) {
        cell.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
        cell.isRecommendedStore = NO;
        objStoreModel = [self getObjectOfStoreForOtherStoreForIndexPath:indexPath];

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
    homeSecondVwController.strStoreImage = objStoreModel.store_image;
    homeSecondVwController.strStore_CategoryName = objStoreModel.store_name;
    [self.navigationController pushViewController:homeSecondVwController animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
-(void)refreshSubCategoryData:(NSInteger)selectedCategory
{
    isRefreshing = YES;
    self.mainCategoryIndex = selectedCategory;
    [tblVwCategory reloadData];
    [tblStores reloadData];
    
    tblVwCategory.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 234);
    viewTable.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 234);
    btnArrow.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-40)/2, viewTable.frame.size.height-15, 40, 25);
    imgVBg.frame = CGRectMake(0,viewTable.frame.size.height-78, [UIScreen mainScreen].bounds.size.width, 85);
    btnArrow.hidden = YES;
    imgVBg.hidden = YES;
    tblStores.frame = CGRectMake(0, 234,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(234+49));
    
    
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
    NSIndexPath *indexPath = nil;
    BOOL isHomeCell = NO;
    if([cell isKindOfClass:[HomeTableCell class]])
    {
        indexPath= [(UITableView *)tblStores indexPathForCell: cell];
        isHomeCell = YES;
    }
    else
    {
        indexPath= [(UITableView *)tblVwCategory indexPathForCell: cell];
        isHomeCell = NO;
    }
    StoreModel *objStoreModel = nil;

    switch (index) {
        case 0:
        {
            if(isHomeCell)
            {
                if (self.mainCategoryIndex !=0) {
                    objStoreModel = [arrSubCategory objectAtIndex:indexPath.row];
                    
                }
                else
                {
                    objStoreModel = [arrSubCategoryMyStores objectAtIndex:indexPath.row];
                }
            }
            else
            {
                if (self.mainCategoryIndex != 0) {
                    objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
                }
                else
                {
                    objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:indexPath.row];
                }
            }
            NSString *mobileNo = objStoreModel.store_mobile; //pendingOrder.mobile_no;
            
            NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",mobileNo]];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            } else
            {
                [Utils showAlertView:kAlertTitle message:kAlertCallFacilityNotAvailable delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            }

         }
            break;
        case 1:
        {
            if(isHomeCell)
            {
                if (self.mainCategoryIndex !=0) {
                    objStoreModel = [arrSubCategory objectAtIndex:indexPath.row];
                    
                }
                else
                {
                    objStoreModel = [arrSubCategoryMyStores objectAtIndex:indexPath.row];
                }
                    AppDelegate *deleg = APP_DELEGATE;
                    SMChatViewController *chatView = nil;
                    chatView = [deleg createChatViewByChatUserNameIfNeeded:objStoreModel.chat_username];
                    chatView.chatWithUser =[NSString stringWithFormat:@"%@@%@",objStoreModel.chat_username,STRChatServerURL];
                    chatView.friendNameId = objStoreModel.store_id;
                    chatView.imageString = objStoreModel.store_image;
                    chatView.userName = objStoreModel.store_name;
                    chatView.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:chatView animated:YES];
            }
            else
            {
                if (self.mainCategoryIndex != 0) {
                    objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
                }
                else
                {
                    objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:indexPath.row];
                }
                AppDelegate *deleg = APP_DELEGATE;
                SMChatViewController *chatView = nil;
                chatView = [deleg createChatViewByChatUserNameIfNeeded:objStoreModel.chat_username];
                chatView.chatWithUser =[NSString stringWithFormat:@"%@@%@",objStoreModel.chat_username,STRChatServerURL];
                chatView.friendNameId = objStoreModel.store_id;
                chatView.imageString = objStoreModel.store_image;
                chatView.userName = objStoreModel.store_name;
                chatView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatView animated:YES];

            }
        }
            break;
        case 2:
        {
            if(isHomeCell)
            {
                if (self.mainCategoryIndex !=0) {
                    objStoreModel = [arrSubCategory objectAtIndex:indexPath.row];
                    
                }
                else
                {
                    objStoreModel = [arrSubCategoryMyStores objectAtIndex:indexPath.row];
                }
            }
            else
            {
                if (self.mainCategoryIndex != 0) {
                    objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
                }
                else
                {
                    objStoreModel = [arrRecommendedStoresMyStores objectAtIndex:indexPath.row];
                }
            }
            HomeSecondViewController *homeSecondVwController = (HomeSecondViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeSecondScreen"];
            homeSecondVwController.strStore_Id = objStoreModel.store_id;
            homeSecondVwController.strStore_CategoryName = objStoreModel.store_category_name;
            [self.navigationController pushViewController:homeSecondVwController animated:YES];
        }
            break;
            
            
            
            
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
