//
//  CartModel.h
//  AaramShop
//
//  Created by Neha Saxena on 25/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModel : NSObject
@property (nonatomic, retain) NSString *store_id;
@property (nonatomic, retain) NSString *store_name;
@property (nonatomic, retain) NSString *store_image;
@property (nonatomic, retain) NSString *cart_price;
@property (nonatomic, retain) NSMutableArray *arrProductDetails;

@end
