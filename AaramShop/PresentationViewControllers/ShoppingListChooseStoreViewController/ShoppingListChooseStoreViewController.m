//
//  ShoppingListChooseStoreViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListChooseStoreViewController.h"

#define kTableCellHeight    85

@interface ShoppingListChooseStoreViewController ()
{
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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    refreshStoreList = [[UIRefreshControl alloc] init];
    [refreshStoreList addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshStoreList;
    
    [self getInitialStoreList];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}


-(void)getInitialStoreList
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
//    [dict setObject:@"0" forKey:@"page_no"];
    
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    
    
    //    [dict setObject:@"28.5136781" forKey:kLatitude]; // temp
    //    [dict setObject:@"77.3769436" forKey:kLongitude]; // temp

    
    
    [self callWebServiceToGetStoreList:dict];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;//arrStoreList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
    
//    static NSString *CellIdentifier = @"ShoppingListDetailCell";
//    ShoppingListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    if(cell == nil)
//    {
//        cell = [[ShoppingListDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    cell.indexPath = indexPath;
//    cell.delegate = self;
//    
//    [cell updateCell:[_arrProductList objectAtIndex:indexPath.row]];
//    
//    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////



#pragma mark - Call Webservice

-(void)callWebServiceToGetStoreList:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kURLGetStores withInput:aDict withCurrentTask:TASK_TO_GET_SHOPPING_STORE_LIST andDelegate:self ];
}


-(void) didFailWithError:(NSError *)error
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    [refreshStoreList endRefreshing];
    
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}


-(void) responseReceived:(id)responseObject
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    [refreshStoreList endRefreshing];
    
    [AppManager stopStatusbarActivityIndicator];
    
    
    switch (aaramShop_ConnectionManager.currentTask)
    {
        case TASK_TO_GET_SHOPPING_STORE_LIST:
        {
            
            if ([[responseObject objectForKey:kstatus] intValue] == 1)
            {
//                [self parseResponseData:responseObject];
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
    
    [self performSelector:@selector(getInitialStoreList) withObject:nil afterDelay:1.0];
}


-(void)calledPullUp
{
    if(totalNoOfPages>pageno)
    {
        pageno++;
        [self getStoreList];
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
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrStoreList.count > 0 && scrollView.contentOffset.y>0){
        if (!isLoading) {
            isLoading=YES;
            [self showFooterLoadMoreActivityIndicator:YES];
            [self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
        }
    }
    
}


-(void)getStoreList
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
//    [dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:@"page_no"];
    
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];

    
    //    [dict setObject:@"28.5136781" forKey:kLatitude]; // temp
    //    [dict setObject:@"77.3769436" forKey:kLongitude]; // temp

    
//    [self callWebServiceToGetStoreList:dict];
}


#pragma mark - Parse Response Data

-(void)parseResponseData:(NSDictionary *)response
{
    if (!arrStoreList) {
        arrStoreList = [[NSMutableArray alloc]init];
    }
    
    if (pageno == 0)
    {
        [arrStoreList removeAllObjects];
    }
    
    /*
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
     //*/
    
    [tblView reloadData];
    
}


@end
