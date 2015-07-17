//
//  ShoplistViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "CreateNewShoppingListViewController.h"
#import "ShoppingListDetailViewController.h"
#import "ShoppingListModel.h"

#define kTableCellHeight	95

@interface ShoppingListViewController ()
{
	AppDelegate *appDeleg;
    int pageno;
    int totalNoOfPages;
}

@end

@implementation ShoppingListViewController
@synthesize aaramShop_ConnectionManager;


- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sideBar = [Utils createLeftBarWithDelegate:self];
	appDeleg = APP_DELEGATE;
    [self setNavigationBar];
    
    tblView.backgroundColor = [UIColor whiteColor];
    
    
    totalNoOfPages = 0;
    pageno = 0;
    isLoading = NO;

    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;

    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = tblView;
    refreshShoppingList = [[UIRefreshControl alloc] init];
    [refreshShoppingList addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshShoppingList;
    
//    [self getInitialShoppingList];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = NO;

    deletedShoppingListIndex = -1;
    
    [self getInitialShoppingList];

}


-(void)getInitialShoppingList
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:@"0" forKey:@"page_no"];
    
    [self callWebServiceToGetShoppingList:dict];
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
    titleView.text = @"Shopping List";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    if(appDeleg.objStoreModel == nil)
	{
		UIButton *sideMenu = [UIButton buttonWithType:UIButtonTypeCustom];
		sideMenu.bounds = CGRectMake( 0, 0, 30, 30 );
		[sideMenu setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
		[sideMenu addTarget:self action:@selector(SideMenuClicked) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *btnHome = [[UIBarButtonItem alloc] initWithCustomView:sideMenu];
		
		
		NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:btnHome, nil];
		self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	}
	else
	{
		UIImage *imgBack = [UIImage imageNamed:@"backBtn.png"];
		
		UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		backBtn.bounds = CGRectMake( -10, 0, 30, 30);
		
		[backBtn setImage:imgBack forState:UIControlStateNormal];
		[backBtn addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
		
		NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
		self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	}
	//
	UIImage *imgSearch = [UIImage imageNamed:@"searchIcon.png"];
	UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
	btnSearch.bounds = CGRectMake( -10, 0, 30, 30);
	
	[btnSearch setImage:imgSearch forState:UIControlStateNormal];
	[btnSearch addTarget:self action:@selector(btnSearchClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
	
	NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnSearch, nil];
	self.navigationItem.rightBarButtonItems = arrBtnsRight;
	
}
- (void)btnBackClicked
{
	[appDeleg removeTabBarRetailer];
}
- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
    [self.navigationController pushViewController:viewC animated:YES];
}


#pragma mark - UITableView Delegates & Data Source Methods

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view;
    if ([arrShoppingList count]==0) {
        return nil;
    }else{
        view=[[UIView alloc]initWithFrame:CGRectMake(0, -10, 320, 44)];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTag:111112];
        UIActivityIndicatorView *activitIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [activitIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        activitIndicator.tag=111111;
        [activitIndicator setCenter:view.center];
        [view addSubview:activitIndicator];
        
        return view;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *btnCreateShoppingList = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70)];
    [btnCreateShoppingList setTitle:@"Create New Shopping List" forState:UIControlStateNormal];
    [btnCreateShoppingList setBackgroundImage:[UIImage imageNamed:@"shoppingListCoverImage.png"] forState:UIControlStateNormal];
	[btnCreateShoppingList setBackgroundImage:[UIImage imageNamed:@"shoppingListCoverImage.png"] forState:UIControlStateHighlighted];

    [btnCreateShoppingList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCreateShoppingList.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:14.0]];
    [btnCreateShoppingList setImage:[UIImage imageNamed:@"shoppingListAddCircle.png"] forState:UIControlStateNormal];
	[btnCreateShoppingList setImage:[UIImage imageNamed:@"shoppingListAddCircle.png"] forState:UIControlStateHighlighted];

    [btnCreateShoppingList setTitleEdgeInsets:UIEdgeInsetsMake(50, -30, 0, 0)];
    [btnCreateShoppingList setImageEdgeInsets:UIEdgeInsetsMake(0, 135, 15, 0)];
    [btnCreateShoppingList addTarget:self action:@selector(btnCreateShoppingListClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnCreateShoppingList];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return arrShoppingList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"shopppingListCell";
	ShoppingListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	if(cell == nil)
	{
		cell = [[ShoppingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.indexPath = indexPath;
	cell.delegate = self;
	
	[cell updateCell:[arrShoppingList objectAtIndex:indexPath.row]];
	
	return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self navigateToShoppingListDetailScreen:indexPath.row];
}


-(void)navigateToShoppingListDetailScreen:(NSInteger)index
{
    ShoppingListDetailViewController *shoppingListDetail = (ShoppingListDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ShoppingListDetail"];
    
    
    ShoppingListModel *shoppingListModel = [arrShoppingList objectAtIndex:index];
    shoppingListDetail.strShoppingListID = shoppingListModel.shoppingListId;
    shoppingListDetail.strShoppingListName = shoppingListModel.shoppingListName;
    
    [self.navigationController pushViewController:shoppingListDetail animated:YES];
}


-(void)btnCreateShoppingListClick
{
    CreateNewShoppingListViewController *createNewShoppingList = (CreateNewShoppingListViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CreateNewShoppingList"];
    
    [self.navigationController pushViewController:createNewShoppingList animated:YES];
}

-(void)SideMenuClicked
{
    [self.sideBar show];
}


-(void)btnSearchClicked
{
    
}


#pragma mark -

 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }




#pragma mark - Call Webservice

-(void)callWebServiceToGetShoppingList:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kURLGetShoppingList withInput:aDict withCurrentTask:TASK_TO_GET_SHOPPING_LIST andDelegate:self ];
}

-(void)callWebServiceToDeleteShoppingList:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kURLDeleteShoppingList withInput:aDict withCurrentTask:TASK_TO_DELETE_SHOPPING_LIST andDelegate:self ];
}


-(void) didFailWithError:(NSError *)error
{
    {
        isLoading = NO;
        [self showFooterLoadMoreActivityIndicator:NO];
        [refreshShoppingList endRefreshing];
        
        [AppManager stopStatusbarActivityIndicator];
        [aaramShop_ConnectionManager failureBlockCalled:error];
    }
}


-(void) responseReceived:(id)responseObject
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    [refreshShoppingList endRefreshing];
    
    [AppManager stopStatusbarActivityIndicator];
    
    
    switch (aaramShop_ConnectionManager.currentTask)
    {
        case TASK_TO_GET_SHOPPING_LIST:
        {
            
            if ([[responseObject objectForKey:kstatus] intValue] == 1)
            {
                [self parseResponseData:responseObject];
            }
            else
            {
                [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            }
        }
            break;
        case TASK_TO_DELETE_SHOPPING_LIST:
        {
            
            if ([[responseObject objectForKey:kstatus] intValue] == 1)
            {
                [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
                
                [arrShoppingList removeObjectAtIndex:deletedShoppingListIndex];
                [tblView reloadData];
            }
            else
            {
                [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            }
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - Pagination

- (void)refreshTable
{
    pageno = 0;
    
    [self performSelector:@selector(getInitialShoppingList) withObject:nil afterDelay:1.0];
}


-(void)calledPullUp
{
    if(totalNoOfPages>pageno)
    {
        pageno++;
        [self getShoppingList];
    }
    else
    {
        isLoading = NO;
        [self showFooterLoadMoreActivityIndicator:NO];
    }
}


#pragma mark - to refreshing a view

-(void)showFooterLoadMoreActivityIndicator:(BOOL)show{
    UIView *view=[tblView viewWithTag:111112];
    UIActivityIndicatorView *activity=(UIActivityIndicatorView*)[view viewWithTag:111111];
    
    if (show) {
        [activity startAnimating];
    }else
        [activity stopAnimating];
}


#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrShoppingList.count > 0 && scrollView.contentOffset.y>0){
        if (!isLoading) {
            isLoading=YES;
            [self showFooterLoadMoreActivityIndicator:YES];
            [self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
        }
    }
    
}


-(void)getShoppingList
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:@"page_no"];
    
    [self callWebServiceToGetShoppingList:dict];
}


#pragma mark - Parse Response Data

-(void)parseResponseData:(NSDictionary *)response
{
    if (!arrShoppingList) {
        arrShoppingList = [[NSMutableArray alloc]init];
    }
    
    if (pageno == 0)
    {
        [arrShoppingList removeAllObjects];
    }
    
    NSArray *arrTemp = [response objectForKey:@"shopping_list"];
   
    for (id obj in arrTemp)
    {
        ShoppingListModel *shoppingListModel = [[ShoppingListModel alloc]init];
        shoppingListModel.creationDate = [NSString stringWithFormat:@"%@",[obj valueForKey:@"creationDate"]];
        shoppingListModel.reminderDate = [NSString stringWithFormat:@"%@",[obj valueForKey:@"reminderDate"]];
        
        // temporary commented ... use model here for user info.
//        shoppingListModel.sharedBy = [NSString stringWithFormat:@"%@",[obj valueForKey:@"sharedBy"]];
//        shoppingListModel.sharedWith = [NSString stringWithFormat:@"%@",[obj valueForKey:@"sharedWith"]];
        
        shoppingListModel.shoppingListId = [NSString stringWithFormat:@"%@",[obj valueForKey:@"shoppingListId"]];
        shoppingListModel.shoppingListName = [NSString stringWithFormat:@"%@",[obj valueForKey:@"shoppingListName"]];
        shoppingListModel.totalItems = [NSString stringWithFormat:@"%@",[obj valueForKey:@"totalItems"]];
        shoppingListModel.total_people = [NSString stringWithFormat:@"%@",[obj valueForKey:@"total_people"]];
        
        
        [arrShoppingList  addObject:shoppingListModel];
        
    }
    
    [tblView reloadData];
    
}




#pragma mark - Cell Delegate

-(void)deleteShoppingList:(NSInteger)index
{
    deletedShoppingListIndex = index;
    
    NSMutableDictionary *dic = [Utils setPredefindValueForWebservice];
    
    ShoppingListModel *shoppingListModel = [arrShoppingList objectAtIndex:deletedShoppingListIndex];
    
    [dic setObject:shoppingListModel.shoppingListId forKey:@"shoppingListId"];
    
    [self callWebServiceToDeleteShoppingList:dic];
}


/*
Printing description of responseObject:
{
    deviceId = 3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0;
    message = "Shopping Lists";
    "page_no" = 0;
    "shopping_list" =     (
                           {
                               creationDate = 1436985000;
                               reminderDate = "";
                               sharedBy =             (
                               );
                               sharedWith =             (
                               );
                               shoppingListId = 4;
                               shoppingListName = "Test list 001";
                               totalItems = 2;
                               "total_people" = 0;
                           },
                           {
                               creationDate = 1436985000;
                               reminderDate = "";
                               sharedBy =             (
                               );
                               sharedWith =             (
                               );
                               shoppingListId = 5;
                               shoppingListName = "Test list 002";
                               totalItems = 2;
                               "total_people" = 0;
                           }
                           );
    status = 1;
    "total_pages" = 1;
}
(lldb)
*/

@end
