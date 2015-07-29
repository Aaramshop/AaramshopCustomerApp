//
//  RetailerShoppingListDetailViewController.m
//  AaramShop
//
//  Created by Neha Saxena on 24/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "RetailerShoppingListDetailViewController.h"

#define kTableHeader1Height 60
#define kTableHeader2Height 40
#define kTableCellHeight    80


@interface RetailerShoppingListDetailViewController ()
{
    int pageno;
    int totalNoOfPages;
}
@end

@implementation RetailerShoppingListDetailViewController
@synthesize aaramShop_ConnectionManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    arrProductList = [[NSMutableArray alloc]init];
    [self setNavigationBar];
    
    self.tabBarController.tabBar.hidden = YES;
    
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
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    [self getProductsInitialList]; // temp
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
    
    titleView.text = _strShoppingListName;
    
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
    
    UIImage *imgCopy = [UIImage imageNamed:@"copyIcon.png"];
    UIButton *btnCopy = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCopy.bounds = CGRectMake( -10, 0, 30, 30);
    
    [btnCopy setImage:imgCopy forState:UIControlStateNormal];
    [btnCopy addTarget:self action:@selector(btnCopyClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnCopy = [[UIBarButtonItem alloc] initWithCustomView:btnCopy];
    
    //
    UIImage *imgSearch = [UIImage imageNamed:@"searchIcon.png"];
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.bounds = CGRectMake( -10, 0, 30, 30);
    
    [btnSearch setImage:imgSearch forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(btnSearchClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    
    //    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnSearch,barBtnCopy, nil];
    
    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnSearch, nil];
    self.navigationItem.rightBarButtonItems = arrBtnsRight;
    
}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnCopyClicked
{
    
}

-(void)btnSearchClicked
{
    
}



#pragma mark - UITableView Delegates & Data Source Methods

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view;
    if ([arrProductList count]==0) {
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
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section==0)
    {
        return kTableHeader1Height;
    }
    else
    {
        return kTableHeader2Height;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        if (section==0)
        {
            return [self viewForHeader1];
        }
        else
        {
            return [self viewForHeader2];
        }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0)
    {
        return 0;
    }
    else
    {
        return [arrProductList count];
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RetailerShoppingListDetailCell";
    RetailerShoppingListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[RetailerShoppingListDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.indexPath = indexPath;
    
    ProductsModel *productsModel = [arrProductList objectAtIndex:indexPath.row];
    
    [cell updateCell:productsModel];
    
    
    if ([productsModel.isAvailable integerValue]==0)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
        cell.contentView.alpha = 0.3;
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.contentView.alpha = 1.0;
    }
    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - Design for Table Header View
-(UIView *)viewForHeader1
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableHeader1Height)];
    
    //
    UILabel *lblTotalAmount = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, view.frame.size.height)];
    lblTotalAmount.font = [UIFont fontWithName:kRobotoRegular size:14];
    lblTotalAmount.textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
    lblTotalAmount.text = @"Total Amount";
    
    
    
    //
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40), 0, 40, 40);
    btnDone.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
    [btnDone setImage:[UIImage imageNamed:@"shoppingListSideArrow"] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(btnDoneClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    NSString *strRupee  = @"\u20B9";
    NSString *strAmount = @"150";//selectedStoreModel.total_product_price;
    
    //
    UILabel *lblTotalAmountValue = [[UILabel alloc]initWithFrame:CGRectMake((btnDone.frame.origin.x - 120), 0, 100, view.frame.size.height)];
    lblTotalAmountValue.font = [UIFont fontWithName:kRobotoBold size:16];
    lblTotalAmountValue.textColor = [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1.0];
    lblTotalAmountValue.textAlignment = NSTextAlignmentRight;
    lblTotalAmountValue.text = [NSString stringWithFormat:@"%@ %@",strRupee,strAmount];
    
    
    
    [view addSubview:lblTotalAmount];
    [view addSubview:lblTotalAmountValue];
    [view addSubview:btnDone];
    
    return view;
}

-(UIView *)viewForHeader2
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableHeader2Height)];
    view.backgroundColor = [UIColor whiteColor];
    
    
    
    ////
    UILabel *lblShoppingListName = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 240, 18)];
    lblShoppingListName.font = [UIFont fontWithName:kRobotoMedium size:14];
    lblShoppingListName.textColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0];
    
    lblShoppingListName.text = @"Monthly Family Grocery"; // shopping list name

    
    
    ////
    UILabel *lblTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width- (8+55), 12, 55, 18)];
    lblTotalPrice.font = [UIFont fontWithName:kRobotoMedium size:14];
    lblTotalPrice.textColor = [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0];
    lblTotalPrice.textAlignment = NSTextAlignmentRight;
    
    NSString *strRupee  = @"\u20B9";
    
    lblTotalPrice.text = [NSString stringWithFormat:@"%@ %@",strRupee,@"5200"]; // total price
    
    

    ////
    UILabel *lblProductsAvailableText = [[UILabel alloc]initWithFrame:CGRectMake(10, (lblShoppingListName.frame.origin.y + lblShoppingListName.frame.size.height + 4), 175, 18)];
    lblProductsAvailableText.font = [UIFont fontWithName:kRobotoRegular size:13];
    lblProductsAvailableText.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
    
    lblProductsAvailableText.text = @"Products available at the store";

    
    ////
    UILabel *lblTotalItems = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width- (8+55), (lblTotalPrice.frame.origin.y + lblTotalPrice.frame.size.height + 4), 55, 18)];
    lblTotalItems.font = [UIFont fontWithName:kRobotoRegular size:12];
    lblTotalItems.textColor = [UIColor colorWithRed:218.0/255.0 green:38.0/255.0 blue:19.0/255.0 alpha:1.0];
    lblTotalItems.textAlignment = NSTextAlignmentRight;
    
    lblTotalItems.text = [NSString stringWithFormat:@"%@, Items",@"24"]; // total items

    
    [view addSubview:lblShoppingListName];
    [view addSubview:lblTotalPrice];
    [view addSubview:lblProductsAvailableText];
    [view addSubview:lblTotalItems];
    
    
    return view;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


#pragma mark - Button Methods

-(void)btnDoneClicked
{
    
}


/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Cell Delegates

-(void)addProduct:(NSIndexPath *)indexPath
{
    //    ProductsModel *productModel = [arrProductList objectAtIndex:indexPath.row];
    //
    //    int counter = [productModel.quantity intValue];
    //
    //    counter++;
    //
    //    productModel.quantity = [NSString stringWithFormat:@"%d",counter];
    //
    //    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}



-(void)removeProduct:(NSIndexPath *)indexPath
{
    //    ProductsModel *productModel = [arrProductList objectAtIndex:indexPath.row];
    //
    //    int counter = [productModel.quantity intValue];
    //    counter--;
    //
    //    productModel.quantity = [NSString stringWithFormat:@"%d",counter];
    //
    //    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


#pragma mark - Call Webservice

-(void)getProductsInitialList
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:_strShoppingListID forKey:@"shoppingListId"];
    [dict setObject:@"0" forKey:@"page_no"];
    
//    if (selectedStoreModel)
//    {
//        [dict setObject:selectedStoreModel.store_id forKey:@"store_id"];
//    }
//    else
//    {
        [dict setObject:@"0" forKey:@"store_id"]; // temp
//    }
    
    [self callWebServiceToGetProductsList:dict];
}


-(void)callWebServiceToGetProductsList:(NSMutableDictionary *)aDict
{
    //    [self activateChooseBtn:NO];
    
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kURLGetShoppingListProducts withInput:aDict withCurrentTask:TASK_TO_GET_SHOPPING_LIST_PRODUCTS andDelegate:self ];
}


-(void) didFailWithError:(NSError *)error
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    [refreshShoppingList endRefreshing];
    
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
    
    //    [self activateChooseBtn:NO];
}


-(void) responseReceived:(id)responseObject
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    [refreshShoppingList endRefreshing];
    
    [AppManager stopStatusbarActivityIndicator];
    
    
    
    switch (aaramShop_ConnectionManager.currentTask)
    {
        case TASK_TO_GET_SHOPPING_LIST_PRODUCTS:
        {
            
            if ([[responseObject objectForKey:kstatus] intValue] == 1)
            {
                totalNoOfPages = [[responseObject valueForKey:@"total_pages"] intValue];
                [self parseResponseData:responseObject];
                
                //                [self activateChooseBtn:YES];
            }
            else
            {
                [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
                
                //                [self activateChooseBtn:NO];
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
    
    [self performSelector:@selector(getProductsInitialList) withObject:nil afterDelay:0.1];
}


-(void)calledPullUp
{
    if(totalNoOfPages>pageno+1)
    {
        pageno++;
        [self getShoppingListProducts];
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
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrProductList.count > 0 && scrollView.contentOffset.y>0){
        if (!isLoading) {
            isLoading=YES;
            [self showFooterLoadMoreActivityIndicator:YES];
            [self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
        }
    }
    
}


-(void)getShoppingListProducts
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:_strShoppingListID forKey:@"shoppingListId"];
    [dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:@"page_no"];
    
//    if (selectedStoreModel)
//    {
//        [dict setObject:selectedStoreModel.store_id forKey:@"store_id"];
//    }
//    else
//    {
        [dict setObject:@"0" forKey:@"store_id"]; // temp
//    }
    
    [self callWebServiceToGetProductsList:dict];
}


#pragma mark - Parse Response Data

-(void)parseResponseData:(NSDictionary *)response
{
    if (!arrProductList) {
        arrProductList = [[NSMutableArray alloc]init];
    }
    
    if (pageno == 0)
    {
        [arrProductList removeAllObjects];
    }
    
    
    NSArray *arrTemp = [response objectForKey:@"products"];
    
    for (id obj in arrTemp)
    {
        ProductsModel *productsModel = [[ProductsModel alloc]init];
        
        productsModel.free_item = [NSString stringWithFormat:@"%@",[obj valueForKey:@"free_item"]];
        productsModel.isAvailable = [NSString stringWithFormat:@"%@",[obj valueForKey:@"isAvailable"]];
        productsModel.offerType = [NSString stringWithFormat:@"%@",[obj valueForKey:@"offerType"]];
        productsModel.offer_price = [NSString stringWithFormat:@"%@",[obj valueForKey:@"offer_price"]];
        
        productsModel.product_id = [NSString stringWithFormat:@"%@",[obj valueForKey:@"product_id"]];
        productsModel.product_image = [NSString stringWithFormat:@"%@",[obj valueForKey:@"product_image"]];
        productsModel.product_name = [NSString stringWithFormat:@"%@",[obj valueForKey:@"product_name"]];
        productsModel.product_price = [NSString stringWithFormat:@"%@",[obj valueForKey:@"product_price"]];
        productsModel.product_sku_id = [NSString stringWithFormat:@"%@",[obj valueForKey:@"product_sku_id"]];
        productsModel.quantity = [NSString stringWithFormat:@"%@",[obj valueForKey:@"quantity"]];
        
        
        [arrProductList  addObject:productsModel];
        
    }
    
    [tblView reloadData];
    
}


//-(void)activateChooseBtn:(BOOL)isActive
//{
//    if (isActive)
//    {
//        btnChooseStore.userInteractionEnabled = YES;
//        [btnChooseStore setTitle:@"CHOOSE A STORE" forState:UIControlStateNormal];
//    }
//    else
//    {
//        btnChooseStore.userInteractionEnabled = NO;
//        [btnChooseStore setTitle:@"" forState:UIControlStateNormal];
//    }
//}


@end
