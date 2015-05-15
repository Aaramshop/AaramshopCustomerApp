/*
 *  UIInputToolbar.m
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

#import "HPGrowingTextView.h"
#import "UIInputToolbar.h"
#import "CXMPPController.h"

@interface UIInputToolbar()
{
UIPanGestureRecognizer *pan;
    CGRect swipeRect;
    float lastpoint;
    float maxpoint;
}
-(void)inputButtonPressed;


@end

@implementation UIInputToolbar
@synthesize  keyBoardStatus;

@synthesize  delegate;

-(void)inputButtonPressed
{
    if (self.inputDelegate)
    {
        [self.inputDelegate inputButtonPressed :self.textView.text];
    }
//       [self.textView setText:@""];

}
//nehaa 26-03-2014
- (void)swiped
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:self.audioFilePath error:&error];
    if (success) {
        NSLog(@"Successfully Deleted");
        self.audioFilePath = @"";
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
   
}
//nehaa 25-03-2014
- (IBAction)startRecording:(UILongPressGestureRecognizer*)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            lastpoint = 295;
            maxpoint = 295;
            [self vibrate:nil];
            self.btnFileUpload.hidden= YES;
            self.textView.hidden = YES;
            self.imgView.hidden = YES;
            self.imgViewRecording.hidden = NO;
            self.lblSwipeToDelete.hidden = NO;
            self.lblWhite.hidden = NO;
            self.lblRecordingTime.hidden=NO;
            
            [self.inputDelegate audioButtonClicked];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translate = [recognizer locationInView:self];
            if(self.audioFilePath.length==0)
            {
                break;
            }
            CGRect rect = self.lblSwipeToDelete.frame;
            if(rect.origin.x<=12)
            {
                [self.imgViewRecording setImage:[UIImage imageNamed:@"iconTrash"]];
                [self.timer invalidate];
                [self swiped];
                [self vibrate:nil];
                [self.inputDelegate stopRecording];
                break;
            }
            if(translate.x<=maxpoint)
            {
                NSLog(@"295 minus %f",translate.x);
                rect.origin.x = rect.origin.x-(lastpoint-translate.x);
                lastpoint = translate.x;
                self.lblSwipeToDelete.frame = rect;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGRect rect = self.lblSwipeToDelete.frame;
            rect.origin.x   = swipeRect.origin.x;
            self.lblSwipeToDelete.frame= rect;
            self.btnFileUpload.hidden= NO;
            self.textView.hidden = NO;
            self.imgView.hidden = NO;
            self.lblSwipeToDelete.hidden = YES;
            self.lblWhite.hidden = YES;
            self.imgViewRecording.hidden = YES;
            self.lblRecordingTime.hidden=YES;
            if(self.audioFilePath.length>0)
            {
                [self.timer invalidate];
            }
            [self.inputDelegate stopRecording];
            break;
        }
        default:
            break;
    }
}
//end
-(void)inputImageButtonPressed
{
    [self.textView resignFirstResponder];
    //24-2-14
    [self.textView setText:@""];
    //    [self.textView clearText];
    
    //end
    if (self.inputDelegate)//([self.inputDelegate respondsToSelector:@selector(inputNewImageButtonPressed)])
    {
        [self.inputDelegate inputImageButtonPressed];
    }
    
    /* Remove the keyboard and clear the text */
    
}
-(void)showCustomKeyboard:(UIButton *)inSender
{
//    if (![AppManager sharedManager].isFromPrivateChat) {
//        self.keyBoardStatus = eKeyBoardCustom;
//    }
    
    if (self.inputDelegate)//([self.inputDelegate conformsToProtocol:@protocol(UINewInputToolbarDelegate)])
        [self.inputDelegate showKeyboard: self andSender: inSender];
}

-(void)setupToolbar:(NSString *)buttonLabel
{
    self.isKonnectMessageAllow = YES;
//    if(![AppManager sharedManager].isFromPrivateChat)
//    {
    self.audioFilePath = @"";
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.tintColor = [UIColor lightGrayColor];
    
    UIImage *imgAttach = [UIImage imageNamed:@"iconAttach"];
    
    self.btnCustomEmoji = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnCustomEmoji setBackgroundImage:imgAttach forState:UIControlStateNormal];
    [self.btnCustomEmoji setFrame:CGRectMake(2, 6, 28, 29)];
    [self.btnCustomEmoji addTarget:self action:@selector(showCustomKeyboard:) forControlEvents:UIControlEventTouchDown];
    [self.btnCustomEmoji sizeToFit];
    //    self.keyBoardStatus = eKeyBoardCustom;
    self.btnCustomEmoji.tag = eKeyBoardCustom;
    self.isFisrtTime = YES;
    
    
    //[self addSubview:self.btnCustomEmoji];
    
    //    CGRect emojRect = self.btnCustomEmoji.frame;
    
    //file uploading button
    CGRect btnUploadRect;
    //    btnUploadRect.origin.x  = emojRect.origin.x + emojRect.size.width + 5;
    btnUploadRect.origin.x = 2;
    btnUploadRect.origin.y = 5;//emojRect.origin.y;
    btnUploadRect.size.width = 35;
    btnUploadRect.size.height = 20;
    UIImage *imgUpload = [UIImage imageNamed:@"chatAdd"];
    
    self.btnFileUpload = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnFileUpload setImage:imgUpload forState:UIControlStateNormal];
    [self.btnFileUpload setFrame: CGRectMake(4, 5, 30, 30)];
    [self.btnFileUpload addTarget:self action:@selector(showCustomKeyboard:) forControlEvents:UIControlEventTouchDown];
    [self.btnFileUpload setExclusiveTouch:YES];
    //    [self.btnFileUpload sizeToFit];
    //7-4-14
    //        self.keyBoardStatus = eKeyBoardCustom;
    self.keyBoardStatus = eKeyBoardNormal;
    //end
    self.btnFileUpload.tag = eKeyBoardCustom;
    
    self.isFisrtTime = YES;
    [self addSubview:self.btnFileUpload];
    
    /* Create UIExpandingTextView input */
    
    CGRect textRect;
    textRect.origin.x  = self.btnFileUpload.frame.origin.x +self.btnFileUpload.frame.size.width +3;
    textRect.origin.y = btnUploadRect.origin.y;
    textRect.size.width = 225;
    textRect.size.height = 30;
    //    	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:26 topCapHeight:18]];
    UIImage *image = [UIImage imageNamed:@"chatMsgBox"];
    self.imgView = [[UIImageView alloc] initWithFrame:textRect];
    [self.imgView setImage:[image stretchableImageWithLeftCapWidth:109 topCapHeight:14.5]];
    [self addSubview:self.imgView];
    
    self.textView = [[HPGrowingTextView alloc] initWithFrame: textRect];
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.textView.internalTextView.scrollIndicatorInsets =  UIEdgeInsetsMake(0, 5, 0, 5);
    //    self.textView.internalTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chatMsgBox"]];
    //UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth ;
    
    self.textView.delegate = self;
    self.textView.textColor=[UIColor darkGrayColor];
    [self.textView setFont:[UIFont systemFontOfSize:14.0]];
    [self.textView setMaxNumberOfLines:5];
    [self.textView setMinNumberOfLines : 1];
    
    [self addSubview:self.textView];
    
    
    
    
    /* Create custom send button*/
    CGRect sendRect;
    sendRect.origin.x  = textRect.origin.x + textRect.size.width+3.5;
    sendRect.origin.y = textRect.origin.y+0.5;
    sendRect.size.width = 40;
    sendRect.size.height = 30;
    
    UIImage *imageSend = [UIImage imageNamed:@"chatSendBtn"];
    
    //    imageSend          = [imageSend stretchableImageWithLeftCapWidth:floorf(imageSend.size.width/2)-20 topCapHeight:floorf(imageSend.size.height/2)];
    //nehaa 25-03-2014
    self.btnRecord             = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.btnSend.titleLabel.shadowOffset = CGSizeMake(0, -1);
    //    self.btnSend.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
    self.btnRecord.contentMode             = UIViewContentModeScaleToFill;
    
    
    [self.btnRecord setBackgroundImage:[UIImage imageNamed:@"chatRecordBtn"] forState:UIControlStateNormal];
    [self.btnRecord setFrame: sendRect];
    [self.btnRecord sizeToFit];
    [self.btnRecord setExclusiveTouch:YES];
    
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startRecording:)];
    [self.longPress setDelegate:self];
    [self.longPress setNumberOfTouchesRequired:1];
    //        [self.longPress setAllowableMovement:5];
    [self.longPress setMinimumPressDuration:0.2];
    [self.btnRecord addGestureRecognizer:self.longPress];
    
    [self.btnRecord addTarget:self action:@selector(inputButtonPressed) forControlEvents:UIControlEventTouchDown];
    self.btnRecord.enabled = YES;
    self.btnRecord.hidden=NO;
    [self addSubview:self.btnRecord];
    //end
    self.btnSend             = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSend.titleLabel.font         = [UIFont boldSystemFontOfSize:15.0f];
    //    self.btnSend.titleLabel.shadowOffset = CGSizeMake(0, -1);
    //    self.btnSend.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
    self.btnSend.contentMode             = UIViewContentModeScaleToFill;
    self.btnSend.titleLabel.textColor = [UIColor whiteColor];
    [self.btnSend setExclusiveTouch:YES];
    
    [self.btnSend setBackgroundImage:imageSend forState:UIControlStateNormal];
    [self.btnSend setFrame: sendRect];
    [self.btnSend sizeToFit];
    //nehaa 25-03-201
    [self.btnSend setTitle:@"Send" forState:UIControlStateNormal];
    [self.btnSend addTarget:self action:@selector(inputButtonPressed) forControlEvents:UIControlEventTouchDown];
    self.btnSend.enabled = NO;
    self.btnSend.hidden=YES;
    //end
    [self addSubview:self.btnSend];
    // Recording view
    CGRect rect;
    rect.origin.x = 0;
    rect.origin.y = 5.5;//emojRect.origin.y;
    rect.size.width = 50;
    rect.size.height = 29;
    rect.origin.x = rect.size.width+rect.origin.x+5;
    
    self.lblRecordingTime = [[UILabel alloc] initWithFrame:rect];
    self.lblRecordingTime.textColor = [UIColor grayColor];
    self.lblRecordingTime.font = [UIFont systemFontOfSize:14.0];
    self.lblRecordingTime.hidden = YES;
    
    self.timer = [[NSTimer alloc] init];
    
    rect.origin.x = rect.size.width + rect.origin.x +5;
    rect.size.width = 150;
    
    self.lblSwipeToDelete = [[UILabel alloc] initWithFrame:rect];
    self.lblSwipeToDelete.text = @"Swipe to delete";
    self.lblSwipeToDelete. font = [UIFont systemFontOfSize:14.0];
    self.lblSwipeToDelete.hidden = YES;
    swipeRect=self.lblSwipeToDelete.frame;
    
    self.lblWhite = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.lblRecordingTime.frame.origin.x+self.lblRecordingTime.frame.size.width, self.frame.size.height)];
    [self.lblWhite setBackgroundColor:[UIColor colorWithRed:252.0/255.0 green:252.0/255.0 blue:252.0/255.0 alpha:1.0]];
    [self.lblWhite setHidden:YES];
    
    [self addSubview:self.lblSwipeToDelete];
    [self addSubview:self.lblWhite];
    UIImage *imgRec = [UIImage imageNamed:@"micRed"];
    
    self.imgViewRecording = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5.5, 50, 29)];
    [self.imgViewRecording setImage:imgRec];
    self.imgViewRecording.hidden = YES;
    [self.imgViewRecording setContentMode:UIViewContentModeScaleAspectFit];
    
    
    [self addSubview:self.imgViewRecording];
    [self addSubview:self.lblRecordingTime];
    [self.imgViewRecording sizeToFit];

    
//    }
//
//    else
//    {
//
////        [self setBarTintColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0]];
//        [self setBarTintColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0]];
//        CGRect textRect;
//        textRect.origin.x  = 5;
//        textRect.origin.y = 5;
//        textRect.size.width = 260;
//        textRect.size.height = 30;
//        //    	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:26 topCapHeight:18]];
//        UIImage *image = [UIImage imageNamed:@"chatMsgBox"];
//        self.imgView = [[UIImageView alloc] initWithFrame:textRect];
//        [self.imgView setImage:[image stretchableImageWithLeftCapWidth:109 topCapHeight:14.5]];
//        [self addSubview:self.imgView];
//        
//        self.textView = [[HPGrowingTextView alloc] initWithFrame: textRect];
//        self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 20);
//        self.textView.internalTextView.scrollIndicatorInsets =  UIEdgeInsetsMake(0, 5, 0, 20);
//        //    self.textView.internalTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chatMsgBox"]];
//        //UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
//        self.textView.backgroundColor = [UIColor clearColor];
//        self.textView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth ;
//        
//        self.textView.delegate = self;
//        self.textView.textColor=[UIColor darkGrayColor];
//        [self.textView setFont:[UIFont fontWithName:ssFontHelveticaNeue_Light size:14.0]];
//        [self.textView setMaxNumberOfLines:5];
//        [self.textView setMinNumberOfLines : 1];
//        self.textView.internalTextView.keyboardAppearance = UIKeyboardAppearanceAlert;
//        [self addSubview:self.textView];
//        
//        
//        CGRect sendRect;
//        sendRect.origin.x  = textRect.origin.x + textRect.size.width+2.5;
//        sendRect.origin.y = textRect.origin.y+0.5;
//        sendRect.size.width = 50;
//        sendRect.size.height = 30;
//        
//        self.btnSend             = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.btnSend.titleLabel.textColor = [UIColor whiteColor];
//        [self.btnSend setFrame: sendRect];
//        [self.btnSend setTitle:@"Ready" forState:UIControlStateNormal];
//        [self.btnSend.titleLabel setFont:[UIFont fontWithName:ssFontHelveticaNeue_Bold size:13.0]];
//        [self.btnSend.layer setCornerRadius:5];
//        [self.btnSend addTarget:self action:@selector(inputButtonPressed) forControlEvents:UIControlEventTouchDown];
//        self.btnSend.enabled = NO;
//         [self.btnSend setExclusiveTouch:YES];
//        //end
//        [self addSubview:self.btnSend];
//        
//
//        UIImage *imgUpload = [UIImage imageNamed:@"chatCameraSmall"];
//        
//        self.btnFileUpload = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.btnFileUpload setImage:imgUpload forState:UIControlStateNormal];
//        [self.btnFileUpload setFrame: CGRectMake(228, 3, 30, 21)];
//        [self.btnFileUpload addTarget:self action:@selector(showCustomKeyboard:) forControlEvents:UIControlEventTouchDown];
//         [self.btnFileUpload setExclusiveTouch:YES];
//        //    [self.btnFileUpload sizeToFit];
//        //7-4-14
//        //        self.keyBoardStatus = eKeyBoardCustom;
//        self.keyBoardStatus = eKeyBoardNone;
//        //end
//        self.btnFileUpload.tag = eKeyBoardCustom;
//        
//        self.isFisrtTime = YES;
//        [self.textView addSubview:self.btnFileUpload];
//        
//        self.btnDeleteText = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.btnDeleteText setImage:[UIImage imageNamed:@"chatCloseCircular"] forState:UIControlStateNormal];
//        [self.btnDeleteText setFrame: CGRectMake(232, 6, 22, 17)];
//        [self.btnDeleteText addTarget:self action:@selector(removeAllText) forControlEvents:UIControlEventTouchDown];
//        self.keyBoardStatus = eKeyBoardNone;
//        //end
//        self.btnDeleteText.tag = eKeyBoardCustom;
//        [self.btnDeleteText setHidden:YES];
//        [self.textView addSubview:self.btnDeleteText];
//    }
}
- (IBAction)vibrate:(id)sender {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
//nehaa 25-03-2014
- (void)setSendBtnProperty:(NSString*)btn
{
    if([btn isEqualToString:@"send"])
    {
        self.btnSend.hidden=NO;
        self.btnSend.enabled = YES;
        self.btnRecord.hidden=YES;
        self.btnRecord.enabled=NO;
    }
    else
    {
        self.btnSend.hidden=YES;
        self.btnSend.enabled = NO;
        self.btnRecord.hidden=NO;
        self.btnRecord.enabled=YES;
    }
    if(!_isKonnectMessageAllow)
    {
        self.btnRecord.enabled = NO;
        self.btnSend.enabled = NO;
        self.btnFileUpload.enabled = NO;
    }
}

- (void)removeAllText
{
    if(self.inputDelegate)
    {
        [self.inputDelegate removeAllText];
    }
}
//end
-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        [self setupToolbar:@"Send"];
    }
    return self;
}

-(id)init
{
    if ((self = [super init])) {
        [self setupToolbar:@"Send"];
    }
    return self;
}



#pragma mark -
#pragma mark UIExpandingTextView delegate

-(void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (self.textView.frame.size.height - height);
    CGRect ir = self.imgView.frame;
    ir.size.height = height;
    self.imgView.frame = ir;
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    self.frame = r;
    
}

//nehaa 25-03-2014
-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if(!self.isConnected)
    {
        self.btnSend.enabled = NO;
        self.btnRecord.enabled = NO;
    }
    else
    {
        self.btnSend.enabled = YES;
        self.btnRecord.enabled = YES;
        if ([growingTextView.text length] > 0)
        {
            [self setSendBtnProperty:@"send"];
        }
        else
        {
            [self setSendBtnProperty:@"record"];
        }
    }
}
//end
-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    if (self.inputDelegate)//([self.inputDelegate respondsToSelector:_cmd])
    {
        //        return [self.inputDelegate growingTextViewShouldReturn:growingTextView];
    }
    
    return YES;
    
    
}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    
    self.keyBoardStatus = eKeyBoardNormal;
    if(self.inputDelegate)// ([self.inputDelegate respondsToSelector:_cmd])
    {
        return [self.inputDelegate growingTextViewShouldBeginEditing:growingTextView];
    }
    return YES;
}


-(BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView
{
    if (self.inputDelegate)//([self.inputDelegate respondsToSelector:_cmd])
    {
                return [self.inputDelegate growingTextViewShouldEndEditing: growingTextView];
    }
    return YES;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    [self.btnCustomEmoji setBackgroundImage:[UIImage imageNamed:@"iconAttach"] forState:UIControlStateNormal];
    
       [self setKeyBoardStatus:eKeyBoardNormal];
    
    if (self.inputDelegate)//([self.inputDelegate respondsToSelector:_cmd])
    {
        [self.inputDelegate growingTextViewDidBeginEditing:growingTextView];
    }
}


- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    if (self.inputDelegate)//([self.inputDelegate respondsToSelector:_cmd])
    {
        [self.inputDelegate growingTextViewDidEndEditing: growingTextView];
    }
}


- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.inputDelegate)//([self.inputDelegate respondsToSelector:_cmd])
    {
        
        BOOL b =[self.inputDelegate growingTextView:growingTextView shouldChangeTextInRange:range replacementText:text];
        return b ;
    }
    return YES;
}


- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView
{
    if (self.inputDelegate)//([self.inputDelegate respondsToSelector:_cmd])
    {
        //        [self.inputDelegate growingTextViewDidChangeSelection: growingTextView];
    }
}


@end
