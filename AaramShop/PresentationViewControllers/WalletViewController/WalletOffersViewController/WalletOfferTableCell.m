//
//  WalletOfferTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "WalletOfferTableCell.h"

@implementation WalletOfferTableCell
@synthesize lblLine;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateCellWithData:(CMWalletOffer *)walletOfferModel
{
	if ([walletOfferModel.offerType isEqualToString:@"1"])//Discount Offer
	{
		lblbrandName.text = walletOfferModel.product_name;
		[lblLine setHidden:NO];
		lblPrice.text = [NSString stringWithFormat:@"₹%@",walletOfferModel.product_actual_price];
		lblOfferPrice.text = [NSString stringWithFormat:@"₹%@",walletOfferModel.offer_price];
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:walletOfferModel.product_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
	}
	else if([walletOfferModel.offerType isEqualToString:@"4"])//Combo Offer
	{
		lblbrandName.text = walletOfferModel.offerTitle;
		[lblLine setHidden:NO];
		lblPrice.text = [NSString stringWithFormat:@"₹%@",walletOfferModel.combo_mrp];
		lblOfferPrice.text = [NSString stringWithFormat:@"₹%@",walletOfferModel.combo_offer_price];
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:walletOfferModel.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
	}
	else if([walletOfferModel.offerType isEqualToString:@"6"])//Custom Offer
	{
		lblbrandName.text = walletOfferModel.offerTitle;
		lblPrice.text = [NSString stringWithFormat:@"₹%@",walletOfferModel.offer_price];
		lblOfferPrice.text = @"";
		[lblLine setHidden:YES];
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:walletOfferModel.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
	}
	lblValidTill.text	= walletOfferModel.end_date;
}

@end
