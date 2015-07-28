//
//  OffersTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 14/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OffersTableCell.h"

@implementation OffersTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateCellWithData: (CMOffers *)offers
{
//	[lblLine setHidden:YES];
	imgViewArrow.hidden = YES;
	
	
	if ([offers.offerType isEqualToString:@"1"])//Discount Offer
	{
		lblbrandName.text = offers.product_name;
		[lblLine setHidden:NO];
		lblPrice.text = [NSString stringWithFormat:@"₹%@",offers.product_actual_price];
		lblOfferPrice.text = [NSString stringWithFormat:@"₹%@",offers.offer_price];
		
		NSLog(@"\n actual price => %@",offers.product_actual_price);
		NSLog(@"\n offer price => %@",offers.offer_price);
		
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:offers.product_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
		
	}
	else if([offers.offerType isEqualToString:@"4"])//Combo Offer
	{
		lblbrandName.text = offers.offerTitle;
				[lblLine setHidden:NO];
		lblPrice.text = [NSString stringWithFormat:@"₹%@",offers.combo_mrp];
		lblOfferPrice.text = [NSString stringWithFormat:@"₹%@",offers.combo_offer_price];
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:offers.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
		imgViewArrow.hidden = NO;
	}
	else if([offers.offerType isEqualToString:@"5"])//Overall Offer
	{
		lblbrandName.text = offers.offerTitle;
		lblPrice.text = [NSString stringWithFormat:@"₹%@",offers.overall_purchase_value];
		[lblLine setHidden:YES];

		lblOfferPrice.text = [NSString stringWithFormat:@"%@ %%",offers.discount_percentage];
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:offers.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
	}
	else if([offers.offerType isEqualToString:@"6"])//Custom Offer
	{
		lblbrandName.text = offers.offerTitle;
		lblPrice.text = [NSString stringWithFormat:@"₹%@",offers.offer_price];
		lblOfferPrice.text = @"";
		[lblLine setHidden:YES];
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:offers.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
	}
	lblValidTill.text	= offers.end_date;
}
@end
