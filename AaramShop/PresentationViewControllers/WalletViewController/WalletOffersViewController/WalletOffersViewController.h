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
#import "WalletOfferTableCell.h"
#import "OffersTableCell.h"
#import "MyCustomOfferTableCell.h"
#import "ComboDetailViewController.h"
@interface WalletOffersViewController : UIViewController<AaramShop_ConnectionManager_Delegate,OffersTableCellDelegate>
{
	
	__weak IBOutlet UITableView *tblView;
	AppDelegate *appDel;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	NSMutableArray *dataSource;
	__weak IBOutlet UIView *subView;
	NSInteger count;
	
}
- (IBAction)btnScan:(id)sender;
@property (weak, nonatomic)CMOffers *offers;
@end
