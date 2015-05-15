//
//  SMChatViewController.h
//  jabberClient
//
//  Created by cesarerocchi on 7/16/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "XMPP.h"
#import "TURNSocket.h"
#import "SMMessageDelegate.h"
#import "XMPPRoom.h"
#import "AppDelegate.h"
#import "UIInputToolbar.h"
#import "ChatCustomKeyboardViewController.h"
#import "CustomUplaodingView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GCDAsyncSocket.h"
#import "CustomChatView.h"
#import "ChatFirstRowCell.h"
#import <AVFoundation/AVFoundation.h>
#import "JCRBlurView.h"
#import "ShareLocationViewController.h"
#import "UIImage+Extension.h"
#import "SHBaseRequest.h"
//#import "ContactsDetailViewController.h"
enum OTRChatState {
    kOTRChatStateUnknown =0,
    kOTRChatStateActive = 1,
    kOTRChatStateComposing = 2,
    kOTRChatStatePaused = 3,
    kOTRChatStateInactive = 4,
    kOTRChatStateGone =5
};
typedef enum {
    SMCHAT_AT_TOP_OF_STACK = 0,
    SMCHAT_NOT_IN_STACK = 1,
    SMCHAT_EXIST_BUT_NOT_ON_TOP = 2
}SMChatStatus;

@interface SMChatViewController : UIViewController </*ContactsDetailViewDelegate,*/UITableViewDelegate, UITableViewDataSource, SMMessageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate,UITextFieldDelegate,UINewInputToolbarDelegate,ChatCustomKeyboardViewDelegate,UIWebViewDelegate,UploadingEventDeligate,MPMediaPickerControllerDelegate,TableLoadMoreDelegate,GCDAsyncSocketDelegate,clipBoardDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIGestureRecognizerDelegate,ShareWithLocationDelegate,UIActionSheetDelegate,RequestDeligate>
{
    UIView* keyboard;
    int originalKeyboardY;
    int originalLocation;
	NSString		*chatWithUser;
	UITableView		*tView;
	NSMutableArray	*messages;
	NSMutableArray *turnSockets;
    UIImagePickerController * picker;
    UIInputToolbar *inputToolbar;
    

    BOOL isMovedUp;
    BOOL isKeyBoard;
    BOOL keyboardIsVisible;
    BOOL customKeyboardVisible;
    
    UIView *viewEmojiContainer;
    
    ChatCustomKeyboardViewController *chatCustomKeyboardViewController;
    NSArray *arrayEmoji;
    NSArray *arrayEmoticons;
    NSArray *arrayStickers;
    UITapGestureRecognizer *tap;
    int isRecv;
    NSString *param;
    BOOL isAnyKeyBoardShowing;
    BOOL _reloading;
    BOOL isPulled;
    BOOL isOnline;
    IBOutlet  UIView *viewforNetworkConnection;
    IBOutlet  UILabel *lblNetworkMsg;
    UIBackgroundTaskIdentifier bgTask;
    BOOL isProcessFailedMsg;
    UIImage *thumbnailImage;
    CGRect kKeyBoardFrame;
}
@property (nonatomic, assign) BOOL isAlreadyInStack;
@property (nonatomic,assign)BOOL isComingFrom;
@property (nonatomic) SMChatStatus eSMChatStatus;
@property (nonatomic, assign) BOOL isUnavailable;
@property (nonatomic,strong) NSString *friendNameId;
@property (nonatomic,strong) UIImagePickerController * picker;
@property (nonatomic,strong) NSMutableArray	*cacheMsgArr;
@property (nonatomic,strong) ChatFirstRowCell	*tableLoadMoreView;
@property (nonatomic,assign) int shownMsgCount;
@property (nonatomic,strong) NSMutableArray	*messages;
@property (nonatomic,strong) NSMutableArray* allKeysOfDate;
@property (nonatomic,strong) NSMutableDictionary* msgGroupedByDate;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) NSMutableArray *webViews;
@property (strong, nonatomic) IBOutlet UILabel *lblTyping;
@property (strong, nonatomic) ShareLocationViewController *shareLVController;
@property (nonatomic, retain) IBOutlet UILabel *lblUsername;
@property (nonatomic, strong) UIInputToolbar *inputToolbar;
@property (weak, nonatomic) IBOutlet UIView *viewMessage;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic,retain) NSString *chatWithUser;
@property (nonatomic,retain) IBOutlet UITableView *tView;
@property (nonatomic, retain) NSString *imageString;
@property (nonatomic, retain) AVAudioPlayer *player;
@property(assign) BOOL isRoom;
@property (nonatomic,retain) NSString *userName;
@property (strong, nonatomic)  NSString *msgText;
@property (assign, nonatomic)  BOOL isUploading;
@property (assign, nonatomic)  BOOL isDownloading;
@property (assign, nonatomic)  BOOL isOnline;
@property (assign, nonatomic)  BOOL isMediaOpened;
@property (assign, nonatomic)  BOOL isAnyMediaUploaded;
@property (nonatomic, retain) NSMutableDictionary *downloadingStatusDic;
@property (nonatomic, retain) NSMutableDictionary *uploadingStatusDic;
@property (strong, nonatomic) IBOutlet UIButton *btnUserImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) NSTimer *timerForPlaying;
@property(nonatomic , assign)long msgTotalCount;
@property(nonatomic , assign)long msgCurrfetchedCount;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingMsgIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *imgNavigationBar;
@property (strong, nonatomic) IBOutlet UILabel *lblBackground;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *btnContactInfo;

//direct media sharing
@property (nonatomic,strong)IBOutlet UIView *blurView;
@property (nonatomic, assign) BOOL isMediaAvailable;
@property (nonatomic, assign) BOOL isComingFromAddressBook;
@property (nonatomic, retain) NSDictionary *dictMessageMedia;

- (IBAction) closeChat;
- (IBAction)addGroupChatButtonClicked:(id)sender;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)updatesMessageWithFectCount:(int)inFetchCount;
- (IBAction)btnAttachBackground:(id)sender;
- (IBAction)btnChatHistory:(id)sender;
- (IBAction)btnFullUserImageViewClicked:(id)sender;
- (void)StopAudioRecorder;
- (IBAction)btnContactInfoClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewBackground;

@end
