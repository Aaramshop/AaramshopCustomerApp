//
//  CartViewController.m
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "CartViewController.h"
#import "CartModel.h"
#import "ProductsModel.h"
#import "PaymentViewController.h"
#define kTableCellHeight        90
#define kTableHeaderHeight      108


@interface CartViewController ()

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    tblView.backgroundColor = [UIColor whiteColor];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setNavigationBar];
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"Cart"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
 }
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSData *enrollData = [[NSUserDefaults standardUserDefaults] objectForKey: kCartData];
	self.arrProductList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: enrollData];
	[tblView reloadData];
}
- (void)hideEmptyCart:(BOOL)show
{
	if(show)
	{
		[tblView setHidden:NO];
	}
	else
	{
		[tblView setHidden:YES];
	}
	[imgViewEmptyCart setHidden:show];
	[lblInfo1 setHidden:show];
	[lblInfo2 setHidden:show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    titleView.text = @"Cart";
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
    
    
//    UIImage *imgCheckout = [UIImage imageNamed:@"doneBtn"];
//    UIButton *btnCheckout = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnCheckout.bounds = CGRectMake( -10, 0, 75, 30);
//    [btnCheckout setTitle:@"Checkout" forState:UIControlStateNormal];
//    [btnCheckout.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:13.0]];
//    [btnCheckout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnCheckout setBackgroundImage:imgCheckout forState:UIControlStateNormal];
//    [btnCheckout addTarget:self action:@selector(btnCheckoutClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barBtnCheckout = [[UIBarButtonItem alloc] initWithCustomView:btnCheckout];
//    
//    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnCheckout, nil];
//    self.navigationItem.rightBarButtonItems = arrBtnsRight;
	
}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
	if([self.arrProductList count]==0)
	{
		[self hideEmptyCart:NO];
	}
	else
	{
		[self hideEmptyCart:YES];
	}
    return [self.arrProductList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableHeaderHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	
	CartModel *cartModel = [self.arrProductList objectAtIndex:section];
	
    UIView *viewBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, kTableHeaderHeight)];
    
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewBackground.frame.size.width, 40)];
    viewTop.backgroundColor = [UIColor whiteColor];
	
	UIImageView *imgView = [[UIImageView alloc]initWithFrame:viewTop.frame];
	imgView.image = [UIImage imageNamed:@"chooseAStoreBox"];
    
    UILabel *lblTotalAmount = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, viewTop.frame.size.height)];
    lblTotalAmount.font = [UIFont fontWithName:kRobotoRegular size:14];
    lblTotalAmount.textColor = [UIColor whiteColor];//[UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
    lblTotalAmount.text = @"Total Amount";
    
    
    UILabel *lblTotalAmountValue = [[UILabel alloc]initWithFrame:CGRectMake((viewTop.frame.size.width - 110), 0, 100, viewTop.frame.size.height)];
    lblTotalAmountValue.font = [UIFont fontWithName:kRobotoBold size:16];
	lblTotalAmountValue.textColor = [UIColor whiteColor];//[UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1.0];
    lblTotalAmountValue.textAlignment = NSTextAlignmentRight;
    
    
    
    NSString *strRupee = @"\u20B9";
	
	NSInteger strAmount = 0;
	NSInteger intTotalProducts = 0;
	for(CartProductModel *product in cartModel.arrProductDetails)
	{
		if([product.strOffer_type integerValue]>0)
		{
			strAmount = strAmount + ([product.strCount integerValue] * [product.offer_price integerValue]);
			intTotalProducts = intTotalProducts +[product.strCount integerValue];
		}
		else
		{
			strAmount = strAmount + ([product.strCount integerValue] * [product.product_price integerValue]);
			intTotalProducts = intTotalProducts +[product.strCount integerValue];
		}
	}
	
	
    lblTotalAmountValue.text = [NSString stringWithFormat:@"%@ %ld",strRupee,(long)strAmount];
	[viewTop addSubview:imgView];
    [viewTop addSubview:lblTotalAmount];
    [viewTop addSubview:lblTotalAmountValue];
    
    
    UILabel *lblSeparator1 = [[UILabel alloc]initWithFrame:CGRectMake(0, (viewTop.frame.origin.y + viewTop.frame.size.height), tblView.frame.size.width, 1)];
    lblSeparator1.backgroundColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0];
	
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, (lblSeparator1.frame.origin.y + lblSeparator1.frame.size.height), viewBackground.frame.size.width, 68)];
    viewBottom.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:238.0/255.0 blue:212.0/255.0 alpha:1.0];
	
	
    UIImageView *imgStore = [[UIImageView alloc]initWithFrame:CGRectMake(5, (viewBottom.frame.size.height - 54)/2, 54, 54)];
    
    imgStore.layer.cornerRadius = imgStore.frame.size.height/2;
    imgStore.clipsToBounds = YES;
    imgStore.contentMode = UIViewContentModeScaleAspectFit;
    
    
    NSString *strStoreImage = [NSString stringWithFormat:@"%@",cartModel.store_image];
    NSURL *urlStoreImage = [NSURL URLWithString:[strStoreImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [imgStore sd_setImageWithURL:urlStoreImage placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];

    
    
    UILabel *lblStoreName = [[UILabel alloc]initWithFrame:CGRectMake((imgStore.frame.origin.x + imgStore.frame.size.width + 8), 7, 162, 37)];
//	lblStoreName.backgroundColor = [UIColor greenColor];
    lblStoreName.font = [UIFont fontWithName:kRobotoMedium size:15];
    lblStoreName.textColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1.0];
    lblStoreName.text = cartModel.store_name;
	lblStoreName.numberOfLines = 0;

	UILabel *lblTotalProducts = [[UILabel alloc]initWithFrame:CGRectMake((imgStore.frame.origin.x + imgStore.frame.size.width + 8), 37, 162, 21)];
	//	lblStoreName.backgroundColor = [UIColor greenColor];
	lblTotalProducts.font = [UIFont fontWithName:kRobotoRegular size:10];
	lblTotalProducts.textColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1.0];
	lblTotalProducts.text = [NSString stringWithFormat:@"Total Products %ld",(long) intTotalProducts];
	
	UIImage *imgCheckout = [UIImage imageNamed:@"doneBtn"];
	UIButton *btnCheckout = [UIButton buttonWithType:UIButtonTypeCustom];
	btnCheckout.frame = CGRectMake( [[UIScreen mainScreen] bounds].size.width-83, 19, 75, 30);
	[btnCheckout setTitle:@"Checkout" forState:UIControlStateNormal];
	[btnCheckout.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:13.0]];
	[btnCheckout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btnCheckout setBackgroundImage:imgCheckout forState:UIControlStateNormal];
	btnCheckout.tag = section;
	[btnCheckout addTarget:self action:@selector(btnCheckoutClicked:) forControlEvents:UIControlEventTouchUpInside];

	
//    UILabel *lblDeliveryTime = [[UILabel alloc]initWithFrame:CGRectMake(lblStoreName.frame.origin.x, (lblStoreName.frame.origin.y + lblStoreName.frame.size.height + 6) , 240, 10)];
//    
//    lblDeliveryTime.font = [UIFont fontWithName:kRobotoRegular size:13];
//    lblDeliveryTime.textColor = [UIColor colorWithRed:91.0/255.0 green:91.0/255.0 blue:91.0/255.0 alpha:1.0];
//    lblDeliveryTime.text = @"Deliver in 90 min"; // temp
	
    
    
    UILabel *lblSeparator2 = [[UILabel alloc]initWithFrame:CGRectMake(0, (viewBackground.frame.size.height-1), tblView.frame.size.width, 1)];
    lblSeparator2.backgroundColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
    
    
    [viewBottom addSubview:imgStore];
    [viewBottom addSubview:lblStoreName];
	[viewBottom addSubview:lblTotalProducts];
	[viewBottom addSubview:btnCheckout];
//    [viewBottom addSubview:lblDeliveryTime];
	
    
    [viewBackground addSubview:viewTop];
    [viewBackground addSubview:lblSeparator1];
    [viewBackground addSubview:viewBottom];
    [viewBackground addSubview:lblSeparator2];

    
    return viewBackground;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	CartModel *cartModel = [self.arrProductList objectAtIndex:section];
    return cartModel.arrProductDetails.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CartModel *cartModel = [self.arrProductList objectAtIndex:indexPath.section];
	CartProductModel *productModel = [cartModel.arrProductDetails objectAtIndex:indexPath.row];
	if([productModel.strOffer_type intValue] == 6)
	{
		return 110;
	}
	
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CartModel *cartModel = [self.arrProductList objectAtIndex:indexPath.section];
	CartProductModel *productModel = [cartModel.arrProductDetails objectAtIndex:indexPath.row];

	if([productModel.strOffer_type intValue]== 0)
	{
		static NSString *CellIdentifier = @"cartListDetailCell";
		CartListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
		
		if(cell == nil)
		{
			cell = [[CartListDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		cell.indexPath = indexPath;
		cell.delegate = self;
		ProductsModel *product	= [[ProductsModel alloc]init];
		product.product_name		= productModel.product_name;
		product.product_image		=	productModel.cartProductImage;
		product.strCount				=	productModel.strCount;
		product.product_price		=	productModel.product_price;
		[cell updateCell:product];
        
        
//        if ([product.isAvailable integerValue]==0)
//        {
//            cell.contentView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
//            cell.contentView.alpha = 0.3;
//            cell.userInteractionEnabled = NO;
//        }
//        else
//        {
//            cell.contentView.backgroundColor = [UIColor clearColor];
//            cell.contentView.alpha = 1.0;
//            cell.userInteractionEnabled = YES;
//        }

        
        
		
		return cell;
	}
	else
	{
		offers	= [[CMOffers alloc]init];
		offers.offerType		= productModel.strOffer_type;
		offers.offer_price	= productModel.offer_price;
		offers.strCount		=	productModel.strCount;
		offers.end_date		=	productModel.end_date;
        
		if([productModel.strOffer_type intValue]==1)
		{
			offers.product_name				= productModel.product_name;
			offers.product_actual_price	= productModel.product_price;
			offers.product_image				=	productModel.cartProductImage;
		}
		else if([productModel.strOffer_type intValue] == 4)
		{
			offers.offerTitle						=	productModel.offerTitle;
			offers.combo_mrp					=	productModel.product_price;
			offers.combo_offer_price			=	productModel.offer_price;
			offers.offerImage						=	productModel.cartProductImage;
		}
		else
		{
			offers.offerTitle						=	productModel.offerTitle;
			offers.offerImage						=	productModel.cartProductImage;
		}

		static NSString *cellIdentifier = nil;
		
		if([offers.offerType isEqualToString:@"6"])
		{
			cellIdentifier = @"CustomOffersCell";
			MyCustomOfferTableCell *cell = (MyCustomOfferTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if (cell == nil) {
				cell = [[MyCustomOfferTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			}
						cell.delegate = self;
			cell.indexPath=indexPath;
			cell.offers = offers;
			[cell updateCellWithData: offers];
			return cell;
		}
		else
		{
			cellIdentifier = @"OffersCell";
			OffersTableCell *cell = (OffersTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if (cell == nil) {
				cell = [[OffersTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			}
			cell.delegate = self;
			cell.indexPath=indexPath;
			cell.offers = offers;
			[cell updateCellWithData: offers];
			return cell;
		}

	}
	return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	CartModel *cartModel = [self.arrProductList objectAtIndex:indexPath.section];
	CartProductModel *productModel = [cartModel.arrProductDetails objectAtIndex:indexPath.row];
	if([productModel.strOffer_type intValue] == 4)
	{
		ComboDetailViewController *comboDetail = (ComboDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"comboDetailController"];
		comboDetail.offersModel = offers;
		comboDetail.cartProductModel = productModel;
		
		[self.navigationController pushViewController:comboDetail animated:YES];
	}
}


#pragma mark - Cell Delegates

-(void)addProduct:(NSIndexPath *)indexPath
{
	CartModel *cartModel = [self.arrProductList objectAtIndex:indexPath.section];
	CartProductModel *productModel = [cartModel.arrProductDetails objectAtIndex:indexPath.row];
	productModel.strCount = [NSString stringWithFormat:@"%d",[productModel.strCount intValue]+1];
	[AppManager AddOrRemoveFromCart:productModel forStore:[NSDictionary dictionaryWithObjectsAndKeys:cartModel.store_id,kStore_id,cartModel.store_name,kStore_name,cartModel.store_image,kStore_image, nil] add:YES fromCart:YES];
	gAppManager.intCount++;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
	NSData *enrollData = [[NSUserDefaults standardUserDefaults] objectForKey: kCartData];
	self.arrProductList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: enrollData];

	NSRange range = NSMakeRange(indexPath.section, 1);
	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)removeProduct:(NSIndexPath *)indexPath
{
	CartModel *cartModel = [self.arrProductList objectAtIndex:indexPath.section];
	CartProductModel *productModel = [cartModel.arrProductDetails objectAtIndex:indexPath.row];
	productModel.strCount = [NSString stringWithFormat:@"%d",[productModel.strCount intValue]-1];

	[AppManager AddOrRemoveFromCart:productModel forStore:[NSDictionary dictionaryWithObjectsAndKeys:cartModel.store_id,kStore_id,cartModel.store_name,kStore_name,cartModel.store_image,kStore_image, nil] add:NO fromCart:YES];
	gAppManager.intCount--;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
	NSData *enrollData = [[NSUserDefaults standardUserDefaults] objectForKey: kCartData];
	self.arrProductList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: enrollData];
	if([productModel.strCount integerValue] == 0)
	{
		[tblView reloadData];
	}
	else
	{
		NSRange range = NSMakeRange(indexPath.section, 1);
		NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
		[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
		[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
	}
}
#pragma mark - table section button methods
-(IBAction)btnCheckoutClicked:(id)sender
{
	UIButton *btnCheckout = (UIButton *)sender;
	CartModel *cartModel = [self.arrProductList objectAtIndex:btnCheckout.tag];
	NSInteger strAmount = 0;
	for(CartProductModel *product in cartModel.arrProductDetails)
	{
		if([product.strOffer_type integerValue]>0)
		{
			strAmount = strAmount + ([product.strCount integerValue] * [product.offer_price integerValue]);
		}
		else
		{
			strAmount = strAmount + ([product.strCount integerValue] * [product.product_price integerValue]);
		}
	}
	
	PaymentViewController *paymentScreen	= (PaymentViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentViewScene"];
	paymentScreen.strStore_Id							= cartModel.store_id;
	paymentScreen.strStore_image					= cartModel.store_image;
	paymentScreen.strStore_name					=	cartModel.store_name;
	paymentScreen.strTotalPrice						= [NSString stringWithFormat:@"%ld",(long)strAmount];
	paymentScreen.arrSelectedProducts			= cartModel.arrProductDetails;
	paymentScreen.fromCart							= YES;
	[self.navigationController pushViewController:paymentScreen animated:YES];
}

#pragma mark - table cell delegate methods
-(void)addedValueByPriceAtIndexPath:(NSIndexPath *)inIndexPath
{
	CartModel *cartModel = [self.arrProductList objectAtIndex:inIndexPath.section];
	CartProductModel *productModel = [cartModel.arrProductDetails objectAtIndex:inIndexPath.row];
	productModel.strCount = [NSString stringWithFormat:@"%d",[productModel.strCount intValue]+1];
	[AppManager AddOrRemoveFromCart:productModel forStore:[NSDictionary dictionaryWithObjectsAndKeys:cartModel.store_id,kStore_id,cartModel.store_name,kStore_name,cartModel.store_image,kStore_image, nil] add:YES fromCart:YES];
	NSData *enrollData = [[NSUserDefaults standardUserDefaults] objectForKey: kCartData];
	self.arrProductList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: enrollData];
	gAppManager.intCount++;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
	NSRange range = NSMakeRange(inIndexPath.section, 1);
	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)minusValueByPriceAtIndexPath:(NSIndexPath *)inIndexPath
{
	CartModel *cartModel = [self.arrProductList objectAtIndex:inIndexPath.section];
	CartProductModel *productModel = [cartModel.arrProductDetails objectAtIndex:inIndexPath.row];
	productModel.strCount = [NSString stringWithFormat:@"%d",[productModel.strCount intValue]-1];
	
	[AppManager AddOrRemoveFromCart:productModel forStore:[NSDictionary dictionaryWithObjectsAndKeys:cartModel.store_id,kStore_id,cartModel.store_name,kStore_name,cartModel.store_image,kStore_image, nil] add:NO fromCart:YES];
	gAppManager.intCount--;
	[AppManager saveCountOfProductsInCart:gAppManager.intCount];
	NSData *enrollData = [[NSUserDefaults standardUserDefaults] objectForKey: kCartData];
	self.arrProductList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: enrollData];
	if([productModel.strCount integerValue] == 0)
	{
		[tblView reloadData];
	}
	else
	{
		NSRange range = NSMakeRange(inIndexPath.section, 1);
		NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
		[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
		[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	}
}



@end
