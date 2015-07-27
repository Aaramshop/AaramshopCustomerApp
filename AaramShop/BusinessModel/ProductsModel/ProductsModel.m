//
//  ProductsModel.m
//  AaramShop
//
//  Created by Approutes on 22/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ProductsModel.h"

@implementation ProductsModel
-(id)init
{
	self = [super init];
	if (self)
	{
		_category_id			=	nil;
		_product_id			=	nil;
		_product_image		=	nil;
		_product_name		=	nil;
		_product_price		=	nil;
		_product_sku_id		=	nil;
		_sub_category_id	=	nil;
		_strCount				=	nil;
		_isSelected				=	NO;
		_quantity					=	nil;
	}
	return  self;
}

// ========== ENCODE DECODE =============//
- (void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.category_id forKey: @"category_id"];
	[encoder encodeObject:self.product_id forKey: @"product_id"];
	[encoder encodeObject:self.product_image forKey: @"product_image"];
	[encoder encodeObject:self.product_name forKey: @"product_name"];
	[encoder encodeObject:self.product_price forKey: @"product_price"];
	[encoder encodeObject:self.product_sku_id forKey: @"product_sku_id"];
	[encoder encodeObject:self.sub_category_id forKey: @"sub_category_id"];
	[encoder encodeObject:self.strCount forKey: @"strCount"];
	[encoder encodeObject:self.quantity forKey: @"quantity"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
	self.category_id				=	[decoder decodeObjectForKey:@"category_id"];
	self.product_id				=	[decoder decodeObjectForKey:@"product_id"];
	self.product_image			=	[decoder decodeObjectForKey:@"product_image"];
	self.product_name			=	[decoder decodeObjectForKey:@"product_name"];
	self.product_price			=	[decoder decodeObjectForKey:@"product_price"];
	self.product_sku_id		=	[decoder decodeObjectForKey:@"product_sku_id"];
	self.sub_category_id		=	[decoder decodeObjectForKey:@"sub_category_id"];
	self.strCount					=	[decoder decodeObjectForKey:@"strCount"];
	self.quantity						=	[decoder decodeObjectForKey:@"quantity"];

	return self;
}

@end
