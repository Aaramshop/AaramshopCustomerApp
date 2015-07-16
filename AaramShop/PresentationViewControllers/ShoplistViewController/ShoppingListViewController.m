//
//  ShoplistViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "CreateNewShoppingListViewController.h"
#import "ShoppingListDetailViewController.h"

#define kTableCellHeight	95

@interface ShoppingListViewController ()
{
	AppDelegate *appDeleg;
}
@end

@implementation ShoppingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    arrShoppingList = [[NSMutableArray alloc]init];
    self.sideBar = [Utils createLeftBarWithDelegate:self];
	appDeleg = APP_DELEGATE;
    [self setNavigationBar];
    
    tblView.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = NO;

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
	return 20;//arrShoppingList.count;
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
//	cell.indexPath = indexPath;
//	cell.delegateFoodList = self;
//	
//	[cell updateFoodListCell:arrProductsModel];
	
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

@end
