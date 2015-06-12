//
//  SubCategoryModel.h
//  AaramShop
//
//  Created by Approutes on 09/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCategoryModel : NSObject
@property(nonatomic,strong) NSString *img;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *strCategoryName;
@property(nonatomic,strong) NSString *restaurantName;
@property(nonatomic,strong) NSString *distance;;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *count;
@property(nonatomic,assign) BOOL isAddedToFavourite;

@end
