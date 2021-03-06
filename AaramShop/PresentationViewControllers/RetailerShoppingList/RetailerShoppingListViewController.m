//
//  RetailerShoppingListViewController.m
//  AaramShop
//
//  Created by Neha Saxena on 24/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "RetailerShoppingListViewController.h"
#import "ShoppingListModel.h"
#import "RetailerShoppingListDetailViewController.h"
#import "CartViewController.h"
//#import "SharedUserModel.h"

@interface RetailerShoppingListViewController ()
{
    AppDelegate *appDeleg;
    BOOL isLoading;
    int pageno;
    int totalNoOfPages;
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    
}
@end

@implementation RetailerShoppingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    appDeleg = APP_DELEGATE;
	
    totalNoOfPages = 0;
    pageno = 0;
    isLoading = NO;
    self.arrShoppingList = [[NSMutableArray alloc] init];
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tblView.showsVerticalScrollIndicator = YES;
    
    _tblView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"RetailerShoppingList"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    _tblView.hidden = YES;
    [self setNavigationBar];
    [self getRetailerShoppingList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - set navigation Bar

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
	titleView.numberOfLines = 2;
    titleView.text = appDeleg.objStoreModel.store_name;
//    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    UIImage *imgBack = [UIImage imageNamed:@"backBtn.png"];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake( -10, 0, 30, 30);
    
    [backBtn setImage:imgBack forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    //
	
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
	NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnCart,
							 barBtnSearch, nil];
	self.navigationItem.rightBarButtonItems = arrBtnsRight;
    
}
-(void)btnCartClicked
{
	CartViewController *cartView = (CartViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CartViewScene"];
	[self.navigationController pushViewController:cartView animated:YES];
	
}

- (void)btnBackClicked
{
    [appDeleg removeTabBarRetailer];
}
-(void)btnSearchClicked
{
	GlobalSearchResultViewC *globalSearchResultViewC = (GlobalSearchResultViewC *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GlobalSearchResultView" ];
	[self.navigationController pushViewController:globalSearchResultViewC animated:YES];
}
#pragma mark - tableview methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([self.arrShoppingList count]>0)
    {
        return 44;
    }
    return CGFLOAT_MIN;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	return [NSString stringWithFormat:@"%ld Shopping List",[self.arrShoppingList count]];
//}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tblView.frame.size.width, 44)];
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, viewHeader.frame.size.width - 30, viewHeader.frame.size.height)];
    
    lblTitle.textColor = [UIColor colorWithRed:57.0/255.0 green:57.0/255.0 blue:57.0/255.0 alpha:1.0];
    lblTitle.font = [UIFont fontWithName:kRobotoRegular size:13];
    
    lblTitle.text = [NSString stringWithFormat:@"%ld Shopping List",[self.arrShoppingList count]];
    
    
    [viewHeader addSubview:lblTitle];
    
    
    return viewHeader;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrShoppingList count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"shoppingListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ShoppingListModel *shoppingListModel = [self.arrShoppingList objectAtIndex:indexPath.row];
    
    UILabel *lblListName		= (UILabel *) [cell.contentView viewWithTag:100];
    UILabel *lblDate				= (UILabel *) [cell.contentView viewWithTag:101];
    UILabel *lblItemsCount	=	(UILabel *) [cell.contentView viewWithTag:102];
    
    lblListName.text				=	shoppingListModel.shoppingListName;
    lblDate.text						=	[Utils convertedDate:[NSDate dateWithTimeIntervalSince1970:[shoppingListModel.creationDate doubleValue]]];
    lblItemsCount.text			=	[NSString stringWithFormat:@"%@ Items", shoppingListModel.totalItems];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self navigateToDetailScreen:indexPath];
    
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view;
    if ([self.arrShoppingList count]==0) {
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
#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //To do Call the parent delegates
    
    if ([_delegate respondsToSelector:@selector(scrollViewDidScroll:onTableView:)]) {
        [_delegate scrollViewDidScroll:scrollView onTableView:self.tblView];
    }
    
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && self.arrShoppingList.count > 0 && scrollView.contentOffset.y>0){
        if (!isLoading) {
            isLoading=YES;
            [self showFooterLoadMoreActivityIndicator:YES];
            [self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
        }
    }
    
}
-(void)calledPullUp
{
    if(totalNoOfPages>pageno+1)
    {
        pageno++;
        [self getRetailerShoppingList];
    }
    else
    {
        isLoading = NO;
        [self showFooterLoadMoreActivityIndicator:NO];
    }
}
#pragma mark - to refreshing a view

-(void)showFooterLoadMoreActivityIndicator:(BOOL)show{
    UIView *view=[self.tblView viewWithTag:111112];
    UIActivityIndicatorView *activity=(UIActivityIndicatorView*)[view viewWithTag:111111];
    
    if (show) {
        [activity startAnimating];
    }else
        [activity stopAnimating];
}

#pragma mark - Web service methods

- (void)getRetailerShoppingList
{
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        isLoading = NO;
        [self showFooterLoadMoreActivityIndicator:NO];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
    [dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
    [aaramShop_ConnectionManager getDataForFunction:kURLGetShoppingList withInput:dict withCurrentTask:TASK_TO_GET_SHOPPING_LIST andDelegate:self];
}
- (void)responseReceived:(id)responseObject
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    
    [AppManager stopStatusbarActivityIndicator];
    if(aaramShop_ConnectionManager.currentTask == TASK_TO_GET_SHOPPING_LIST)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            _tblView.hidden = NO;
            
            if(pageno==0)
            {
                [self createDataForFirstTimeGet:[self parseResponseData:responseObject]];
            }
            else
            {
                [self appendDataForPullUp:[self parseResponseData:responseObject]];
            }
            [self.tblView reloadData];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
}
- (void)didFailWithError:(NSError *)error
{
    //    [Utils stopActivityIndicatorInView:self.view];
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void)createDataForFirstTimeGet:(NSMutableArray*)array{
    [self.arrShoppingList removeAllObjects];
    for(int i = 0 ; i < [array count];i++)
    {
        ShoppingListModel *shoppingListModel = [array objectAtIndex:i];
        [self.arrShoppingList addObject:shoppingListModel];
    }
}
-(void)appendDataForPullUp:(NSMutableArray*)array{
    for(int i = 0 ; i < [array count];i++)
    {
        ShoppingListModel *shoppingListModel = [array objectAtIndex:i];
        [self.arrShoppingList addObject:shoppingListModel];
    }
}

-(NSMutableArray *)parseResponseData:(NSDictionary *)response
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSArray *arrTemp = [response objectForKey:@"shopping_list"];
    
    for (id obj in arrTemp)
    {
        ShoppingListModel *shoppingListModel = [[ShoppingListModel alloc]init];
        shoppingListModel.creationDate = [NSString stringWithFormat:@"%@",[obj valueForKey:@"creationDate"]];
        shoppingListModel.reminder_start_date = [NSString stringWithFormat:@"%@",[obj valueForKey:@"reminder_start_date"]];
        
        shoppingListModel.reminder_end_date = [NSString stringWithFormat:@"%@",[obj valueForKey:@"reminder_end_date"]];

        
        /*
         
        NSArray *arrTempSharedBy = [obj valueForKey:@"sharedBy"];
        
        for (id obj1 in arrTempSharedBy) {
            
            SharedUserModel *sharedUserModel = [[SharedUserModel alloc]init];
            
            sharedUserModel.chat_username = [obj1 valueForKey:@"chat_username"];
            sharedUserModel.email = [obj1 valueForKey:@"email"];
            sharedUserModel.full_name = [obj1 valueForKey:@"full_name"];
            sharedUserModel.mobile = [obj1 valueForKey:@"mobile"];
            
            [shoppingListModel.sharedBy addObject:sharedUserModel];
        }
        
        
        
        NSArray *arrTempSharedWith = [obj valueForKey:@"sharedWith"];
        
        for (id obj2 in arrTempSharedWith) {
            
            SharedUserModel *sharedUserModel = [[SharedUserModel alloc]init];
            
            sharedUserModel.chat_username = [obj2 valueForKey:@"chat_username"];
            sharedUserModel.email = [obj2 valueForKey:@"email"];
            sharedUserModel.full_name = [obj2 valueForKey:@"full_name"];
            sharedUserModel.mobile = [obj2 valueForKey:@"mobile"];
            
            [shoppingListModel.sharedWith addObject:sharedUserModel];
        }
        
        //*/
        
        
        shoppingListModel.shoppingListId = [NSString stringWithFormat:@"%@",[obj valueForKey:@"shoppingListId"]];
        shoppingListModel.shoppingListName = [NSString stringWithFormat:@"%@",[obj valueForKey:@"shoppingListName"]];
        shoppingListModel.totalItems = [NSString stringWithFormat:@"%@",[obj valueForKey:@"totalItems"]];
        shoppingListModel.total_people = [NSString stringWithFormat:@"%@",[obj valueForKey:@"total_people"]];
        
        
        [array  addObject:shoppingListModel];
        
    }
    
    return array;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - navigate to detail screen
-(void)navigateToDetailScreen:(NSIndexPath *)indexPath
{
    RetailerShoppingListDetailViewController *retailerShoppingListDetailView = (RetailerShoppingListDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"retailerShoppingListDetail"];
	retailerShoppingListDetailView.hidesBottomBarWhenPushed = YES;

    ShoppingListModel *shoppingListModel = [self.arrShoppingList objectAtIndex:indexPath.row];
    retailerShoppingListDetailView.shoppingListModel = shoppingListModel;
    [self.navigationController pushViewController:retailerShoppingListDetailView animated:YES];
}


@end
