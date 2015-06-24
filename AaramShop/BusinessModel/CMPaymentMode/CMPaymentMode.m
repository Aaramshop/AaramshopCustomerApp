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
        _mode_id  =   nil;
        _name=nil;
    }
    return  self;
}
// ========== ENCODE DECODE =============//
- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.mode_id forKey: @"mode_id"];
    [encoder encodeObject:self.name forKey: @"name"];
   }

- (id)initWithCoder:(NSCoder *)decoder
{
    self.mode_id            = [decoder decodeObjectForKey:@"mode_id"];
    self.name             = [decoder decodeObjectForKey:@"name"];
    
    
    return self;
}
@end
