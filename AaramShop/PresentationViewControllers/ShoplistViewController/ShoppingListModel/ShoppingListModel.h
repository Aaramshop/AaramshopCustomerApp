//
//  ShoppingListModel.h
//  AaramShop
//
//  Created by Approutes on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingListModel : NSObject

@property(nonatomic,strong) NSString * creationDate;
@property(nonatomic,strong) NSString * frequency;
@property(nonatomic,strong) NSString * reminder;

@property(nonatomic,strong) NSString * reminder_start_date;
@property(nonatomic,strong) NSString * reminder_end_date;

@property(nonatomic,strong) NSMutableArray * sharedBy;
@property(nonatomic,strong) NSMutableArray * sharedWith;

@property(nonatomic,strong) NSString * shoppingListId;
@property(nonatomic,strong) NSString * shoppingListName;
@property(nonatomic,strong) NSString * totalItems;
@property(nonatomic,strong) NSString * total_people;

@end