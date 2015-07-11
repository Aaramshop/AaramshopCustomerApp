//
//  HomeStoreModel.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 10/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeStoreModel : NSObject

@property(nonatomic,strong) NSString * chat_username;
@property(nonatomic,strong) NSString * home_delivery;
@property(nonatomic,strong) NSString * is_favorite;
@property(nonatomic,strong) NSString * is_home_store;
@property(nonatomic,strong) NSString * is_open;
@property(nonatomic,strong) NSString * store_category_icon;
@property(nonatomic,strong) NSString * store_category_id;
@property(nonatomic,strong) NSString * store_category_name;
@property(nonatomic,strong) NSString * store_id;
@property(nonatomic,strong) NSString * store_image;
@property(nonatomic,strong) NSString * store_latitude;
@property(nonatomic,strong) NSString * store_longitude;
@property(nonatomic,strong) NSString * store_mobile;
@property(nonatomic,strong) NSString * store_name;
@property(nonatomic,strong) NSString * store_rating;
@property(nonatomic,strong) NSString * total_orders;

@end