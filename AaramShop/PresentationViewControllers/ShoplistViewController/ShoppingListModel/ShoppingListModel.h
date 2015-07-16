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
@property(nonatomic,strong) NSString * reminderDate;
@property(nonatomic,strong) NSString * sharedBy; // temp // user model here
@property(nonatomic,strong) NSString * sharedWith; // temp // user model here
@property(nonatomic,strong) NSString * shoppingListId;
@property(nonatomic,strong) NSString * shoppingListName;
@property(nonatomic,strong) NSString * totalItems;
@property(nonatomic,strong) NSString * total_people;

@end