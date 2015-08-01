//
//  CMWalletOffer.h
//  AaramShop
//
//  Created by Arbab Khan on 31/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMWalletOffer : NSObject


@property (nonatomic, strong) NSString *offerType;
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSString *product_sku_id;
@property (nonatomic, strong) NSString *product_image;
@property (nonatomic, strong) NSString *product_actual_price;
@property (nonatomic, strong) NSString *offer_price;
@property (nonatomic, strong) NSString *product_name;
@property (nonatomic, strong) NSString *offerTitle;
@property (nonatomic, strong) NSString *offer_id;
@property (nonatomic, strong) NSString *free_item;
@property (nonatomic, strong) NSString *combo_mrp;
@property (nonatomic, strong) NSString *combo_offer_price;
@property (nonatomic, strong) NSString *offerDetail;
@property (nonatomic, strong) NSString *offerDescription;
@property (nonatomic, strong) NSString *offerImage;
@property (nonatomic, strong) NSString *start_date;
@property (nonatomic, strong) NSString *end_date;
@end
