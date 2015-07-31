//
//  SharedUserModel.h
//  AaramShop
//
//  Created by Approutes on 30/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedUserModel : NSObject

@property (nonatomic,strong) NSString * full_name;
@property (nonatomic,strong) NSString * profileImage;
@property (nonatomic,strong) NSString * userId;


// followings are used in 'getShoppingList' api

@property (nonatomic,strong) NSString * chat_username;
@property (nonatomic,strong) NSString * email;
@property (nonatomic,strong) NSString * mobile;
//@property (nonatomic,strong) NSString * full_name;

@end
