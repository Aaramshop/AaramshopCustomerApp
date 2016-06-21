//
//  CMPaymentMode.m
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 19/06/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import "CMPaymentMode.h"

@implementation CMPaymentMode
-(id)init
{
    self = [super init];
    if (self)
    {
        _mode_id  =   @"0";
        _name=nil;
	_isChecked=NO;
    }
    return  self;
}
// ========== ENCODE DECODE =============//
- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.mode_id forKey: @"mode_id"];
    [encoder encodeObject:self.name forKey: @"name"];
	[encoder encodeBool:self.isChecked forKey:@"isChecked"];
   }

- (id)initWithCoder:(NSCoder *)decoder
{
    self.mode_id            = [decoder decodeObjectForKey:@"mode_id"];
    self.name             = [decoder decodeObjectForKey:@"name"];
	self.isChecked		=	[decoder decodeBoolForKey:@"isChecked"];
	
    return self;
}
@end
