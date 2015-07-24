//
//  CMWalletPoints.h
//  AaramShop
//
//  Created by Arbab Khan on 22/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMWalletPoints : NSObject

@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSString *order_code;
@property (strong, nonatomic) NSString *store_id;
@property (strong, nonatomic) NSString *store_name;
@property (strong, nonatomic) NSString *point;
@property (strong, nonatomic) NSString *order_amount;


@property (strong, nonatomic) NSString *product_name;
@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *brand_name;
@property (strong, nonatomic) NSString *quantity;

@end
