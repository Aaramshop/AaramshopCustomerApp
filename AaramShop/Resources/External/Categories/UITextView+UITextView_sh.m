//
//  UITextView+UITextView_sh.m
//  SocialParty
//
//  Created by Shakir Approutes on 02/07/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import "UITextView+UITextView_sh.h"

@implementation UITextView (UITextView_sh)
#pragma mark - Calculate the size,bounds,frame of the Multi line Label
/*====================================================================*/

/* Calculate the size,bounds,frame of the Multi line Label */

/*====================================================================*/
/**
 *  Returns the size of the Label
 *
 *  @param aLabel To be used to calculte the height
 *
 *  @return size of the Label
 */
-(CGSize)sizeOfMultiLineLabel{
    
//    NSAssert(self, @"UILabel was nil");
    
    //Label text
    NSString *aLabelTextString = [self text];
    
    //Label font
    UIFont *aLabelFont = [self font];
    
    //Width of the Label
    CGFloat aLabelSizeWidth = self.frame.size.width;
    
      // (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(iOS7_0))
        //version >= 7.0
        
        //Return the calculated size of the Label
        CGRect txtRect = [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                                        NSFontAttributeName : aLabelFont
                                                        }
                                              context: nil];
    return txtRect.size;
}


@end
