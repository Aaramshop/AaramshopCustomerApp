//
//  AddressModel.h
//  AaramShop
//
//  Created by Approutes on 18/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *state;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *locality;
@property(nonatomic,strong) NSString *pincode;
@property(nonatomic,strong) NSString *title;

@end
