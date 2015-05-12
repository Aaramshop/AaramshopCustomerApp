//
//  UIScrollView+AKKeyboardAvoidingAdditions.h
//  PoppuhApp
//
//  Created by Approutes on 1/20/15.
//  Copyright (c) 2015 Approutes. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIScrollView (AKKeyboardAvoidingAdditions)
- (BOOL)AKKeyboardAvoiding_focusNextTextField;
- (void)AKKeyboardAvoiding_scrollToActiveTextField;

- (void)AKKeyboardAvoiding_keyboardWillShow:(NSNotification*)notification;
- (void)AKKeyboardAvoiding_keyboardWillHide:(NSNotification*)notification;
- (void)AKKeyboardAvoiding_updateContentInset;
- (void)AKKeyboardAvoiding_updateFromContentSizeChange;
- (void)AKKeyboardAvoiding_assignTextDelegateForViewsBeneathView:(UIView*)view;
- (UIView*)AKKeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view;
-(CGSize)AKKeyboardAvoiding_calculatedContentSizeFromSubviewFrames;
@end
