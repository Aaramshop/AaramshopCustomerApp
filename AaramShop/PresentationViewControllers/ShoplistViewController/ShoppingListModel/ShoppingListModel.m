//
//  ShoppingListModel.m
//  AaramShop
//
//  Created by Approutes on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListModel.h"

@implementation ShoppingListModel

-(id)init
{
    self = [super init];
    if (self)
    {
        _sharedBy =nil;
        _sharedWith = nil;
    }
    return  self;
}


-(NSMutableArray*)sharedBy
{
    if (_sharedBy==nil)
    {
        _sharedBy=[[NSMutableArray alloc]init];
        
    }
    return _sharedBy;
}

-(NSMutableArray*)sharedWith
{
    if (_sharedWith==nil)
    {
        _sharedWith=[[NSMutableArray alloc]init];
        
    }
    return _sharedWith;
}


@end
