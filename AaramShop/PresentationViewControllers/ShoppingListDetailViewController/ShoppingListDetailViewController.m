//
//  ShoppingListDetailViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListDetailViewController.h"
#import "ShoppingListAddMoreViewController.h"
#import "ShoppingListShareViewController.h"
#import "ShoppingListCalenderViewController.h"
#import "CartViewController.h"
#import "ProductsModel.h"
#import "ShoppingListChooseStoreViewController.h"
#import "PaymentViewController.h"
#import "ShoppingListChooseStoreModel.h"


#define kTableHeader1Height    40
#define kTableHeader2Height    70
#define kTableHeader2ButtonWidhtHeight   44
#define kTableCellHeight    80


@interface ShoppingListDetailViewController ()
{
    int pageno;
    int totalNoOfPages;
    
    ShoppingListChooseStoreModel *selectedStoreModel;
}
@end

@implementation ShoppingListDetailViewController
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
    
    strTotalAvailProductPrice = @"";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    tblView.hidden = YES;
    
    [self getProductsInitialList];
    
    if (selectedStoreModel)
    {
        [btnChooseStore setTitle:@"CHANGE STORE" forState:UIControlStateNormal];
    }
    else
    {
        [btnChooseStore setTitle:@"CHOOSE A STORE" forState:UIControlStateNormal];
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

-(void)getProductsInitialList
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:_strShoppingListID forKey:@"shoppingListId"];
    [dict setObject:@"0" forKey:@"page_no"];
    
    if (selectedStoreModel)
    {
        [dict setObject:selectedStoreModel.store_id forKey:@"store_id"];
    }
    else
    {
        [dict setObject:@"0" forKey:@"store_id"];
    }
    
    [self callWebServiceToGetProductsList:dict];
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
	GlobalSearchResultViewC *globalSearchResultViewC = (GlobalSearchResultViewC *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GlobalSearchResultView" ];
	[self.navigationController pushViewController:globalSearchResultViewC animated:YES];
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
    if (selectedStoreModel)
    {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if (selectedStoreModel)
    //    {
    //        return kTableHeader1Height;
    //    }
    //    else
    //    {
    //        return kTableHeader2Height;
    //    }
    
    
    
    switch (section)
    {
        case 0:
        {
            if (selectedStoreModel)
            {
                return kTableHeader1Height;
            }
            else
            {
                return kTableHeader2Height;
            }
        }
            break;
        case 1:
        {
            return kTableHeader2Height;
        }
            break;
            
        default:
            return CGFLOAT_MIN;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    if (selectedStoreModel)
    //    {
    //        return [self viewForHeader1];
    //    }
    //    else
    //    {
    //        return [self viewForHeader2];
    //    }
    
    
    switch (section)
    {
        case 0:
        {
            if (selectedStoreModel)
            {
                return [self viewForHeader1];
            }
            else
            {
                return [self viewForHeader2];
            }
        }
            break;
        case 1:
        {
            return [self viewForHeader2];
        }
            break;
            
        default:
            return nil;
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return arrProductList.count;
    
    
    switch (section)
    {
        case 0:
        {
            if (selectedStoreModel)
            {
                return 0;
            }
            else
            {
                return arrProductList.count;
            }
        }
            break;
        case 1:
        {
            return arrProductList.count;;
        }
            break;
            
        default:
            return 0;
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (selectedStoreModel)
    {
        ////
        static NSString *CellIdentifier = @"ShoppingListDetailCell";
        ShoppingListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if(cell == nil)
        {
            cell = [[ShoppingListDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.delegate = self;
        ////
        
        cell.indexPath = indexPath;
        ProductsModel *productsModel = [arrProductList objectAtIndex:indexPath.row];
        [cell updateCell:productsModel];
        
        if (selectedStoreModel && [productsModel.isAvailable integerValue]==0)
        {
            cell.contentView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
            cell.contentView.alpha = 0.3;
            cell.userInteractionEnabled = NO;
        }
        else
        {
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.contentView.alpha = 1.0;
            cell.userInteractionEnabled = YES;
        }
        
        
        return cell;
    }
    else
    {
        
        static NSString *CellIdentifier = @"ShoppingListDetailNewCell";
        ShoppingListDetailNewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if(cell == nil)
        {
            cell = [[ShoppingListDetailNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.indexPath = indexPath;
        ProductsModel *productsModel = [arrProductList objectAtIndex:indexPath.row];
        [cell updateCell:productsModel];
        
        if (selectedStoreModel && [productsModel.isAvailable integerValue]==0)
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
    
    
    
    
    NSString *strRupee = @"\u20B9";
    NSString *strAmount = strTotalAvailProductPrice;
    
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
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    imgBackground.image = [UIImage imageNamed:@"shoppingListCoverImage.png"];
    
    
    double button_Y = (view.frame.size.height - kTableHeader2ButtonWidhtHeight)/2;
    
    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(30, button_Y, kTableHeader2ButtonWidhtHeight, kTableHeader2ButtonWidhtHeight);
    [btnShare setImage:[UIImage imageNamed:@"shoppingListShareCircle"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(btnShareClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake((view.frame.size.width - kTableHeader2ButtonWidhtHeight)/2, button_Y, kTableHeader2ButtonWidhtHeight, kTableHeader2ButtonWidhtHeight);
    [btnAdd setImage:[UIImage imageNamed:@"updateIcon"] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(btnAddClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnCalender = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCalender.frame = CGRectMake((view.frame.size.width - (kTableHeader2ButtonWidhtHeight + 30)), button_Y, kTableHeader2ButtonWidhtHeight, kTableHeader2ButtonWidhtHeight);
    [btnCalender setImage:[UIImage imageNamed:@"shoppingListCalenderCircle"] forState:UIControlStateNormal];
    [btnCalender addTarget:self action:@selector(btnCalenderClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if (selectedStoreModel)
    {
        btnCalender.enabled = YES;
        btnAdd.enabled = NO;
    }
    else
    {
        btnCalender.enabled = NO;
        btnAdd.enabled = YES;
    }
    
    
    
    [view addSubview:imgBackground];
    
    [view addSubview:btnShare];
    [view addSubview:btnAdd];
    [view addSubview:btnCalender];
    
    
    return view;
    
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}





#pragma mark - Button Methods
- (CartProductModel *)getCartProductFromProduct:(ProductsModel *)product
{
    CartProductModel *cart = [[CartProductModel alloc]init];
    cart.strOffer_type			= [NSString stringWithFormat:@"%d",[product.offer_type intValue]];
    cart.offer_price				=	product.offer_price;
    cart.offerTitle					=	product.product_name;
    cart.offer_id					=	product.offer_id;
    if([product.offer_type integerValue] >0)
    {
        cart.cartProductId		=	product.offer_id;
    }
    else
    {
        cart.cartProductId		=	product.product_id;
    }
    cart.strCount					=	product.strCount;
    cart.product_id				=	product.product_id;
    cart.product_sku_id		=	product.product_sku_id;
    cart.cartProductImage	= product.product_image;
    cart.product_name			=	product.product_name;
    cart.product_price			=	product.product_price;
    return cart;
}
-(void)btnDoneClicked
{
    if ([strTotalAvailProductPrice integerValue]==0)
    {
        [Utils showAlertView:kAlertTitle message:@"No products available." delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    
    NSMutableArray *arrCartProducts = [[NSMutableArray	 alloc]init];
    if ([arrProductList count]>0)
    {
		NSInteger strAmount = 0;
		for (ProductsModel *productModel in arrProductList) {
			if([productModel.isAvailable intValue] == 1)
			{
				[arrCartProducts addObject:[self getCartProductFromProduct:productModel]];
				if([productModel.offer_type integerValue]>0)
				{
					strAmount = strAmount + ([productModel.strCount integerValue] * [productModel.offer_price integerValue]);
				}
				else
				{
					strAmount = strAmount + ([productModel.strCount integerValue] * [productModel.product_price integerValue]);
				}

			}
		}
				
		PaymentViewController *paymentScreen	= (PaymentViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentViewScene"];
		paymentScreen.strStore_Id							= selectedStoreModel.store_id;
		paymentScreen.strStore_image					= selectedStoreModel.store_image;
		paymentScreen.strStore_name					=	selectedStoreModel.store_name;
		paymentScreen.strTotalPrice						= [NSString stringWithFormat:@"%ld",(long)strAmount];
		paymentScreen.arrSelectedProducts			= arrCartProducts;
		paymentScreen.fromCart							=	NO;
		[self.navigationController pushViewController:paymentScreen animated:YES];
    }
    
}


-(void)btnShareClicked
{
    ShoppingListShareViewController *shoppingListShareView = (ShoppingListShareViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ShoppingListShareView"];
    
    shoppingListShareView.strShoppingListId = _strShoppingListID;
    
    [self.navigationController pushViewController:shoppingListShareView animated:YES];
}

-(void)btnAddClicked
{
    ShoppingListAddMoreViewController *shoppingListAddMore = (ShoppingListAddMoreViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ShoppingListAddMore"];
    
    shoppingListAddMore.arrProductList = [[NSMutableArray alloc]init];
    [shoppingListAddMore.arrProductList addObjectsFromArray:arrProductList];
    
    shoppingListAddMore.strShoppingListId = _strShoppingListID;
    
    
    [self.navigationController pushViewController:shoppingListAddMore animated:YES];
}

-(void)btnCalenderClicked
{
    [Utils showAlertView:kAlertTitle message:@"Do you want to set automatic purchase of this list?" delegate:self cancelButtonTitle:kAlertBtnNO otherButtonTitles:kAlertBtnYES];
}

-(IBAction)actionChooseStore:(id)sender
{
    
    if ([arrProductList count]>0)
    {
        ShoppingListChooseStoreViewController *shoppingListChooseStoreView = (ShoppingListChooseStoreViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ShoppingListChooseStoreView"];
        
        shoppingListChooseStoreView.strShoppingListId = _strShoppingListID;
        
        shoppingListChooseStoreView.refreshShoppingList = ^(ShoppingListChooseStoreModel *chooseStoreModel)
        {
            if (!selectedStoreModel)
            {
                selectedStoreModel = [[ShoppingListChooseStoreModel alloc]init];
            }
            
            selectedStoreModel = chooseStoreModel;
            
            strTotalAvailProductPrice = selectedStoreModel.total_product_price;
            
            [tblView reloadData];
        };
        
        
        
        [self.navigationController pushViewController:shoppingListChooseStoreView animated:YES];
    }
    
}


#pragma mark - Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        ShoppingListCalenderViewController *shoppingListCalenderView = (ShoppingListCalenderViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ShoppingListCalenderView"];
        
        shoppingListCalenderView.storeId = selectedStoreModel.store_id;
        shoppingListCalenderView.shoppingListId=_strShoppingListID;
        [self.navigationController pushViewController:shoppingListCalenderView animated:YES];
    }
}


#pragma mark - Cell Delegates

-(void)addProduct:(NSIndexPath *)indexPath
{
    ProductsModel *productModel = [arrProductList objectAtIndex:indexPath.row];
    
    //    int counter = [productModel.quantity intValue];
    int counter = [productModel.strCount intValue];
    
    
    counter++;
    
    //    productModel.quantity = [NSString stringWithFormat:@"%d",counter];
    productModel.strCount = [NSString stringWithFormat:@"%d",counter];
    
    
    
    NSInteger totalAmount;
    
        if ([productModel.offer_type integerValue]>0)
        {
            totalAmount = [strTotalAvailProductPrice integerValue]+[productModel.offer_price integerValue];
        }
        else
        {
            totalAmount = [strTotalAvailProductPrice integerValue]+[productModel.product_price integerValue];
        }
    
    
//        countTotalProductPrice = countTotalProductPrice + [productModel.product_price integerValue];
    
        strTotalAvailProductPrice = [NSString stringWithFormat:@"%ld",(long)totalAmount];
    
    [tblView reloadData];
}


-(void)removeProduct:(NSIndexPath *)indexPath
{
    ProductsModel *productModel = [arrProductList objectAtIndex:indexPath.row];
    
    //    int counter = [productModel.quantity intValue];
    
    int counter = [productModel.strCount intValue];
    
    counter--;
    
    //    productModel.quantity = [NSString stringWithFormat:@"%d",counter];
    productModel.strCount = [NSString stringWithFormat:@"%d",counter];
    
    
    
    NSInteger totalAmount;
    
        if ([productModel.offer_type integerValue]>0)
        {
            totalAmount = [strTotalAvailProductPrice integerValue]-[productModel.offer_price integerValue];
        }
        else
        {
            totalAmount = [strTotalAvailProductPrice integerValue]-[productModel.product_price integerValue];
        }
    
//        countTotalProductPrice = countTotalProductPrice - [productModel.product_price integerValue];
    
    
        strTotalAvailProductPrice = [NSString stringWithFormat:@"%ld",(long)totalAmount];
    
    [tblView reloadData];
    
}


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


#pragma mark - Call Webservice

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
                tblView.hidden = NO;
                
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
    
    if (selectedStoreModel)
    {
        [dict setObject:selectedStoreModel.store_id forKey:@"store_id"];
    }
    else
    {
        [dict setObject:@"0" forKey:@"store_id"];
    }
    
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
    
    if (pageno==0 && arrTemp.count==0)
    {
        btnChooseStore.hidden = YES;
    }
    else
    {
        btnChooseStore.hidden = NO;
    }
    
    
    for (id obj in arrTemp)
    {
        [arrProductList  addObject:[self addProductInArray:obj]];
    }
    
    [tblView reloadData];
    
}
- (ProductsModel *)addProductInArray:(NSDictionary *)dictProducts
{
	ProductsModel *objProductsModel = [[ProductsModel alloc]init];
	objProductsModel.category_id = [NSString stringWithFormat:@"%d",[[dictProducts objectForKey:kCategory_id] intValue]];
	objProductsModel.product_id = [NSString stringWithFormat:@"%d",[[dictProducts objectForKey:kProduct_id] intValue]];
	objProductsModel.product_image = [NSString stringWithFormat:@"%@",[[dictProducts objectForKey:kProduct_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	objProductsModel.isAvailable			=	[NSString stringWithFormat:@"%d", [[dictProducts objectForKey:kIsAvailable] intValue]];
	objProductsModel.product_name = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_name]];
	objProductsModel.product_price = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_price]];
	objProductsModel.product_sku_id = [NSString stringWithFormat:@"%d",[[dictProducts objectForKey:kProduct_sku_id] intValue]];
	objProductsModel.sub_category_id = [NSString stringWithFormat:@"%d",[[dictProducts objectForKey:kSub_category_id] intValue]];
	
	objProductsModel.offer_id=[NSString stringWithFormat:@"%d",[[dictProducts objectForKey:kOffer_id] intValue]];
	objProductsModel.offer_price = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kOffer_price]];
	objProductsModel.offer_type = [NSString stringWithFormat:@"%d",[[dictProducts objectForKey:@"offerType"] intValue]];
	objProductsModel.strCount = [NSString stringWithFormat:@"%d",[[dictProducts valueForKey:@"quantity"] intValue]];
	
	return objProductsModel;
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
