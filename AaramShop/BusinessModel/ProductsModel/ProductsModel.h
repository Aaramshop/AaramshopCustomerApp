//
//  ProductsModel.h
//  AaramShop
//
//  Created by Approutes on 22/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductsModel : NSObject
@property(nonatomic,strong) NSString *category_id;
@property(nonatomic,strong) NSString *product_id;
@property(nonatomic,strong) NSString *product_image;
@property(nonatomic,strong) NSString *product_name;
@property(nonatomic,strong) NSString *product_price;
@property(nonatomic,strong) NSString *product_sku_id;
@property(nonatomic,strong) NSString *sub_category_id;

@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,strong) NSString *quantity;


@property(nonatomic,strong) NSString *free_item;
@property(nonatomic,strong) NSString *isAvailable;
@property(nonatomic,strong) NSString *offerType;
@property(nonatomic,strong) NSString *offer_price;

@property(nonatomic,strong) NSString *strCount;

@end