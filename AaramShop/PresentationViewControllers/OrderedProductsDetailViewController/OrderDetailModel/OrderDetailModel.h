//
//  OrderDetailModel.h
//  AaramShop_Merchant
//
//  Created by chetan shishodia on 21/06/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property (nonatomic,strong) NSString *quantity;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *product_id;
@property (nonatomic,strong) NSString *product_sku_id;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *isReported; // for local use.
@property (nonatomic,strong) NSString *isAvailable;

// new keys .. 
@property (nonatomic,strong) NSString * combo_mrp;
@property (nonatomic,strong) NSString * combo_offer_price;
@property (nonatomic,strong) NSString * free_product;
@property (nonatomic,strong) NSString * offerDescription;
@property (nonatomic,strong) NSString * offerImage;
@property (nonatomic,strong) NSString * offerTitle;
@property (nonatomic,strong) NSString * offer_price;
@property (nonatomic,strong) NSString * offer_type;
@property (nonatomic,strong) NSString * order_detail_id;

// added on Oct 07th, 2015
@property (nonatomic,strong) NSString * offer_id;
@property (nonatomic,strong) NSString * end_date;

@end



