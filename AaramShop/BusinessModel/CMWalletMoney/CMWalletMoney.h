//
//  CMWalletMoney.h
//  AaramShop
//
//  Created by Arbab Khan on 23/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMWalletMoney : NSObject

@property (strong, nonatomic) NSString *store_id;
@property (strong, nonatomic) NSString *store_name;
@property (strong, nonatomic) NSString *due_amount;
@property (strong, nonatomic) NSString *order_amount;
@property (strong, nonatomic) NSString *order_date;

@end
