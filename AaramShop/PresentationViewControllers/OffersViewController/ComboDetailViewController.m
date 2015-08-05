//
//  ComboDetailViewController.m
//  AaramShop_Merchant
//
//  Created by Neha Saxena on 22/07/2015.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import "ComboDetailViewController.h"
#import "ProductsModel.h"
@interface ComboDetailViewController ()
{
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
}
@end

@implementation ComboDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	[self setNavigationBar];
	lblActualPrice.text		= [NSString stringWithFormat:@"₹%@", self.offersModel.combo_mrp];
	lblOfferPrice.text		=	[NSString stringWithFormat:@"₹%@", self.offersModel.combo_offer_price];
	lblOfferName.text		=	self.offersModel.offerTitle;
	lblValidTill.text			=	[NSString stringWithFormat:@"Valid till %@",self.offersModel.end_date];
	[imgViewOffer sd_setImageWithURL:[NSURL URLWithString:self.offersModel.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		
	}];
	
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;

	self.arrProducts = [[NSMutableArray alloc] init];
	[self getComboDetails];
}
-(void)setNavigationBar
{
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
	titleView.text = self.offersModel.offerTitle;
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
}
-(void)backBtn
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 97;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.arrProducts.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Products";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"comboDetailCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	ProductsModel *product = [self.arrProducts objectAtIndex:indexPath.row];
	UIImageView *imgView		= (UIImageView *)[cell.contentView viewWithTag:100];
	UILabel *lblName				=	(UILabel *)[cell.contentView viewWithTag:101];
	UILabel *lblPrice				=	(UILabel *)[cell.contentView viewWithTag:102];
	
	[imgView sd_setImageWithURL:[NSURL URLWithString:product.product_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		//
	}];
	lblName.text						= product.product_name;
	lblPrice.text						= [NSString stringWithFormat:@"₹%@", product.product_price ];
	
	
	return cell;
}
#pragma mark - Calling Web Service Methods

- (void)getComboDetails
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:self.offersModel.offer_id forKey:kOfferId];
	[self callWebServiceToGetDetails:dict];
}

- (void)callWebServiceToGetDetails:(NSMutableDictionary *)dict
{
	if (![Utils isInternetAvailable])
	{
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetComboDetails withInput:dict withCurrentTask:TASK_GET_COMBO_DETAILS andDelegate:self ];
}

- (void)responseReceived:(id)responseObject
{
	[AppManager stopStatusbarActivityIndicator];
	if([[responseObject objectForKey:kstatus] intValue]==1)
	{
		if(aaramShop_ConnectionManager.currentTask == TASK_GET_COMBO_DETAILS)
		{
			[self parseData:[responseObject objectForKey:@"combo_products"]];
		}
	}
	else
	{
		[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
	}
}
- (void)didFailWithError:(NSError *)error
{
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}

-(void)parseData:(id)data
{
	if(!self.arrProducts)
	{
		self.arrProducts = [[NSMutableArray alloc] init];
	}
	[self.arrProducts removeAllObjects];
	
	for(NSDictionary *dict in data)
	{
		ProductsModel *cmProduct			= [[ProductsModel alloc]init];
		cmProduct.product_id			= [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_id]];
		cmProduct.product_sku_id	=	[NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_sku_id]];
		cmProduct.product_name		=	[NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_name]];
		cmProduct.product_image		=	[NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_image]];
		cmProduct.product_price		=	[NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_price]];
		[self.arrProducts addObject:cmProduct];
	}
	[self.tblView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
