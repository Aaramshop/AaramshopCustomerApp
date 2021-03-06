//
//  ShoppingListShareViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListShareViewController.h"
#import "ShoppingListShareCell.h"
#import "AddContactsToShareViewController.h"
#import "SharedUserModel.h"

#define kTableCellHeight    58

@interface ShoppingListShareViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    AppDelegate *appDeleg;
    int pageno;
    int totalNoOfPages;
}
@end

@implementation ShoppingListShareViewController
@synthesize aaramShop_ConnectionManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    arrShareList = [[NSMutableArray alloc]init];
    
    
    totalNoOfPages = 0;
    pageno = 0;
    isLoading = NO;
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
    aaramShop_ConnectionManager.delegate = self;
    
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblView.bounces = YES;
    tblView.tag = 10;
    self.view.tag = 100;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = tblView;
    refreshStoreList = [[UIRefreshControl alloc] init];
    [refreshStoreList addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshStoreList;
    
    ////
    CGRect frame = CGRectZero;
    frame.size.height = CGFLOAT_MIN;
    [tblView setTableHeaderView:[[UIView alloc] initWithFrame:frame]];
    
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"ShareShoppingList"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//    [self callWebserviceToGetSharedList];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self callWebserviceToGetSharedList];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    lblMessage.hidden = YES;
    tblView.hidden = NO;
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
    titleView.text = @"Share";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.bounds = CGRectMake( 0, 0, 30, 30 );
    [btnBack setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *batBtnBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:batBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
    //
    
    UIImage *imgAdd = [UIImage imageNamed:@"addIconBig"];
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.bounds = CGRectMake( -10, 0, 30, 30);
    
    [btnAdd setImage:imgAdd forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(btnAddClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    
    //
    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnAdd, nil];
    self.navigationItem.rightBarButtonItems = arrBtnsRight;
    
}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnAddClicked
{
    AddContactsToShareViewController *addContactsToShareView = (AddContactsToShareViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AddContactsToShare"];
    
    addContactsToShareView.strShoppingListId = _strShoppingListId;
    [self.navigationController pushViewController:addContactsToShareView animated:YES];

}





#pragma mark - UITableView Delegates & Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrShareList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShoppingListShareCell";
    
    ShoppingListShareCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if(cell == nil)
    {
        cell = [[ShoppingListShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell updateCell:[arrShareList objectAtIndex:indexPath.row]];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Call Webservice

-(void)callWebserviceToGetSharedList
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
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
    
    [aaramShop_ConnectionManager getDataForFunction:kURLGetShoppingListShareWith withInput:dict withCurrentTask:TASK_TO_GET_SHOPPING_LIST_SHARE_WITH andDelegate:self ];
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
    
    if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_SHOPPING_LIST_SHARE_WITH)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            totalNoOfPages = [[responseObject objectForKey:kTotal_page] intValue];
            [self parseResponseData:responseObject];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject valueForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
    
}


#pragma mark - Parse Response Data

-(void)parseResponseData:(NSDictionary *)responseObject
{
    
    if (!arrShareList)
    {
        arrShareList = [[NSMutableArray alloc]init];
    }
    
    if (pageno == 0)
    {
        [arrShareList removeAllObjects];
    }
    
    
    NSArray *arrTempShareUser = [responseObject valueForKey:@"share_user"];
    
    if (arrTempShareUser.count==0 && pageno==0)
    {
        lblMessage.hidden = NO;
        tblView.hidden = YES;
    }
    else
    {
        lblMessage.hidden = YES;
        tblView.hidden = NO;
    }
    
    
    
    for (id obj in arrTempShareUser)
    {
        SharedUserModel *sharedUserModel = [[SharedUserModel alloc]init];
        sharedUserModel.full_name = [obj valueForKey:@"full_name"];
        
        sharedUserModel.profileImage = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"profileImage"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        sharedUserModel.userId = [obj valueForKey:@"userId"];
        
        [arrShareList addObject:sharedUserModel];
    }
    
    [tblView reloadData];
}

/*
 
 Printing description of responseObject:
 {
 deviceId = 3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0;
 message = "Share Shopper Data!";
 "page_no" = 0;
 "share_user" =     (
 {
 "full_name" = "Joy Sharma";
 profileImage = "http://52.74.220.25/uploaded_files/user/profileImage9.jpg";
 userId = 26;
 },
 {
 "full_name" = "Neha Saxena";
 profileImage = "http://52.74.220.25/uploaded_files/user/profileImage12.jpg";
 userId = 8;
 }
 );
 status = 1;
 "total_page" = 1;
 }

 
 */




////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////


- (void)refreshTable
{
    pageno = 0;
    [self performSelector:@selector(callWebserviceToGetSharedList) withObject:nil afterDelay:1.0];
}

-(void)calledPullUp
{
    if(totalNoOfPages>pageno+1)
    {
        pageno++;
        [self callWebserviceToGetSharedList];
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
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrShareList.count > 0 && scrollView.contentOffset.y>0){
        if (!isLoading) {
            isLoading=YES;
            [self showFooterLoadMoreActivityIndicator:YES];
            [self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
        }
    }
    
}



@end
