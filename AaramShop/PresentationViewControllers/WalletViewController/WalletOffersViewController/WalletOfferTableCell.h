//
//  WalletOfferTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMWalletOffer.h"
@interface WalletOfferTableCell : UITableViewCell
{
	__weak IBOutlet UIImageView *imgBrandLogo;
	__weak IBOutlet UILabel *lblOfferPrice;
	__weak IBOutlet UILabel *lblPrice;
	__weak IBOutlet UILabel *lblbrandName;
	__weak IBOutlet UILabel *lblValidTill;
}
@property (nonatomic, strong)	IBOutlet UILabel *lblLine;
@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)updateCellWithData:(CMWalletOffer *)walletOfferModel;
@end
