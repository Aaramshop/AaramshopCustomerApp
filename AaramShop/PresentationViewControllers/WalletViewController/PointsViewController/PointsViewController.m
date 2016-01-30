//
//  PointsViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PointsViewController.h"
#import "WalletViewController.h"
@interface PointsViewController ()
{
	WalletViewController *walletVC;
}
@end

@implementation PointsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
	totalNoOfPages = 0;
	pageno = 0;
	isLoading = NO;
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate = self;
	walletVC = [[WalletViewController alloc] init];
	strAaramPoints = @"";
	strBonusPoints = @"";
	strBrandPoints = @"";
	
	[self getPoints];
	selectedPointsType = eSelectedPointsTypeNone;
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"WalletPoints"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
#pragma mark - TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	switch (section) {
		case 0:
		{
			switch (selectedPointsType) {
				case eAaramPoints:
					return arrTemp.count;
					break;
					
				default:
					return 0;
					break;
			}
		}
			break;
		case 1:
		{
			switch (selectedPointsType) {
				case eBonusPoints:
					return arrTemp.count;
					break;
					
				default:
					return 0;
					break;
			}
		}
			break;
		case 2:
		{
			switch (selectedPointsType) {
				case eBrandPoints:
					return arrTemp.count;
					break;
					
				default:
					return 0;
					break;
			}
		}
			break;
		default:
			return 0;
			break;
	}
	
	
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 52;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case eAaramPoints:
		{
			UIView * secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 52)];
			UILabel *lblSeprator = [[ UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
			lblSeprator.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f  blue:232/255.0f  alpha:1.0f];
			
			lblPointsName = [[UILabel alloc] initWithFrame:CGRectMake(12, (secView.frame.size.height - 21)/2, [[UIScreen mainScreen] bounds].size.width - 24, 21)];
			lblPointsName.font = [UIFont fontWithName:kRobotoRegular size:14];
			lblPointsName.textColor = [UIColor colorWithRed:44/255.0f green:44/255.0f blue:44/255.0f alpha:1.0f];
			lblPointsName.textAlignment = NSTextAlignmentLeft;
			lblPointsName.text = @"Aaram Points";
			UIImage *imgPlus = [UIImage imageNamed:@"addBtnCircleGrey"];
            
            UIImageView* imgVPlus=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-30 , (secView.frame.size.height - 25)/2,25,25)];
            UIImageView* imgVMinus=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-30 , (secView.frame.size.height - 25)/2,25,25)];
          
            
            
            
			UIImage *imgMinus = [UIImage imageNamed:@"minusBtnCircleRed"];
			
			UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
			plusBtn.frame = CGRectMake(12, (secView.frame.size.height - 25)/2, [[UIScreen mainScreen] bounds].size.width - 12, 25);
			plusBtn.tag = 101;
			if(selectedPointsType == eAaramPoints)
			{
                imgVMinus.image=imgMinus;
				//[plusBtn setImage:imgMinus forState:UIControlStateNormal];
				secView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
			}
			else
			{
                imgVPlus.image=imgPlus;
				//[plusBtn setImage:imgPlus forState:UIControlStateNormal];
				secView.backgroundColor = [UIColor whiteColor];
			}
			[plusBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -([UIScreen mainScreen].bounds.size.width-50))];
			[plusBtn addTarget:self action:@selector(expandTable:) forControlEvents:UIControlEventTouchUpInside];
			
			UILabel *lblAmount = [[UILabel alloc] initWithFrame:CGRectMake(plusBtn.frame.size.width - 25 - 100, (secView.frame.size.height - 21)/2, 100, 21)];
			
			lblAmount.textColor = [UIColor colorWithRed:101/255.0f green:101/255.0f blue:101/255.0f alpha:1.0f];
			lblAmount.text = [NSString stringWithFormat:@"%@",strAaramPoints];
			lblAmount.font = [UIFont fontWithName:kRobotoRegular size:14.0f];
			UILabel *lblSeprator2 = [[ UILabel alloc] initWithFrame:CGRectMake(0, secView.frame.size.height - 1, [[UIScreen mainScreen] bounds].size.width, 1)];
			lblAmount.textAlignment = NSTextAlignmentRight;
			lblSeprator2.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f  blue:232/255.0f  alpha:1.0f];
			[secView addSubview:lblSeprator];
			
			[secView addSubview:lblPointsName];
			[secView addSubview:plusBtn];
			[secView addSubview:lblAmount];
			[secView addSubview:lblSeprator2];
			
            [secView addSubview:imgVPlus];
            [secView addSubview:imgVMinus];
            
			return secView;
		}
			break;
		case eBonusPoints:
		{
			UIView * secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 52)];
			UILabel *lblSeprator = [[ UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
			lblSeprator.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f  blue:232/255.0f  alpha:1.0f];
			
			lblPointsName = [[UILabel alloc] initWithFrame:CGRectMake(12, (secView.frame.size.height - 21)/2, [[UIScreen mainScreen] bounds].size.width - 24, 21)];
			lblPointsName.font = [UIFont fontWithName:kRobotoRegular size:14];
			lblPointsName.textColor = [UIColor colorWithRed:44/255.0f green:44/255.0f blue:44/255.0f alpha:1.0f];
			lblPointsName.textAlignment = NSTextAlignmentLeft;
			lblPointsName.text = @"Bonus Points";
			UIImage *imgPlus = [UIImage imageNamed:@"addBtnCircleGrey"];
            UIImageView* imgVPlus=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-30 , (secView.frame.size.height - 25)/2,25,25)];
            UIImageView* imgVMinus=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-30 , (secView.frame.size.height - 25)/2,25,25)];
            
			UIImage *imgMinus = [UIImage imageNamed:@"minusBtnCircleRed"];
			
			UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
			plusBtn.frame = CGRectMake(12, (secView.frame.size.height - 25)/2, [[UIScreen mainScreen] bounds].size.width - 10, 25);
			plusBtn.tag = 102;
			if(selectedPointsType == eBonusPoints)
			{
				imgVMinus.image=imgMinus;
                //[plusBtn setImage:imgMinus forState:UIControlStateNormal];
				secView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
			}
			else
			{
                 imgVPlus.image=imgPlus;
				//[plusBtn setImage:imgPlus forState:UIControlStateNormal];
				secView.backgroundColor = [UIColor whiteColor];
			}
			[plusBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -([UIScreen mainScreen].bounds.size.width-50))];
			[plusBtn addTarget:self action:@selector(expandTable:) forControlEvents:UIControlEventTouchUpInside];
			
			UILabel *lblAmount = [[UILabel alloc] initWithFrame:CGRectMake(plusBtn.frame.size.width - 25 - 100, (secView.frame.size.height - 21)/2, 100, 21)];
			
			lblAmount.textColor = [UIColor colorWithRed:101/255.0f green:101/255.0f blue:101/255.0f alpha:1.0f];
			lblAmount.textAlignment = NSTextAlignmentRight;
			lblAmount.text = [NSString stringWithFormat:@"%@",strBonusPoints];
			lblAmount.font = [UIFont fontWithName:kRobotoRegular size:14.0f];
			UILabel *lblSeprator2 = [[ UILabel alloc] initWithFrame:CGRectMake(0, secView.frame.size.height - 1, [[UIScreen mainScreen] bounds].size.width, 1)];
			lblSeprator2.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f  blue:232/255.0f  alpha:1.0f];
			[secView addSubview:lblSeprator];
			
			[secView addSubview:lblPointsName];
			[secView addSubview:plusBtn];
			[secView addSubview:lblAmount];
			[secView addSubview:lblSeprator2];
			
             [secView addSubview:imgVPlus];
             [secView addSubview:imgVMinus];
            
			return secView;
		}
			break;
		case eBrandPoints:
		{
			UIView * secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 52)];
			UILabel *lblSeprator = [[ UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
			lblSeprator.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f  blue:232/255.0f  alpha:1.0f];
			
			lblPointsName = [[UILabel alloc] initWithFrame:CGRectMake(12, (secView.frame.size.height - 21)/2, [[UIScreen mainScreen] bounds].size.width - 24, 21)];
			lblPointsName.font = [UIFont fontWithName:kRobotoRegular size:14];
			lblPointsName.textColor = [UIColor colorWithRed:44/255.0f green:44/255.0f blue:44/255.0f alpha:1.0f];
			lblPointsName.textAlignment = NSTextAlignmentLeft;
			lblPointsName.text = @"Brand Points";
			UIImage *imgPlus = [UIImage imageNamed:@"addBtnCircleGrey"];
            UIImageView* imgVPlus=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-30 , (secView.frame.size.height - 25)/2,25,25)];
            UIImageView* imgVMinus=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-30 , (secView.frame.size.height - 25)/2,25,25)];
            
			UIImage *imgMinus = [UIImage imageNamed:@"minusBtnCircleRed"];
			
			UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
			plusBtn.frame = CGRectMake(12, (secView.frame.size.height - 25)/2, [[UIScreen mainScreen] bounds].size.width - 10, 25);
			plusBtn.tag = 103;
			if(selectedPointsType == eBrandPoints)
			{
                imgVMinus.image=imgMinus;
				//[plusBtn setImage:imgMinus forState:UIControlStateNormal];
				secView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
			}
			else
			{
                 imgVPlus.image=imgPlus;
				//[plusBtn setImage:imgPlus forState:UIControlStateNormal];
				secView.backgroundColor = [UIColor whiteColor];
			}
			[plusBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -([UIScreen mainScreen].bounds.size.width-50))];
			[plusBtn addTarget:self action:@selector(expandTable:) forControlEvents:UIControlEventTouchUpInside];
			
			UILabel *lblAmount = [[UILabel alloc] initWithFrame:CGRectMake(plusBtn.frame.size.width - 25 -100, (secView.frame.size.height - 21)/2, 100, 21)];
			
			lblAmount.textColor = [UIColor colorWithRed:101/255.0f green:101/255.0f blue:101/255.0f alpha:1.0f];
			lblAmount.textAlignment = NSTextAlignmentRight;
			lblAmount.text = [NSString stringWithFormat:@"%@",strBrandPoints];
			lblAmount.font = [UIFont fontWithName:kRobotoRegular size:14.0f];
			UILabel *lblSeprator2 = [[ UILabel alloc] initWithFrame:CGRectMake(0, secView.frame.size.height - 1, [[UIScreen mainScreen] bounds].size.width, 1)];
			lblSeprator2.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f  blue:232/255.0f  alpha:1.0f];
			[secView addSubview:lblSeprator];
			
			[secView addSubview:lblPointsName];
			[secView addSubview:plusBtn];
			[secView addSubview:lblAmount];
			[secView addSubview:lblSeprator2];
			
             [secView addSubview:imgVPlus];
             [secView addSubview:imgVMinus];
            
			return secView;
		}
			break;
		default:
			return nil;
			break;
	}
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"PointsCell";
	
	PointsTableCell *cell = (PointsTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[PointsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	CMWalletPoints *cmWalletPoints = [arrTemp objectAtIndex: indexPath.row];
	cell.indexPath=indexPath;
	[cell updateCellWithData: cmWalletPoints];
	return cell;
}

- (void)getPoints
{
	[self userInteraction:NO];
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[self performSelector:@selector(callWebServiceToGetPoints:) withObject:dict afterDelay:0.1];
}

- (void)callWebServiceToGetPoints:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[self userInteraction:YES];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetPoints withInput:aDict withCurrentTask:TASK_GET_WALLET_POINTS andDelegate:self];
}
- (void)responseReceived:(id)responseObject
{
	[self userInteraction:YES];
	[AppManager stopStatusbarActivityIndicator];
	switch (aaramShop_ConnectionManager.currentTask) {
		case TASK_GET_WALLET_POINTS:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				lblPoint.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"total_points"]];
				strBrandPoints = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"total_brand_points"]];
				strAaramPoints = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"total_aaram_points"]];
				strBonusPoints = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"total_bonus_points"]];
				[tblView reloadData];
			}
		}
			break;
		case TASK_TO_GET_AARAM_POINTS:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				[arrTemp removeAllObjects];
				if(pageno==0)
				{
					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:kAaramPointsDetails]]];
				}
				else
				{
					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:kAaramPointsDetails]]];
				}
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eAaramPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
		}
			break;
		case TASK_TO_GET_BONUS_POINTS:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				[arrTemp removeAllObjects];
				if(pageno==0)
				{
					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:kBonus_points]]];
				}
				else
				{
					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:kBonus_points]]];
				}
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eBonusPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
		}
			break;
		case TASK_TO_GET_BRAND_POINTS:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				[arrTemp removeAllObjects];
				if(pageno==0)
				{
					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:kBrandPointsDetails]]];
				}
				else
				{
					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:kBrandPointsDetails]]];
				}
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eBrandPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
		}
			break;
		default:
			break;
	}
	
}
- (void)didFailWithError:(NSError *)error
{
	[self userInteraction:YES];
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}
- (void)userInteraction:(BOOL)enable
{
	[walletVC.offersBtn setUserInteractionEnabled:enable];
	[walletVC.pointsBtn setUserInteractionEnabled:enable];
	[walletVC.moneyBtn setUserInteractionEnabled:enable];
	[walletVC.subView setUserInteractionEnabled:enable];
	[walletVC.btnBack setUserInteractionEnabled:enable];
}






#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	//To do Call the parent delegates
	
	if ([_delegate respondsToSelector:@selector(scrollViewDidScroll:onTableView:)]) {
		[_delegate scrollViewDidScroll:scrollView onTableView:tblView];
	}
	
	
	if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrTemp.count > 0 && scrollView.contentOffset.y>0){
		if (!isLoading) {
			isLoading=YES;
			[self showFooterLoadMoreActivityIndicator:YES];
			[self performSelector:@selector(calledPullUp) withObject:nil afterDelay:0.5 ];
		}
	}
	
}

-(void)calledPullUp
{
	if(totalNoOfPages>pageno+1)
	{
		pageno++;
		switch (selectedPointsType) {
			case eAaramPoints:
				[self createDataToGetAaramPoints];
				break;
			case eBonusPoints:
				[self createDataToGetBonusPoints];
				break;
			case eBrandPoints:
				[self createDataToGetBrandPoints];
				break;
			default:
				break;
		}
		
		
	}
	else
	{
		isLoading = NO;
		[self showFooterLoadMoreActivityIndicator:NO];
	}
}
- (void)createDataToGetAaramPoints
{
	[self userInteraction:NO];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
	[self performSelector:@selector(callWebservicesToGetAaramPoints:) withObject:dict afterDelay:0.1];
}

- (void)callWebservicesToGetAaramPoints:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[self userInteraction:YES];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetAaramPoints withInput:aDict withCurrentTask:TASK_TO_GET_AARAM_POINTS andDelegate:self ];
}
- (void)createDataToGetBonusPoints
{
	[self userInteraction:NO];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
	[self performSelector:@selector(callWebservicesToGetBonusPoints:) withObject:dict afterDelay:0.1];
}

- (void)callWebservicesToGetBonusPoints:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[self userInteraction:YES];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetBonusPoints withInput:aDict withCurrentTask:TASK_TO_GET_BONUS_POINTS andDelegate:self ];
}
- (void)createDataToGetBrandPoints
{
	[self userInteraction:NO];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
	[self performSelector:@selector(callWebservicesToGetBrandPoints:) withObject:dict afterDelay:0.1];
}

- (void)callWebservicesToGetBrandPoints:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[self userInteraction:YES];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetBrandPoints withInput:aDict withCurrentTask:TASK_TO_GET_BRAND_POINTS andDelegate:self ];
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

#pragma mark - Parsing Data
-(void)createDataForFirstTimeGet:(NSMutableArray*)array{
	if(!arrTemp)
	{
		arrTemp = [[NSMutableArray alloc] init];
	}
	[arrTemp removeAllObjects];
	for(int i = 0 ; i < [array count];i++)
	{
		CMWalletPoints *walletPointsModel = [array objectAtIndex:i];
		[arrTemp addObject:walletPointsModel];
	}
}
-(void)appendDataForPullDown:(NSMutableArray*)array{
	BOOL wasArrayEmpty = NO;
	if ([arrTemp count]==0) {
		arrTemp = [[NSMutableArray alloc]init];
		wasArrayEmpty=YES;
	}
	for(int i = 0 ; i < [array count];i++)
	{
		CMWalletPoints *walletPointsModel = [array objectAtIndex:i];
		if (wasArrayEmpty) {
			[arrTemp addObject:walletPointsModel];
		}else
			[arrTemp insertObject:walletPointsModel atIndex:i];
	}
}
-(void)appendDataForPullUp:(NSMutableArray*)array{
	for(int i = 0 ; i < [array count];i++)
	{
		CMWalletPoints *walletPointsModel = [array objectAtIndex:i];
		[arrTemp addObject:walletPointsModel];
	}
}

- (NSMutableArray *)parseData:(id)data
{
	NSMutableArray *array = [[NSMutableArray alloc]init];
	if([data count]>0)
	{
		for(int i =0 ; i < [data count] ; i++)
		{
			NSDictionary *dict = [data objectAtIndex:i];
			CMWalletPoints *walletPointsModel			=      [[CMWalletPoints alloc] init];
			
			
			walletPointsModel.order_id			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kOrder_id]];
			walletPointsModel.order_code			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kOrder_code]];
			walletPointsModel.store_id			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_id]];
			walletPointsModel.store_name			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_name]];
			walletPointsModel.point			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kPoint]];
			walletPointsModel.order_amount			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kOrder_amount]];
			
			
			
			
			walletPointsModel.product_name			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_name]];
			walletPointsModel.product_id			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_id]];
			walletPointsModel.brand_name			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kBrand_name]];
			walletPointsModel.quantity			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kQuantity]];
			
			totalNoOfPages                                           =      [[dict objectForKey:kTotal_page] intValue];
			
			[array addObject:walletPointsModel];
		}
	}
	return array;
}
- (IBAction)expandTable:(id)sender
{
	UIButton *btn = (UIButton *)sender;
	switch (btn.tag) {
  case 101:
		{
			if(selectedPointsType == eAaramPoints)
			{
				selectedPointsType = eSelectedPointsTypeNone;
				[arrTemp removeAllObjects];
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eAaramPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
			else if (selectedPointsType == eBrandPoints)
			{
				selectedPointsType = eAaramPoints;
				[arrTemp removeAllObjects];
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eBrandPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
				[self createDataToGetAaramPoints];
			}
			else
			{
				selectedPointsType = eAaramPoints;
				[arrTemp removeAllObjects];
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eBonusPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
				[self createDataToGetAaramPoints];
			}
		}
			break;
		case 102:
		{
			if(selectedPointsType == eBonusPoints)
			{
				selectedPointsType = eSelectedPointsTypeNone;
				[arrTemp removeAllObjects];
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eBonusPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
			else if (selectedPointsType == eAaramPoints)
			{
				selectedPointsType = eBonusPoints;
				[arrTemp removeAllObjects];
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eAaramPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
				[self createDataToGetBonusPoints];
			}
			else
			{
				selectedPointsType = eBonusPoints;
				[arrTemp removeAllObjects];
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eBrandPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
				[self createDataToGetBonusPoints];
				
			}
		}
			break;
		case 103:
		{
			if(selectedPointsType == eBrandPoints)
			{
				selectedPointsType = eSelectedPointsTypeNone;
				[arrTemp removeAllObjects];
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eBrandPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
			else if (selectedPointsType == eBonusPoints)
			{
				selectedPointsType = eBrandPoints;
				[arrTemp removeAllObjects];
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eBonusPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
				[self createDataToGetBrandPoints];
			}
			else
			{
				selectedPointsType = eBrandPoints;
				[arrTemp removeAllObjects];
				[tblView reloadSections:[NSIndexSet indexSetWithIndex:eAaramPoints] withRowAnimation:UITableViewRowAnimationAutomatic];
				[self createDataToGetBrandPoints];
			}
		}
			break;
  default:
			break;
	}
	//	[tblView reloadData];
}
@end
