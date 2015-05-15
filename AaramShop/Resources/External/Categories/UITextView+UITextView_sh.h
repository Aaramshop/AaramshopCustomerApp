//
//  UITextView+UITextView_sh.h
//  SocialParty
//
//  Created by Shakir Approutes on 02/07/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (UITextView_sh)
#pragma mark - Calculate the size the Multi line Label
/*====================================================================*/

/* Calculate the size of the Multi line Label */

/*====================================================================*/
/**
 *  Returns the size of the Label
 *
 *  @param aLabel To be used to calculte the height
 *
 *  @return size of the Label
 */
-(CGSize)sizeOfMultiLineLabel;
@end
