//
//  ShoppingListChooseStoreViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListChooseStoreViewController.h"
#import "ShoppingListChooseStoreGeneralCell.h"
#import "ShoppingListChooseStoreRecommendedCell.h"
#import "StoreModel.h"


#define kTableRecommendedHeaderTitleHeight          23
#define kTableParentHeaderDefaultHeight             115
#define kTableParentHeaderExpandedHeight            260
#define kTableParentCellHeight                      100


@interface ShoppingListChooseStoreViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    AppDelegate *appDeleg;
    int pageno;
    int totalNoOfPages;
}

@end

@implementation ShoppingListChooseStoreViewController
@synthesize aaramShop_ConnectionManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDeleg = APP_DELEGATE;
    [appDeleg findCurrentLocation];
    
    [self setNavigationBar];
    
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
    
    
    
    
    tblRecommendedStore = [[UITableView alloc]init];
    
    tblRecommendedStore.bounces = NO;
    tblRecommendedStore.backgroundColor = [UIColor whiteColor];
    tblRecommendedStore.delegate = self;
    tblRecommendedStore.dataSource = self;
    
    
    arrAllStores = [[NSMutableArray alloc]init];
    arrRecommendedStores = [[NSMutableArray alloc]init];
    
    [self callWebserviceToGetStoresList];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}


#pragma mark Navigation
-(void)setNavigationBar
{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
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
    titleView.text = @"CHOOSE A STORE";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.bounds = CGRectMake( 0, 0, 30, 30 );
    [btnBack setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *batBtnBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:batBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
    
    UIImage *imgDone = [UIImage imageNamed:@"doneBtn"];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.bounds = CGRectMake( -10, 0, 50, 30);
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:13.0]];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:imgDone forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(btnDoneClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnDone = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnDone, nil];
    self.navigationItem.rightBarButtonItems = arrBtnsRight;
    
}


- (void)btnBackClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)btnDoneClicked
{
    if (!selectedStoreModel)
    {
        [Utils showAlertView:kAlertTitle message:@"Please choose a store" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Are you sure ?" delegate:self cancelButtonTitle:kAlertBtnNO otherButtonTitles:kAlertBtnYES];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (self.refreshShoppingList)
        {
            self.refreshShoppingList(selectedStoreModel);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
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




#pragma mark - UITableView Delegates & Data Source Methods

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
            
//            tblRecommendedStore = [[UITableView alloc]init];
//            
//            tblRecommendedStore.bounces = NO;
//            tblRecommendedStore.backgroundColor = [UIColor whiteColor];
//            tblRecommendedStore.delegate = self;
//            tblRecommendedStore.dataSource = self;
            
            
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
        
        ShoppingListChooseStoreRecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingListChooseStoreRecommendedCell"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"ShoppingListChooseStoreRecommendedCell" bundle:nil] forCellReuseIdentifier:@"ShoppingListChooseStoreRecommendedCell"];
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingListChooseStoreRecommendedCell"];
        }
        
        cell.backgroundColor = [UIColor whiteColor];
        
        ShoppingListChooseStoreModel *objStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
        
        cell.indexPath=indexPath;
        
        [cell updateCellWithData:objStoreModel];
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"ShoppingListChooseStoreGeneralCell";
        
        ShoppingListChooseStoreGeneralCell *cell = (ShoppingListChooseStoreGeneralCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[ShoppingListChooseStoreGeneralCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        
        cell.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
        
        ShoppingListChooseStoreModel *objStoreModel = [arrAllStores objectAtIndex:indexPath.row];
        
        cell.indexPath=indexPath;
        
        [cell updateCellWithData:objStoreModel];
        return cell;

    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!selectedStoreModel)
    {
        selectedStoreModel = [[ShoppingListChooseStoreModel alloc]init];
    }
    
    
    if (tableView == tblStores)
    {
        selectedStoreModel = [arrAllStores objectAtIndex:indexPath.row];
    }
    else
    {
        selectedStoreModel = [arrRecommendedStores objectAtIndex:indexPath.row];
    }

}



/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////



#pragma mark - Call Webservice

-(void)callWebserviceToGetStoresList
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    
    [dict setObject:_strShoppingListId forKey:@"shoppingListId"];
    [dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
    
    
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        isLoading = NO;
        [refreshStoreList endRefreshing];
        
        [self showFooterLoadMoreActivityIndicator:NO];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kURLGetStoreforShoppingList withInput:dict withCurrentTask:TASK_TO_GET_SHOPPING_STORE_LIST andDelegate:self ];
}


-(void) didFailWithError:(NSError *)error
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    [refreshStoreList endRefreshing];
    
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}


- (void)responseReceived:(id)responseObject
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    [refreshStoreList endRefreshing];
    
    [AppManager stopStatusbarActivityIndicator];
    
    if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_SHOPPING_STORE_LIST)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            totalNoOfPages = [[responseObject objectForKey:kTotal_page] intValue];
            [self parseResponseData:responseObject];
        }
    }
    
}


#pragma mark - Parse Response Data

-(void)parseResponseData:(NSDictionary *)responseObject
{
    
//    if (!shoppingListChooseStoreModel)
//    {
        ShoppingListChooseStoreModel *shoppingListChooseStoreModel = [[ShoppingListChooseStoreModel alloc]init];
//    }
    
    
    if (pageno == 0)
    {
        [arrAllStores removeAllObjects];
        [arrRecommendedStores removeAllObjects];
    }
    
    //*
    
    NSArray *arrTempRecomendedStores = [responseObject objectForKey:@"recommended_stores"];
    NSArray *arrTempHomeStores = [responseObject objectForKey:@"home_stores"];
    NSArray *arrTempShoppingStores = [responseObject objectForKey:@"shopping_store"];
    
    
    if (!shoppingListChooseStoreModel.arrRecommendedStores)
    {
        shoppingListChooseStoreModel.arrRecommendedStores = [[NSMutableArray alloc]init];
    }
    
    if (!shoppingListChooseStoreModel.arrFavoriteStores)
    {
        shoppingListChooseStoreModel.arrFavoriteStores = [[NSMutableArray alloc]init];
    }
    
    if (!shoppingListChooseStoreModel.arrHomeStores)
    {
        shoppingListChooseStoreModel.arrHomeStores = [[NSMutableArray alloc]init];
    }
    
    if (!shoppingListChooseStoreModel.arrShoppingStores)
    {
        shoppingListChooseStoreModel.arrShoppingStores = [[NSMutableArray alloc]init];
    }
    
    
    
    for (NSDictionary *dictRecommended in arrTempRecomendedStores) {
        
        ShoppingListChooseStoreModel *objStore = [[ShoppingListChooseStoreModel alloc]init];
        
        objStore.available_products = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"available_products"]];
        objStore.chat_username = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"chat_username"]];
        objStore.home_delivery = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"home_delivery"]];
        objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"is_favorite"]];
        objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"is_home_store"]];
        objStore.is_open = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"is_open"]];
        objStore.remaining_products = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"remaining_products"]];
        
        objStore.store_category_icon = [NSString stringWithFormat:@"%@",[[dictRecommended objectForKey:@"store_category_icon"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        objStore.store_category_id = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"store_category_id"]];
        objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"store_category_name"]];
        objStore.store_id = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"store_id"]];
        objStore.store_image = [NSString stringWithFormat:@"%@",[[dictRecommended objectForKey:@"store_image"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        objStore.store_latitude = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"store_latitude"]];
        objStore.store_longitude = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"store_longitude"]];
        
        StoreModel *store = [[StoreModel alloc]init];
        store.store_latitude = objStore.store_latitude;
        store.store_longitude = objStore.store_longitude;
        
        objStore.store_distance = [AppManager getDistance:store];

        
        
        
        objStore.store_mobile = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"store_mobile"]];
        objStore.store_name = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"store_name"]];
        objStore.store_rating = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"store_rating"]];
        objStore.total_orders = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"total_orders"]];
        objStore.total_product_price = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"total_product_price"]];
        objStore.total_products = [NSString stringWithFormat:@"%@",[dictRecommended objectForKey:@"total_products"]];
        
        [shoppingListChooseStoreModel.arrRecommendedStores addObject:objStore];
    }
    for (NSDictionary *dictHome in arrTempHomeStores) {
        
        ShoppingListChooseStoreModel *objStore = [[ShoppingListChooseStoreModel alloc]init];
        
        objStore.available_products = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"available_products"]];
        objStore.chat_username = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"chat_username"]];
        objStore.home_delivery = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"home_delivery"]];
        objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"is_favorite"]];
        objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"is_home_store"]];
        objStore.is_open = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"is_open"]];
        objStore.remaining_products = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"remaining_products"]];
        
        objStore.store_category_icon = [NSString stringWithFormat:@"%@",[[dictHome objectForKey:@"store_category_icon"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        
        objStore.store_category_id = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"store_category_id"]];
        objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"store_category_name"]];
        objStore.store_id = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"store_id"]];
        
        objStore.store_image = [NSString stringWithFormat:@"%@",[[dictHome objectForKey:@"store_image"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        
        objStore.store_latitude = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"store_latitude"]];
        objStore.store_longitude = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"store_longitude"]];
        
        StoreModel *store = [[StoreModel alloc]init];
        store.store_latitude = objStore.store_latitude;
        store.store_longitude = objStore.store_longitude;
        
        
        objStore.store_distance = [AppManager getDistance:store];
        
        
        objStore.store_mobile = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"store_mobile"]];
        objStore.store_name = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"store_name"]];
        objStore.store_rating = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"store_rating"]];
        objStore.total_orders = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"total_orders"]];
        objStore.total_product_price = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"total_product_price"]];
        objStore.total_products = [NSString stringWithFormat:@"%@",[dictHome objectForKey:@"total_products"]];

        
        [shoppingListChooseStoreModel.arrHomeStores addObject:objStore];
    }
    
    for (NSDictionary *dictShopping in arrTempShoppingStores) {
        
        ShoppingListChooseStoreModel *objStore = [[ShoppingListChooseStoreModel alloc]init];
        
        objStore.available_products = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"available_products"]];
        objStore.chat_username = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"chat_username"]];
        objStore.home_delivery = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"home_delivery"]];
        objStore.is_favorite = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"is_favorite"]];
        objStore.is_home_store = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"is_home_store"]];
        objStore.is_open = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"is_open"]];
        objStore.remaining_products = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"remaining_products"]];
        
        objStore.store_category_icon = [NSString stringWithFormat:@"%@",[[dictShopping objectForKey:@"store_category_icon"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        
        objStore.store_category_id = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"store_category_id"]];
        objStore.store_category_name = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"store_category_name"]];
        objStore.store_id = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"store_id"]];
        
        objStore.store_image = [NSString stringWithFormat:@"%@",[[dictShopping objectForKey:@"store_image"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        
        
        objStore.store_latitude = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"store_latitude"]];
        objStore.store_longitude = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"store_longitude"]];
        
        StoreModel *store = [[StoreModel alloc]init];
        store.store_latitude = objStore.store_latitude;
        store.store_longitude = objStore.store_longitude;
        
        objStore.store_distance = [AppManager getDistance:store];

        
        objStore.store_mobile = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"store_mobile"]];
        objStore.store_name = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"store_name"]];
        objStore.store_rating = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"store_rating"]];
        objStore.total_orders = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"total_orders"]];
        objStore.total_product_price = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"total_product_price"]];
        objStore.total_products = [NSString stringWithFormat:@"%@",[dictShopping objectForKey:@"total_products"]];

        
        [shoppingListChooseStoreModel.arrShoppingStores addObject:objStore];
    }
    
 
//    if (shoppingListChooseStoreModel)
//    {
        [arrAllStores addObjectsFromArray:shoppingListChooseStoreModel.arrFavoriteStores];
        [arrAllStores addObjectsFromArray:shoppingListChooseStoreModel.arrHomeStores];
        [arrAllStores addObjectsFromArray:shoppingListChooseStoreModel.arrShoppingStores];
        
        [arrRecommendedStores addObjectsFromArray:shoppingListChooseStoreModel.arrRecommendedStores];
//    }
    
    
    [tblStores reloadData];
    
    //*/
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
    if(totalNoOfPages>pageno+1)
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


/*
Printing description of dict:
{
    deviceId = 3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0;
    deviceType = 1;
    latitude = "28.516046";
    longitude = "77.373550";
    "page_no" = 0;
    shoppingListId = 8;
    userId = 8;
}
2015-07-23 17:07:23.323 AaramShop[12654:150552] Reachability: dealloc
2015-07-23 17:07:23.643 AaramShop[12654:150552] -[UIApplication endIgnoringInteractionEvents] called without matching -beginIgnoringInteractionEvents. Ignoring.
Printing description of responseObject:
{
    deviceId = 3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0;
    "home_stores" =     (
                         {
                             "available_products" = 2;
                             "chat_username" = 14351391776712;
                             "home_delivery" = 1;
                             "is_favorite" = 0;
                             "is_home_store" = 1;
                             "is_open" = 0;
                             "remaining_products" = 11;
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
                             "total_orders" = 10;
                             "total_product_price" = 80;
                             "total_products" = 13;
                         },
                         {
                             "available_products" = 0;
                             "chat_username" = 14351708254740;
                             "home_delivery" = 0;
                             "is_favorite" = 0;
                             "is_home_store" = 1;
                             "is_open" = 0;
                             "remaining_products" = 13;
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
                             "total_product_price" = 0;
                             "total_products" = 13;
                         },
                         {
                             "available_products" = 0;
                             "chat_username" = 14369559578164;
                             "home_delivery" = 1;
                             "is_favorite" = 0;
                             "is_home_store" = 1;
                             "is_open" = 1;
                             "remaining_products" = 13;
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
                             "total_product_price" = 0;
                             "total_products" = 13;
                         }
                         );
    isValid = 1;
    message = "Store Data!";
    "page_no" = 0;
    "recommended_stores" =     (
                                {
                                    "available_products" = 0;
                                    "chat_username" = 1435156460661;
                                    "home_delivery" = 1;
                                    "is_favorite" = 0;
                                    "is_home_store" = 0;
                                    "is_open" = 1;
                                    "remaining_products" = 13;
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
                                    "total_orders" = 2;
                                    "total_product_price" = 0;
                                    "total_products" = 13;
                                },
                                {
                                    "available_products" = 0;
                                    "chat_username" = 14351410003250;
                                    "home_delivery" = 1;
                                    "is_favorite" = 0;
                                    "is_home_store" = 0;
                                    "is_open" = 0;
                                    "remaining_products" = 13;
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
                                    "total_product_price" = 0;
                                    "total_products" = 13;
                                }
                                );
    "shopping_store" =     (
                            {
                                "available_products" = 0;
                                "chat_username" = 14351571438319;
                                "home_delivery" = 1;
                                "is_favorite" = 0;
                                "is_home_store" = 0;
                                "is_open" = 1;
                                "remaining_products" = 13;
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
                                "total_product_price" = 0;
                                "total_products" = 13;
                            }
                            );
    status = 1;
    "total_page" = 1;
    userId = 8;
}
(lldb)

//*/

@end
