//
//  HomeCategoriesViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 09/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoriesViewController.h"
#import "HomeCategoryListViewController.h"
#import "CartViewController.h"
#import "StoreModel.h"
#import "BroadcastViewController.h"
#import "LocationEnterViewController.h"

#define kTagForYSLScrollView    1000
#define kTagForFoodTableView    10
#define kBtnDone   33454
#define kBtnCancel 33455
static NSString *strCollectionCell = @"collectionCellMasterCategory";

@interface HomeCategoriesViewController ()<YSLContainerViewControllerDelegate>
{
    CGFloat kTableProductsHeight;
    CGFloat kCollectionHeight;
    CGFloat kYSLScrollMenuViewHeight;
    CGFloat kTabbarHeight;
	NSString *strHeaderTitle;
    AppDelegate *appDeleg;
	NSMutableArray *pickerArray;

}
@end

@implementation HomeCategoriesViewController
@synthesize aaramShop_ConnectionManager;


- (void)viewDidLoad {
    [super viewDidLoad];
  
    
	
    self.navigationController.navigationBarHidden = NO;

	appDeleg = APP_DELEGATE;

	[self designPickerViewSlots];
	
	[self toolBarDesignes];
    [self initilizeData];
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.sideBar = [Utils createLeftBarWithDelegate:self];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kBroadcastNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBroadCastMessage:) name:kBroadcastNotification object:nil];
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"Home"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
	
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //	if([arrCategories count]==0)
    //	{
    //	}

    
    
	if([AppManager sharedManager].notifyDict && [[[AppManager sharedManager].notifyDict valueForKey:@"pType"]integerValue]==3)
	{
		[self btnBroadcastClicked];
		[AppManager sharedManager].notifyDict = nil;
		return;
	}
	if(!arrAddress)
	{
		arrAddress = [[NSMutableArray alloc]init];
	}
	[arrAddress removeAllObjects];
	
	arrAddress = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:kUser_address]];

	if (appDeleg.myCurrentLocation == nil) {
		if([arrAddress count]>0)
		{
			CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:[[[arrAddress objectAtIndex:0] objectForKey:@"latitude"] doubleValue] longitude:[[[arrAddress objectAtIndex:0] objectForKey:@"longitude"] doubleValue]];
			appDeleg.myCurrentLocation = newLocation;
			strHeaderTitle =[[arrAddress objectAtIndex:0] objectForKey:@"user_address_title"];
		}
		else
		{
			CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:0.00000f longitude:0.00000f];
			appDeleg.myCurrentLocation = newLocation;
			strHeaderTitle =@"";
			
		}
	}
	else
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.longitude CONTAINS[cd] %@ AND SELF.latitude CONTAINS[cd] %@",[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude],[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude]];
		NSArray *arrFilter = [arrAddress filteredArrayUsingPredicate:predicate];
		if([arrFilter count]>0)
		{
			strHeaderTitle = [[arrFilter objectAtIndex:0] objectForKey:@"user_address_title"];
		}
	}
	 [self setUpNavigationBar];
	[self	createDataToGetStores];

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
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 97, 44);
    UIView* _headerTitleSubtitleView = [[UIView alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
	btnPicker = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnPicker setFrame:CGRectMake(0, 0, 97, 44)];
	btnPicker.titleLabel.textAlignment=NSTextAlignmentCenter;
	btnPicker.titleLabel.font = [UIFont fontWithName:kRobotoRegular size:15];
	btnPicker.titleLabel.adjustsFontSizeToFitWidth = YES;
	[btnPicker setImage:[UIImage imageNamed:@"dropDownArrowLocation"] forState:UIControlStateNormal];
	[btnPicker setTitle:[NSString stringWithFormat:@" %@", strHeaderTitle] forState:UIControlStateNormal];
	
	[btnPicker addTarget:self action:@selector(btnPicker) forControlEvents:UIControlEventTouchUpInside];
	[btnPicker setShowsTouchWhenHighlighted:YES];
	[_headerTitleSubtitleView addSubview:btnPicker];
	self.navigationItem.titleView = _headerTitleSubtitleView;
	
    UIImage *imgBack = [UIImage imageNamed:@"menuIcon.png"];
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake( -10, 0, 30, 30);
    [backBtn setImage:imgBack forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnMenuClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	
	UIView *rightContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 26, 44)];
	[rightContainer setBackgroundColor:[UIColor clearColor]];
	UIImage *imgCart = [UIImage imageNamed:@"addToCartIcon.png"];
	btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
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
	
	
	btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
	btnSearch.bounds = CGRectMake( 0, 0, 26, 26);
	
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
	
	btnBroadcast = [UIButton buttonWithType:UIButtonTypeCustom];
	btnBroadcast.bounds = CGRectMake( 0, 0, 26, 26);
	
	[btnBroadcast setImage:imgBroadcast forState:UIControlStateNormal];
	[btnBroadcast addTarget:self action:@selector(btnBroadcastClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnBroadcast = [[UIBarButtonItem alloc] initWithCustomView:btnBroadcast];
	
	
	NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnCart,barBtnSearch,barBtnBroadcast, nil];
	self.navigationItem.rightBarButtonItems = arrBtnsRight;

}
- (void)userInteraction:(BOOL)enable
{
	btnBroadcast.userInteractionEnabled = enable;
	btnCart.userInteractionEnabled = enable;
	btnSearch.userInteractionEnabled = enable;
	backBtn.userInteractionEnabled = enable;
	collectionMaster.userInteractionEnabled = enable;
	viewOverlay.userInteractionEnabled = enable;
	viewSubcategories.userInteractionEnabled = enable;
}
- (void)btnPicker
{
	if(!pickerArray)
		pickerArray = [[NSMutableArray alloc] init];
	[pickerArray removeAllObjects];

	[pickerArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Add new address",@"user_address_title",@"0",kUser_address_id, nil]];
	[pickerArray addObjectsFromArray:arrAddress];
	[pickerViewSlots reloadAllComponents];
	[self userInteraction:NO];
	[self showPickerView:YES];
	[self showOptionPatch:YES];
	
}
-(void)designPickerViewSlots
{
	
	pickerViewSlots=[[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)+100,[UIScreen mainScreen].bounds.size.width ,216)];
	pickerViewSlots.delegate =self;
	pickerViewSlots.dataSource =self;
	pickerViewSlots.backgroundColor=[UIColor whiteColor];
	pickerViewSlots.showsSelectionIndicator = YES;
	[self.view addSubview:pickerViewSlots];
}
-(void)toolBarDesignes
{
	if (keyBoardToolBar==nil)
	{
		keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 630 , [[UIScreen mainScreen]bounds].size.width, 40)];
		UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarBtnClicked:)];
		btnCancel.tag = kBtnCancel;
		
		keyBoardToolBar.backgroundColor=[UIColor blackColor];
		UIBarButtonItem *tempDistance = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarBtnClicked:)];
		btnDone.tag = kBtnDone;
		keyBoardToolBar.items = [NSArray arrayWithObjects:btnCancel,tempDistance,btnDone, nil];
	}
	else
	{
		[keyBoardToolBar removeFromSuperview];
	}
	
	[self.view addSubview:keyBoardToolBar];
	[self.view bringSubviewToFront:keyBoardToolBar];
}

-(void)toolBarBtnClicked:(UIBarButtonItem *)sender
{
	if ([sender tag] == kBtnCancel) {
		[self showOptionPatch:NO];
		[self showPickerView:NO];
		[self userInteraction:YES];
		
	}
	else if ([sender tag] == kBtnDone)
	{

		[self userInteraction:YES];
		[self showOptionPatch:NO];
		[self showPickerView:NO];
		if([[dictPickerValue objectForKey:kUser_address_id] integerValue]==0)
		{
			LocationEnterViewController *locationScreen = (LocationEnterViewController*) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationEnterScreen"];
			locationScreen.delegate							= self;
			locationScreen.hidesBottomBarWhenPushed	=	YES;
			locationScreen.addAddressCompletion	= ^(void)
			{
				self.navigationController.navigationBarHidden = NO;
			};
			[self.navigationController pushViewController:locationScreen animated:YES];
		}
		else
		{
			strHeaderTitle =[dictPickerValue objectForKey:@"user_address_title"];
			[btnPicker setTitle:[NSString stringWithFormat:@" %@", strHeaderTitle] forState:UIControlStateNormal];
			CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:[[dictPickerValue objectForKey:@"latitude"] doubleValue] longitude:[[dictPickerValue objectForKey:@"longitude"] doubleValue]];
			appDeleg.myCurrentLocation = newLocation;
			[self createDataToGetStores];
		}
		
	}
}
-(void)showOptionPatch:(BOOL)isShow
{
	if(isShow)
	{
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
		 {
			 keyBoardToolBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) -(196 + 20 +49) , [[UIScreen mainScreen]bounds].size.width, 40 );
		 }completion:nil];
		
	}
	else
	{
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
		 {
			 keyBoardToolBar.frame = CGRectMake(0, [[UIScreen mainScreen]bounds].size.height + 40 +49, [[UIScreen mainScreen]bounds].size.width, 40);
		 }
						 completion:nil];
	}
}
-(void)showPickerView:(BOOL)isShow
{
	if(isShow)
	{
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			pickerViewSlots.frame = CGRectMake(0,CGRectGetHeight(self.view.bounds)-(196-20+49), [[UIScreen mainScreen]bounds].size.width, 196);
			
		}
						 completion:nil];
		
	}
	else
	{
		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
						 animations:^{
							 pickerViewSlots.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)+100-49, [[UIScreen mainScreen]bounds].size.width,196);
						 }
						 completion:nil];
		
	}
}
#pragma mark PickerView Methods & Delegates
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	
	return pickerArray.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	
	return [pickerArray [row] objectForKey:@"user_address_title"];
	
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
	dictPickerValue= [pickerArray objectAtIndex:[pickerViewSlots selectedRowInComponent:0]];
	
	
}

- (void)btnBroadcastClicked
{
	BroadcastViewController *broadcastView = (BroadcastViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"broadcastView"];
	[self.navigationController pushViewController:broadcastView animated:YES];
}

-(void)btnMenuClicked
{
    [self.sideBar show];
}
-(void)btnSearchClicked
{
	GlobalSearchResultViewC *globalSearchResultViewC = (GlobalSearchResultViewC *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GlobalSearchResultView" ];
	[self.navigationController pushViewController:globalSearchResultViewC animated:YES];

}
-(void)btnCartClicked
{
	CartViewController *cartView = (CartViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CartViewScene"];
	[self.navigationController pushViewController:cartView animated:YES];

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
    
    [arrCategories enumerateObjectsUsingBlock:^(StoreModel *storeModel, NSUInteger idx, BOOL *stop)
    {
        HomeCategoryListViewController *homeCategoryListView = [sb instantiateViewControllerWithIdentifier:@"HomeCategoryListView"];
        homeCategoryListView.title = storeModel.store_main_category_name;
        homeCategoryListView.storeModel = storeModel;
        homeCategoryListView.totalNoOfPages = totalNoOfPages;
        
//        if (idx==0)
//        {
//            homeCategoryListView.isFirstPage = YES;
//        }
//        else
//        {
//            homeCategoryListView.isFirstPage = NO;
//        }
        
        
        CGRect frame = homeCategoryListView.view.frame;
        frame.origin.y = 0.0;
        homeCategoryListView.view.frame = frame;
        
        [viewControllers addObject:homeCategoryListView];
    }];
    
    
    
    
    
    // ContainerView
    float statusHeight = 0;
    float navigationHeight = 0;
    if(containerVC)
	{
		[containerVC.view removeFromSuperview];
		containerVC = nil;
	}
    containerVC = [[YSLContainerViewController alloc]initWithControllers:viewControllers
                                                                                        topBarHeight:statusHeight + navigationHeight
                                                                                parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:kRobotoRegular size:14.0];
    
    //
    CGRect containerFrame  = containerVC.view.frame;
    containerFrame.origin.y = 0.0;
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

    
//        [dict setObject:@"28.5160458" forKey:kLatitude]; // temp
//        [dict setObject:@"77.3735504" forKey:kLongitude]; // temp
    
    
    [self callWebserviceToGetStores:dict];
}

-(void)callWebserviceToGetStores:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    
    [Utils stopActivityIndicatorInView:self.view];
    [Utils startActivityIndicatorInView:self.view withMessage:nil];

    if (![Utils isInternetAvailable])
    {
        [Utils stopActivityIndicatorInView:self.view];

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
    [Utils stopActivityIndicatorInView:self.view];

    viewOverlay.hidden = YES;
    collectionMaster.hidden = YES;
    [AppManager stopStatusbarActivityIndicator];

    [aaramShop_ConnectionManager failureBlockCalled:error];
}

-(void) responseReceived:(id)responseObject
{
    [AppManager stopStatusbarActivityIndicator];
    [Utils stopActivityIndicatorInView:self.view];


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
            
            objStore.store_distance = [AppManager getDistance:objStore];
            
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
            
            objStore.store_distance = [AppManager getDistance:objStore];
            
            
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
            
            objStore.store_distance = [AppManager getDistance:objStore];
            
            
            
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
- (void)gotBroadCastMessage:(NSNotification *)notification
{
	[self setUpNavigationBar];
}

/*


{
    categories =     (
                      {
                          "home_stores" =             (
                                                       {
                                                           "chat_username" = 14351391776712;
                                                           "home_delivery" = 1;
                                                           "is_favorite" = 1;
                                                           "is_home_store" = 1;
                                                           "is_open" = 0;
                                                           "store_category_icon" = "http://52.74.220.25/uploaded_files/aaramshop_category_icon/1-grocery icon.png";
                                                           "store_category_id" = 2;
                                                           "store_category_name" = Grocery;
                                                           "store_id" = 9206;
                                                           "store_image" = "http://52.74.220.25/uploaded_files/aaramshop/S1435139177.png";
                                                           "store_latitude" = "28.516395";
                                                           "store_longitude" = "77.372966";
                                                           "store_mobile" = 8377944952;
                                                           "store_name" = "Sabka Bazar";
                                                           "store_rating" = 5;
                                                           "total_orders" = 24;
                                                       },
                                                       {
                                                           "chat_username" = 14351708254740;
                                                           "home_delivery" = 1;
                                                           "is_favorite" = 1;
                                                           "is_home_store" = 1;
                                                           "is_open" = 0;
                                                           "store_category_icon" = "http://52.74.220.25/uploaded_files/aaramshop_category_icon/1-grocery icon.png";
                                                           "store_category_id" = 2;
                                                           "store_category_name" = Grocery;
                                                           "store_id" = 9212;
                                                           "store_image" = "http://52.74.220.25/uploaded_files/aaramshop/P1435170825.png";
                                                           "store_latitude" = "";
                                                           "store_longitude" = "";
                                                           "store_mobile" = 9582150033;
                                                           "store_name" = Prateek;
                                                           "store_rating" = 5;
                                                           "total_orders" = 5;
                                                       },
                                                       {
                                                           "chat_username" = 14369559578164;
                                                           "home_delivery" = 1;
                                                           "is_favorite" = 1;
                                                           "is_home_store" = 1;
                                                           "is_open" = 1;
                                                           "store_category_icon" = "http://52.74.220.25/uploaded_files/aaramshop_category_icon/1-grocery icon.png";
                                                           "store_category_id" = 2;
                                                           "store_category_name" = Grocery;
                                                           "store_id" = 9267;
                                                           "store_image" = "http://52.74.220.25/uploaded_files/aaramshop/M1436955957.png";
                                                           "store_latitude" = "";
                                                           "store_longitude" = "";
                                                           "store_mobile" = 8800375554;
                                                           "store_name" = "Malik Stores ";
                                                           "store_rating" = 5;
                                                           "total_orders" = 0;
                                                       },
                                                       {
                                                           "chat_username" = 14377229557840;
                                                           "home_delivery" = 1;
                                                           "is_favorite" = 0;
                                                           "is_home_store" = 1;
                                                           "is_open" = 0;
                                                           "store_category_icon" = "http://52.74.220.25/uploaded_files/aaramshop_category_icon/1-grocery icon.png";
                                                           "store_category_id" = 2;
                                                           "store_category_name" = Grocery;
                                                           "store_id" = 9271;
                                                           "store_image" = "http://52.74.220.25/uploaded_files/aaramshop/A1437722955.png";
                                                           "store_latitude" = "28.515737";
                                                           "store_longitude" = "77.373311";
                                                           "store_mobile" = 7811806364;
                                                           "store_name" = aaram132;
                                                           "store_rating" = 5;
                                                           "total_orders" = 1;
                                                       }
                                                       );
                          "recommended_stores" =             (
                          );
                          "shopping_store" =             (
                                                          {
                                                              "chat_username" = 14351571438319;
                                                              "home_delivery" = 1;
                                                              "is_favorite" = 0;
                                                              "is_home_store" = 0;
                                                              "is_open" = 1;
                                                              "store_category_icon" = "http://52.74.220.25/uploaded_files/aaramshop_category_icon/1-grocery icon.png";
                                                              "store_category_id" = 2;
                                                              "store_category_name" = Grocery;
                                                              "store_id" = 69;
                                                              "store_image" = "http://52.74.220.25/uploaded_files/aaramshop/01-30-46894064714.jpg";
                                                              "store_latitude" = "28.567132";
                                                              "store_longitude" = "77.19836";
                                                              "store_mobile" = 1126166277;
                                                              "store_name" = "City Stores";
                                                              "store_rating" = 5;
                                                              "total_orders" = 32;
                                                          }
                                                          );
                          "store_main_category_banner_1" = "http://52.74.220.25/uploaded_files/aaramshop_category_banner/user/1-Grocery.png";
                          "store_main_category_banner_2" = "";
                          "store_main_category_id" = 0;
                          "store_main_category_name" = "My Stores";
                      },
                      {
                          "store_main_category_banner_1" = "http://52.74.220.25/uploaded_files/aaramshop_category_banner/user/1-Grocery.png";
                          "store_main_category_banner_2" = "";
                          "store_main_category_id" = 2;
                          "store_main_category_name" = Grocery;
                      },
                      {
                          "store_main_category_banner_1" = "http://52.74.220.25/uploaded_files/aaramshop_category_banner/user/3-Personal Care.png";
                          "store_main_category_banner_2" = "";
                          "store_main_category_id" = 7;
                          "store_main_category_name" = "Personal Care";
                      },
                      {
                          "store_main_category_banner_1" = "http://52.74.220.25/uploaded_files/aaramshop_category_banner/user/2-Medical.png";
                          "store_main_category_banner_2" = "";
                          "store_main_category_id" = 10;
                          "store_main_category_name" = Medicine;
                      }
                      );
    deviceId = 3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0;
    isValid = 1;
    message = "Store Category Related Data!";
    "page_no" = 0;
    status = 1;
    "total_page" = 1;
    userId = 8;
}



//*/

@end
