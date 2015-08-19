//
//  MoneyViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "MoneyViewController.h"

@interface MoneyViewController ()
{
	WalletViewController *walletVC;
}
@end

@implementation MoneyViewController

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
	[self createDataToGetMoney];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createDataToGetMoney
{
	[self userInteraction:NO];
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:[NSString stringWithFormat:@"%d",pageno] forKey:kPage_no];
	[self performSelector:@selector(callWebServiceToGetMoney:) withObject:dict afterDelay:0.1];
}

- (void)callWebServiceToGetMoney:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[self userInteraction:YES];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kGetMoney withInput:aDict withCurrentTask:TASK_TO_GET_MONEY andDelegate:self];
}
- (void)responseReceived:(id)responseObject
{
	isLoading = NO;
	[self userInteraction:YES];
	[AppManager stopStatusbarActivityIndicator];
	switch (aaramShop_ConnectionManager.currentTask) {
		case TASK_TO_GET_MONEY:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				lblMoney.text = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"total_money"]];
				if ([lblMoney.text intValue]>0) {
					[viewMoney setHidden:NO];
					[tblView setHidden:NO];
					[lblMessage setHidden:YES];
				}
				else
				{
					[viewMoney setHidden:YES];
					[tblView setHidden:YES];
					[lblMessage setHidden:NO];
					break;
				}
				if(pageno==0)
				{
					[self createDataForFirstTimeGet:[self parseData:[responseObject objectForKey:@"money_data"]]];
				}
				else
				{
					[self appendDataForPullUp:[self parseData:[responseObject objectForKey:@"money_data"]]];
				}
				
			}
			[tblView reloadData];
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
	
	
	if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrMoney.count > 0 && scrollView.contentOffset.y>0){
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
		[self createDataToGetMoney];
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

#pragma mark - Parsing Data
-(void)createDataForFirstTimeGet:(NSMutableArray*)array{
	if(!arrMoney)
	{
		arrMoney = [[NSMutableArray alloc] init];
	}
	[arrMoney removeAllObjects];
	for(int i = 0 ; i < [array count];i++)
	{
		CMWalletMoney *walletMoneyModel = [array objectAtIndex:i];
		[arrMoney addObject:walletMoneyModel];
	}
}
-(void)appendDataForPullDown:(NSMutableArray*)array{
	BOOL wasArrayEmpty = NO;
	if ([arrMoney count]==0) {
		arrMoney = [[NSMutableArray alloc]init];
		wasArrayEmpty=YES;
	}
	for(int i = 0 ; i < [array count];i++)
	{
		CMWalletMoney *walletMoneyModel = [array objectAtIndex:i];
		if (wasArrayEmpty) {
			[arrMoney addObject:walletMoneyModel];
		}else
			[arrMoney insertObject:walletMoneyModel atIndex:i];
	}
}
-(void)appendDataForPullUp:(NSMutableArray*)array{
	for(int i = 0 ; i < [array count];i++)
	{
		CMWalletMoney *walletMoneyModel = [array objectAtIndex:i];
		[arrMoney addObject:walletMoneyModel];
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
			CMWalletMoney *walletMoneyModel			=      [[CMWalletMoney alloc] init];
			
			
			walletMoneyModel.store_id			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kOrder_id]];
			walletMoneyModel.store_name			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kOrder_code]];
			walletMoneyModel.due_amount			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_id]];
			walletMoneyModel.store_name			=	[NSString stringWithFormat:@"%@",[dict objectForKey:kStore_name]];
			walletMoneyModel.order_amount			=	[[[NSString stringWithFormat:@"%@",[dict objectForKey:kOrder_amount]] componentsSeparatedByString:@"."]firstObject];
			walletMoneyModel.order_date			=	[Utils stringFromDateForTimeWithAt:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kOrder_date] doubleValue]]];
			
			totalNoOfPages                                           =      [[dict objectForKey:kTotal_page] intValue];
			
			[array addObject:walletMoneyModel];
		}
	}
	return array;
}
#pragma mark - TableView delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return arrMoney.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"MoneyCell";
	
	MoneyTableCell *cell = (MoneyTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[MoneyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	CMWalletMoney *walletMoneyModel = [arrMoney objectAtIndex: indexPath.row];
	cell.indexPath=indexPath;
	[cell updateCellWithData: walletMoneyModel];
	return cell;
}
@end
