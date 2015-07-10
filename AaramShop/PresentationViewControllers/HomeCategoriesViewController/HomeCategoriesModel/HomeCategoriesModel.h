//
//  HomeCategoriesModel.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 10/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCategoriesModel : NSObject

@property(nonatomic,strong) NSString * store_main_category_banner_1;
@property(nonatomic,strong) NSString * store_main_category_banner_2;
@property(nonatomic,strong) NSString * store_main_category_id;
@property(nonatomic,strong) NSString * store_main_category_name;

@property(nonatomic,strong) NSMutableArray * arrHome_stores;
@property(nonatomic,strong) NSMutableArray * arrRecommended_stores;
@property(nonatomic,strong) NSMutableArray * arrShopping_store;

@end