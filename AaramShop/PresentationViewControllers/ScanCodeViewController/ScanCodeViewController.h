//
//  ScanCodeViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 31/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMWalletOffer.h"
#import "WalletOffersViewController.h"
@protocol ScanCodeVCDelegate <NSObject>

-(void)removeSuperviewWithModel: (CMWalletOffer *)walletOfferModel;
-(void)removeSuperview;

@end
@interface ScanCodeViewController : UIViewController
{
	NSInteger count;
	BOOL isQrCode;
}
@property (weak, nonatomic)id<ScanCodeVCDelegate>delegate;
@end
