//
//  HomeCategoriesViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 09/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoriesViewController.h"
#import "YSLContainerViewController.h"
#import "ArtistsViewController.h"

#define kTagForYSLScrollView    1000
#define kTagForFoodTableView    10

@interface HomeCategoriesViewController ()<YSLContainerViewControllerDelegate>
{
    CGFloat kTableProductsHeight;
    CGFloat kCollectionHeight;
    CGFloat kYSLScrollMenuViewHeight;
    CGFloat kTabbarHeight;
    
    AppDelegate *appDeleg;

}
@end

@implementation HomeCategoriesViewController
@synthesize aaramShop_ConnectionManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNavigationBar];
    
    kCollectionHeight = 235 - 66; // minus navigation height (66).
    kYSLScrollMenuViewHeight = 40;
    kTabbarHeight = 49;
    
    kTableProductsHeight = self.view.frame.size.height - (kCollectionHeight + kTabbarHeight + 2);
    
//    collectionMaster.backgroundColor = [UIColor blueColor];
    
    [self setupDesign];
    
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;
    
    appDeleg = APP_DELEGATE;
    [appDeleg findCurrentLocation];
    
    [self createDataToGetStores];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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

-(void)setupDesign
{
    // SetUp ViewControllers
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:6];

    for (int i = 0; i<6; i++)
    {
//        CategoryViewController *categoryView = [sb instantiateViewControllerWithIdentifier:@"categoryScreen"];
        
        ArtistsViewController *artistVC = [[ArtistsViewController alloc]initWithNibName:@"ArtistsViewController" bundle:nil];
        artistVC.title = [NSString stringWithFormat:@"Title %d",i];
        
        [viewControllers addObject:artistVC];
    }
    
    
    // ContainerView
    float statusHeight = 0;
    float navigationHeight = 0;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:viewControllers
                                                                                        topBarHeight:statusHeight + navigationHeight
                                                                                parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:kRobotoRegular size:14.0];
    
    
    //
    CGRect containerFrame  = containerVC.view.frame;
    containerFrame.size.height = kTableProductsHeight;
    containerVC.view.frame = containerFrame;
    
    NSArray *arrViews = [[containerVC.view viewWithTag:kTagForYSLScrollView] subviews];
    
    for (UIView *viewProducts in arrViews)
    {
        CGRect frameProducts = viewProducts.frame;
        frameProducts.size.height = kTableProductsHeight-kYSLScrollMenuViewHeight;
        viewProducts.frame = frameProducts;
        
        UITableView *tblProducts = (UITableView *)[viewProducts viewWithTag:kTagForFoodTableView];
        tblProducts.frame = frameProducts;
    }
    
    //
    
    viewSubcategories.backgroundColor = [UIColor clearColor];
    
    [viewSubcategories addSubview:containerVC.view];
}


-(void)btnMenuClicked
{
//    [self.sideBar show];
}
-(void)btnSearchClicked
{
    
}
-(void)btnCartClicked
{
    
}



#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    //    NSLog(@"current Index : %ld",(long)index);
    //    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}


#pragma mark - createDataToGetStores

-(void)createDataToGetStores
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    
    
    //    [dict setObject:@"28.5136781" forKey:kLatitude]; // temp
    //    [dict setObject:@"77.3769436" forKey:kLongitude]; // temp
    
    
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
//    else if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_STORES_FROM_CATEGORIES_ID) {
//        
//        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
//            [self  parseStoreNextData:responseObject];
//        }
//        else
//        {
//            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//        }
//    }
//    else if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_STORES_PAGINATION) {
//        
//        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
//            
//            [self parseStoreData:responseObject];
//        }
//        else
//        {
//            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//        }
//    }
    
    
}


-(void)parseStoreData:(NSMutableDictionary *)responseObject
{
    /*
    
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
    //*/
}


@end
