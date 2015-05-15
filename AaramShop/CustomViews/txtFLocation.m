//
//  txtFLocation.m
//  AaramShop
//
//  Created by Approutes on 14/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "txtFLocation.h"

@implementation txtFLocation

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [self setLeftViewMode:UITextFieldViewModeAlways];
        self.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locationIcon.png"]];

    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.edgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [self setLeftViewMode:UITextFieldViewModeAlways];
        self.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locationIcon.png"]];

    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return [super leftViewRectForBounds:UIEdgeInsetsInsetRect(bounds,UIEdgeInsetsMake(-5, -5, -5, -5 ))];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

@end
