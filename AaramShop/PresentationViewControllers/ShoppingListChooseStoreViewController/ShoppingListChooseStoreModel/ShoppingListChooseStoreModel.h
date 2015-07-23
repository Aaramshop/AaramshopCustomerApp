//
//  ShoppingListChooseStoreModel.h
//  AaramShop
//
//  Created by Approutes on 23/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingListChooseStoreModel : NSObject


////////////////////////// old //////////////////////////

//@property(nonatomic,strong) NSString *banner;
//@property(nonatomic,strong) NSString *banner_2x;
//@property(nonatomic,strong) NSString *banner_3x;
//@property(nonatomic,strong) NSString *store_address;
//@property(nonatomic,strong) NSString *store_category_image;
//@property(nonatomic,strong) NSString *store_distance;
//@property(nonatomic,strong) NSString *store_code;
//@property(nonatomic,strong) NSString *store_main_category_banner_1;
//@property(nonatomic,strong) NSString *store_main_category_banner_2;
//@property(nonatomic,strong) NSString *store_main_category_id;
//@property(nonatomic,strong) NSString *store_main_category_name;
//@property(nonatomic,strong) NSString *home_delivey;


@property(nonatomic,strong) NSMutableArray *arrRecommendedStores;
@property(nonatomic,strong) NSMutableArray *arrFavoriteStores;
@property(nonatomic,strong) NSMutableArray *arrHomeStores;
@property(nonatomic,strong) NSMutableArray *arrShoppingStores;

////////////////////////// old //////////////////////////

////////////////////////// new //////////////////////////

@property(nonatomic,strong) NSString * available_products;
@property(nonatomic,strong) NSString * chat_username;
@property(nonatomic,strong) NSString * home_delivery;
@property(nonatomic,strong) NSString * is_favorite;
@property(nonatomic,strong) NSString * is_home_store;
@property(nonatomic,strong) NSString * is_open;
@property(nonatomic,strong) NSString * remaining_products;
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
@property(nonatomic,strong) NSString * total_product_price;
@property(nonatomic,strong) NSString * total_products;

////////////////////////// new //////////////////////////
@end








