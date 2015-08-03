//
//  CartProductModel.h
//  AaramShop
//
//  Created by Neha Saxena on 29/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartProductModel : NSObject
@property (nonatomic, retain) NSString		*	cartProductId;
@property (nonatomic, retain) NSString		*	cartProductImage;
@property (nonatomic, retain) NSString		*	product_id;
@property (nonatomic, retain) NSString		*	product_name;
@property (nonatomic, retain) NSString		*	product_price;
@property (nonatomic, retain) NSString		*	product_sku_id;
@property (nonatomic, retain) NSString		*	offer_id;
@property (nonatomic, retain) NSString		*	offer_price;
@property (nonatomic, retain) NSString		*	offerTitle;
@property (nonatomic, retain) NSString		*	strCount;
@property (nonatomic, retain) NSString		*   strOffer_type;
@end
