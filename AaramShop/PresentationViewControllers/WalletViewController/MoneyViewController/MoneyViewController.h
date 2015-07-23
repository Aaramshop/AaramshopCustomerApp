//
//  MoneyViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletViewController.h"
#import "CMWalletMoney.h"
#import "MoneyTableCell.h"
@protocol MoneyVCDelegate <NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView onTableView:(UITableView *)tableView;
@end
@interface MoneyViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
	
	__weak IBOutlet UILabel *lblMoney;
	__weak IBOutlet UITableView *tblView;
	int pageno;
	int totalNoOfPages;
	BOOL isLoading;
	
	NSMutableArray *arrMoney;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
}
@property (weak, nonatomic) id <MoneyVCDelegate> delegate;
@end
