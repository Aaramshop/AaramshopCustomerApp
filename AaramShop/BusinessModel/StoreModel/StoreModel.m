//
//  StoreModel.m
//  AaramShop
//
//  Created by Approutes on 19/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "StoreModel.h"

@implementation StoreModel
-(id)init
{
    self = [super init];
    if (self)
    {
        _arrRecommendedStores = nil;
        _arrFavoriteStores = nil;
        _arrHomeStores = nil;
        _arrShoppingStores = nil;
        
    }
    return  self;
}

-(NSMutableArray*)arrRecommendedStores
{
    if (_arrRecommendedStores==nil)
    {
        _arrRecommendedStores=[[NSMutableArray alloc]init];
    }
    return  _arrRecommendedStores;
}

-(NSMutableArray*)arrFavoriteStores
{
    if (_arrFavoriteStores==nil)
    {
        _arrFavoriteStores=[[NSMutableArray alloc]init];
    }
    return  _arrFavoriteStores;
}

-(NSMutableArray*)arrHomeStores
{
    if (_arrHomeStores==nil)
    {
        _arrHomeStores=[[NSMutableArray alloc]init];
    }
    return  _arrHomeStores;
}

-(NSMutableArray*)arrShoppingStores
{
    if (_arrShoppingStores==nil)
    {
        _arrShoppingStores=[[NSMutableArray alloc]init];
    }
    return  _arrShoppingStores;
}




@end
