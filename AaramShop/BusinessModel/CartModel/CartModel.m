//
//  CartModel.m
//  AaramShop
//
//  Created by Neha Saxena on 25/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "CartModel.h"

@implementation CartModel
-(id)init
{
	self = [super init];
	if (self)
	{
		_store_id  =   nil;
		_store_image=nil;
		_store_name=nil;
		_arrProductDetails = nil;
		_cart_price = nil;
	}
	return  self;
}

// ========== ENCODE DECODE =============//
- (void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.store_id forKey: @"store_id"];
	[encoder encodeObject:self.store_image forKey: @"store_image"];
	[encoder encodeObject:self.store_name forKey: @"store_name"];
	[encoder encodeObject:self.arrProductDetails forKey: @"arrProductDetails"];
	[encoder encodeObject:self.cart_price forKey: @"cart_price"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self.store_id						=	[decoder decodeObjectForKey:@"store_id"];
	self.store_image				=	[decoder decodeObjectForKey:@"store_image"];
	self.store_name              =	[decoder decodeObjectForKey:@"store_name"];
	self.arrProductDetails		=	[decoder decodeObjectForKey:@"arrProductDetails"];
	self.cart_price					=	[decoder decodeObjectForKey:@"cart_price"];
	return self;
}

@end
