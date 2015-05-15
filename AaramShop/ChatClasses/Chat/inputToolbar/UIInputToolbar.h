/*
 *  UIInputToolbar.h
 *
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
//#import "UIExpandingTextView.h"
#import "HPGrowingTextView.h"
#import <AudioToolbox/AudioToolbox.h>
@class HPGrowingTextView;
//changed10-9-13
typedef enum
{
    eKeyBoardNone = 0,
    eKeyBoardCustom,
    eKeyBoardUpload,
    eKeyBoardNormal
}enKeyBoardStaus;
//end

@protocol UINewInputToolbarDelegate <HPGrowingTextViewDelegate>
@optional
-(void)inputButtonPressed:(NSString *)inputText;
-(void)inputImageButtonPressed;

//nehaa 25-03-2014
- (void)audioButtonClicked;
- (IBAction)stopRecording;
//end
-(void)showKeyboard :(id)inToolBar andSender:(UIButton *)inSender;
- (void)removeAllText;
@end

//nehaa 25-03-2014
@interface UIInputToolbar : UIToolbar <UINewInputToolbarDelegate,UIGestureRecognizerDelegate>
//end
- (void)drawRect:(CGRect)rect;

@property (nonatomic, strong) HPGrowingTextView *textView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIBarButtonItem *barBtnSend;
@property (assign) BOOL boolIsCustomKeyboardVisible;
@property (nonatomic, strong) UIBarButtonItem *barBtnCustomEmoji;
@property (nonatomic, strong) UIBarButtonItem *barBtnAdd;
@property (nonatomic, strong) UIButton *btnAttach;
@property (nonatomic, strong) UIButton *btnCustomEmoji;
@property (nonatomic, strong) UIButton *btnSend;
@property (nonatomic, strong) UIButton *btnRecord;
@property (nonatomic, strong) UIButton *btnFileUpload;
@property (nonatomic, strong) UIButton *btnDeleteText;
@property (nonatomic, strong) id<UINewInputToolbarDelegate> inputDelegate;
@property (nonatomic, assign) enKeyBoardStaus keyBoardStatus;
@property (nonatomic, assign) BOOL isFisrtTime;
//nehaa 25-02-2014
@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, assign) BOOL isKonnectMessageAllow;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPress;
@property (nonatomic, retain) UITapGestureRecognizer *singleTap;
@property (nonatomic, retain) UILabel *lblRecordingTime;
@property (nonatomic, retain) UILabel *lblSwipeToDelete;
@property (nonatomic, retain) UILabel *lblWhite;
@property (nonatomic, retain) UIImageView *imgViewRecording;
@property (nonatomic, retain) NSTimer *timer;
//end
- (void)swiped;
//nehaa 26-03-2014
@property (nonatomic, retain) NSString *audioFilePath;
//end
- (void)setSendBtnProperty:(NSString*)btn;
@end
