//
//  HomeCategoriesViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 09/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoriesViewController.h"
#import "HomeCategoryListViewController.h"

#import "StoreModel.h"


#define kTagForYSLScrollView    1000
#define kTagForFoodTableView    10

static NSString *strCollectionCell = @"collectionCellMasterCategory";

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
    
    self.navigationController.navigationBarHidden = NO;

    [self setUpNavigationBar];
    [self initilizeData];
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.sideBar = [Utils createLeftBarWithDelegate:self];

    
    
    appDeleg = APP_DELEGATE;
    [appDeleg findCurrentLocation];
    
    [self createDataToGetStores];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    NSLog(@"value = %f",appDeleg.myCurrentLocation.coordinate.latitude);
    if(![gCXMPPController isConnected])
    {
        [gCXMPPController connect];
    }
}



-(void)initilizeData
{
    kCollectionHeight = 235 - 66; // minus navigation height (66).
    kYSLScrollMenuViewHeight = 40;
    kTabbarHeight = 49;
    
    kTableProductsHeight = self.view.frame.size.height - (kCollectionHeight + kTabbarHeight + 2);

    viewOverlay.hidden = YES;
    collectionMaster.hidden = YES;
    
    arrCategories = [[NSMutableArray alloc]init];
    
    totalNoOfPages = 0;
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


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}




-(void)setupViewDesign
{
    // SetUp ViewControllers
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:[arrCategories count]];

    for (StoreModel *storeModel in arrCategories)
    {
        HomeCategoryListViewController *homeCategoryListView = [sb instantiateViewControllerWithIdentifier:@"HomeCategoryListView"];
        homeCategoryListView.title = storeModel.store_main_category_name;
        homeCategoryListView.storeModel = storeModel;
        homeCategoryListView.totalNoOfPages = totalNoOfPages;
        [viewControllers addObject:homeCategoryListView];

    }
    
    
    // ContainerView
    float statusHeight = 0;
    float navigationHeight = 0;
    
    containerVC = [[YSLContainerViewController alloc]initWithControllers:viewControllers
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


#pragma mark - Create Data To Get Stores

-(void)createDataToGetStores
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    
    int pageno = 0;
    
    [dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];

    
//        [dict setObject:@"28.5136781" forKey:kLatitude]; // temp
//        [dict setObject:@"77.3769436" forKey:kLongitude]; // temp
    
    
    [self callWebserviceToGetStores:dict];
}

-(void)callWebserviceToGetStores:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        viewOverlay.hidden = YES;
        collectionMaster.hidden = YES;
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kGetStoresURL withInput:aDict withCurrentTask:TASK_TO_GET_STORES andDelegate:self ];
}

-(void) didFailWithError:(NSError *)error
{
    viewOverlay.hidden = YES;
    collectionMaster.hidden = YES;
    [aaramShop_ConnectionManager failureBlockCalled:error];
}

-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_STORES) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            viewOverlay.hidden = NO;
            collectionMaster.hidden = NO;
            
            totalNoOfPages = [[responseObject valueForKey:@"total_page"] integerValue];
            
            [self parseStoreData:responseObject];
        }
        else
        {
            viewOverlay.hidden = YES;
            collectionMaster.hidden = YES;
            
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
        
        NSArray *arrTempRecomendedStores = [dict objectForKey:@"recommended_stores"];
        NSArray *arrTempHomeStores = [dict objectForKey:@"home_stores"];
        NSArray *arrTempShoppingStores = [dict objectForKey:@"shopping_store"];
        
        
        if (!objStoreModel.arrRecommendedStores)
        {
            objStoreModel.arrRecommendedStores = [[NSMutableArray alloc]init];
        }
        
        if (!objStoreModel.arrFavoriteStores)
        {
            objStoreModel.arrFavoriteStores = [[NSMutableArray alloc]init];
        }
        
        if (!objStoreModel.arrHomeStores)
        {
            objStoreModel.arrHomeStores = [[NSMutableArray alloc]init];
        }
        
        if (!objStoreModel.arrShoppingStores)
        {
            objStoreModel.arrShoppingStores = [[NSMutableArray alloc]init];
        }
        

        
        for (NSDictionary *dictRecommended in arrTempRecomendedStores) {
            
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
            
            [objStoreModel.arrRecommendedStores addObject:objStore];
        }
        for (NSDictionary *dictHome in arrTempHomeStores) {
            
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
            
            [objStoreModel.arrHomeStores addObject:objStore];
        }
        
        for (NSDictionary *dictShopping in arrTempShoppingStores) {
            
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
            
            [objStoreModel.arrShoppingStores addObject:objStore];
        }
        
        [arrCategories addObject:objStoreModel];
    }
    
    [collectionMaster reloadData];
    [self setupViewDesign];

}


#pragma mark - UICollectionView Delegate & DataSource Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [arrCategories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCategoriesCollectionCell *cell = (HomeCategoriesCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier: strCollectionCell forIndexPath:indexPath];

    cell.indexPath = indexPath;
    [cell updateMasterCollectionCell:[arrCategories objectAtIndex:indexPath.item]];
    cell.backgroundColor = [UIColor redColor];
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionViewSelected didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    //    NSLog(@"current Index : %ld",(long)index);
    //    NSLog(@"current controller : %@",controller);
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    [collectionMaster scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [controller viewWillAppear:YES];

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    if (previousPage != page) {
        previousPage = page;
        [self navigateToOtherScreen:nil atPage:page];
    }
}


#pragma mark - Navigate To Other Screen
-(void)navigateToOtherScreen:(UIViewController *)controller atPage:(NSInteger)pageIndex
{
    [containerVC scrollMenuViewSelectedIndex:pageIndex];
}


/*

Printing description of responseObject:
{
    categories =     (
                      {
                          "home_stores" =             (
                                                       {
                                                           "chat_username" = 14351391776712;
                                                           "home_delivery" = 1;
                                                           "is_favorite" = 0;
                                                           "is_home_store" = 1;
                                                           "is_open" = 0;
                                                           "store_category_icon" = "http://52.74.220.25/uploaded_files/aaramshop_category_icon/1-grocery icon.png";
                                                           "store_category_id" = 3;
                                                           "store_category_name" = Grocery;
                                                           "store_id" = 9206;
                                                           "store_image" = "http://52.74.220.25/uploaded_files/aaramshop/S1435139177.png";
                                                           "store_latitude" = "28.516395";
                                                           "store_longitude" = "77.372966";
                                                           "store_mobile" = 8377944952;
                                                           "store_name" = "Sabka Bazar";
                                                           "store_rating" = 5;
                                                           "total_orders" = 7;
                                                       },
                                                       {
                                                           "chat_username" = 14351708254740;
                                                           "home_delivery" = 0;
                                                           "is_favorite" = 0;
                                                           "is_home_store" = 1;
                                                           "is_open" = 0;
                                                           "store_category_icon" = "http://52.74.220.25/uploaded_files/aaramshop_category_icon/1-grocery icon.png";
                                                           "store_category_id" = 3;
                                                           "store_category_name" = Grocery;
                                                           "store_id" = 9212;
                                                           "store_image" = "http://52.74.220.25/uploaded_files/aaramshop/P1435170825.png";
                                                           "store_latitude" = "28.516046";
                                                           "store_longitude" = "77.373550";
                                                           "store_mobile" = 9582150033;
                                                           "store_name" = Prateek;
                                                           "store_rating" = 5;
                                                           "total_orders" = 3;
                                                       },
                                                       {
                                                           "chat_username" = 14369559578164;
                                                           "home_delivery" = 1;
                                                           "is_favorite" = 0;
                                                           "is_home_store" = 1;
                                                           "is_open" = 1;
                                                           "store_category_icon" = "http://52.74.220.25/uploaded_files/aaramshop_category_icon/1-grocery icon.png";
                                                           "store_category_id" = 3;
                                                           "store_category_name" = Grocery;
                                                           "store_id" = 9267;
                                                           "store_image" = "http://52.74.220.25/uploaded_files/aaramshop/M1436955957.png";
                                                           "store_latitude" = "";
                                                           "store_longitude" = "";
                                                           "store_mobile" = 8800375554;
                                                           "store_name" = "Malik Stores ";
                                                           "store_rating" = 5;
                                                           "total_orders" = 0;
                                                       }
                                                       );
                          "recommended_stores" =             (
                                                              {
                                                                  "chat_username" = 1435156460661;
                                                                  "home_delivery" = 1;
                                                                  "is_favorite" = 0;
                                                                  "is_home_store" = 0;
                                                                  "is_open" = 1;
                                                                  "store_category_icon" = "http://52.74.220.25/uploaded_files/aaramshop_category_icon/1-grocery icon.png";
                                                                  "store_category_id" = 3;
                                                                  "store_category_name" = Grocery;
                                                                  "store_id" = 3706;
                                                                  "store_image" = "http://52.74.220.25/uploaded_files/aaramshop/";
                                                                  "store_latitude" = "28.519364";
                                                                  "store_longitude" = "77.38737";
                                                                  "store_mobile" = 1204325682;
                                                                  "store_name" = "Big Shop";
                                                                  "store_rating" = 5;
                                                                  "total_orders" = 0;
                                                              },
                                                              {
                                                                  "chat_username" = 14351410003250;
                                                                  "home_delivery" = 1;
                                                                  "is_favorite" = 0;
                                                                  "is_home_store" = 0;
                                                                  "is_open" = 0;
                                                                  "store_category_icon" = "http://52.74.220.25/uploaded_files/aaramshop_category_icon/1-grocery icon.png";
                                                                  "store_category_id" = 3;
                                                                  "store_category_name" = Grocery;
                                                                  "store_id" = 9207;
                                                                  "store_image" = "http://52.74.220.25/uploaded_files/aaramshop/A1435141000.png";
                                                                  "store_latitude" = "28.516395";
                                                                  "store_longitude" = "77.372966";
                                                                  "store_mobile" = 8744944068;
                                                                  "store_name" = "Arbab Ahmed Khan";
                                                                  "store_rating" = 5;
                                                                  "total_orders" = 0;
                                                              }
                                                              );
                          "shopping_store" =             (
                                                          {
                                                              "chat_username" = 14351571438319;
                                                              "home_delivery" = 1;
                                                              "is_favorite" = 0;
                                                              "is_home_store" = 0;
                                                              "is_open" = 1;
                                                              "store_category_icon" = "http://52.74.220.25/uploaded_files/aaramshop_category_icon/1-grocery icon.png";
                                                              "store_category_id" = 3;
                                                              "store_category_name" = Grocery;
                                                              "store_id" = 69;
                                                              "store_image" = "http://52.74.220.25/uploaded_files/aaramshop/01-30-46894064714.jpg";
                                                              "store_latitude" = "28.567132";
                                                              "store_longitude" = "77.19836";
                                                              "store_mobile" = 1126166277;
                                                              "store_name" = "City Stores";
                                                              "store_rating" = 5;
                                                              "total_orders" = 2;
                                                          }
                                                          );
                          "store_main_category_banner_1" = "http://52.74.220.25/uploaded_files/aaramshop_category_banner/user/1-Grocery.png";
                          "store_main_category_banner_2" = "";
                          "store_main_category_id" = 0;
                          "store_main_category_name" = "My Stores";
                      },
                      {
                          "store_main_category_banner_1" = "http://52.74.220.25/uploaded_files/aaramshop_category_banner/user/3-Personal Care.png";
                          "store_main_category_banner_2" = "";
                          "store_main_category_id" = 1;
                          "store_main_category_name" = "Personal Care";
                      },
                      {
                          "store_main_category_banner_1" = "http://52.74.220.25/uploaded_files/aaramshop_category_banner/user/1-Grocery.png";
                          "store_main_category_banner_2" = "";
                          "store_main_category_id" = 3;
                          "store_main_category_name" = Grocery;
                      }
                      );
    deviceId = 3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0;
    isValid = 1;
    message = "Store Category Related Data!";
    "page_no" = 0;
    status = 1;
    userId = 8;
}
(lldb) 



//*/

@end
