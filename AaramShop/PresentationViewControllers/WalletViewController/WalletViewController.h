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
	
	WalletOffersViewController *walletOfferVC;
	PointsViewController *pointsVC;
	
	
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	enWalletSelectedType selectedWallet;

}
@property (strong, nonatomic) IBOutlet UIButton *offersBtn;
@property (strong, nonatomic) IBOutlet UIButton *moneyBtn;
@property (strong, nonatomic) IBOutlet UIButton *pointsBtn;
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) UIButton *btnBack;
- (IBAction)btnOffers:(id)sender;
- (IBAction)btnMoney:(id)sender;
- (IBAction)btnPoints:(id)sender;
@end
