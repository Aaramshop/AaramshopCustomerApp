//
//  UIScrollView+AKKeyboardAvoidingAdditions.m
//  PoppuhApp
//
//  Created by Approutes on 1/20/15.
//  Copyright (c) 2015 Approutes. All rights reserved.

#import "UIScrollView+AKKeyboardAvoidingAdditions.h"
#import "AKKeyboardAvoidingScrollView.h"
#import <objc/runtime.h>

static const CGFloat kCalculatedContentPadding = 26;
static const CGFloat kMinimumScrollOffsetPadding = 20;

static const int kStateKey;

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

#define fequal(a,b) (fabs((a) - (b)) < DBL_EPSILON)


@interface AKKeyboardAvoidingState : NSObject
@property (nonatomic, assign) UIEdgeInsets priorInset;
@property (nonatomic, assign) UIEdgeInsets priorScrollIndicatorInsets;
@property (nonatomic, assign) BOOL         keyboardVisible;
@property (nonatomic, assign) CGRect       keyboardRect;
@property (nonatomic, assign) CGSize       priorContentSize;


@property (nonatomic) BOOL priorPagingEnabled;
@end

@implementation UIScrollView (AKKeyboardAvoidingAdditions)

- (AKKeyboardAvoidingState*)keyboardAvoidingState {
    AKKeyboardAvoidingState *state = objc_getAssociatedObject(self, &kStateKey);
    if ( !state ) {
        state = [[AKKeyboardAvoidingState alloc] init];
        objc_setAssociatedObject(self, &kStateKey, state, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#if !__has_feature(objc_arc)
        [state release];
#endif
    }
    return state;
}

- (void)AKKeyboardAvoiding_keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    
    AKKeyboardAvoidingState *state = self.keyboardAvoidingState;
    
    if ( state.keyboardVisible ) {
        return;
    }
    
    UIView *firstResponder = [self AKKeyboardAvoiding_findFirstResponderBeneathView:self];
    
    state.keyboardRect = keyboardRect;
    state.keyboardVisible = YES;
    state.priorInset = self.contentInset;
    state.priorScrollIndicatorInsets = self.scrollIndicatorInsets;
    
    state.priorPagingEnabled = self.pagingEnabled;
    self.pagingEnabled = NO;
    
    if ( [self isKindOfClass:[AKKeyboardAvoidingScrollView class]] ) {
        state.priorContentSize = self.contentSize;
        
        if ( CGSizeEqualToSize(self.contentSize, CGSizeZero) ) {
            // Set the content size, if it's not set. Do not set content size explicitly if auto-layout
            // is being used to manage subviews
            self.contentSize = [self AKKeyboardAvoiding_calculatedContentSizeFromSubviewFrames];
        }
    }
    
    // Shrink view's inset by the keyboard's height, and scroll to show the text field/view being edited
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    self.contentInset = [self AKKeyboardAvoiding_contentInsetForKeyboard];
    
    if ( firstResponder ) {
        CGFloat viewableHeight = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
        [self setContentOffset:CGPointMake(self.contentOffset.x,
                                           [self AKKeyboardAvoiding_idealOffsetForView:firstResponder
                                                                 withViewingAreaHeight:viewableHeight])
                      animated:NO];
    }
    
    self.scrollIndicatorInsets = self.contentInset;
    
    [UIView commitAnimations];
}

- (void)AKKeyboardAvoiding_keyboardWillHide:(NSNotification*)notification {
    CGRect keyboardRect = [self convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    
    AKKeyboardAvoidingState *state = self.keyboardAvoidingState;
    
    if ( !state.keyboardVisible ) {
        return;
    }
    
    state.keyboardRect = CGRectZero;
    state.keyboardVisible = NO;
    
    // Restore dimensions to prior size
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    if ( [self isKindOfClass:[AKKeyboardAvoidingScrollView class]] ) {
        self.contentSize = state.priorContentSize;
    }
    
    self.contentInset = state.priorInset;
    self.scrollIndicatorInsets = state.priorScrollIndicatorInsets;
    self.pagingEnabled = state.priorPagingEnabled;
    [UIView commitAnimations];
}

- (void)AKKeyboardAvoiding_updateContentInset {
    AKKeyboardAvoidingState *state = self.keyboardAvoidingState;
    if ( state.keyboardVisible ) {
        self.contentInset = [self AKKeyboardAvoiding_contentInsetForKeyboard];
    }
}

- (void)AKKeyboardAvoiding_updateFromContentSizeChange {
    AKKeyboardAvoidingState *state = self.keyboardAvoidingState;
    if ( state.keyboardVisible ) {
		state.priorContentSize = self.contentSize;
        self.contentInset = [self AKKeyboardAvoiding_contentInsetForKeyboard];
    }
}

#pragma mark - Utilities

- (BOOL)AKKeyboardAvoiding_focusNextTextField {
    UIView *firstResponder = [self AKKeyboardAvoiding_findFirstResponderBeneathView:self];
    if ( !firstResponder ) {
        return NO;
    }
    
    CGFloat minY = CGFLOAT_MAX;
    UIView *view = nil;
    [self AKKeyboardAvoiding_findTextFieldAfterTextField:firstResponder beneathView:self minY:&minY foundView:&view];
    
    if ( view ) {
        [view performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
        return YES;
    }
    
    return NO;
}

-(void)AKKeyboardAvoiding_scrollToActiveTextField {
    AKKeyboardAvoidingState *state = self.keyboardAvoidingState;
    
    if ( !state.keyboardVisible ) return;
    
    CGFloat visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom;
    
    CGPoint idealOffset = CGPointMake(0, [self AKKeyboardAvoiding_idealOffsetForView:[self AKKeyboardAvoiding_findFirstResponderBeneathView:self]
                                                               withViewingAreaHeight:visibleSpace]);

    // Ordinarily we'd use -setContentOffset:animated:YES here, but it does not appear to
    // scroll to the desired content offset. So we wrap in our own animation block.
    [UIView animateWithDuration:0.25 animations:^{
        [self setContentOffset:idealOffset animated:NO];
    }];
}

#pragma mark - Helpers

- (UIView*)AKKeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self AKKeyboardAvoiding_findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

- (void)AKKeyboardAvoiding_findTextFieldAfterTextField:(UIView*)priorTextField beneathView:(UIView*)view minY:(CGFloat*)minY foundView:(UIView* __autoreleasing *)foundView {
    // Search recursively for text field or text view below priorTextField
    CGFloat priorFieldOffset = CGRectGetMinY([self convertRect:priorTextField.frame fromView:priorTextField.superview]);
    for ( UIView *childView in view.subviews ) {
        if ( childView.hidden ) continue;
        if ( ([childView isKindOfClass:[UITextField class]] || [childView isKindOfClass:[UITextView class]]) && childView.isUserInteractionEnabled) {
            CGRect frame = [self convertRect:childView.frame fromView:view];
            if ( childView != priorTextField
                    && CGRectGetMinY(frame) >= priorFieldOffset
                    && CGRectGetMinY(frame) < *minY &&
                    !(fequal(frame.origin.y, priorTextField.frame.origin.y)
                      && frame.origin.x < priorTextField.frame.origin.x) ) {
                *minY = CGRectGetMinY(frame);
                *foundView = childView;
            }
        } else {
            [self AKKeyboardAvoiding_findTextFieldAfterTextField:priorTextField beneathView:childView minY:minY foundView:foundView];
        }
    }
}

- (void)AKKeyboardAvoiding_assignTextDelegateForViewsBeneathView:(UIView*)view {
    for ( UIView *childView in view.subviews ) {
        if ( ([childView isKindOfClass:[UITextField class]] || [childView isKindOfClass:[UITextView class]]) ) {
            [self AKKeyboardAvoiding_initializeView:childView];
        } else {
            [self AKKeyboardAvoiding_assignTextDelegateForViewsBeneathView:childView];
        }
    }
}

-(CGSize)AKKeyboardAvoiding_calculatedContentSizeFromSubviewFrames {
    
    BOOL wasShowingVerticalScrollIndicator = self.showsVerticalScrollIndicator;
    BOOL wasShowingHorizontalScrollIndicator = self.showsHorizontalScrollIndicator;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    CGRect rect = CGRectZero;
    for ( UIView *view in self.subviews ) {
        rect = CGRectUnion(rect, view.frame);
    }
    rect.size.height += kCalculatedContentPadding;
    
    self.showsVerticalScrollIndicator = wasShowingVerticalScrollIndicator;
    self.showsHorizontalScrollIndicator = wasShowingHorizontalScrollIndicator;
    
    return rect.size;
}


- (UIEdgeInsets)AKKeyboardAvoiding_contentInsetForKeyboard {
    AKKeyboardAvoidingState *state = self.keyboardAvoidingState;
    UIEdgeInsets newInset = self.contentInset;
    CGRect keyboardRect = state.keyboardRect;
    newInset.bottom = keyboardRect.size.height - MAX((CGRectGetMaxY(keyboardRect) - CGRectGetMaxY(self.bounds)), 0);
    return newInset;
}

-(CGFloat)AKKeyboardAvoiding_idealOffsetForView:(UIView *)view withViewingAreaHeight:(CGFloat)viewAreaHeight {
    CGSize contentSize = self.contentSize;
    CGFloat offset = 0.0;

    CGRect subviewRect = [view convertRect:view.bounds toView:self];
    
    // Attempt to center the subview in the visible space, but if that means there will be less than kMinimumScrollOffseAKadding
    // pixels above the view, then substitute kMinimumScrollOffseAKadding
    CGFloat padding = (viewAreaHeight - subviewRect.size.height) / 2;
    if ( padding < kMinimumScrollOffsetPadding ) {
        padding = kMinimumScrollOffsetPadding;
    }

    // Ideal offset places the subview rectangle origin "padding" points from the top of the scrollview.
    // If there is a top contentInset, also compensate for this so that subviewRect will not be placed under
    // things like navigation bars.
    offset = subviewRect.origin.y - padding - self.contentInset.top;
    
    // Constrain the new contentOffset so we can't scroll past the bottom. Note that we don't take the bottom
    // inset into account, as this is manipulated to make space for the keyboard.
    if ( offset > (contentSize.height - viewAreaHeight) ) {
        offset = contentSize.height - viewAreaHeight;
    }
    
    // Constrain the new contentOffset so we can't scroll past the top, taking contentInsets into account
    if ( offset < -self.contentInset.top ) {
        offset = -self.contentInset.top;
    }

    return offset;
}

- (void)AKKeyboardAvoiding_initializeView:(UIView*)view {
    if ( [view isKindOfClass:[UITextField class]]
            && ((UITextField*)view).returnKeyType == UIReturnKeyDefault
            && (![(UITextField*)view delegate] || [(UITextField*)view delegate] == (id<UITextFieldDelegate>)self) ) {
        [(UITextField*)view setDelegate:(id<UITextFieldDelegate>)self];
        UIView *otherView = nil;
        CGFloat minY = CGFLOAT_MAX;
        [self AKKeyboardAvoiding_findTextFieldAfterTextField:view beneathView:self minY:&minY foundView:&otherView];
        
        if ( otherView ) {
            ((UITextField*)view).returnKeyType = UIReturnKeyNext;
        } else {
            ((UITextField*)view).returnKeyType = UIReturnKeyDone;
        }
    }
}

@end


@implementation AKKeyboardAvoidingState
@end
