//
//  HomeCategoryListViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 11/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoryListViewController.h"

#define kTableRecommendedHeaderTitleHeight          23
#define kTableParentHeaderDefaultHeight             115
#define kTableParentHeaderExpandedHeight            260
#define kTableParentCellHeight                      100


@interface HomeCategoryListViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    int pageno;
    int totalNoOfPages;
    
    AppDelegate *appDeleg;

}
@end

@implementation HomeCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDeleg = APP_DELEGATE;
    [appDeleg findCurrentLocation];
    
    
    totalNoOfPages = 0;
    pageno = 0;
    isLoading = NO;
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
    aaramShop_ConnectionManager.delegate = self;
    
    tblStores.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblStores.bounces = YES;
    tblStores.tag = 10;
    self.view.tag = 100;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = tblStores;
    refreshStoreList = [[UIRefreshControl alloc] init];
    [refreshStoreList addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshStoreList;

    ////
    CGRect frame = CGRectZero;
    frame.size.height = CGFLOAT_MIN;
    [tblStores setTableHeaderView:[[UIView alloc] initWithFrame:frame]];
    
    
    ////
    if (!arrAllStores)
    {
        arrAllStores = [[NSMutableArray alloc]init];
    }
    
    if (!arrRecommendedStores)
    {
        arrRecommendedStores = [[NSMutableArray alloc]init];
    }
    
    
    if (_storeModel)
    {
        [arrAllStores addObjectsFromArray:_storeModel.arrFavoriteStores];
        [arrAllStores addObjectsFromArray:_storeModel.arrHomeStores];
        [arrAllStores addObjectsFromArray:_storeModel.arrShoppingStores];
        
        [arrRecommendedStores addObjectsFromArray:_storeModel.arrRecommendedStores];
    }
    
    tblStores.delegate = self;
    tblStores.dataSource = self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([arrAllStores count]==0)
    {
//        tblView.hidden = YES;
        
        [self callWebserviceToGetStoresList];
        
    }
    else
    {
//        tblView.hidden = NO;
    }
    
    
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//*
#pragma mark - TableView Datasource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblRecommendedStore)
    {
        return [arrRecommendedStores count];
    }
    else
    {
        return [arrAllStores count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==tblRecommendedStore)
    {
        return kTableRecommendedHeaderTitleHeight; // text - recommended stores height.
    }
    else
    {
        if ([arrRecommendedStores count]>0)
        {
            if (isTableExpanded==YES)
            {
                return kTableParentHeaderExpandedHeight;
            }
            return kTableParentHeaderDefaultHeight;
        }
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *viewHeader;
    
    if (tableView==tblRecommendedStore)
    {
        viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableRecommendedHeaderTitleHeight)];
        viewHeader.backgroundColor = [UIColor redColor];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, kTableRecommendedHeaderTitleHeight)];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont fontWithName:kFontHandSean size:14];
        lbl.text = @"Recommended Stores";
        [viewHeader addSubview:lbl];
    }
    else
    {
        if ([arrRecommendedStores count]>0)
        {
            
            viewHeader = [[UIView alloc]init];
            viewHeader.backgroundColor = [UIColor whiteColor];
            
            tblRecommendedStore = [[UITableView alloc]init];
            
            tblRecommendedStore.bounces = NO;
            tblRecommendedStore.backgroundColor = [UIColor whiteColor];
            tblRecommendedStore.delegate = self;
            tblRecommendedStore.dataSource = self;
            
            
            if (!btnExpandCollapse)
            {
                btnExpandCollapse = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            
            
            ////
            [btnExpandCollapse setImage:[UIImage imageNamed:@"homeScreenArrowBox.png"] forState:UIControlStateNormal];
            [btnExpandCollapse setImage:[UIImage imageNamed:@"upArrow.png"] forState:UIControlStateSelected];
            ////
            
            [btnExpandCollapse addTarget:self action:@selector(btnExpandCollapseClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if (isTableExpanded==NO)
            {
                viewHeader.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableParentHeaderDefaultHeight);
                tblRecommendedStore.frame = CGRectMake(0, 0, viewHeader.frame.size.width, viewHeader.frame.size.height - 0);
                
                [btnExpandCollapse setImageEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
            }
            else
            {
                
                viewHeader.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableParentHeaderExpandedHeight);
                tblRecommendedStore.frame = CGRectMake(0, 0, viewHeader.frame.size.width, viewHeader.frame.size.height - 30);
                
                [btnExpandCollapse setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
            }
            
            btnExpandCollapse.frame = CGRectMake(0, (viewHeader.frame.size.height-30), viewHeader.frame.size.width, 40);
            
            
            //            btnExpandCollapse.backgroundColor = [UIColor blueColor];
            //            btnExpandCollapse.alpha = 0.4;
            
            
            [viewHeader addSubview:tblRecommendedStore];
            [viewHeader addSubview:btnExpandCollapse];
            
        }
        
    }
    
    return viewHeader;
    
}


-(void)btnExpandCollapseClicked:(UIButton *)sender
{
    if (isTableExpanded == YES)
    {
        isTableExpanded = NO;
        btnExpandCollapse.selected = NO;
    }
    else
    {
        isTableExpanded = YES;
        btnExpandCollapse.selected = YES;
    }
    
    [tblStores reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableParentCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblRecommendedStore)
    {
        
        RecommendedStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendedStoreCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"RecommendedStoreCell" bundle:nil] forCellReuseIdentifier:@"RecommendedStoreCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendedStoreCell"];
        }
        
        [cell setRightUtilityButtons:[self leftButtons] WithButtonWidth:225];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.isRecommendedStore = NO;
        
        StoreModel *objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
        
        cell.indexPath=indexPath;
        cell.delegate=self;
        
        [cell updateCellWithData:objStoreModel];
        
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"HomeCategoryListCell";
        
        HomeCategoryListCell *cell = (HomeCategoryListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[HomeCategoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [cell setRightUtilityButtons:[self leftButtons] WithButtonWidth:225];
        
        
        cell.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
        cell.isRecommendedStore = NO;
        
        StoreModel *objStoreModel = [arrAllStores objectAtIndex:indexPath.row];
        
        cell.indexPath=indexPath;
        cell.delegate=self;
        
        [cell updateCellWithData:objStoreModel];
        return cell;
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HomeSecondViewController *homeSecondVwController = (HomeSecondViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeSecondScreen"];
    
    StoreModel *objStoreModel = nil;
    
    if (tableView == tblStores)
    {
        objStoreModel = [arrAllStores objectAtIndex:indexPath.row];
    }
    else
    {
        objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
    }

    homeSecondVwController.strStore_Id = objStoreModel.store_id;
    homeSecondVwController.strStoreImage = objStoreModel.store_image;
    homeSecondVwController.strStore_CategoryName = objStoreModel.store_name;
    [self.navigationController pushViewController:homeSecondVwController animated:YES];
    
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


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
    [self.navigationController pushViewController:viewC animated:YES];
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = nil;
    BOOL isHomeCell = NO;
    if([cell isKindOfClass:[HomeCategoryListCell class]])
    {
        indexPath= [(UITableView *)tblStores indexPathForCell: cell];
        isHomeCell = YES;
    }
    else
    {
        indexPath= [(UITableView *)tblRecommendedStore indexPathForCell: cell];
        isHomeCell = NO;
    }
    StoreModel *objStoreModel = nil;
    
    switch (index) {
        case 0:
        {
            if(isHomeCell)
            {
                objStoreModel = [arrAllStores objectAtIndex:indexPath.row];
            }
            else
            {
                objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
            }
            
            NSString *mobileNo = objStoreModel.store_mobile;
            
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
                objStoreModel = [arrAllStores objectAtIndex:indexPath.row];
                
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
                objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
                
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
                objStoreModel = [arrAllStores objectAtIndex:indexPath.row];
            }
            else
            {
                objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
            }
            
            HomeSecondViewController *homeSecondVwController = (HomeSecondViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeSecondScreen"];
            homeSecondVwController.strStore_Id = objStoreModel.store_id;
            homeSecondVwController.strStore_CategoryName = objStoreModel.store_name;
            [self.navigationController pushViewController:homeSecondVwController animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}



/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Call Webservice to get  initial products list

-(void)callWebserviceToGetStoresList
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
        
    [dict setObject:_storeModel.store_main_category_id forKey:kCategory_id];
    
    
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        isLoading = NO;
        [refreshStoreList endRefreshing];
        
        [self showFooterLoadMoreActivityIndicator:NO];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kGetStoresfromCategoryIdURL withInput:dict withCurrentTask:TASK_TO_GET_STORES_FROM_CATEGORIES_ID andDelegate:self ];
}



- (void)responseReceived:(id)responseObject
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    [refreshStoreList endRefreshing];
    
    [AppManager stopStatusbarActivityIndicator];
    
    if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_STORES_FROM_CATEGORIES_ID)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            totalNoOfPages = [[responseObject objectForKey:kTotal_page] intValue];
            [self parseStoreListData:responseObject];
        }
    }
    
}


- (void)didFailWithError:(NSError *)error
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    [refreshStoreList endRefreshing];
    
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}


#pragma mark - Parse Store List response data

-(void)parseStoreListData:(NSMutableDictionary *)responseObject
{
    
    if (!_storeModel)
    {
        _storeModel = [[StoreModel alloc]init];
    }
    
    NSArray *arrTempRecomendedStores = [responseObject objectForKey:@"recommended_stores"];
    NSArray *arrTempHomeStores = [responseObject objectForKey:@"home_stores"];
    NSArray *arrTempShoppingStores = [responseObject objectForKey:@"shopping_store"];
    
    
    if (!_storeModel.arrRecommendedStores)
    {
        _storeModel.arrRecommendedStores = [[NSMutableArray alloc]init];
    }
    
    if (!_storeModel.arrFavoriteStores)
    {
        _storeModel.arrFavoriteStores = [[NSMutableArray alloc]init];
    }
    
    if (!_storeModel.arrHomeStores)
    {
        _storeModel.arrHomeStores = [[NSMutableArray alloc]init];
    }
    
    if (!_storeModel.arrShoppingStores)
    {
        _storeModel.arrShoppingStores = [[NSMutableArray alloc]init];
    }
    
    
    
    for (NSDictionary *dictRecommended in arrTempRecomendedStores) {
        
        StoreModel *objStore = [[StoreModel alloc]init];
        objStore.chat_username = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kChat_username]];
        objStore.home_delivey = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kHome_delivery]];
        objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_favorite]];
        objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_home_store]];
        objStore.is_open = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kIs_open]];
        objStore.store_category_icon = [NSString stringWithFormat:@"%@",[[dictRecommended objectForKey:kStore_category_icon]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        objStore.store_category_id = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_category_id]];
        objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_category_name]];
        objStore.store_id = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_id]];
        objStore.store_image = [NSString stringWithFormat:@"%@",[[dictRecommended objectForKey:kStore_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        objStore.store_latitude = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_latitude]];
        objStore.store_longitude = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_longitude]];
        objStore.store_mobile = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_mobile]];
        objStore.store_name = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_name]];
        objStore.store_rating = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kStore_rating]];
        objStore.total_orders = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:kTotal_orders]];
        
        [_storeModel.arrRecommendedStores addObject:objStore];
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
        
        [_storeModel.arrHomeStores addObject:objStore];
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
        
        [_storeModel.arrShoppingStores addObject:objStore];
    }
    
    
    if (pageno == 0)
    {
        [arrAllStores removeAllObjects];
        [arrRecommendedStores removeAllObjects];
    }
    
    
    if (_storeModel)
    {
        [arrAllStores addObjectsFromArray:_storeModel.arrFavoriteStores];
        [arrAllStores addObjectsFromArray:_storeModel.arrHomeStores];
        [arrAllStores addObjectsFromArray:_storeModel.arrShoppingStores];
        
        [arrRecommendedStores addObjectsFromArray:_storeModel.arrRecommendedStores];
    }
    
    
    [tblStores reloadData];
}




////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////


- (void)refreshTable
{
    pageno = 0;
    [self performSelector:@selector(callWebserviceToGetStoresList) withObject:nil afterDelay:1.0];
}

-(void)calledPullUp
{
    if(totalNoOfPages>pageno)
    {
        pageno++;
        [self callWebserviceToGetStoresList];
    }
    else
    {
        isLoading = NO;
        [self showFooterLoadMoreActivityIndicator:NO];
    }
}

#pragma mark - to refreshing a view

-(void)showFooterLoadMoreActivityIndicator:(BOOL)show{
    UIView *view=[tblStores viewWithTag:111112];
    UIActivityIndicatorView *activity=(UIActivityIndicatorView*)[view viewWithTag:111111];
    
    if (show) {
        [activity startAnimating];
    }else
        [activity stopAnimating];
}


#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrAllStores.count > 0 && scrollView.contentOffset.y>0){
        if (!isLoading) {
            isLoading=YES;
            [self showFooterLoadMoreActivityIndicator:YES];
            [self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
        }
    }
    
}


@end
