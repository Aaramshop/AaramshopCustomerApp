//
//  CMOrderHist.h
//  AaramShop
//
//  Created by Arbab Khan on 23/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMOrderHist : NSObject

@property (nonatomic,strong) NSString *customer_id;
@property (nonatomic,strong) NSString *chat_username;
@property (nonatomic,strong) NSString *store_id;
@property (nonatomic,strong) NSString *store_name;
@property (nonatomic,strong) NSString *store_mobile;
@property (nonatomic,strong) NSString *store_address;
@property (nonatomic,strong) NSString *store_locality;
@property (nonatomic,strong) NSString *store_city;
@property (nonatomic,strong) NSString *store_state;
@property (nonatomic,strong) NSString *store_pincode;
@property (nonatomic,strong) NSString *store_latitude;
@property (nonatomic,strong) NSString *store_longitude;
@property (nonatomic,strong) NSString *store_image;
@property (nonatomic,strong) NSString *customer_image;
@property (nonatomic,strong) NSString *customer_name;
@property (nonatomic,strong) NSString *customer_latitude;
@property (nonatomic,strong) NSString *customer_longitude;
@property (nonatomic,strong) NSString *customer_addresss;
@property (nonatomic,strong) NSString *customer_locality;
@property (nonatomic,strong) NSString *customer_city;
@property (nonatomic,strong) NSString *customer_state;
@property (nonatomic,strong) NSString *customer_pincode;
@property (nonatomic,strong) NSString *quantity;
@property (nonatomic,strong) NSString *order_amount;
@property (nonatomic,strong) NSString *delivery_time;
@property (nonatomic,strong) NSString *order_time;
@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,strong) NSString *customer_mobile;
@property (nonatomic,strong) NSString *delivery_status;
@property (nonatomic,strong) NSString *delivery_slot;

@end
