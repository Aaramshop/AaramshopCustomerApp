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

#define kTableCellHeight        70
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
	NSData *enrollData = [[NSUserDefaults standardUserDefaults] objectForKey: kCartData];
	self.arrProductList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: enrollData];
	
    [self setNavigationBar];
    
    
    
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
    
    
    UIImage *imgCheckout = [UIImage imageNamed:@"doneBtn"];
    UIButton *btnCheckout = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCheckout.bounds = CGRectMake( -10, 0, 75, 30);
    [btnCheckout setTitle:@"Checkout" forState:UIControlStateNormal];
    [btnCheckout.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:13.0]];
    [btnCheckout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCheckout setBackgroundImage:imgCheckout forState:UIControlStateNormal];
    [btnCheckout addTarget:self action:@selector(btnCheckoutClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnCheckout = [[UIBarButtonItem alloc] initWithCustomView:btnCheckout];
    
    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnCheckout, nil];
    self.navigationItem.rightBarButtonItems = arrBtnsRight;
    
}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnCheckoutClicked
{
    
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
    viewTop.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    UILabel *lblTotalAmount = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, viewTop.frame.size.height)];
    lblTotalAmount.font = [UIFont fontWithName:kRobotoRegular size:14];
    lblTotalAmount.textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
    lblTotalAmount.text = @"Total Amount";
    
    
    UILabel *lblTotalAmountValue = [[UILabel alloc]initWithFrame:CGRectMake((viewTop.frame.size.width - 110), 0, 100, viewTop.frame.size.height)];
    lblTotalAmountValue.font = [UIFont fontWithName:kRobotoBold size:16];
    lblTotalAmountValue.textColor = [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1.0];
    lblTotalAmountValue.textAlignment = NSTextAlignmentRight;
    
    
    
    NSString *strRupee = @"\u20B9";
	
	NSInteger strAmount = 0;
	for(ProductsModel *product in cartModel.arrProductDetails)
	{
		strAmount = strAmount + ([product.strCount integerValue] * [product.product_price integerValue]);
	}
	
	
    lblTotalAmountValue.text = [NSString stringWithFormat:@"%@ %ld",strRupee,(long)strAmount];

    
    [viewTop addSubview:lblTotalAmount];
    [viewTop addSubview:lblTotalAmountValue];
    
    
    UILabel *lblSeparator1 = [[UILabel alloc]initWithFrame:CGRectMake(0, (viewTop.frame.origin.y + viewTop.frame.size.height), tblView.frame.size.width, 1)];
    lblSeparator1.backgroundColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0];
    
    
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, (lblSeparator1.frame.origin.y + lblSeparator1.frame.size.height), viewBackground.frame.size.width, 68)];
    viewBottom.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];

    
    UIImageView *imgStore = [[UIImageView alloc]initWithFrame:CGRectMake(5, (viewBottom.frame.size.height - 54)/2, 54, 54)];
    
    imgStore.layer.cornerRadius = imgStore.frame.size.height/2;
    imgStore.clipsToBounds = YES;
    imgStore.contentMode = UIViewContentModeScaleAspectFit;
    
    
    NSString *strStoreImage = [NSString stringWithFormat:@"%@",cartModel.store_image];
    NSURL *urlStoreImage = [NSURL URLWithString:[strStoreImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [imgStore sd_setImageWithURL:urlStoreImage placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];

    
    
    UILabel *lblStoreName = [[UILabel alloc]initWithFrame:CGRectMake((imgStore.frame.origin.x + imgStore.frame.size.width + 16), 15, 240, 18)];
    
    lblStoreName.font = [UIFont fontWithName:kRobotoMedium size:15];
    lblStoreName.textColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1.0];
    lblStoreName.text = cartModel.store_name;

    
    
    UILabel *lblDeliveryTime = [[UILabel alloc]initWithFrame:CGRectMake(lblStoreName.frame.origin.x, (lblStoreName.frame.origin.y + lblStoreName.frame.size.height + 6) , 240, 10)];
    
    lblDeliveryTime.font = [UIFont fontWithName:kRobotoRegular size:13];
    lblDeliveryTime.textColor = [UIColor colorWithRed:91.0/255.0 green:91.0/255.0 blue:91.0/255.0 alpha:1.0];
//    lblDeliveryTime.text = @"Deliver in 90 min"; // temp
	
    
    
    UILabel *lblSeparator2 = [[UILabel alloc]initWithFrame:CGRectMake(0, (viewBackground.frame.size.height-1), tblView.frame.size.width, 1)];
    lblSeparator2.backgroundColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
    
    
    [viewBottom addSubview:imgStore];
    [viewBottom addSubview:lblStoreName];
    [viewBottom addSubview:lblDeliveryTime];
    
    
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
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShoppingListDetailCell";
    ShoppingListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[ShoppingListDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    CartModel *cartModel = [self.arrProductList objectAtIndex:indexPath.section];
    [cell updateCell:[cartModel.arrProductDetails objectAtIndex:indexPath.row]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Cell Delegates

-(void)addProduct:(NSIndexPath *)indexPath
{
	CartModel *cartModel = [self.arrProductList objectAtIndex:indexPath.section];
	ProductsModel *productModel = [cartModel.arrProductDetails objectAtIndex:indexPath.row];
	productModel.strCount = [NSString stringWithFormat:@"%d",[productModel.strCount intValue]+1];
	[AppManager AddOrRemoveFromCart:productModel forStore:[NSDictionary dictionaryWithObjectsAndKeys:cartModel.store_id,kStore_id,cartModel.store_name,kStore_name,cartModel.store_image,kStore_image, nil] add:YES];
	NSData *enrollData = [[NSUserDefaults standardUserDefaults] objectForKey: kCartData];
	self.arrProductList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: enrollData];
	[tblView reloadSectionIndexTitles];
    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)removeProduct:(NSIndexPath *)indexPath
{
	CartModel *cartModel = [self.arrProductList objectAtIndex:indexPath.section];
	ProductsModel *productModel = [cartModel.arrProductDetails objectAtIndex:indexPath.row];
	productModel.strCount = [NSString stringWithFormat:@"%d",[productModel.strCount intValue]-1];

	[AppManager AddOrRemoveFromCart:[cartModel.arrProductDetails objectAtIndex:indexPath.row] forStore:[NSDictionary dictionaryWithObjectsAndKeys:cartModel.store_id,kStore_id,cartModel.store_name,kStore_name,cartModel.store_image,kStore_image, nil] add:NO];
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


@end
