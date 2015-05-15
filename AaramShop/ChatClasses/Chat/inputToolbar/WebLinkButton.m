//
//  WebLinkButton.m
 
//
//  Created by Shakir Approutes on 30/09/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "WebLinkButton.h"

@implementation WebLinkButton
@synthesize  webLink;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.webLink = nil;
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
