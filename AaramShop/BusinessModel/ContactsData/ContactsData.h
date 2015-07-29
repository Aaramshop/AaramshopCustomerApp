//
//  ContactsData.h
//  AaramShop_Merchant
//
//  Created by chetan shishodia on 09/06/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsData : NSObject

@property(nonatomic,strong) NSString *firstName;
@property(nonatomic,strong) NSString *lastName;
@property(nonatomic) int contactId;
//@property(nonatomic,strong) NSString *fullname;
@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *isSelected;

@property(nonatomic,strong) UIImage  *profilePic;
@property(nonatomic,strong) NSArray  *numbers;
@property(nonatomic,strong) NSArray  *emails;

@end

