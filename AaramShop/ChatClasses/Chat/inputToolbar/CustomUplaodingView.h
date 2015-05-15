//
//  CustomUplaodingView.h

//
//  Created by Shakir Approutes on 21/10/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
//15-3-14
#import "RMDownloadIndicator.h"
//end
#import "CLocation.h"
#import "ChatDefines.h"

typedef enum
{
    eTypeUpldNone = 0,
    eTypeUpldCancel,
    eTypeDownloadCancel,
    eTypeUpldDownLoad,
    eTypeUpldDownLoading,
    eTypeUpldDownLoaded,
    eTypeUpldUpLoad,
    eTypeUpldUpLoading,
    eTypeUpldUpLoaded,
    eTypeUpldPlaying,
    eTypeUpldViewing,
    eTypeUpldError,
    eTypeDownloadingError
}
UploadingButtonType;

typedef enum
{
    eMediaTypeNone = 0,
    eMediaTypeImage,
    eMediaTypeVideo,
    eMediaTypeAudeo,
    eMediaTypeSound,
    eMediaTypeLocation,
    eMediaTypeOther
}
MediaType;
//27-3-14 p
typedef enum
{
    eMediaLandscape = 0,
    eMediaPortrait
}
enMediaOrientation;
//end

//4-2-14
typedef enum
{
    eStateTypeNone = 0,
    eStateTypeCancel,
    eStateTypePending,
    eStateTypeDownloading,
    eStateTypeuploading,
    eStateTypeDownloaded
}
enCurrentStateType;
//end


@protocol UploadingEventDeligate <NSObject>

@optional
-(void)UploadingFileEventHandler :(id)inHandlerClass;
//-(void)UploadingFileEventHandler :(id)inHandlerClass EventType :(UploadingButtonType)inEventType andCurrentState :(enCurrentStateType)inCurrentState;
-(void)clipBoardForwardFromIndexPath:(NSIndexPath*)inIndexPath andMediaType:(NSString *)inMediaType;
-(void)clipBoardDeleteFromIndexPath:(NSIndexPath*)inIndexPath andMediaType:(NSString *)inMediaType;


-(void)clipBoardCopyFromCell:(id)inCell;
-(void)clipBoardForwardFromCell:(id)inCell;
-(void)clipBoardDeleteFromCell:(id)inCell;
-(void)hideKeyboard;

@end


@interface CustomUplaodingView : UIView<RMProgressDelegate>

@property(nonatomic,strong)NSString *fileLocalUrlStr;
@property(nonatomic,retain)NSString *fileServerUrlStr;
@property(nonatomic,strong)NSString *chatId;

@property(nonatomic,strong)UIProgressView *ProgressView;
@property(nonatomic,strong)UIButton *btnCancel;
@property(nonatomic,strong)UIButton *btnDownloading;
@property(nonatomic,strong)UIButton *btnPlaying;
@property(nonatomic,strong)UIButton *btnViewing;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UIButton *btnImgView;
@property(nonatomic,strong)UIButton *btnPlay;
@property(nonatomic,strong)UIButton *btnDownload;
@property(nonatomic,strong)UIButton *btnStatus;
@property(nonatomic,strong)UILabel *lblPrivateStatus;

@property(nonatomic,strong)UILabel *lblState;

@property(nonatomic,strong)UIImage *downloadedImage;
@property(nonatomic,strong)NSString * fileSize;
@property(nonatomic,assign)double downloadedFileSize;
@property(nonatomic,strong) id<UploadingEventDeligate>delegate;
@property(nonatomic,assign) UploadingButtonType eventType;
@property(nonatomic,assign) MediaType mediaType;
@property(nonatomic,assign) enCurrentStateType currentState;
//27-3-14 p
@property(nonatomic,assign) enMediaOrientation mediaOrientation;
//end
//nehaa thumbnail
@property(nonatomic,strong)NSString * imageString;
//end thumbnail
@property(nonatomic,assign) BOOL isFromSelf;
@property(nonatomic,assign) BOOL isDownloaded;

//18-2-14
@property(nonatomic,assign)enChatType chatType;
//end
//15-3-14
@property (strong, nonatomic) RMDownloadIndicator *closedIndicator;
@property (strong, nonatomic) RMDownloadIndicator *filledIndicator;
@property (strong, nonatomic) RMDownloadIndicator *mixedIndicator;

//end...

//25-3-14 thumb download...
@property(nonatomic,assign) enCurrentStateType thumbNailIMageDownloadingState;
//end...
@property(nonatomic,strong)CLocation *Location;


-(void)UpdateUIContents;
-(void)UpdateProgressBarWithValue:(double)inValue;
- (CustomUplaodingView *)ImageView:(NSString *)inMsg isSelf:(BOOL)isSelf;
//nehaa thumbnail
- (CustomUplaodingView *)ImageView:(NSString *)inMsg isSelf:(BOOL)isSelf andMediaOrientation:(enMediaOrientation)inMediaOrient andthumbString:(NSString *)inthumbStr;
//end thumbnail

@end
