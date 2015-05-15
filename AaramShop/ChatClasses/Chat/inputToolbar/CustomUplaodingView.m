//
//  CustomUplaodingView.m
 
//
//  Created by Shakir Approutes on 21/10/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "CustomUplaodingView.h"
#import "SHFileUtil.h"
#import <QuartzCore/QuartzCore.h>
//#import "UIImageView+WebCache.h"
#import "SHBaseRequestImage.h"
//nehaa thumbnail
#import "NSData+Base64.h"
#import "UIImage+ImageEffects.h"

//end thumbnail
//#define KImageSizeWidth  200.0
//#define KImageSizeHeight 200.0
#define KPadding 10.0
#define KFontSize 13.0
#define KImageSizeWidth  200.0
#define KImageSizePortraitHeight 160.0
#define KImageSizeLandscapeHeight 160.0//end



@implementation CustomUplaodingView

@synthesize Location;
@synthesize ProgressView;
@synthesize btnCancel;
@synthesize btnDownloading;
@synthesize btnPlaying;
@synthesize btnViewing;
@synthesize eventType;
@synthesize fileLocalUrlStr;
@synthesize fileServerUrlStr;
@synthesize imgView;
@synthesize mediaType;
@synthesize isFromSelf;
@synthesize chatId;
@synthesize downloadedImage;
@synthesize fileSize;
@synthesize downloadedFileSize;
@synthesize isDownloaded;
@synthesize currentState;
@synthesize btnImgView;

//15-3-14
@synthesize closedIndicator;
@synthesize mixedIndicator;
@synthesize filledIndicator;
@synthesize btnPlay;
@synthesize btnDownload;
@synthesize btnStatus;
//end
//27-3-14 p
@synthesize  mediaOrientation;
//end
//nehaa thumbnail
@synthesize imageString;
//end thumbnail

//25-3-14 thumb download
@synthesize thumbNailIMageDownloadingState;
//end

//18-2-14
@synthesize chatType;
//end
@synthesize lblPrivateStatus;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
             [self attachLongPressHandler];
        
        //18-2-14
        self.chatType = eChatNone;
        //end
        
        self.downloadedImage = nil;
        self.fileSize = nil;
        self.downloadedFileSize = 0.0;
        self.isDownloaded = NO;
        self.currentState = eStateTypeNone;
        self.fileServerUrlStr = nil;
        
        // Initialization code
        //27-3-14 p
        mediaOrientation = eMediaLandscape;
        //end
        
        
        //progress view
        //25-3-14 thumb download
        self.thumbNailIMageDownloadingState = eStateTypeNone;
        //end
        
        
        CGRect aProgressRect;
        aProgressRect.size.width = 100.0;
        aProgressRect.size.height = 10;
        aProgressRect.origin.x = frame.size.width - aProgressRect.size.width - KImageSizeWidth;
        aProgressRect.origin.y = (frame.size.height - aProgressRect.size.height)/2 - 10.0;
        
        self.ProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.ProgressView.frame = aProgressRect;
        self.ProgressView.progress = 0.0;
        
        //        [self addSubview:self.ProgressView];
        
        //cancel Button
        
        CGRect aCancelRect;
        aCancelRect.size.width = 60.0;
        aCancelRect.size.height = 30.0;
        aCancelRect.origin.x = frame.size.width - aCancelRect.size.width - aProgressRect.size.width - KImageSizeWidth - KPadding;
        aCancelRect.origin.y = (frame.size.height - aCancelRect.size.height)/2 - 10.0;
        
        
        
        self.btnCancel = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [self.btnCancel addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
        self.btnCancel.frame = aCancelRect;
        
        self.btnCancel.tag = eTypeUpldCancel;
        
        
        //        [self addSubview: self.btnCancel];
        
        //Downloading Button
        
        CGRect aDownloadRect;
        aDownloadRect.size.width = 60.0;
        aDownloadRect.size.height = 30.0;
        aDownloadRect.origin.x =  frame.size.width - aDownloadRect.size.width - KImageSizeWidth - KPadding;
        aDownloadRect.origin.y = (frame.size.height - aDownloadRect.size.height)/2 - 10.0;
        
        
        self.btnDownloading = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.btnDownloading setTitle:@"Download" forState:UIControlStateNormal];
        [self.btnDownloading setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [self.btnDownloading addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
        self.btnDownloading.userInteractionEnabled = YES;
        //        self.btnDownloading.frame = aDownloadRect;
        
        self.btnDownloading.tag = eTypeUpldDownLoading;
        
        //        self.btnDownloading.backgroundColor = [UIColor redColor];
        //        [self addSubview: self.btnDownloading];
        
        //Playin Button
        
        CGRect aPlayRect;
        aPlayRect.size.width = frame.size.width;
        aPlayRect.size.height = 30.0;
        aPlayRect.origin.x =  frame.size.width - aPlayRect.size.width - KImageSizeWidth - KPadding;
        aPlayRect.origin.y = (frame.size.height - aPlayRect.size.height)/2 - 10.0;
        
        
        self.btnPlaying = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.btnPlaying setTitle:@"Play" forState:UIControlStateNormal];
        [self.btnPlaying setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [self.btnPlaying addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
        
        //        self.btnPlaying.frame = aPlayRect;
        
        self.btnPlaying.tag = eTypeUpldPlaying;
        
        //        [self addSubview: self.btnPlaying];
        
        //Viewing Button
        
        CGRect aViewingRect;
        aViewingRect.size.width = 60.0;
        aViewingRect.size.height = 30.0;
        aViewingRect.origin.x = frame.size.width - aViewingRect.size.width - KImageSizeWidth - KPadding;
        aViewingRect.origin.y = (frame.size.height - aViewingRect.size.height)/2 - 10.0;
        
        self.btnViewing = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.btnViewing setTitle:@"View" forState:UIControlStateNormal];
        [self.btnViewing setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        
        
        [self.btnViewing addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
        
        //        self.btnViewing.frame = aViewingRect;
        self.btnViewing.tag = eTypeUpldViewing;
        
        //        [self addSubview: self.btnViewing];
        
        
        self.ProgressView.hidden = YES;
        self.btnCancel.hidden = YES;
        self.btnDownloading.hidden = YES;
        self.btnPlaying.hidden = YES;
        self.btnViewing.hidden = YES;
        
        
    }
    return self;
}
-(void)layoutSubviews
{
//    CGRect frame = self.frame;
    [super layoutSubviews];
    
    //    NSData*thumbData = [NSData dataWithBase64EncodedString: self.imageString];
    //    UIImage *aThumbImage = [UIImage imageWithData: thumbData scale: 1.0];
    
    UIImage *aThumbImage;
    NSData*thumbData = [NSData dataWithBase64EncodedString:self.imageString];
    
    if (self.eventType == eTypeUpldUpLoaded || self.eventType == eTypeUpldDownLoaded)
    {
        aThumbImage = [UIImage imageWithData: thumbData scale: 1.0];
    }
    else
    {
        UIImage *aTempImageForBlur = [UIImage imageWithData: thumbData scale: 1.0];
        aThumbImage = [aTempImageForBlur applyTintEffectWithColor:[UIColor whiteColor]];//
    }
    if (self.mediaType == eMediaTypeImage || self.mediaType == eMediaTypeVideo)
    {
        [self.btnImgView setImage:aThumbImage forState:UIControlStateNormal];
    }
    return;
    
//    float imageWidth = 0;
//    float imageHeight = 0;
//    
//    getImageWidthByOrientationFlag(self.mediaOrientation,imageWidth);
//    getImageHeightByOrientationFlag(self.mediaOrientation,imageHeight);
//    
//    if (self.isFromSelf)
//    {
//        //progress view
//        
//        CGRect aProgressRect;
//        aProgressRect.size.width = 60.0 ;
//        aProgressRect.size.height = 5;
//        aProgressRect.origin.x = frame.size.width - aProgressRect.size.width - imageWidth;
//        aProgressRect.origin.y = (frame.size.height - aProgressRect.size.height)/2 - 10.0;
//        
//        self.ProgressView.frame = aProgressRect;
//        
//        
//        //cancel Button
//        
//        CGRect aCancelRect;
//        aCancelRect.size.width = 60.0;
//        aCancelRect.size.height = 30.0;
//        aCancelRect.origin.x = frame.size.width - aCancelRect.size.width - aProgressRect.size.width - imageWidth - KPadding;
//        aCancelRect.origin.y = (frame.size.height - aCancelRect.size.height)/2 - 10.0;
//        
//        self.btnCancel.titleLabel.font = [UIFont systemFontOfSize: KFontSize];
//        
//        self.btnCancel.frame = aCancelRect;
//        
//        
//        //Downloading Button
//        
//        CGRect aDownloadRect;
//        aDownloadRect.size.width = 60.0;
//        aDownloadRect.size.height = 30.0;
//        aDownloadRect.origin.x =  frame.size.width - aDownloadRect.size.width - imageWidth - KPadding;
//        aDownloadRect.origin.y = (frame.size.height - aDownloadRect.size.height)/2 - 10.0;
//        self.btnDownloading.titleLabel.font = [UIFont systemFontOfSize: KFontSize];
//        
//        self.btnDownloading.frame = aDownloadRect;
//        
//        //Playin Button
//        
//        CGRect aPlayRect;
//        aPlayRect.size.width = frame.size.width;
//        aPlayRect.size.height = 30.0;
//        aPlayRect.origin.x =  frame.size.width - aPlayRect.size.width - imageWidth - KPadding;
//        aPlayRect.origin.y = (frame.size.height - aPlayRect.size.height)/2 - 10.0;
//        
//        self.btnPlaying.titleLabel.font = [UIFont systemFontOfSize: KFontSize];
//        
//        self.btnPlaying.frame = aPlayRect;
//        
//        
//        //Viewing Button
//        
//        CGRect aViewingRect;
//        aViewingRect.size.width = 60.0;
//        aViewingRect.size.height = 30.0;
//        aViewingRect.origin.x = frame.size.width - aViewingRect.size.width - imageWidth - KPadding;
//        aViewingRect.origin.y = (frame.size.height - aViewingRect.size.height)/2 - 10.0;
//        self.btnViewing.titleLabel.font = [UIFont systemFontOfSize: KFontSize];
//        
//        
//        self.btnViewing.frame = aViewingRect;
//        
//        
//        
//    }
//    
//    //progress view
//    
//    CGRect aProgressRect;
//    aProgressRect.size.width = 60.0 + 20;
//    aProgressRect.size.height = 5;
//    aProgressRect.origin.x = imageWidth + KPadding;
//    aProgressRect.origin.y = (frame.size.height - aProgressRect.size.height)/2 - 10.0;
//    
//    self.ProgressView.frame = aProgressRect;
//    
//    
//    //cancel Button
//    
//    CGRect aCancelRect;
//    aCancelRect.size.width = aProgressRect.size.width;
//    aCancelRect.size.height = 30.0;
//    aCancelRect.origin.x = aProgressRect.origin.x;
//    aCancelRect.origin.y = aProgressRect.origin.y + aProgressRect.size.height;
//    self.btnCancel.titleLabel.font = [UIFont systemFontOfSize: KFontSize];
//    self.btnCancel.frame = aCancelRect;
//    
//    //Downloading Button
//    
//    CGRect aDownloadRect;
//    aDownloadRect.size.width = aProgressRect.size.width;
//    aDownloadRect.size.height = 30.0;
//    aDownloadRect.origin.x = aProgressRect.origin.x;
//    aDownloadRect.origin.y = aProgressRect.origin.y + aProgressRect.size.height;
//    
//    self.btnDownloading.titleLabel.font = [UIFont systemFontOfSize: KFontSize];
//    
//    self.btnDownloading.frame = aDownloadRect;
//    self.btnDownloading.enabled = YES;
//    
//    //Playin Button
//    
//    CGRect aPlayRect;
//    aPlayRect.size.width = aProgressRect.size.width;
//    aPlayRect.size.height = 30.0;
//    aPlayRect.origin.x =  imageWidth;
//    aPlayRect.origin.y = (frame.size.height - aPlayRect.size.height)/2 - 10.0;
//    
//    aPlayRect.origin.x = aProgressRect.origin.x;
//    aPlayRect.origin.y = aProgressRect.origin.y + aProgressRect.size.height;
//    
//    self.btnPlaying.titleLabel.font = [UIFont systemFontOfSize: KFontSize];
//    
//    self.btnPlaying.frame = aPlayRect;
//    
//    
//    //Viewing Button
//    
//    CGRect aViewingRect;
//    aViewingRect.size.width = aProgressRect.size.width;
//    aViewingRect.size.height = 30.0;
//    aViewingRect.origin.x = imageWidth;
//    aViewingRect.origin.y = (frame.size.height - aViewingRect.size.height)/2 - 10.0;
//    self.btnViewing.titleLabel.font = [UIFont systemFontOfSize:KFontSize];
//    
//    self.btnViewing.frame = aViewingRect;
//    //[self UpdateUIContents];
//    
//    //
//    CGRect stateRect = self.btnImgView.frame;
//    stateRect.origin.y = stateRect.size.height - 30;
//    stateRect.size.height = 21;
//    self.lblState.frame = stateRect;
}

-(void)UpdateUIContents
{
    switch (self.eventType)
    {
        case eTypeUpldNone:
            
            self.ProgressView.hidden = YES;
            if(self.mediaType != eMediaTypeAudeo)
            {
                self.mixedIndicator.hidden = YES;
            }
            self.btnDownload.hidden = YES;
            self.btnCancel.hidden = YES;
            self.btnDownloading.hidden = YES;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            //end
            
            break;
            
        case eTypeUpldCancel:
            //24-3-14 media
            self.btnCancel.enabled = YES;
            self.ProgressView.hidden = YES;
            self.mixedIndicator.hidden = NO;
            self.btnDownload.hidden = YES;
            self.btnStatus.hidden = NO;
            [self.btnStatus setTitle:@"Cancelling" forState:UIControlStateNormal];
            self.btnCancel.hidden = YES;
            self.btnDownloading.hidden = YES;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            self.btnPlay.hidden = YES;
            //end
            break;
            //24-3-14 media
        case eTypeDownloadCancel:
            self.ProgressView.hidden = YES;
            self.mixedIndicator.hidden = NO;
            self.btnDownload.hidden = NO;
            self.btnStatus.hidden = NO;
            [self.btnStatus setTitle:@"Cancelling" forState:UIControlStateNormal];
            self.btnCancel.hidden = YES;
            self.btnDownloading.hidden = NO;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            
            break;
            //end
            
        case eTypeUpldError:
            
            self.ProgressView.hidden = YES;
            self.mixedIndicator.hidden = NO;
            self.btnDownload.hidden = NO;
            
            self.btnCancel.hidden = YES;
            self.btnCancel.enabled = YES;
            self.btnDownloading.hidden = YES;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            
            break;
            
        case eTypeDownloadingError:
            
            self.ProgressView.hidden = YES;
            self.mixedIndicator.hidden = NO;
            self.btnDownload.hidden = NO;
            
            self.btnCancel.hidden = YES;
            self.btnCancel.enabled = YES;
            self.btnDownloading.hidden = YES;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            
            break;
            
        case eTypeUpldDownLoad:
            
            self.ProgressView.hidden = YES;
            self.mixedIndicator.hidden = NO;
            self.btnDownload.hidden = NO;
            self.btnStatus.hidden = NO;
            //24-3-14
            [self.btnStatus setTitle:@"Download" forState:UIControlStateNormal];
            //end
            
            self.btnCancel.hidden = YES;
            self.btnDownloading.hidden = NO;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            break;
            
        case eTypeUpldUpLoad:
            
            self.ProgressView.hidden = YES;
            self.mixedIndicator.hidden = NO;
            //22-3-14 sh
            self.btnPlay.hidden = YES;
            //end
            self.btnDownload.hidden = NO;
            
            self.btnStatus.hidden = NO;
            //24-3-14
            [self.btnStatus setTitle:@"Upload" forState:UIControlStateNormal];
            //end
            
            self.btnCancel.hidden = YES;
            self.btnDownloading.hidden = NO;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            break;
            
            
        case eTypeUpldDownLoading:
            
            self.ProgressView.hidden = YES;
            self.mixedIndicator.hidden = NO;
            self.btnDownload.hidden = YES;
            //23-3-14 media
            self.btnStatus.hidden = NO;
            [self.btnStatus setTitle:@"Cancel" forState:UIControlStateNormal];
            //end
            self.btnCancel.hidden = YES;
            self.btnDownloading.hidden = YES;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            break;
        case eTypeUpldDownLoaded:
            
            self.ProgressView.hidden = YES;
            self.mixedIndicator.hidden = YES;
            self.btnDownload.hidden = YES;
            self.btnStatus.hidden = YES;
            
            
            self.btnCancel.hidden = YES;
            self.btnDownloading.hidden = YES;
            
            if (self.mediaType == eMediaTypeImage)
            {
                self.btnPlaying.hidden = YES;
                self.btnViewing.hidden = YES;
            }
            else if (self.mediaType == eMediaTypeVideo)
            {
                self.btnPlaying.hidden = YES;
                self.btnViewing.hidden = YES;
                self.btnPlay.hidden = NO;
            }
            else if (self.mediaType == eMediaTypeAudeo)
            {
                self.btnPlaying.hidden = YES;
                self.btnViewing.hidden = YES;
            }
            
            break;
            
            
        case eTypeUpldUpLoading:
            self.btnCancel.enabled = YES;
            self.ProgressView.hidden = YES;
            self.mixedIndicator.hidden = NO;
            self.btnDownload.hidden = YES;
            self.btnStatus.hidden = NO;
            [self.btnStatus setTitle:@"Cancel" forState:UIControlStateNormal];
            self.btnCancel.hidden = YES;
            self.btnDownloading.hidden = YES;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            //22-3-14 sh
            self.btnPlay.hidden = YES;
            //end
            break;
            
        case eTypeUpldUpLoaded:
            
            self.ProgressView.hidden = NO;
            if(self.mediaType != eMediaTypeAudeo)
            {
                self.mixedIndicator.hidden = YES;
            }
            self.btnDownload.hidden = YES;
            self.btnStatus.hidden = YES;
            self.btnCancel.hidden = YES;
            self.btnDownloading.hidden = YES;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            if (self.mediaType == eMediaTypeVideo)
            {
                self.btnPlay.hidden = NO;
            }
            
            break;
            
            
        case eTypeUpldPlaying:
            
            self.ProgressView.hidden = YES;
            self.mixedIndicator.hidden = YES;
            self.btnDownload.hidden = YES;
            self.btnCancel.hidden = YES;
            self.btnDownloading.hidden = YES;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            break;
            
        case eTypeUpldViewing:
            
            self.ProgressView.hidden = YES;
            self.mixedIndicator.hidden = YES;
            self.btnDownload.hidden = YES;
            self.btnCancel.hidden = YES;
            self.btnDownloading.hidden = YES;
            self.btnPlaying.hidden = YES;
            self.btnViewing.hidden = YES;
            break;
            
            
        default:
            break;
    }
    self.btnImgView.tag = self.eventType;
    [self setNeedsLayout];
}
-(void)UpdateProgressBarWithValue:(double)inValue
{
    self.ProgressView.progress = inValue;
}
-(void)tappedActionOnMedia:(UITapGestureRecognizer *)inGesture
{
    
    if([self.delegate conformsToProtocol:@protocol(UploadingEventDeligate)] &&
       [self.delegate respondsToSelector:@selector(UploadingFileEventHandler:)])
    {
        [self.delegate UploadingFileEventHandler: self];
    }
    
}
-(void)PressedButton:(UIButton *)inSender
{
    //    self.eventType = inSender.tag;
    
    if([self.delegate conformsToProtocol:@protocol(UploadingEventDeligate)] &&
       [self.delegate respondsToSelector:@selector(UploadingFileEventHandler:)])
    {
        [self.delegate UploadingFileEventHandler: self];
    }
}
//nehaa thumbnail
- (CustomUplaodingView *)ImageView:(NSString *)inMsg isSelf:(BOOL)isSelf andMediaOrientation:(enMediaOrientation)inMediaOrient andthumbString:(NSString *)inthumbStr
{
    self.mediaOrientation = inMediaOrient;
    self.imageString = inthumbStr;
    float imageWidth = 0;
    float imageHeight = 0;
    
    UIImage *aThumbImage;
    NSData*thumbData = [NSData dataWithBase64EncodedString:self.imageString];
    
    if (self.eventType == eTypeUpldUpLoaded || self.eventType == eTypeUpldDownLoaded)
    {
        aThumbImage = [UIImage imageWithData: thumbData scale: 1.0];
    }
    else
    {
        UIImage *aTempImageForBlur = [UIImage imageWithData: thumbData scale: 1.0];
        aThumbImage = [aTempImageForBlur applyTintEffectWithColor:[UIColor whiteColor]];
    }
    
    
    getImageWidthByOrientationFlag(self.mediaOrientation,imageWidth);
    
    
    getImageHeightByOrientationFlag(self.mediaOrientation,imageHeight);
    self.thumbNailIMageDownloadingState = eStateTypeNone;
    
    self.fileLocalUrlStr = inMsg;
    if(isSelf)
    {
        
        
        if (self.mediaType == eMediaTypeImage || self.mediaType == eMediaTypeLocation)
        {
            self.imgView = [[UIImageView alloc]init];
            self.imgView.clipsToBounds = YES;
//            if([[AppManager sharedManager]isFromPrivateChat]==NO)
//            {
            
                self.frame =CGRectMake(320-imageWidth-10, 6.0, imageWidth, KImageSizeLandscapeHeight);
                self.imgView.frame =CGRectMake(0, 0, aThumbImage.size.width, aThumbImage.size.height);
                CGRect aBtnImageViewRect = CGRectMake(0, 0, aThumbImage.size.width, aThumbImage.size.height);
                
                self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
                [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                self.btnImgView.layer.cornerRadius = 12.0;
                self.btnImgView.clipsToBounds =YES;
                self.btnImgView.backgroundColor = [UIColor clearColor];
                [self.btnImgView setContentMode:UIViewContentModeScaleAspectFit];
                [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
                
                self.eventType = eTypeUpldUpLoaded;
                
                
                if (self.mediaType == eMediaTypeLocation)
                {
                    aThumbImage = [UIImage imageNamed:@"msgChatMapImg"];
                    self.imgView.frame =CGRectMake(0, 0, 169, 171);
                    aBtnImageViewRect = CGRectMake(0, 0, 169, 171);
                    
                    [self.btnImgView setImage:aThumbImage forState:UIControlStateNormal];
                    self.Location =  [AppManager getLocationByLocationStr: inMsg ];
                    self.Location.isSelf = self.isFromSelf;
                    
                }
                else
                {
                    [self.imgView setImage:aThumbImage];
                    //                    [self.btnImgView setImage:aThumbImage forState:UIControlStateNormal];
                }
                self.btnImgView.frame = aBtnImageViewRect;
                
                [self.btnImgView.imageView setContentMode:UIViewContentModeScaleAspectFill];
//            }
//            else
//            {
//                self.frame =CGRectMake(320-200-20, 6.0, 200, 55);
//                self.imgView.frame =CGRectMake(2, 2, 51, 51);
//                self.imgView.image = [UIImage imageNamed:@"chatBubbleCamera"];
//                CGRect aBtnImageViewRect = CGRectMake(0,0, 200, 55);
//                
//                self.lblPrivateStatus = [[UILabel alloc] initWithFrame:CGRectMake(57, 5, 150, 45)];
//                self.lblPrivateStatus.font = [UIFont fontWithName:ssFontHelveticaNeue size:12.0];
//                self.lblPrivateStatus.numberOfLines = 0;
//                
//                self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
//                [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//                self.btnImgView.layer.cornerRadius = 12.0;
//                self.btnImgView.clipsToBounds =YES;
//                self.btnImgView.backgroundColor = [UIColor clearColor];
//                [self.btnImgView setContentMode:UIViewContentModeScaleAspectFit];
//                [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
//                
//                self.eventType = eTypeUpldUpLoaded;
//                
//                self.btnImgView.frame = aBtnImageViewRect;
//                
//                [self.btnImgView.imageView setContentMode:UIViewContentModeScaleAspectFill];
//            }
            
        }
        else if (self.mediaType == eMediaTypeVideo)
        {
            self.imgView = [[UIImageView alloc]init];
//            if ([[AppManager sharedManager] isFromPrivateChat]==NO) {
            
                
                
                self.frame =CGRectMake(320-imageWidth-10, 6.0, imageWidth, KImageSizeLandscapeHeight);
                self.imgView.frame =CGRectMake(0, 0, imageWidth, imageHeight-20);
                
                CGRect aBtnImageViewRect = CGRectMake(0,0, imageWidth, imageHeight);
                
                self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
                [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                self.btnImgView.layer.cornerRadius = 12.0;
                self.btnImgView.clipsToBounds =YES;
                self.btnImgView.backgroundColor = [UIColor clearColor];
                [self.btnImgView setContentMode:UIViewContentModeScaleAspectFit];
                [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
                
                self.btnImgView.frame = aBtnImageViewRect;
                
                [self.btnImgView setImage:aThumbImage forState:UIControlStateNormal];
                
                [self.btnImgView.imageView setContentMode:UIViewContentModeScaleAspectFill];
                
//            }
//            else
//            {
//                self.frame =CGRectMake(320-200-20, 6.0, 200, 55);
//                self.imgView.frame =CGRectMake(2, 2, 51, 51);
//                self.imgView.image = [UIImage imageNamed:@"privateVideoIcon"];
//                CGRect aBtnImageViewRect = CGRectMake(0,0, 200, 55);
//                
//                self.lblPrivateStatus = [[UILabel alloc] initWithFrame:CGRectMake(57, 5, 150, 45)];
//                self.lblPrivateStatus.font = [UIFont fontWithName:ssFontHelveticaNeue size:12.0];
//                self.lblPrivateStatus.numberOfLines = 0;
//                
//                self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
//                [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//                self.btnImgView.layer.cornerRadius = 12.0;
//                self.btnImgView.clipsToBounds =YES;
//                self.btnImgView.backgroundColor = [UIColor clearColor];
//                [self.btnImgView setContentMode:UIViewContentModeScaleAspectFit];
//                [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
//                
//                self.eventType = eTypeUpldUpLoaded;
//                
//                self.btnImgView.frame = aBtnImageViewRect;
//                
//            }
            
            
        }
        else if (self.mediaType == eMediaTypeAudeo)
        {
            self.frame = CGRectMake(320-200,6, 180,KImageSizeLandscapeHeight);
            CGRect aBtnImageViewRect = CGRectMake(0,0, 180,55);
            
            self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
            [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            self.btnImgView.layer.cornerRadius = 12.0;
            self.btnImgView.clipsToBounds =YES;
            self.btnImgView.backgroundColor = [UIColor clearColor];
            [self.btnImgView setContentMode:UIViewContentModeScaleAspectFit];
            [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
            
            self.btnImgView.frame = aBtnImageViewRect;
            
        }
        
        [self addSubview:self.btnImgView];
//        if([[AppManager sharedManager] isFromPrivateChat]==YES)
//        {
//            [self addSubview:self.imgView];
//            [self addSubview:self.lblPrivateStatus];
//        }
        
    }
    else
    {
        //        keyboard_bg
        
        if (self.mediaType == eMediaTypeImage)
        {
//            if([[AppManager sharedManager]isFromPrivateChat]==NO)
//            {
                self.imgView = [[UIImageView alloc]init];
                self.frame = CGRectMake(4, 6, imageWidth, KImageSizeLandscapeHeight);
                self.imgView.frame =CGRectMake(0, 0, aThumbImage.size.width, aThumbImage.size.height);
                //                [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
                
                
                CGRect aBtnImageViewRect = CGRectMake(0, 0, aThumbImage.size.width, aThumbImage.size.height);
                
                self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
                [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                self.btnImgView.layer.cornerRadius = 12.0;
                self.btnImgView.clipsToBounds =YES;
                
                [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
                
                self.btnImgView.frame = aBtnImageViewRect;
                //                [self.btnImgView setImage:aThumbImage forState:UIControlStateNormal];
                [self.imgView setImage:aThumbImage];
                
                [self.btnImgView.imageView setContentMode:UIViewContentModeScaleAspectFill];
                
//            }
//            else
//            {
//                self.imgView = [[UIImageView alloc]init];
//                self.frame = CGRectMake(4, 6, 200, 55);
//                self.imgView.frame =CGRectMake(2, 2, 51, 51);
//                
//                self.imgView.image = [UIImage imageNamed:@"chatBubbleCamera"];
//                
//                [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
//                
//                
//                CGRect aBtnImageViewRect = CGRectMake(0,0, 200, 55);
//                
//                self.lblPrivateStatus = [[UILabel alloc] initWithFrame:CGRectMake(57, 5, 150, 45)];
//                self.lblPrivateStatus.font = [UIFont fontWithName:ssFontHelveticaNeue size:12.0];
//                self.lblPrivateStatus.numberOfLines = 0;
//                
//                
//                self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
//                [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//                self.btnImgView.layer.cornerRadius = 12.0;
//                self.btnImgView.clipsToBounds =YES;
//                
//                [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
//                
//                self.btnImgView.frame = aBtnImageViewRect;
//                
//                
//            }
        }
        
        if (self.mediaType == eMediaTypeLocation)
        {
            self.imgView = [[UIImageView alloc]init];
            self.frame = CGRectMake(4, 6, imageWidth, KImageSizePortraitHeight);
            self.imgView.frame =CGRectMake(0, 0, 169, 171);
            [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
            
            
            CGRect aBtnImageViewRect = CGRectMake(0,0, 169, 171);
            
            self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
            [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            self.btnImgView.layer.cornerRadius = 12.0;
            self.btnImgView.clipsToBounds =YES;
            
            [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
            
            self.btnImgView.frame = aBtnImageViewRect;
            
            [self.btnImgView setImage:[UIImage imageNamed:@"msgChatMapImg"] forState:UIControlStateNormal];
            [self.btnImgView.imageView setContentMode:UIViewContentModeScaleToFill];
            self.eventType = eTypeUpldDownLoaded;
            self.isDownloaded = YES;
            self.Location = [AppManager getLocationByLocationStr: inMsg ];
            self.Location.isSelf = self.isFromSelf;
            
        }
        else if (self.mediaType == eMediaTypeVideo)
        {
//            if([[AppManager sharedManager] isFromPrivateChat]==NO)
//            {
                self.imgView = [[UIImageView alloc]init];
                self.frame = CGRectMake(4, 6, imageWidth, KImageSizeLandscapeHeight);
                self.imgView.frame =CGRectMake(0, 0, imageWidth, imageHeight);
                [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
                
                
                CGRect aBtnImageViewRect = CGRectMake(0,0, imageWidth, imageHeight);
                
                self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
                [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                self.btnImgView.layer.cornerRadius = 12.0;
                self.btnImgView.clipsToBounds =YES;
                
                [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
                
                self.btnImgView.frame = aBtnImageViewRect;
                
                [self.btnImgView setImage:aThumbImage forState:UIControlStateNormal];
                
                [self.btnImgView.imageView setContentMode:UIViewContentModeScaleAspectFill];
//            }
//            else
//            {
//                self.imgView = [[UIImageView alloc]init];
//                self.frame = CGRectMake(4, 6, 200, 55);
//                self.imgView.frame =CGRectMake(2, 2, 51, 51);
//                
//                self.imgView.image = [UIImage imageNamed:@"privateVideoIcon"];
//                
//                [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
//                
//                
//                CGRect aBtnImageViewRect = CGRectMake(0,0, 200, 55);
//                
//                self.lblPrivateStatus = [[UILabel alloc] initWithFrame:CGRectMake(57, 5, 150, 45)];
//                self.lblPrivateStatus.font = [UIFont fontWithName:ssFontHelveticaNeue size:12.0];
//                self.lblPrivateStatus.numberOfLines = 0;
//                
//                
//                self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
//                [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//                self.btnImgView.layer.cornerRadius = 12.0;
//                self.btnImgView.clipsToBounds =YES;
//                
//                [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
//                
//                self.btnImgView.frame = aBtnImageViewRect;
//                
//                
//            }
            
            
        }
        else if (self.mediaType == eMediaTypeAudeo)
        {
            self.frame = CGRectMake(4, 6, 180,KImageSizeLandscapeHeight);
            CGRect aBtnImageViewRect = CGRectMake(0,0, 180,55);
            
            self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
            [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            self.btnImgView.layer.cornerRadius = 12.0;
            self.btnImgView.clipsToBounds =YES;
            self.btnImgView.backgroundColor = [UIColor clearColor];
            [self.btnImgView setContentMode:UIViewContentModeScaleAspectFit];
            [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
            
            self.btnImgView.frame = aBtnImageViewRect;
            
        }
        
        [self addSubview:self.btnImgView];
//        if([[AppManager sharedManager] isFromPrivateChat]==YES)
//        {
//            [self addSubview:self.imgView];
//            [self addSubview:self.lblPrivateStatus];
//        }
        
    }
    
    
    [self addDownloadIndicators];
    [self setNeedsLayout];
    return self;
}
//end

- (CustomUplaodingView *)ImageView:(NSString *)inMsg isSelf:(BOOL)isSelf
{
    //25-3-14 thumb download
    self.thumbNailIMageDownloadingState = eStateTypeNone;
    //end
    
    self.fileLocalUrlStr = inMsg;
    if(isSelf)
    {
        self.imgView = [[UIImageView alloc]init];
        self.imgView.frame =CGRectMake(320-KImageSizeWidth-20, 5, KImageSizeWidth, KImageSizeLandscapeHeight);
        
        CGRect aBtnImageViewRect = CGRectMake(320-KImageSizeWidth-20, 5, KImageSizeWidth, KImageSizeLandscapeHeight);
        
        self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.btnImgView.layer.cornerRadius = 12.0;
        self.btnImgView.clipsToBounds =YES;
        self.btnImgView.backgroundColor = [UIColor clearColor];
        [self.btnImgView setContentMode:UIViewContentModeScaleAspectFit];
        [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
        
        self.btnImgView.frame = aBtnImageViewRect;
        
        
        if (self.mediaType == eMediaTypeImage)
        {
            //22-1-14 thumbnail
            
            //            NSData *imageData1 = [SHFileUtil readFileFromCache: inMsg];//test
            
            NSData *imageData = [SHFileUtil readFileFromCache: [Utils getThumbNailImagePathByItsImagePath: inMsg]];
            UIImage *aImage = [UIImage imageWithData: imageData];
            
            //            aImage = [Utils resizeImage:aImage width: 100 height:100];
            
            [self.btnImgView setImage:aImage forState:UIControlStateNormal];
            //end
            
            
        }
        else if (self.mediaType == eMediaTypeVideo)
        {
            
            
            if (self.eventType == eTypeUpldPlaying)
            {
                [self.btnImgView setBackgroundImage:[UIImage imageNamed:@"videoIcon"] forState:UIControlStateNormal];
                
            }
            else
            {
                [self.btnImgView setBackgroundImage:[UIImage imageNamed:@"videoIcon2"] forState:UIControlStateNormal];
                //                self.lblState.text = @"Download";
                
                
            }
            //            self.imgView.image = [UIImage imageNamed:@"videoIcon2"];
        }
        else if (self.mediaType == eMediaTypeAudeo)
        {
            
            if (self.eventType == eTypeUpldPlaying)
            {
                //                [self.btnImgView setBackgroundImage:[UIImage imageNamed:@"audioIcon"] forState:UIControlStateNormal];
                
            }
            else
            {
                //                self.lblState.text = @"Download";
                
                //                [self.btnImgView setBackgroundImage:[UIImage imageNamed:@"audioIcon"] forState:UIControlStateNormal];
                
            }
            
            //            self.imgView.image = [UIImage imageNamed:@"audioIcon2"];
            
            
        }
        [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
        
        //        [self addSubview: self.imgView];
        [self addSubview: self.btnImgView];
        
    }
    else
    {
        //        keyboard_bg
        
        self.imgView = [[UIImageView alloc]init];
        self.imgView.frame =CGRectMake(4,5, KImageSizeWidth, KImageSizeLandscapeHeight);
        [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
        
        
        CGRect aBtnImageViewRect = CGRectMake(4, 5, KImageSizeWidth, KImageSizeLandscapeHeight);
        
        self.btnImgView = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.btnImgView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.btnImgView.layer.cornerRadius =12.0;
        self.btnImgView.clipsToBounds =YES;
        [self.btnImgView addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
        
        self.btnImgView.frame = aBtnImageViewRect;
        
        
        if (self.mediaType == eMediaTypeImage)
        {
            //22-1-14 thumbnail
            NSString *FileLocalPath =   [Utils getThumbNailImagePathByItsImagePath: [NSString stringWithFormat:@"%@",[Utils getSimpleStringFromURL : self.fileServerUrlStr]]];
            
            NSString *thumbFilePath = [NSString stringWithFormat:@"%@",[Utils getThumbNailImagePathByItsImagePath: inMsg]];
            
            NSData *imageData =  [SHFileUtil readFileFromCache : FileLocalPath];
            
            UIImage *aImage = [UIImage imageWithData: imageData];
            
            if (aImage)
            {
                [self.btnImgView setImage: aImage forState:UIControlStateNormal];
                
            }
            else
            {
                //                self.imgView.image = [UIImage imageNamed:@"pictureIcon"];
                //                [self.imgView setImageWithURL:[NSURL URLWithString:inMsg] placeholderImage:[UIImage imageNamed:@"pictureIcon"]];
                //                [self.imgView.layer setCornerRadius:12.0];
                //                [self.imgView setClipsToBounds:YES];
                //                [self.btnImgView setBackgroundImage:[UIImage imageNamed:@"pictureIcon"] forState:UIControlStateNormal];
                [self.btnImgView setBackgroundImage:[UIImage imageNamed:@"pictureIcon"] forState:UIControlStateNormal];
                self.lblState.text = @"Download";
                
            }
            //end
        }
        else if (self.mediaType == eMediaTypeVideo)
        {
            
            NSData *videoData =  [SHFileUtil readFileFromCache : inMsg];
            
            if (videoData)
            {
                [self.btnImgView setBackgroundImage:[UIImage imageNamed:@"videoIcon"] forState:UIControlStateNormal];
                
            }
            else
            {
                self.lblState.text = @"Download";
                
                [self.btnImgView setBackgroundImage:[UIImage imageNamed:@"videoIcon2"] forState:UIControlStateNormal];
                
            }
            //            self.imgView.image = [UIImage imageNamed:@"videoIcon2"];
            
            
        }
        else if (self.mediaType == eMediaTypeAudeo)
        {
            
            NSData *audioData =  [SHFileUtil readFileFromCache : inMsg];
            if (audioData)
            {
                //                [self.btnImgView setBackgroundImage:[UIImage imageNamed:@"audioIcon"] forState:UIControlStateNormal];
                
            }
            else
            {
                //                [self.btnImgView setBackgroundImage:[UIImage imageNamed:@"audioIcon"] forState:UIControlStateNormal];
                self.lblState.text = @"Download";
                
                
            }
            
            //            self.imgView.image = [UIImage imageNamed:@"audioIcon2"];
            
            
        }
        //        [self addSubview:self.imgView];
        [self addSubview:self.btnImgView];
        
        
        //        self.imgView.backgroundColor = [UIColor redColor];
        
    }
    
    //15-3-14 frame and size
    //    CALayer *borderLayer = [CALayer layer];
    //    CGRect borderFrame = self.btnImgView.frame;
    //    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    //    [borderLayer setFrame:borderFrame];
    //    [borderLayer setCornerRadius:kCornerRadius];
    //    [borderLayer setBorderWidth:kBoarderWidth];
    //    [borderLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    //    [self.layer addSublayer:borderLayer];
    
    
    //    CGRect aBtnImageViewRect = self.btnImgView.frame;
    //    aBtnImageViewRect.size.width =     aBtnImageViewRect.size.width - 6;
    //    aBtnImageViewRect.size.height =     aBtnImageViewRect.size.height - 6;
    //    aBtnImageViewRect.origin.x = aBtnImageViewRect.origin.x + 3;
    //    aBtnImageViewRect.origin.y = aBtnImageViewRect.origin.y + 3;
    //    self.btnImgView.frame = aBtnImageViewRect;
    
    [self addDownloadIndicators];
    
    //end
    
    
    [self setNeedsLayout];
    return self;
}

- (void)addDownloadIndicators
{
    CGRect btnImagRect = self.btnImgView.frame;
    
    if (self.mediaType == eMediaTypeAudeo)
    {
        btnImagRect.size.width = btnImagRect.size.height = 25.0;
        btnImagRect.origin.x = ((self.btnImgView.frame.size.width - btnImagRect.size.width)/2.0)+25;
        btnImagRect.origin.y = ((self.btnImgView.frame.size.height - btnImagRect.size.height)/2.0)-8;
    }
    else
    {
//        if([[AppManager sharedManager] isFromPrivateChat]==YES)
//        {
//            btnImagRect.size.width = btnImagRect.size.height = 25.0;
//            btnImagRect.origin.x = ((self.btnImgView.frame.size.width - btnImagRect.size.width)/2.0)+25;
//            btnImagRect.origin.y = ((self.btnImgView.frame.size.height - btnImagRect.size.height)/2.0)-8;
//        }
//        else
//        {
            btnImagRect.size.width = btnImagRect.size.height = 36.0;
            btnImagRect.origin.x = (self.btnImgView.frame.size.width - btnImagRect.size.width)/2.0;
            btnImagRect.origin.y = (self.btnImgView.frame.size.height - btnImagRect.size.height)/2.0;
//        }
    }
    
    self.closedIndicator = [[RMDownloadIndicator alloc]initWithFrame:btnImagRect type:kRMClosedIndicator];
    [self.closedIndicator setBackgroundColor:[UIColor whiteColor]];
    [self.closedIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    [self.closedIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    self.closedIndicator.radiusPercent = 0.45;
    //[self.btnImgView addSubview:self.closedIndicator];
    // [self.closedIndicator loadIndicator];
    
    self.filledIndicator = [[RMDownloadIndicator alloc]initWithFrame:btnImagRect type:kRMFilledIndicator];
    [self.filledIndicator setBackgroundColor:[UIColor whiteColor]];
    [self.filledIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    [self.filledIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    self.filledIndicator.radiusPercent = 0.45;
    // [self.btnImgView addSubview:self.filledIndicator];
    //[self.filledIndicator loadIndicator];
    
    self.mixedIndicator = [[RMDownloadIndicator alloc]initWithFrame:btnImagRect type:kRMMixedIndictor];
    if (self.mediaType == eMediaTypeAudeo)
    {
        if (self.isFromSelf == YES) {
            [self.mixedIndicator setBackgroundColor:[UIColor whiteColor]];
            [self.mixedIndicator setFillColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0f]];
            [self.mixedIndicator setStrokeColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0f]];
            
        }
        else
        {
            [self.mixedIndicator setBackgroundColor:[UIColor blueColor]];
            [self.mixedIndicator setFillColor:[UIColor colorWithRed:42.0/255.0 green:137.0/255.0 blue:252.0/255.0 alpha:1.0]];
            [self.mixedIndicator setStrokeColor:[UIColor colorWithRed:42.0/255.0 green:137.0/255.0 blue:252.0/255.0 alpha:1.0]];
            
        }
    }
    else
    {
        [self.mixedIndicator setBackgroundColor:[UIColor whiteColor]];
    }
    self.mixedIndicator.radiusPercent = 0.45;
    [self.btnImgView addSubview:self.mixedIndicator];
    [mixedIndicator loadIndicator];
    
    self.mixedIndicator.hidden = YES;
    [self.mixedIndicator setBackgroundColor: [UIColor clearColor]];
    self.mixedIndicator.delegate = self;
    
    //
    CGRect stateRect = self.btnImgView.frame;
    
    stateRect.origin.y = stateRect.size.height - 30;
    
    stateRect.size.height = 21;
    
    
    self.lblState = [[UILabel alloc] initWithFrame: stateRect];
    
    
    self.lblState.textAlignment = NSTextAlignmentCenter;
    
    [self.lblState setFont:[UIFont systemFontOfSize:10]];
    [self addSubview: self.lblState];
    self.lblState.hidden = YES;
    
    
    
    CGRect btnStateRect = self.btnImgView.frame;
    
    btnStateRect.size.width = 90;
    btnStateRect.size.height = 15;
    if (self.mediaType == eMediaTypeAudeo)
    {
        btnStateRect.origin.x =( (self.btnImgView.frame.size.width - btnStateRect.size.width)/2.0)+25;
    }
    else
    {
//        if([[AppManager sharedManager]isFromPrivateChat]==YES)
//        {
//            btnStateRect.origin.x =( (self.btnImgView.frame.size.width - btnStateRect.size.width)/2.0)+25;
//        }
//        else
//        {
            btnStateRect.origin.x =(self.btnImgView.frame.size.width - btnStateRect.size.width)/2.0;
//        }
    }
    btnStateRect.origin.y = self.btnImgView.frame.size.height - 26;
    
    self.btnStatus = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.btnStatus setTitle:@"Download" forState:UIControlStateNormal];
    [self.btnStatus setFrame: btnStateRect];
    [self.btnStatus setBackgroundImage:[UIImage imageNamed:@"bgDownload"] forState:UIControlStateNormal];
    [self.btnStatus.titleLabel setFont:[UIFont systemFontOfSize:13]] ;
    
    [self.btnStatus addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
    self.btnStatus.hidden = YES;
    [self.btnImgView addSubview: self.btnStatus];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedActionOnMedia:)];
    [tap setNumberOfTapsRequired:1];
    [self.mixedIndicator addGestureRecognizer: tap];
    
    //Btn Play on for for video
    self.btnPlay = [UIButton buttonWithType: UIButtonTypeCustom];
    //    [self.btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    [self.btnPlay setFrame: btnImagRect];
    [self.btnPlay setBackgroundImage:[UIImage imageNamed:@"iconVideoPlay"] forState:UIControlStateNormal];
    
    [self.btnPlay addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
    self.btnPlay.hidden = YES;
    [self.btnImgView addSubview: self.btnPlay];
    
    
    
    self.btnDownload = [UIButton buttonWithType: UIButtonTypeCustom];
    //    [self.btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    [self.btnDownload setFrame: btnImagRect];
    [self.btnDownload setBackgroundImage:[UIImage imageNamed:@"iconDownload"] forState:UIControlStateNormal];
    
    [self.btnDownload addTarget: self action:@selector(PressedButton:) forControlEvents: UIControlEventTouchUpInside];
    self.btnDownload.hidden = YES;
    [self.btnImgView addSubview: self.btnDownload];
    
    
}
//-(CLocation *)getLocationByLocationStr:(NSString *)inLocationStr
//{
//    CLocation *aLocation = [[CLocation alloc] init];
//
//    NSArray *aLocationComponents = [inLocationStr componentsSeparatedByString:@","];
//
//    CLLocationCoordinate2D  aCoordinate ;
//
//    aCoordinate.latitude = [[aLocationComponents objectAtIndex:0] doubleValue];
//    aCoordinate.longitude = [[aLocationComponents objectAtIndex:1] doubleValue];
//    aLocation.Coordinates = aCoordinate;
//    aLocation.LocationName = [NSString stringWithFormat:@"%@",[aLocationComponents objectAtIndex:2]];
//    return aLocation;
//}


#pragma RMProgressDeligate
- (void)updateWithTotalBytes:(CGFloat)bytes downloadedBytes:(CGFloat)downloadedBytes
{
    
    //    if (self.eventType == eTypeUpldUpLoading)
    //    {
    //        self.lblState.text = @"Uploading...";
    //
    //    }
    //    if (self.eventType == eTypeUpldDownLoading)
    //    {
    //        self.lblState.text = @"Downloading...";
    //
    //    }
    //    self.btnDownload.hidden = YES;
    //    self.btnPlay.hidden = YES;
    
    if ((bytes - downloadedBytes) == 0)
    {
        //        [self.mixedIndicator removeFromSuperview];
        //        self.mixedIndicator.hidden = YES;
        
        //        self.isDownloaded = YES;
        
        if (self.mediaType == eMediaTypeVideo)
        {
            self.btnPlay.hidden = NO;
        }
        else if (self.mediaType == eMediaTypeAudeo)
        {
            //            [self.btnImgView setBackgroundImage:[UIImage imageNamed:@"audioIcon"] forState:UIControlStateNormal];
            
        }
        self.lblState.text = @"";
        self.btnStatus.hidden = YES;
    }
    
    if (self.eventType == eTypeUpldUpLoading || self.eventType == eTypeUpldDownLoading)
    {
        
    }
    else
    {
        //        [self.mixedIndicator updateWithTotalBytes:1.0 downloadedBytes:0];
    }
    //    self.btnStatus.hidden = YES;
    
}



-(void)doFetchThumbImageByThumbUrl:(NSString *)inThumbUrl
{
    //25-3-14 thumb download
    if (self.thumbNailIMageDownloadingState != eStateTypeNone)
    {
        return;
    }
    //25-3-14 thumb download
    self.thumbNailIMageDownloadingState = eStateTypeDownloading;
    //end
    
    
    //end
    
    if (inThumbUrl== nil || inThumbUrl.length == 0)
    {
        //        NSLog(@"*** inThumbUrl = %@ ***",inThumbUrl);
        return;
        
    }
    else
    {
        //        NSLog(@" inThumbUrl = %@",inThumbUrl);
        
    }
//    SHRequestSampleImage *aRequest = [[SHRequestSampleImage alloc] initWithURL: nil] ;
//    [aRequest setImageId:inThumbUrl];
//    [aRequest SetResponseHandler:@selector(handledImage:) ];
//    [aRequest SetErrorHandler:@selector(errorHandler:)];
//    [aRequest SetResponseHandlerObj:self];
//    [aRequest SetRequestType: eRequestType1];
//    
//    [gHttpRequestProcessor ProcessImage: aRequest];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

-(void)errorHandler:(SHBaseRequestImage *)inRequest
{
    //25-3-14 thumb download
    self.thumbNailIMageDownloadingState = eStateTypeNone;
    //end
    //  NSLog(@"*** errorHandler ***");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}
-(void)handledImage:(SHBaseRequestImage *)inRequest
{
    NSData *aImageData =  [inRequest GetResponseData];
//    SHRequestSampleImage * aCurrReq = (SHRequestSampleImage *)inRequest;
    //    NSLog(@"Handed image Index :%d",aCurrReq.index);
    //    NSLog(@"Handed image length :%d",aImageData.length);
    
    if (aImageData)
    {
        NSString *url = [NSString stringWithFormat:@"%@",inRequest.URL];
        
        NSString *FileLocalPath = [Utils getDownloadedThumbnailCachePath : url];
        [SHFileUtil writeFileInCache:aImageData toPartialPath:FileLocalPath];
        //
        UIImage *aImage = [UIImage imageWithData: aImageData];
        
        [self.btnImgView setImage:aImage forState:UIControlStateNormal];
        
        //25-3-14 thumb download
        self.thumbNailIMageDownloadingState = eStateTypeDownloaded;
        //end
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}





/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (void) attachLongPressHandler
{
    //    [self setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *touchy = [[UILongPressGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(handleLongPress:)];
    
    touchy.minimumPressDuration = 0.3;
    
    [self addGestureRecognizer:touchy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideEditMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (void) willHideEditMenu:(NSNotification*)notification
{
    
    [self resignFirstResponder];
}
#pragma mark Clipboard

- (BOOL) canPerformAction: (SEL) action withSender: (id) sender
{
    if (action == NSSelectorFromString(@"doCopy:"))
    {
        return YES;
    }
    if (action == NSSelectorFromString(@"doPaste:"))
    {
        return YES;
    }
    else if (action == NSSelectorFromString(@"doForward:"))
    {
        return YES;
    }
    else if (action == NSSelectorFromString(@"doDelete:"))
    {
        return YES;
    }
    return  NO;
}

- (void) handleLongPress: (UIGestureRecognizer*) recognizer
{
    
    NSLog(@"Event Type ::: %d",eventType);
    if(eventType == eTypeUpldUpLoading||eventType == eTypeUpldDownLoading  || eventType == eTypeUpldViewing || eventType == eTypeUpldPlaying || eventType == eTypeUpldCancel)
        return;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if(self.delegate && [self.delegate conformsToProtocol:@protocol(UploadingEventDeligate)] && [self.delegate respondsToSelector:@selector(hideKeyboard)])
        {
            [ self.delegate hideKeyboard];
        }
        [self becomeFirstResponder];
        
        //        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"Copy" action: NSSelectorFromString(@"doCopy:")];
        //
        //        UIMenuItem *forward = [[UIMenuItem alloc] initWithTitle:@"Forward" action:NSSelectorFromString(@"doForward:")];
        UIMenuItem *delete = [[UIMenuItem alloc] initWithTitle:@"Delete" action: NSSelectorFromString(@"doDelete:")];
        
        
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:delete, nil]];
        
        [menu setTargetRect: self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
        
    }
}
- (BOOL) canBecomeFirstResponder
{
    return YES;
}

-(void)doCopy:(id)inSender
{
    if (self.delegate &&  [self.delegate conformsToProtocol: @protocol(UploadingEventDeligate)] && [self.delegate respondsToSelector:@selector(clipBoardCopyFromCell:)])
    {
        [self.delegate clipBoardCopyFromCell: self];
    }
}

-(void)doForward:(id)inSender
{
    if (self.delegate &&  [self.delegate conformsToProtocol: @protocol(UploadingEventDeligate)] && [self.delegate respondsToSelector:@selector(clipBoardForwardFromCell:)])
    {
        [self.delegate clipBoardForwardFromCell:self];
    }
}

-(void)doDelete:(id)inSender
{
    if (self.delegate &&  [self.delegate conformsToProtocol: @protocol(UploadingEventDeligate)] && [self.delegate respondsToSelector:@selector(clipBoardDeleteFromCell:)])
    {
        [self.delegate clipBoardDeleteFromCell: self];
    }
}


@end
