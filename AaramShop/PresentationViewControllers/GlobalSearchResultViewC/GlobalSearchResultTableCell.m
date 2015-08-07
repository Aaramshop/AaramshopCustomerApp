//
//  GlobalSearchResultTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 05/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "GlobalSearchResultTableCell.h"

@implementation GlobalSearchResultTableCell
@synthesize indexPath,delegate,objProductsModelMain;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnMinus:(id)sender {
	if ([objProductsModelMain.strCount intValue]>=0) {
		[Utils playSound:@"beepUnselect"];
		int Counter = [objProductsModelMain.strCount intValue];
		Counter--;
		objProductsModelMain.strCount = [NSString stringWithFormat:@"%d",Counter];
		if (self.delegate && [self.delegate conformsToProtocol:@protocol(HomeSecondCustomCellDelegate)] && [self.delegate respondsToSelector:@selector(minusValueByPrice:atIndexPath:)])
		{
			int TotalPrice =  1 * [objProductsModelMain.product_price intValue];
			
			[self.delegate minusValueByPrice:[NSString stringWithFormat:@"%d",TotalPrice] atIndexPath:indexPath];
		}
	}
}

- (IBAction)btnPlus:(id)sender {
	if ([objProductsModelMain.strCount intValue]>=0) {
		[Utils playSound:@"beepSelect"];
		int Counter = [objProductsModelMain.strCount intValue];
		Counter++;
		objProductsModelMain.strCount = [NSString stringWithFormat:@"%d",Counter];
		if (self.delegate && [self.delegate conformsToProtocol:@protocol(HomeSecondCustomCellDelegate)] && [self.delegate respondsToSelector:@selector(addedValueByPrice:atIndexPath:)])
		{
			int TotalPrice =  1 * [objProductsModelMain.product_price intValue];
			
			[self.delegate addedValueByPrice:[NSString stringWithFormat:@"%d",TotalPrice] atIndexPath:indexPath];
		}
	}

}
-(void)updateCellWithSubCategory:(ProductsModel *)objProductsModel
{
	
	//////////////////////////////////////////////////////////////////for offer kind of products//////////////////////////////////////////////////////////////////
	lblOfferPrice.hidden = YES;
	NSString *strCount = @"0";
	if([objProductsModel.offer_type integerValue]>0)
	{
		lblLine.hidden = NO;
		lblOfferPrice.hidden = NO;
		lblOfferPrice.text = [NSString stringWithFormat:@"₹%@",objProductsModel.offer_price];
		strCount = [AppManager getCountOfProduct:objProductsModel.offer_id withOfferType:objProductsModel.offer_type forStore_id:objProductsModel.store_id];
	}
	else
	{
		strCount = [AppManager getCountOfProduct:objProductsModel.product_id withOfferType:objProductsModel.offer_type forStore_id:objProductsModel.store_id];
	}
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if ([strCount intValue]<=0) {
		btnMinus.enabled=NO;
	}
	else
		btnMinus.enabled = YES;
	if([strCount intValue]==20)
	{
		btnPlus.enabled=NO;
	}
	else
	{
		btnPlus.enabled = YES;
	}
	
	[imgProduct sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objProductsModel.product_image]] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		if (image) {
		}
	}];
	lblProductName.text= objProductsModel.product_name;
	lblPrice.text = [NSString stringWithFormat:@"₹%@",objProductsModel.product_price];
	lblCount.text = strCount;
	lblStoreName.text = objProductsModel.store_name;
	[imgStore sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objProductsModel.store_image]] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		if (image) {
		}
	}];
	
}

@end
