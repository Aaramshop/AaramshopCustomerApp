//
//  PWTextField.m
//  ProjectParty
//
//  Created by JTMD Innovations GmbH on 06/11/14.
//  Copyright (c) 2014 Nightadvisor GmbH. All rights reserved.
//

#import "PWTextField.h"

@implementation PWTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 5 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 5 );
}
@end
