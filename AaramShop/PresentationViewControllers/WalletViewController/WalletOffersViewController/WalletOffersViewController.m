//
//  WalletOffersViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "WalletOffersViewController.h"

@interface WalletOffersViewController ()<ScanCodeVCDelegate>
{
	ScanCodeViewController *scanCodeVC;
}
@end

@implementation WalletOffersViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	appDel = APP_DELEGATE;
	tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate = self;
	dataSource = [[NSMutableArray alloc] init];
	
	
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	count =0;
}

- (IBAction)btnScan:(id)sender {
	
	
	[self showView];
	
}
- (void)showView
{
	
	scanCodeVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"ScanCodeView"];
	scanCodeVC.delegate = self;
	
	[appDel.window addSubview:scanCodeVC.view];
}
- (void)removeSuperviewWithModel: (CMWalletOffer *)walletOfferModel
{	
	[dataSource insertObject:walletOfferModel atIndex:0];
	[scanCodeVC.view removeFromSuperview];
	scanCodeVC = nil;
	[tblView reloadData];
}
- (void)removeSuperview
{
	[scanCodeVC.view removeFromSuperview];
	scanCodeVC = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CMOffers *cmOffers = [dataSource objectAtIndex: indexPath.row];
	if([cmOffers.offerType isEqualToString:@"6"])
	{
		return 110;
	}
	return 90;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CMOffers *offers = [dataSource objectAtIndex: indexPath.row];
	static NSString *cellIdentifier = nil;
	
	if([offers.offerType isEqualToString:@"6"])
	{
		cellIdentifier = @"CustomOffersCell";
		MyCustomOfferTableCell *cell = (MyCustomOfferTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (cell == nil) {
			cell = [[MyCustomOfferTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		}
		cell.indexPath=indexPath;
		cell.delegate = self;
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
		cell.indexPath=indexPath;
		cell.delegate = self;
		[cell updateCellWithData: offers];
		return cell;
	}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	CMOffers *offers  = [dataSource objectAtIndex:indexPath.row];
	if([offers.offerType isEqualToString:@"4"])
	{
		ComboDetailViewController *comboDetail = (ComboDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"comboDetailController"];
		comboDetail.offersModel = offers;
		[self.navigationController pushViewController:comboDetail animated:YES];
	}
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[tableView setLayoutMargins:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

@end
