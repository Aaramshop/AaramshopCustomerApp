//
//  WalletViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "WalletViewController.h"

@interface WalletViewController ()

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate = self;
	
	[self setupAllViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupAllViews
{
	//Calling WalletOffersViewController
	walletOfferVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"WalletOfferViewScene"];
//	walletOfferVC.delegate  = self;
	CGRect walletOfferRect = subView.bounds;
	walletOfferVC.view.frame = walletOfferRect;
	[walletOfferVC.view setHidden:YES];
	[subView addSubview:walletOfferVC.view];
	
	
	//Calling MoneyViewController
	moneyVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewScene"];
//	moneyVC.delegate = self;
	CGRect moneyViewRect = subView.bounds;
	moneyVC.view.frame = moneyViewRect;
	[moneyVC.view setHidden:YES];
	[subView addSubview:moneyVC.view];
	
	
	//Calling PointsViewController
	pointsVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"PointsViewScene"];
//	pointsVC.delegate = self;
	CGRect pointsViewRect = subView.bounds;
	pointsVC.view.frame = pointsViewRect;
	[subView addSubview:pointsVC.view];
	
	
}

- (IBAction)btnOffers:(id)sender {
	[offersBtn setSelected:![offersBtn isSelected]];
	[self setSideBtnState: eSelectedWalletOffer];
	selectedWallet = eSelectedWalletOffer;
	
}

- (IBAction)btnMoney:(id)sender {
	[moneyBtn setSelected:![moneyBtn isSelected]];
	[self setSideBtnState: eSelectedAaramMoney];
	selectedWallet = eSelectedAaramMoney;
}

- (IBAction)btnPoints:(id)sender {
	[pointsBtn setSelected:![pointsBtn isSelected]];
	[self setSideBtnState: eSelectedPoints];
	selectedWallet = eSelectedPoints;
}

#pragma mark - custom method for button state
-(void)setSideBtnState:(enWalletSelectedType)inSelectedState
{
	switch (inSelectedState)
	{
		case eSelectedPoints:
		{
			[pointsBtn setSelected: YES];
			[moneyBtn setSelected:NO];
			[offersBtn setSelected:NO];
			[pointsVC.view setHidden:NO];
			[moneyVC.view setHidden:YES];
			[walletOfferVC.view setHidden:YES];
		}
			break;
			
		case eSelectedAaramMoney:
		{
			[pointsBtn setSelected: NO];
			[moneyBtn setSelected:YES];
			[offersBtn setSelected:NO];
			[pointsVC.view setHidden:YES];
			[moneyVC.view setHidden:NO];
			[walletOfferVC.view setHidden:YES];
		}
			break;
		case eSelectedWalletOffer:
		{
			[pointsBtn setSelected: NO];
			[moneyBtn setSelected:NO];
			[offersBtn setSelected:YES];
			[pointsVC.view setHidden:YES];
			[moneyVC.view setHidden:YES];
			[walletOfferVC.view setHidden:NO];
		}
			break;
		default:
			break;
	}
}

@end
