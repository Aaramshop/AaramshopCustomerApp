//
//  CMGlobalSearch.h
//  AaramShop
//
//  Created by Arbab Khan on 04/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMGlobalSearch : NSObject

@property (strong, nonatomic) NSString *search_type;
@property (strong, nonatomic) NSString *store_id;
@property (strong, nonatomic) NSString *store_name;
@property (strong, nonatomic) NSString *store_image;
@property (strong, nonatomic) NSString *category_id;
@property (strong, nonatomic) NSString *sub_category_id;
@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *product_sku_id;
@property (strong, nonatomic) NSString *product_name;
@property (strong, nonatomic) NSString *product_image;
@property (strong, nonatomic) NSString *product_price;

@end
