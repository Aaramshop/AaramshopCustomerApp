//
//  OrderedProductsDetailViewController.m
//  AaramShop
//
//  Created by Approutes on 17/09/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OrderedProductsDetailViewController.h"
#import "OrderDetailModel.h"
#import "CartProductModel.h"
#import "CartViewController.h"

#import "CreateNewShoppingListViewController.h"
#import "ProductsModel.h"


#define kSection1Height 42


@interface OrderedProductsDetailViewController ()
{
    UIRefreshControl *refreshFoodList;
    BOOL isLoading;
    int pageno;
    int totalNoOfPages;
}
@end


@implementation OrderedProductsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;
    
    
    //
    totalNoOfPages = 0;
    pageno = 0;
    isLoading = NO;
    
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tblView.bounces = YES;
    tblView.tag = 10;
    self.view.tag = 100;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = tblView;
    refreshFoodList = [[UIRefreshControl alloc] init];
    [refreshFoodList addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshFoodList;
    
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"OrderedProductDetails"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self callWebServiceToGetInitialOrderDetails];
    
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



-(void)setUpNavigationBar
{
    
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 190, 44);
    UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
    CGRect titleFrame = CGRectMake(0,0, 190, 44);
    UILabel* titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:kRobotoRegular size:15];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"Order Detail";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    UIImage *imgBack = [UIImage imageNamed:@"backBtn"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake( -10, 0, 30, 30);
    
    [backBtn setImage:imgBack forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
    
    /////
    
    UIImage *imgReOrder = [UIImage imageNamed:@"optionIcon"];
    UIButton *btnReOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReOrder.bounds = CGRectMake( 0, 0, 26, 26);
    
    [btnReOrder setImage:imgReOrder forState:UIControlStateNormal];
    [btnReOrder addTarget:self action:@selector(btnReOrderClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnReOrder = [[UIBarButtonItem alloc] initWithCustomView:btnReOrder];
    
    
    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnReOrder, nil];
    self.navigationItem.rightBarButtonItems = arrBtnsRight;
    
    /////

    
}

-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView Delegates & Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrOrderDetail count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return kSection1Height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc]init];
    viewHeader.frame = CGRectMake(0, 0, tblView.frame.size.width, kSection1Height);
    viewHeader.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    
    UILabel *lblTotalAmount = [[UILabel alloc]initWithFrame:CGRectMake(8, 0,100,kSection1Height)];
    lblTotalAmount.textColor = [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0];
    lblTotalAmount.font = [UIFont fontWithName:kRobotoRegular size:14];
    
    lblTotalAmount.text = @"Total Amount";
    
    
    
    UILabel *lblAmount = [[UILabel alloc]initWithFrame:CGRectMake((tblView.frame.size.width - (100 + 10)), 0, 100, kSection1Height)];
    lblAmount.textAlignment = NSTextAlignmentRight;
    lblAmount.font = [UIFont fontWithName:kRobotoBold size:16];
    lblAmount.textColor = [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0];
    
    NSString *strRupee = @"\u20B9";
    lblAmount.text = [NSString stringWithFormat:@"%@ %@",strRupee,_orderHist.total_cart_value];
    
    
    [viewHeader addSubview:lblTotalAmount];
    [viewHeader addSubview:lblAmount];
    
    return viewHeader;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailModel *order = [arrOrderDetail objectAtIndex:indexPath.row];
    
    if ([order.offer_type integerValue]==6) //Custom Offer (description)
    {
        return 100;
    }
    return 70;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailModel *order = [arrOrderDetail objectAtIndex:indexPath.row];
    
    if ([order.offer_type integerValue]==6) //Custom Offer (description)
    {
        static NSString *CellIdentifier = @"UserOrderDetailOfferCell";
        UserOrderDetailOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if(cell == nil)
        {
            cell = (UserOrderDetailOfferCell *)[[UserOrderDetailOfferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.indexPath = indexPath;
        cell.orderDetailOfferDelegate = self;
        [cell updateOrderDetailOfferCell:arrOrderDetail];
        //        cell.contentView.alpha = 0.5;
        return cell;
    }
    else // rest cells
    {
        
        static NSString *CellIdentifier = @"UserOrderDetailCell";
        UserOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if(cell == nil)
        {
            cell = (UserOrderDetailCell *)[[UserOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.indexPath = indexPath;
        cell.orderDetailDelegate = self;
        [cell updateOrderDetailCell:arrOrderDetail];
        //        cell.contentView.alpha = 0.5;
        return cell;
        
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)callWebServiceToGetInitialOrderDetails
{
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        isLoading = NO;
        [refreshFoodList endRefreshing];
        
        [self showFooterLoadMoreActivityIndicator:NO];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
   
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:_orderHist.order_id forKey:kOrder_id];
    [dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
    
    [aaramShop_ConnectionManager getDataForFunction:kURLOrderDetail withInput:dict withCurrentTask:TASK_GET_ORDER_DETAIL andDelegate:self ];
}


- (void)responseReceived:(id)responseObject
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    [refreshFoodList endRefreshing];
    
    [AppManager stopStatusbarActivityIndicator];
    
    
    if (aaramShop_ConnectionManager.currentTask==TASK_GET_ORDER_DETAIL)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            totalNoOfPages = [[responseObject objectForKey:kTotal_page] intValue];
            [self parseOrderDetailData:[responseObject objectForKey:@"product_details"]];
        }
    }
    
}

- (void)didFailWithError:(NSError *)error
{
    isLoading = NO;
    [self showFooterLoadMoreActivityIndicator:NO];
    [refreshFoodList endRefreshing];
    
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}


#pragma mark - Parsing Data
- (void)parseOrderDetailData:(id)data
{
    if (![data isKindOfClass:[NSArray class]])
    {
        return;
    }
    
    if (!arrOrderDetail) {
        arrOrderDetail = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
    
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        OrderDetailModel *orderDetail = [[OrderDetailModel alloc]init];
        orderDetail.quantity = [NSString stringWithFormat:@"%@",[obj valueForKey:@"quantity"]];
        orderDetail.name = [obj valueForKey:@"name"];
        orderDetail.price = [NSString stringWithFormat:@"%@",[obj valueForKey:@"price"]];
        orderDetail.isAvailable = [NSString stringWithFormat:@"%@",[obj valueForKey:@"isAvailable"]];
        orderDetail.image = [obj valueForKey:@"image"];
        
        orderDetail.isReported = @"0"; // for local use
        
        
        // new keys has been added ..
        
        orderDetail.combo_mrp = [NSString stringWithFormat:@"%@",[obj valueForKey:@"combo_mrp"]];
        orderDetail.combo_offer_price = [NSString stringWithFormat:@"%@",[obj valueForKey:@"combo_offer_price"]];
        orderDetail.free_product = [NSString stringWithFormat:@"%@",[obj valueForKey:@"free_product"]];
        orderDetail.offerDescription = [obj valueForKey:@"offerDescription"];
        orderDetail.offerImage = [obj valueForKey:@"offerImage"];
        orderDetail.offerTitle = [obj valueForKey:@"offerTitle"];
        orderDetail.offer_price = [NSString stringWithFormat:@"%@",[obj valueForKey:@"offer_price"]];
        orderDetail.offer_type = [NSString stringWithFormat:@"%@",[obj valueForKey:@"offer_type"]];
        orderDetail.order_detail_id = [NSString stringWithFormat:@"%@",[obj valueForKey:@"order_detail_id"]];
        
        
        // added on Oct 07th, 2015...begin
        orderDetail.product_id = [obj valueForKey:@"product_id"];
        orderDetail.product_sku_id = @"0"; // take product_sku_id 0 here, as it is not necessary for further use..
        orderDetail.offer_id = [obj valueForKey:@"offer_id"];
        
        orderDetail.end_date = [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[obj valueForKey:kEnd_date] doubleValue]]];

        
        //// end ....

        [arrTemp addObject:orderDetail];
        
    }];
    
    if (pageno == 0)
    {
        [arrOrderDetail removeAllObjects];
    }
    
    [arrOrderDetail addObjectsFromArray:arrTemp];
    
    [tblView reloadData];
}




/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view;
    if ([arrOrderDetail count]==0) {
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


-(void)calledPullUp
{
    if(totalNoOfPages>pageno+1)
    {
        pageno++;
        [self callWebServiceToGetInitialOrderDetails];
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
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrOrderDetail.count > 0 && scrollView.contentOffset.y>0){
        if (!isLoading) {
            isLoading=YES;
            [self showFooterLoadMoreActivityIndicator:YES];
            [self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
        }
    }
    
}



- (void)refreshTable
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    pageno = 0;
    [self callWebServiceToGetInitialOrderDetails];
    
}



#pragma mark - btnReOrderClicked

-(void)btnReOrderClicked
{
    if (arrOrderDetail.count>0)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Re Order",@"Save As Shopping List", nil];
        
        //    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Re Order", nil];
        
        
        [actionSheet showInView:self.view];

    }
    
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        // Re-Order
        [self reOrderProducts];
    }
    else if (buttonIndex==1)
    {
        // Save As Shopping list
        [self saveAsShoppingList];
    }
}


#pragma mark - Re-Order Products
-(void)reOrderProducts
{
    [arrOrderDetail enumerateObjectsUsingBlock:^(OrderDetailModel *orderDetail, NSUInteger idx, BOOL *stop) {
        
        
        if ([orderDetail.offer_type intValue]>0)
        {
            // code for offers ...
            
            [AppManager AddOrRemoveFromCart:[self getCartFromOffers:orderDetail] forStore:[NSDictionary dictionaryWithObjectsAndKeys:_orderHist.store_id,kStore_id,_orderHist.store_name,kStore_name,_orderHist.store_image,kStore_image, nil] add:YES fromCart:NO];
        }
        else
        {
            // code for product ...
            
            [AppManager AddOrRemoveFromCart:[self getCartFromProducts:orderDetail] forStore:[NSDictionary dictionaryWithObjectsAndKeys:_orderHist.store_id,kStore_id,_orderHist.store_name,kStore_name,_orderHist.store_image,kStore_image, nil] add:YES fromCart:NO];
            
        }
        
        
    }];
    
    
    CartViewController *cartView = (CartViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CartViewScene"];
    [self.navigationController pushViewController:cartView animated:YES];

    
}


-(CartProductModel *)getCartFromProducts:(OrderDetailModel *)orderDetailModel
{
    CartProductModel *cart = [[CartProductModel alloc]init];
    cart.strOffer_type              = [NSString stringWithFormat:@"%d",[orderDetailModel.offer_type intValue]];
    
    cart.offer_price				=	orderDetailModel.offer_price;
    cart.offerTitle					=	orderDetailModel.name;
    cart.offer_id					=	orderDetailModel.offer_id;
    cart.cartProductId              =	orderDetailModel.product_id;
    cart.strCount					=	orderDetailModel.quantity;
    cart.product_id                 =	orderDetailModel.product_id;
    cart.product_sku_id             =	orderDetailModel.product_sku_id;
    cart.cartProductImage           =   orderDetailModel.image;
    cart.product_name               =	orderDetailModel.name;
    cart.product_price              =	orderDetailModel.price;
    cart.end_date                   =   orderDetailModel.end_date;
    
    
    return cart;
}

-(CartProductModel *)getCartFromOffers:(OrderDetailModel *)orderDetailModel
{
    CartProductModel *cart = [[CartProductModel alloc]init];
    
    cart.strOffer_type              = [NSString stringWithFormat:@"%d",[orderDetailModel.offer_type  intValue]];
    
    cart.offer_price                =	orderDetailModel.offer_price;
    cart.offerTitle                 =	orderDetailModel.offerTitle;
    cart.offer_id                   =	orderDetailModel.offer_id;
    cart.cartProductId              =	orderDetailModel.offer_id;
    cart.strCount                   =	orderDetailModel.quantity;
    cart.end_date                   =   orderDetailModel.end_date;

    
    if([orderDetailModel.offer_type intValue]== 1)// discount
    {
        cart.product_id				=	orderDetailModel.product_id;
        cart.product_sku_id         =	orderDetailModel.product_sku_id;
        cart.cartProductImage       =   orderDetailModel.image;
        cart.product_name			=	orderDetailModel.offerTitle;
        cart.product_price			=	orderDetailModel.price;
    }
    else if([orderDetailModel.offer_type intValue] == 4)//combo
    {
        cart.product_id				=	@"0";
        cart.product_sku_id         =	@"0";
        cart.cartProductImage       =   orderDetailModel.offerImage;
        cart.product_price			=	orderDetailModel.combo_mrp;
        cart.offer_price			=	orderDetailModel.combo_offer_price;
    }
    else//custom
    {
        cart.product_id				=	orderDetailModel.product_id;
        cart.product_sku_id         =	orderDetailModel.product_sku_id;
        cart.cartProductImage       =   orderDetailModel.offerImage;
        cart.product_price			=	@"0";
    }
    
    return cart;
}


#pragma mark - Save As Shopping List
-(void)saveAsShoppingList
{
    NSArray *arrProducts = [self createProductsModel];
    
    CreateNewShoppingListViewController *createNewShoppingList = (CreateNewShoppingListViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateNewShoppingList"];
    
    createNewShoppingList.arrProductList = [[NSMutableArray alloc]initWithArray:arrProducts];
        
    [self.navigationController pushViewController:createNewShoppingList animated:YES];

}


-(NSMutableArray *)createProductsModel
{
    
    NSMutableArray *arrProductsArray;
    
    if (!arrProductsArray)
    {
        arrProductsArray = [[NSMutableArray alloc]init];
    }
    
    for (OrderDetailModel *order in arrOrderDetail)
    {
        ProductsModel *productModel = [[ProductsModel alloc]init];
        
//        productModel.offer_type = order.offer_type;
        productModel.product_id = order.product_id;
        productModel.isStoreProduct = @"0";
        ///////////////////////////////////////////////////////
//        productModel.product_image = order.offerImage;
//        productModel.product_name = order.offerTitle;
//        productModel.product_price = order.price;
//        productModel.strCount = order.quantity;
        ///////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////
        
        switch ([order.offer_type intValue])
        {
            case 0:
            {
                productModel.product_image = order.image;
                productModel.product_name = order.name;
                productModel.product_price = order.price;
                productModel.strCount = order.quantity;
            }

                break;
            case 1:
            {
                productModel.product_image = order.offerImage;
                productModel.product_name = order.offerTitle;
                productModel.product_price = order.price;
                productModel.strCount = order.quantity;
            }

                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                
            }
                break;
            case 4: // Combo
            {
                productModel.product_image = order.offerImage;
                productModel.product_name = order.offerTitle;
                productModel.product_price = order.combo_mrp;
                productModel.strCount = order.quantity;
            }
                break;
            case 5:
            {
                
            }
                break;
            case 6:
            {
                
            }
                break;
                
            default:
                break;
        }
        
        [arrProductsArray addObject:productModel];
        
        
        ///////////////////////////////////////////////////////

        
    }
//    {
//        ProductsModel *productModel = [[ProductsModel alloc]init];
//
//        productModel.offer_type = order.offer_type;
//        productModel.product_id = order.product_id;
//        productModel.isStoreProduct = @"0";
//
//        switch ([order.offer_type intValue])
//        {
//            case 0:
//            {
//                productModel.product_name = order.name;
//                productModel.offer_price = order.offer_price;
//                productModel.product_price = order.price;
//                productModel.product_image = order.image;
//                productModel.strCount = order.quantity;
//            }
//                break;
//            case 1:
//            {
//                productModel.product_name = order.offerTitle;
//                productModel.offer_price = order.offer_price;
//                productModel.product_price = order.price;
//                productModel.product_image = order.offerImage;
//                productModel.strCount = order.quantity;
//            }
//                break;
//            case 2:
//            {
//                
//            }
//                break;
//            case 3:
//            {
//                
//            }
//                break;
//            case 4: // combo
//            {
//                productModel.product_name = order.offerTitle;
//                productModel.offer_price = order.combo_offer_price;
//                productModel.product_price = order.combo_mrp;
//
//                productModel.product_image = order.offerImage;
//                productModel.strCount = order.quantity;
//
//            }
//                break;
//            case 5:
//            {
//                
//            }
//                break;
//            case 6:
//            {
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//        
//
//        if ([order.offer_type integerValue]==6) //Custom Offer (description)
//        {
//            productModel.product_image = order.offerImage;
//            
//            NSString *strQuantity = [[order.name componentsSeparatedByString:@" "] lastObject];
//            productModel.strCount = strQuantity;
//        }
//        else
//        {
//            productModel.product_image = order.image;
//            productModel.strCount = order.quantity;
//        }
//        
//        [arrProductsArray addObject:productModel];
//    }
    
    
    return arrProductsArray;
}




/*
 {
 
 OrderDetailModel *orderDetail = [[OrderDetailModel alloc]init];
 orderDetail.quantity = [NSString stringWithFormat:@"%@",[obj valueForKey:@"quantity"]];
 orderDetail.name = [obj valueForKey:@"name"];
 orderDetail.price = [NSString stringWithFormat:@"%@",[obj valueForKey:@"price"]];
 orderDetail.isAvailable = [NSString stringWithFormat:@"%@",[obj valueForKey:@"isAvailable"]];
 orderDetail.image = [obj valueForKey:@"image"];
 
 orderDetail.isReported = @"0"; // for local use
 
 
 // new keys has been added ..
 
 orderDetail.combo_mrp = [NSString stringWithFormat:@"%@",[obj valueForKey:@"combo_mrp"]];
 orderDetail.combo_offer_price = [NSString stringWithFormat:@"%@",[obj valueForKey:@"combo_offer_price"]];
 orderDetail.free_product = [NSString stringWithFormat:@"%@",[obj valueForKey:@"free_product"]];
 orderDetail.offerDescription = [obj valueForKey:@"offerDescription"];
 orderDetail.offerImage = [obj valueForKey:@"offerImage"];
 orderDetail.offerTitle = [obj valueForKey:@"offerTitle"];
 orderDetail.offer_price = [NSString stringWithFormat:@"%@",[obj valueForKey:@"offer_price"]];
 orderDetail.offer_type = [NSString stringWithFormat:@"%@",[obj valueForKey:@"offer_type"]];
 orderDetail.order_detail_id = [NSString stringWithFormat:@"%@",[obj valueForKey:@"order_detail_id"]];
 
 
 // added on Oct 07th, 2015...begin
 orderDetail.product_id = [obj valueForKey:@"product_id"];
 orderDetail.product_sku_id = @"0"; // take product_sku_id 0 here, as it is not necessary for further use..
 orderDetail.offer_id = [obj valueForKey:@"offer_id"];
 
 orderDetail.end_date = [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[obj valueForKey:kEnd_date] doubleValue]]];
 
 
 //// end ....
 
 [arrTemp addObject:orderDetail];
 
 }
 
 */


@end

