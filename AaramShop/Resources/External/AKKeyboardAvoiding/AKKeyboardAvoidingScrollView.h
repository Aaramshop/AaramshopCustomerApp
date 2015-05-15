//
//  AKKeyboardAvoidingScrollView.h
//  PoppuhApp
//
//  Created by Approutes on 1/20/15.
//  Copyright (c) 2015 Approutes. All rights reserved.

#import <UIKit/UIKit.h>
#import "UIScrollView+AKKeyboardAvoidingAdditions.h"

@interface AKKeyboardAvoidingScrollView : UIScrollView <UITextFieldDelegate, UITextViewDelegate>
- (void)contentSizeToFit;
- (BOOL)focusNextTextField;
- (void)scrollToActiveTextField;
@end
