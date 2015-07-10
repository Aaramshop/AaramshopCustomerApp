//
//  HomeCategoriesViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 09/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoriesViewController.h"
#import "ArtistsViewController.h" // temp

#import "HomeCategoriesModel.h"
#import "HomeStoreModel.h"
#import "RecommendedStoreModel.h"
#import "ShoppingStoreModel.h"


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
    
    [self setUpNavigationBar];
    [self initilizeData];
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;
    
    appDeleg = APP_DELEGATE;
    [appDeleg findCurrentLocation];
    
    [self createDataToGetStores];
}

-(void)initilizeData
{
    kCollectionHeight = 235 - 66; // minus navigation height (66).
    kYSLScrollMenuViewHeight = 40;
    kTabbarHeight = 49;
    
    kTableProductsHeight = self.view.frame.size.height - (kCollectionHeight + kTabbarHeight + 2);

    viewOverlay.hidden = YES;
    indexMasterCategory = 0;
    
    arrCategories = [[NSMutableArray alloc]init];
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

-(void)setupViewDesign
{
    // SetUp ViewControllers
    
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:[arrCategories count]];

    for (HomeCategoriesModel *homeCategoriesModel in arrCategories)
    {
        //        CategoryViewController *categoryView = [sb instantiateViewControllerWithIdentifier:@"categoryScreen"];
        
        ArtistsViewController *artistVC = [[ArtistsViewController alloc]initWithNibName:@"ArtistsViewController" bundle:nil];
        artistVC.title = homeCategoriesModel.store_main_category_name;
        
        [viewControllers addObject:artistVC];

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
        viewOverlay.hidden = YES;
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kGetStoresURL withInput:aDict withCurrentTask:TASK_TO_GET_STORES andDelegate:self ];
}

-(void) didFailWithError:(NSError *)error
{
    viewOverlay.hidden = YES;
    [aaramShop_ConnectionManager failureBlockCalled:error];
}

-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_STORES) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            viewOverlay.hidden = NO;
            [self parseStoreData:responseObject];
        }
        else
        {
            viewOverlay.hidden = YES;
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
    
}


-(void)parseStoreData:(NSMutableDictionary *)responseObject
{
    NSArray *arrTempCategories = [responseObject objectForKey:@"categories"];

    for (NSDictionary *dict in arrTempCategories)
    {
        HomeCategoriesModel *homeCategoriesModel = [[HomeCategoriesModel alloc]init];
        
        homeCategoriesModel.store_main_category_banner_1 = [[dict objectForKey:kStore_main_category_banner_1]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        homeCategoriesModel.store_main_category_banner_2 = [[dict objectForKey:kStore_main_category_banner_2]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        homeCategoriesModel.store_main_category_id = [dict objectForKey:kStore_main_category_id];
        homeCategoriesModel.store_main_category_name = [dict objectForKey:kStore_main_category_name];
        
        
        NSArray *arrTempHomeStores = [dict objectForKey:@"home_stores"];
        for (NSDictionary *dict in arrTempHomeStores)
        {
            HomeStoreModel *homeStoreModel = [[HomeStoreModel alloc]init];
            homeStoreModel.chat_username = [dict objectForKey:@"chat_username"];
            homeStoreModel.home_delivery = [dict objectForKey:@"home_delivery"];
            homeStoreModel.is_favorite = [dict objectForKey:@"is_favorite"];
            homeStoreModel.is_home_store = [dict objectForKey:@"is_home_store"];
            homeStoreModel.is_open = [dict objectForKey:@"is_open"];
            homeStoreModel.store_category_icon = [dict objectForKey:@"store_category_icon"];
            homeStoreModel.store_category_id = [dict objectForKey:@"store_category_id"];
            homeStoreModel.store_category_name = [dict objectForKey:@"store_category_name"];
            homeStoreModel.store_id = [dict objectForKey:@"store_id"];
            homeStoreModel.store_image = [dict objectForKey:@"store_image"];
            homeStoreModel.store_latitude = [dict objectForKey:@"store_latitude"];
            homeStoreModel.store_longitude = [dict objectForKey:@"store_longitude"];
            homeStoreModel.store_mobile = [dict objectForKey:@"store_mobile"];
            homeStoreModel.store_name = [dict objectForKey:@"store_name"];
            homeStoreModel.store_rating = [dict objectForKey:@"store_rating"];
            homeStoreModel.total_orders = [dict objectForKey:@"total_orders"];
            
            [homeCategoriesModel.arrHome_stores addObject:homeStoreModel];
        }
        
        NSArray *arrTempRecomendedStores = [dict objectForKey:@"recommended_stores"];
        for (NSDictionary *dict in arrTempRecomendedStores)
        {
            RecommendedStoreModel *recommendedStoreModel = [[RecommendedStoreModel alloc]init];
            recommendedStoreModel.chat_username = [dict objectForKey:@"chat_username"];
            recommendedStoreModel.home_delivery = [dict objectForKey:@"home_delivery"];
            recommendedStoreModel.is_favorite = [dict objectForKey:@"is_favorite"];
            recommendedStoreModel.is_home_store = [dict objectForKey:@"is_home_store"];
            recommendedStoreModel.is_open = [dict objectForKey:@"is_open"];
            recommendedStoreModel.store_category_icon = [dict objectForKey:@"store_category_icon"];
            recommendedStoreModel.store_category_id = [dict objectForKey:@"store_category_id"];
            recommendedStoreModel.store_category_name = [dict objectForKey:@"store_category_name"];
            recommendedStoreModel.store_id = [dict objectForKey:@"store_id"];
            recommendedStoreModel.store_image = [dict objectForKey:@"store_image"];
            recommendedStoreModel.store_latitude = [dict objectForKey:@"store_latitude"];
            recommendedStoreModel.store_longitude = [dict objectForKey:@"store_longitude"];
            recommendedStoreModel.store_mobile = [dict objectForKey:@"store_mobile"];
            recommendedStoreModel.store_name = [dict objectForKey:@"store_name"];
            recommendedStoreModel.store_rating = [dict objectForKey:@"store_rating"];
            recommendedStoreModel.total_orders = [dict objectForKey:@"total_orders"];
            
            [homeCategoriesModel.arrRecommended_stores addObject:recommendedStoreModel];
        }
        
        NSArray *arrTempshoppingStores = [dict objectForKey:@"shopping_store"];
        for (NSDictionary *dict in arrTempshoppingStores)
        {
            ShoppingStoreModel *shoppingStoreModel = [[ShoppingStoreModel alloc]init];
            shoppingStoreModel.chat_username = [dict objectForKey:@"chat_username"];
            shoppingStoreModel.home_delivery = [dict objectForKey:@"home_delivery"];
            shoppingStoreModel.is_favorite = [dict objectForKey:@"is_favorite"];
            shoppingStoreModel.is_home_store = [dict objectForKey:@"is_home_store"];
            shoppingStoreModel.is_open = [dict objectForKey:@"is_open"];
            shoppingStoreModel.store_category_icon = [dict objectForKey:@"store_category_icon"];
            shoppingStoreModel.store_category_id = [dict objectForKey:@"store_category_id"];
            shoppingStoreModel.store_category_name = [dict objectForKey:@"store_category_name"];
            shoppingStoreModel.store_id = [dict objectForKey:@"store_id"];
            shoppingStoreModel.store_image = [dict objectForKey:@"store_image"];
            shoppingStoreModel.store_latitude = [dict objectForKey:@"store_latitude"];
            shoppingStoreModel.store_longitude = [dict objectForKey:@"store_longitude"];
            shoppingStoreModel.store_mobile = [dict objectForKey:@"store_mobile"];
            shoppingStoreModel.store_name = [dict objectForKey:@"store_name"];
            shoppingStoreModel.store_rating = [dict objectForKey:@"store_rating"];
            shoppingStoreModel.total_orders = [dict objectForKey:@"total_orders"];
            
            [homeCategoriesModel.arrShopping_store addObject:shoppingStoreModel];
        }
        
        [arrCategories addObject:homeCategoriesModel];
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

//    cell.delegateMasterCategory = self;
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
    
    
    indexMasterCategory = index;
    
    [controller viewWillAppear:YES];
}


#pragma mark - Navigate To Other Screen
-(void)navigateToOtherScreen:(UIViewController *)controller
{
    [containerVC scrollMenuViewSelectedIndex:3];
}

@end
