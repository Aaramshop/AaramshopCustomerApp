//
//  WalletOffersViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanCodeViewController.h"
#import "CMOffers.h"
#import "OffersTableCell.h"
#import "MyCustomOfferTableCell.h"
#import "ComboDetailViewController.h"
@protocol OffersVCDelegate <NSObject>
@optional
- (void)callWebService;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView onTableView:(UITableView *)tableView;

@end
@interface WalletOffersViewController : UIViewController<AaramShop_ConnectionManager_Delegate,OffersTableCellDelegate>
{
	
	__weak IBOutlet UITableView *tblView;
	AppDelegate *appDel;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	NSMutableArray *dataSource;
	int pageno;
	int totalNoOfPages;
	BOOL isLoading;
	
}
- (IBAction)btnScan:(id)sender;
@property (weak, nonatomic) id <OffersVCDelegate> delegate;
@property (weak, nonatomic)CMOffers *offers;
@end
