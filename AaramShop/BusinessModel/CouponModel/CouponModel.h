//
//  CouponModel.h
//  AaramShop
//
//  Created by Neha Saxena on 28/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject
@property (nonatomic, retain) NSString *coupon_id;
@property (nonatomic, retain) NSString *coupon_code;
@property (nonatomic, retain) NSString *coupon_title;
@property (nonatomic, retain) NSString *coupon_image;
@property (nonatomic, retain) NSString *coupon_expiry;
@end
