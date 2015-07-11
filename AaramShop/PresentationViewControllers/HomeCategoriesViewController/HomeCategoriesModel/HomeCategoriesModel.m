//
//  HomeCategoriesModel.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 10/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoriesModel.h"

@implementation HomeCategoriesModel
-(id)init
{
    self = [super init];
    if (self)
    {
        _arrHome_stores=nil;
        _arrRecommended_stores=nil;
        _arrShopping_store=nil;
    }
    return  self;
}

-(NSMutableArray*)arrHome_stores
{
    if (_arrHome_stores==nil)
    {
        _arrHome_stores=[[NSMutableArray alloc]init];
    }
    return  _arrHome_stores;
}

-(NSMutableArray*)arrRecommended_stores
{
    if (_arrRecommended_stores==nil)
    {
        _arrRecommended_stores=[[NSMutableArray alloc]init];
    }
    return  _arrRecommended_stores;
}

-(NSMutableArray*)arrShopping_store
{
    if (_arrShopping_store==nil)
    {
        _arrShopping_store=[[NSMutableArray alloc]init];
    }
    return  _arrShopping_store;
}


@end
