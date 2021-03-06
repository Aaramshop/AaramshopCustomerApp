//
//  OffersTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 14/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OffersTableCell.h"

@implementation OffersTableCell
@synthesize btnAdd;
@synthesize btnRemove;
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
	
    // check first if store name exists or not ..
    lblStoreName.text = offers.store_name; // added on 17 Sep 2015 ..
    
    
    
	
	if ([offers.offerType isEqualToString:@"1"])//Discount Offer
	{
		lblbrandName.text = offers.product_name;
		[lblLine setHidden:NO];
		lblPrice.text = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol],offers.product_actual_price];
		lblOfferPrice.text = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol],offers.offer_price];
		
		NSLog(@"\n actual price => %@",offers.product_actual_price);
		NSLog(@"\n offer price => %@",offers.offer_price);
		
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:offers.product_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
		lblViewDetails.hidden= YES;
	}
	else if([offers.offerType isEqualToString:@"4"])//Combo Offer
	{
		lblbrandName.text = offers.offerTitle;
				[lblLine setHidden:NO];
		lblPrice.text = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol],offers.combo_mrp];
		lblOfferPrice.text = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol],offers.combo_offer_price];
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:offers.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
		lblViewDetails.hidden = NO;
	}
	else if([offers.offerType isEqualToString:@"5"])//Overall Offer
	{
		lblbrandName.text = offers.offerTitle;
		lblPrice.text = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol],offers.overall_purchase_value];
		[lblLine setHidden:YES];

		lblOfferPrice.text = [NSString stringWithFormat:@"%@ %%",offers.discount_percentage];
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:offers.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
		lblViewDetails.hidden = YES;
	}
	else if([offers.offerType isEqualToString:@"6"])//Custom Offer
	{
		lblbrandName.text = offers.offerTitle;
		lblPrice.text = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol],offers.offer_price];
		lblOfferPrice.text = @"";
		[lblLine setHidden:YES];
		[imgBrandLogo sd_setImageWithURL:[NSURL URLWithString:offers.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			
		}];
		lblViewDetails.hidden = YES;
	}
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
    
    
    

	lblCounter.text = offers.strCount;
}

- (IBAction)btnRemoveClicked:(id)sender {
	@try {
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
	@catch (NSException *exception) {
		NSLog(@"%@",exception);
	}
	@finally {
		//
	}

}

- (IBAction)btnAddClicked:(id)sender {
	@try {
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
	@catch (NSException *exception) {
		NSLog(@"%@",exception);
	}
	@finally {
		//
	}
}
@end
