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
	cmWalletOffer = walletOfferModel;
	
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
	count ++;
	if(count > 3)
	{
		return 1;
	}
	else
		return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *cellIdentifier = @"WalletOfferCell";
	
	WalletOfferTableCell *cell = (WalletOfferTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[WalletOfferTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
		[cell updateCellWithData: cmWalletOffer];
	
	return cell;
	
}

@end
