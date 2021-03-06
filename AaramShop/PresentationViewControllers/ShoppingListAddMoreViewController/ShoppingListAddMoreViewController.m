//
//  ShoppingListAddMoreViewController.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListAddMoreViewController.h"

#define kTableCellHeight    70


@interface ShoppingListAddMoreViewController ()<UIAlertViewDelegate>

@end

@implementation ShoppingListAddMoreViewController
@synthesize aaramShop_ConnectionManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = APP_DELEGATE;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!_arrProductList)
    {
        _arrProductList = [[NSMutableArray alloc]init];
    }
    
    [self setNavigationBar];
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;
    
    
    tblView.backgroundColor = [UIColor whiteColor];
    
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"AddedShoppingListProducts"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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
    titleView.text = @"Add more product";
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

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)btnDoneClicked
{
    [self.view endEditing:YES];
    
	__block NSString *strProductID				=	@"";
	__block NSString *strQuantity					=	@"";
	__block NSString *strIsStoreProducts		=	@"";
	NSArray *array		=	[_arrProductList valueForKey:@"product_id"];
	strProductID			=	[array componentsJoinedByString:@","];
	array						=	[_arrProductList valueForKey:@"strCount"];
	strQuantity				=	[array componentsJoinedByString:@","];
	array						=	[_arrProductList valueForKey:@"isStoreProduct"];
	strIsStoreProducts	=	[array componentsJoinedByString:@","];
	
	if([strProductID length]==0)
	{
		[Utils showAlertView:kAlertTitle message:@"Add Product(s)" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	else
	{
		NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
		[dict setObject:strProductID forKey:@"productId"];
		[dict setObject:strQuantity forKey:@"quantity"];
		[dict setObject:strIsStoreProducts forKey:@"isStoreProducts"];
		[dict setObject:_strShoppingListId forKey:@"shoppingListId"];
		[self callWebServiceToUpdateShoppingList:dict];
	}
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
    return _arrProductList.count;
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
    
    [cell updateCell:[_arrProductList objectAtIndex:indexPath.row]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Cell Delegates

-(void)addProduct:(NSIndexPath *)indexPath
{
    ProductsModel *productModel = [_arrProductList objectAtIndex:indexPath.row];
    
//    int counter = [productModel.quantity intValue];
    
    int counter = [productModel.strCount intValue];

    
    counter++;
    
//    productModel.quantity = [NSString stringWithFormat:@"%d",counter];
    productModel.strCount = [NSString stringWithFormat:@"%d",counter];

    
    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)removeProduct:(NSIndexPath *)indexPath
{
    ProductsModel *productModel = [_arrProductList objectAtIndex:indexPath.row];
    int counter = [productModel.strCount intValue];
    counter--;
    productModel.strCount = [NSString stringWithFormat:@"%d",counter];
	if (counter == 0) {
		if ([_arrProductList count] == 1) {
			[Utils showAlertView:kAlertTitle message:@"This product cant be removed. Please add a new product 1st or delete the list from main menu." delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
			counter++;
			productModel.strCount = [NSString stringWithFormat:@"%d",counter];
			[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
		}
		else
		{
			[_arrProductList removeObjectAtIndex:indexPath.row];
			[tblView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
	else
	{
		 [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
	}
}




-(void)doSearch
{
    searchViewController = (SearchViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController" ];
    [searchViewController setDelegate:self];
	searchViewController.store	=	self.store;
    [appDel.window addSubview:searchViewController.view];
    
}

-(void)removeSearchViewFromParentView{
    [searchViewController.view removeFromSuperview];
}



-(void)openSearchedUserPrroductFor:(ProductsModel *)product
{
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"product_sku_id like[cd]  %@",product.product_sku_id];
    
    NSArray *aFilteredObjects = [_arrProductList filteredArrayUsingPredicate: aPredicate];
    
    if (aFilteredObjects && aFilteredObjects.count > 0) {
        //already exist
        [Utils showAlertView:kAlertTitle message:@"This Product is already being added " delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else{
        //add new product
        
//        product.quantity = @"1";
        product.strCount = @"1";

        
        [_arrProductList insertObject:product atIndex:0];
        
    }
    
    [tblView reloadData];
    
}


-(void)addProductIfNeeded:(NSDictionary *)inDic{
    
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"product_sku_id like[cd]  %@",[inDic objectForKey: @"product_sku_id"]];
    
    NSArray *aFilteredObjects = [_arrProductList filteredArrayUsingPredicate: aPredicate];
    
    if (aFilteredObjects && aFilteredObjects.count > 0) {
        //already exist
        [Utils showAlertView:kAlertTitle message:@"This Product is already being added " delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else{
        //add new product
        [_arrProductList insertObject:inDic atIndex:0];
        
    }
    
    [tblView reloadData];
    
}


-(IBAction)actionSearch:(id)sender
{
    [self doSearch];
}


///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////



#pragma mark - Call Webservice

-(void)callWebServiceToUpdateShoppingList:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kURLUpdateShoppingListProducts withInput:aDict withCurrentTask:TASK_TO_UPDATE_SHOPPING_LIST andDelegate:self ];
}

-(void) didFailWithError:(NSError *)error
{
    [aaramShop_ConnectionManager failureBlockCalled:error];
}

-(void) responseReceived:(id)responseObject
{
    switch (aaramShop_ConnectionManager.currentTask)
    {
        case TASK_TO_UPDATE_SHOPPING_LIST:
        {
            
            if ([[responseObject objectForKey:kstatus] intValue] == 1)
            {
                [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex) {
		
	}
	else
	{
		[_arrProductList removeObjectAtIndex:inIndexPath.row];
		[self btnDoneClicked];
	}
}


@end
