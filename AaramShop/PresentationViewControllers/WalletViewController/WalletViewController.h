//
//  WalletViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletOffersViewController.h"
#import "PointsViewController.h"
#import "MoneyViewController.h"
typedef enum
{
	eSelectedPoints=0,
	eSelectedAaramMoney,
	eSelectedWalletOffer
	
}enWalletSelectedType;
@interface WalletViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
	__weak IBOutlet UIButton *offersBtn;
	__weak IBOutlet UIButton *moneyBtn;
	__weak IBOutlet UIButton *pointsBtn;
	__weak IBOutlet UIView *subView;
	WalletOffersViewController *walletOfferVC;
	PointsViewController *pointsVC;
	MoneyViewController *moneyVC;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	enWalletSelectedType selectedWallet;

}
- (IBAction)btnOffers:(id)sender;
- (IBAction)btnMoney:(id)sender;
- (IBAction)btnPoints:(id)sender;
@end
