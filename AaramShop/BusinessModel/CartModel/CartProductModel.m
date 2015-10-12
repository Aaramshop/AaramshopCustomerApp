//
//  CartProductModel.m
//  AaramShop
//
//  Created by Neha Saxena on 29/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "CartProductModel.h"

@implementation CartProductModel
-(id)init
{
	self = [super init];
	if (self)
	{
		_cartProductId		=	nil;
		_product_id			=	nil;
		_cartProductImage	=	nil;
		_product_name		=	nil;
		_product_price		=	nil;
		_product_sku_id		=	nil;
		_offer_id					=	nil;
		_offer_price			=	nil;
		_offerTitle				=	nil;
		_strCount				=	nil;
		_strOffer_type		=	nil;
        _end_date		=	nil;

	}
	return  self;
}

// ========== ENCODE DECODE =============//
- (void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.cartProductId				forKey: @"cartProductId"];
	[encoder encodeObject:self.product_id					forKey: @"product_id"];
	[encoder encodeObject:self.product_name			forKey: @"product_name"];
	[encoder encodeObject:self.product_price			forKey: @"product_price"];
	[encoder encodeObject:self.product_sku_id			forKey: @"product_sku_id"];
	[encoder encodeObject:self.offer_id						forKey: @"offer_id"];
	[encoder encodeObject:self.offer_price					forKey: @"offer_price"];
	[encoder encodeObject:self.offerTitle					forKey: @"offerTitle"];
	[encoder encodeObject:self.cartProductImage		forKey: @"cartProductImage"];
	[encoder encodeObject:self.strCount						forKey: @"strCount"];
	[encoder encodeObject:self.strOffer_type				forKey: @"strOffer_type"];
    [encoder encodeObject:self.end_date				forKey: @"end_date"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
	self.cartProductId			=	[decoder decodeObjectForKey:@"cartProductId"];
	self.product_id				=	[decoder decodeObjectForKey:@"product_id"];
	self.product_name			=	[decoder decodeObjectForKey:@"product_name"];
	self.product_price			=	[decoder decodeObjectForKey:@"product_price"];
	self.product_sku_id		=	[decoder decodeObjectForKey:@"product_sku_id"];
	self.offer_id						=	[decoder decodeObjectForKey:@"offer_id"];
	self.offer_price				=	[decoder decodeObjectForKey:@"offer_price"];
	self.offerTitle					=	[decoder decodeObjectForKey:@"offerTitle"];
	self.cartProductImage		=	[decoder decodeObjectForKey:@"cartProductImage"];
	self.strCount					=	[decoder decodeObjectForKey:@"strCount"];
	self.strOffer_type			=	[decoder decodeObjectForKey:@"strOffer_type"];
    self.end_date			=	[decoder decodeObjectForKey:@"end_date"];

	return self;
}

-(NSString *)strOffer_type
{
	if (_strOffer_type == nil) {
		_strOffer_type = @"";
	}
	return _strOffer_type;
}

@end
