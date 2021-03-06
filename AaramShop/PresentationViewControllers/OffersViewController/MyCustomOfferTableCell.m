//
//  MyCustomOfferTableCell.m
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 15/06/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import "MyCustomOfferTableCell.h"
@implementation MyCustomOfferTableCell

@synthesize btnRemove;
@synthesize btnAdd;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
	[super layoutSubviews];

}


-(void)updateCellWithData:(CMOffers  *)offers
{
//	if ([cmMyOffers.offerType isEqualToString:@"1"])//Discount Offer
//	{
//		lblbrandName.text = cmMyOffers.product_name;
//		[lblLine setHidden:NO];
//		lblPrice.text = [NSString stringWithFormat:@"₹%@",cmMyOffers.product_actual_price];
//		lblOfferPrice.text = [NSString stringWithFormat:@"₹%@",cmMyOffers.offer_price];
//		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:cmMyOffers.product_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//			
//		}];
//		
//	}
//	else if([cmMyOffers.offerType isEqualToString:@"4"])//Combo Offer
//	{
//		lblbrandName.text = cmMyOffers.offerTitle;
//		[lblLine setHidden:NO];
//		lblPrice.text = [NSString stringWithFormat:@"₹%@",cmMyOffers.combo_mrp];
//		lblOfferPrice.text = [NSString stringWithFormat:@"₹%@",cmMyOffers.combo_offer_price];
//		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:cmMyOffers.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//			
//		}];
//	}
//	else if([cmMyOffers.offerType isEqualToString:@"5"])//Overall Offer
//	{
//		lblLine.hidden = YES;
//		lblbrandName.text = cmMyOffers.offerTitle;
//		lblPrice.text = [NSString stringWithFormat:@"₹%@",cmMyOffers.overall_purchase_value];
//		lblOfferPrice.text = [NSString stringWithFormat:@"%@%% off",cmMyOffers.discount_percentage];
//		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:cmMyOffers.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//			
//		}];
//	}
//	else if([cmMyOffers.offerType isEqualToString:@"6"])//Custom Offer
//	{
    
        lblStoreName.text = offers.store_name; // added on 17 Sep 2015 ...
    
		lblbrandName.text = offers.offerTitle;
		lblPrice.text = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol],offers.offer_price];
		lblOfferPrice.text = @"";
		lblDescription.text = offers.offerDescription;
		[lblLine setHidden:YES];
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:offers.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
//	}
	if ([offers.strCount intValue]<=0) {
		btnRemove.enabled=NO;
	}
	else
		btnRemove.enabled = YES;
	if([offers.strCount intValue]==20)
	{
		btnAdd.enabled=NO;
	}
	else
	{
		btnAdd.enabled = YES;
	}
    
    
    //// updated on 05 Nov 2015 ... begins // due to data inconsistency in model
    if ([offers.end_date rangeOfString:@"-"].location == NSNotFound)
    {
        lblValidTill.text	= [NSString stringWithFormat:@"Valid till %@",offers.end_date];
    }
    else
    {
//        NSString *strEndDate = [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[offers.end_date doubleValue]]]; // added on 23 Oct 2015
        lblValidTill.text	= [NSString stringWithFormat:@"Valid till %@",offers.end_date];
    }
    //// updated on 05 Nov 2015 ... ends ....

    
//	lblValidTill.text	= [NSString stringWithFormat:@"Valid till %@",offers.end_date]; // commented on 05 Nov 2015
    
    
	lblCounter.text = offers.strCount;
}
- (IBAction)btnRemoveClicked:(id)sender {
	if ([self.offers.strCount intValue]>=0) {
		[Utils playSound:@"beepUnselect"];
		int Counter = [self.offers.strCount intValue];
		Counter--;
		self.offers.strCount = [NSString stringWithFormat:@"%d",Counter];
		if (self.delegate && [self.delegate conformsToProtocol:@protocol(OffersTableCellDelegate)] && [self.delegate respondsToSelector:@selector(minusValueByPriceAtIndexPath:)])
		{
			[self.delegate minusValueByPriceAtIndexPath:self.indexPath];
		}
	}
}

- (IBAction)btnAddClicked:(id)sender {
	if ([self.offers.strCount intValue]>=0) {
		[Utils playSound:@"beepSelect"];
		int Counter = [self.offers.strCount intValue];
		Counter++;
		self.offers.strCount = [NSString stringWithFormat:@"%d",Counter];
		if (self.delegate && [self.delegate conformsToProtocol:@protocol(OffersTableCellDelegate)] && [self.delegate respondsToSelector:@selector(addedValueByPriceAtIndexPath:)])
		{
			[self.delegate addedValueByPriceAtIndexPath:self.indexPath];
		}
	}
}


@end
