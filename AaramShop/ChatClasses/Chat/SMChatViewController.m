//
//  SMChatViewController.m
//  jabberClient
//
//  Created by cesarerocchi on 7/16/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import "SMChatViewController.h"
#import "XMPP.h"
#import "AppDelegate.h"
#import "NSString+Utils.h"
#import "NSData+Base64.h"
#import "NSData+XMPP.h"
#import "NSString+SH.h"
#import "CXMPPController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import "XMPPMessage+XEP_0085.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ChatComponent.h"
#import "SHFileUtil.h"
#import "CustomUplaodingView.h"
#import "PlayVideoViewController.h"
#import "TopNotificationManager.h"
#import "WebLinkButton.h"
#import "ChatCustomCell.h"
#import "UIWebView+SH.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
//3-2-14
#import "XMPPDateTimeProfiles.H"
//END
#import "JCRBlurView.h"
#import <QuartzCore/QuartzCore.h>
#import "ShowLargePhotoViewController.h"
#import "MapViewController.h"
#import "NetworkService.h"
//#import "ContactsDetailViewController.h"
//#import "AddressBookDB.h"
#import "ShowFullProfileImageViewController.h"

#define MaxMsgCountAtOneTime 15
#define FontSise 12.0
#define FontName @"ProximaNova-Regular"
#define RTimeColorCode 153.0/255.0
#define GTimeColorCode 153.0/255.0
#define BTimeColorCode 153.0/255.0
#define AlphaTrans 1.0
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightLandscape 140
#define KEmojiSizeWidth  32
#define KEmojiSizeHeight 32
#define KEmotionSizeWidth  18
#define KEmotionSizeHeight 18
#define KStickerSizeWidth  120//100
#define KStickerSizeHeight 120//
#define KImageSizeWidth  215//100
#define KImageSizeHeight 215//
#define MAX_WIDTH 250
#define MAX_WIDTH_SELF 250
#define MAX_WIDTH_OTHER 200
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300
#define kSelfBubblePosition	300
#define kSelfTextWidth	250
#define kTextHeight 21
#define kOtherBubblePosition 300
#define kOtherTextWidth 210
#define NativeEmojiBEGIN_FLAG @"{+"
#define NativeEmojiEND_FLAG @"-}"
#define EmojiBEGIN_FLAG @"[/"
#define EmojiEND_FLAG @"]"
#define EmotionBEGIN_FLAG @"(/"
#define EmotionEND_FLAG @")"
#define StickerBEGIN_FLAG @"{/"
#define StickerEND_FLAG @"}"
#define LeftPaddingForSticker 20.0
#define RightPaddingForSticker 20.0
#define RightPaddingForTime 20.0
#define LeftPaddingForTime 20.0
#define VericalPaddingForTime 20.0
#define VericalPaddingForTimeOther 30.0
#define VericalPaddingChatV 3.0
#define LeftPaddingForChatV 10.0
#define RightPaddingForChatV 10.0
#define BubblePadding 8
#define kFingerGrabHandleHeight     (20.0f)

#define kMaxMessageTextLength  2000

@interface SMChatViewController()
{
    
#pragma mark
//    FriendsDetails *friends;
    float yAxis;
    NSIndexPath *inIndexPath;
    AVAudioRecorder *recorder;
    int timeSec;
    int timeMin;
    BOOL isMenuOpened;
    BOOL isStickerClicked;
    UIPanGestureRecognizer *panRecognizer;
    NSMutableArray *arrPhotos;
    NSDate *lastRecordTimestamp;
    NSMutableArray *arrGallaryPics;
    NSInteger photoIndex;
    AppDelegate *deleg;
//    NSDictionary *dictSettings;
}
- (void)animateKeyboardReturnToOriginalPosition;
- (void)animateKeyboardOffscreen;
-(void)listenerDidTakeScreenShot:(NSNotification *)inNotification;

@end

@implementation SMChatViewController

@synthesize userName, chatWithUser, inputToolbar, tView, imageString, lblUsername,img,msgText;
@synthesize isDownloading;
@synthesize isUploading;
@synthesize isOnline;
@synthesize picker;
@synthesize tableLoadMoreView;
@synthesize shownMsgCount;
@synthesize cacheMsgArr;
@synthesize webViews;
@synthesize allKeysOfDate;
@synthesize msgGroupedByDate;
@synthesize messages;
@synthesize friendNameId;
@synthesize isMediaOpened;
@synthesize isAnyMediaUploaded;
@synthesize msgTotalCount;
@synthesize msgCurrfetchedCount;
@synthesize uploadingStatusDic;
@synthesize downloadingStatusDic;
@synthesize isUnavailable;
@synthesize shareLVController;
@synthesize player;
@synthesize isMediaAvailable;
@synthesize dictMessageMedia;
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
    return [gCXMPPController xmppStream];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.isComingFromAddressBook = NO;
        isMediaAvailable = NO;
        dictMessageMedia = [[NSDictionary alloc] init];
        lastRecordTimestamp = [[NSDate alloc] init];
        arrPhotos =[[ NSMutableArray alloc] init];
        isMenuOpened = NO;
        isProcessFailedMsg = NO;
        turnSockets = [[NSMutableArray alloc] init];
        isRecv = 0;
        self.msgText = [[NSString alloc] init];
        self.isUploading = YES;
        self.isDownloading = YES;
        self.isOnline = NO;
        messages = [[NSMutableArray alloc ] init];
        self.isMediaOpened = NO;
        self.isAnyMediaUploaded = YES;
        self.uploadingStatusDic = [[NSMutableDictionary alloc] init];
        self.downloadingStatusDic = [[NSMutableDictionary alloc] init];
        self.msgTotalCount = 0;;
        self.msgCurrfetchedCount = 0;
        isStickerClicked =  NO;
        self.shareLVController = nil;
        arrGallaryPics = [[NSMutableArray alloc] init];
        photoIndex = 0;
        
        //        self.extendedLayoutIncludesOpaqueBars=YES;
    }
    
    return self;
    
}

- (void)getUserPresenceId:(NSString*)chatUser
{
    NSManagedObjectContext *moc = [gCXMPPController managedObjectContext_roster];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPResourceCoreDataStorageObject"
                                                         inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@",[[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1] lowercaseString]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]]];
    NSError *error;
    NSArray *message = [moc executeFetchRequest:request error:&error];
    for(int i=0; i<[message count];i++)
    {
        
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //    [self callRequest];
//    self.inputToolbar.keyBoardStatus = eKeyBoardNone;
//    dictSettings = [[NSMutableDictionary alloc] init];
//    dictSettings = [[[NSUserDefaults standardUserDefaults] valueForKey:kAPP_SETTINGS] objectForKey:kCHAT_SETTINGS];
//    if([[dictSettings objectForKey:kCHAT_SETTINGS_CHAT_WALLPAPER]isEqualToString:@"selected"])
//    {
//        NSData*thumbData = [NSData dataWithBase64EncodedString:[[NSUserDefaults standardUserDefaults] valueForKey:@"Wallpaper"]];
//        self.imgViewBackground.image = [UIImage imageWithData: thumbData scale: 1.0];
//    }
//    else
//    {
//        self.imgViewBackground.image = [UIImage imageNamed:@"chatBg.png"];
//    }
    [_btnBack setExclusiveTouch:YES];
    [_btnUserImage setExclusiveTouch:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver: self selector:@selector(listenerDidTakeScreenShot:) name: UIApplicationUserDidTakeScreenshotNotification  object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageCollectionFromGallery:) name:@"ImageCollectedFromGallery" object:nil];
    
    self.cacheMsgArr = [[NSMutableArray alloc] init];
    self.lblTyping.font = [UIFont systemFontOfSize:12];
    isAnyKeyBoardShowing = NO;
    deleg = APP_DELEGATE;
    self.webViews = [[NSMutableArray alloc] init];
    
    self.lblUsername.text = self.userName;
    keyboardIsVisible = NO;
    customKeyboardVisible = NO;
    
    [self initiateUIInputToolBar];
    
    NSMutableArray *array =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_IN_TEXTFIELD]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chatUserName = %@",chatWithUser];
    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    if([filteredArray count]>0)
    {
        self.inputToolbar.textView.text = [[filteredArray objectAtIndex:0] objectForKey:@"text"];
        [array removeObject:[filteredArray objectAtIndex:0]];
        [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:array] forKey:MESSAGE_IN_TEXTFIELD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.inputToolbar setSendBtnProperty:@"send"];
    }
    
    self.tView.delegate = self;
    self.tView.dataSource = self;
    [self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    gCXMPPController._messageDelegate = self;
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [tap setNumberOfTapsRequired:1];
    
    chatCustomKeyboardViewController = [[ChatCustomKeyboardViewController alloc] init];
    [chatCustomKeyboardViewController setDelegate:self];
    arrayEmoji = [chatCustomKeyboardViewController allocateEmojiArray];
    arrayEmoticons = [chatCustomKeyboardViewController allocateEmoticonsArray];
    arrayStickers = [chatCustomKeyboardViewController allocateStickersArray];
    [self.view addSubview: chatCustomKeyboardViewController.view];
    chatCustomKeyboardViewController.view.hidden = YES;
    
    //7-1-14
    self.isDownloading = NO;
    //end
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(internetConnectionListener:) name: kReachabilityChangedNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowEditMenu:) name:UIMenuControllerWillShowMenuNotification object:nil];
 
    
}
// Priyanka

-(void)imageCollectionFromGallery:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    
    arrGallaryPics=[NSMutableArray arrayWithArray:[dictionary objectForKey:@"GetArray"]];
    
    self.isMediaOpened = YES;
    photoIndex = 0;
    //        [self performSelector:@selector(uploadImage:) withObject:dict];
    [self performSelector:@selector(imageUploading) withObject:nil];
    
}
- (void)imageUploading
{
    if(photoIndex < [arrGallaryPics count])
    {
        NSDictionary *dict=[arrGallaryPics objectAtIndex:photoIndex];
        [self uploadImage:dict];
        photoIndex ++;
        [self performSelector:@selector(imageUploading) withObject:nil afterDelay:0.8];
    }
    else
    {
        photoIndex = 0;
        [arrGallaryPics removeAllObjects];
    }
}

-(void)listenerDidTakeScreenShot:(NSNotification *)inNotification
{
    AppDelegate *appDel = APP_DELEGATE;
    if ([appDel getChatWindowOpenedStatusBySender:chatWithUser])
    {
        NSLog(@"listenerDidTakeScreenShot");
        
    }
}

-(void)fetchInitialMsgs
{
    NSLog(@"fetchInitialMsgs Method");
    
    [self setMsgByCount];
    
    if([messages count]>0)
    {
        NSString *groupKey = [self.allKeysOfDate lastObject];
        if (groupKey)
        {
            int sec = self.allKeysOfDate.count-1;
            int row = [[self.msgGroupedByDate objectForKey: groupKey] count]-1;
            
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:row
                                                           inSection:sec];
            
            [self.tView scrollToRowAtIndexPath:topIndexPath
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:NO];
            
        }
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
    [self.btnBack setExclusiveTouch:YES];
    [self.btnUserImage setExclusiveTouch:YES];
    [self.btnContactInfo setExclusiveTouch:YES];
    
//    friends = [[Database database] fetchDataFromDatabaseForEntity:@"FriendsDetails" chatUserName:[[chatWithUser componentsSeparatedByString:@"@"] objectAtIndex:0] keyName:kchatUserName];
    
    
    AppDelegate *appDel =   APP_DELEGATE;
    appDel.isChatViewOpened = YES;
    [appDel setChatWindowOpenedStatusBySender: chatWithUser andBool: YES];
    
    
    NSMutableArray *array =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_COUNTER]];
    [array removeObject:chatWithUser];
    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithArray:array] forKey:MESSAGE_COUNTER];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAudio:) name:@"STOPAUDIO" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageProcessedNotification:) name:MESSAGE_PROCESSED_NOTIFICATION object:nil];
    //    if(isOnline)
    //    {
    ////        self.lblTyping.hidden = NO;
    //        self.lblTyping.text = LocalizedString(@"Online", nil);
    //    }
    
    [self showNetworkView];
    
    [self setLastDeliveredDate:nil];
    NSLog(@"%@",self.imageString);
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.imageString] placeholderImage:[UIImage imageNamed:@"homeScreenAaramShopLogo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //
    }] ;
    
    self.imgView.layer.cornerRadius = self.imgView.bounds.size.width/2;
    self.imgView.backgroundColor = [UIColor clearColor];
    self.imgView.clipsToBounds = YES;
    self.btnUserImage.backgroundColor=[UIColor clearColor];
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    NSMutableArray *aPasteArr =  [NSMutableArray arrayWithArray: [pb strings]];
    if ([aPasteArr containsObject:kMESSAGEFORWARD])
    {
        [aPasteArr removeObject:kMESSAGEFORWARD];
        if (aPasteArr && aPasteArr.count > 1)
        {
            for (NSString *aMsg in aPasteArr)
            {
                [self doSendMessage: aMsg];
            }
            
            [pb setStrings: Nil];
            
        }
        else if (aPasteArr && aPasteArr.count == 1)
        {
            //5-3-14
            
            self.inputToolbar.textView.text = [aPasteArr objectAtIndex: 0];
            [self.inputToolbar setSendBtnProperty:@"send"];
            [self.inputToolbar.textView becomeFirstResponder];
            [pb setStrings: Nil];
            //end
        }
        //end
        
    }
    
    //end
    if (self.isMediaOpened == NO)
    {
        [self.inputToolbar.btnSend setEnabled:NO];
        self.inputToolbar.btnFileUpload.enabled = NO;
        self.inputToolbar.btnRecord.enabled = NO;
        
        gCXMPPController._messageDelegate = self;
    }

}
//4-3-14
-(void)CheckXMPPConnection
{
    if([Utils isInternetAvailable])
    {
        if(![gCXMPPController.xmppStream isConnecting])
        {
            if([gCXMPPController connect])
            {
                self.lblUsername.hidden = NO;
                self.activity.hidden = YES;
                self.inputToolbar.btnSend.enabled = YES;
                self.inputToolbar.btnFileUpload.enabled = YES;
                self.inputToolbar.btnRecord.enabled = YES;
                self.inputToolbar.isConnected = YES;
                self.lblTyping.text = [self CheckPresenceOfFriend];
            }
            else
            {
                self.inputToolbar.btnSend.enabled = NO;
                self.inputToolbar.btnRecord.enabled = NO;
                self.inputToolbar.btnFileUpload.enabled = NO;
                self.activity.hidden = NO;
                self.lblUsername.hidden = YES;
                self.lblTyping.text = @"Waiting for network...";
                self.inputToolbar.isConnected = NO;
            }
        }
        else
        {
            [self performSelector:@selector(CheckXMPPConnection) withObject:nil afterDelay:2.0];
            self.inputToolbar.btnSend.enabled = NO;
            self.inputToolbar.btnRecord.enabled = NO;
            self.inputToolbar.btnFileUpload.enabled = NO;
            self.activity.hidden = NO;
            self.lblUsername.hidden = YES;
            self.lblTyping.text = @"Connecting...";
            self.inputToolbar.isConnected = NO;
        }
    }
    else
    {
        self.inputToolbar.btnSend.enabled = NO;
        self.inputToolbar.btnRecord.enabled = NO;
        self.inputToolbar.btnFileUpload.enabled = NO;
        self.activity.hidden = NO;
        self.lblUsername.hidden = YES;
        self.lblTyping.text =@"Waiting for network...";
        self.inputToolbar.isConnected=NO;
    }
    //end
}
- (void) willShowEditMenu:(NSNotification*)notification
{
    if (keyboardIsVisible && self.inputToolbar.keyBoardStatus == eKeyBoardCustom)
    {
        isMenuOpened = YES;
        [self showNormalKeyboard];
    }
}
//end
- (void)getDatabaseImages
{
    [arrPhotos removeAllObjects];
    NSManagedObjectContext *moc = [gCXMPPController messagesStoreMainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSString *user = nil;
    if([chatWithUser rangeOfString:@"/"].length>0)
    {
        user = [[chatWithUser componentsSeparatedByString:@"/"] objectAtIndex:0];
    }
    else
    {
        user = chatWithUser;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ and streamBareJidStr == %@ and mediaType == \"image\" and konnect == 0 and blackMessage = 'no'",user, [[[NSString stringWithFormat:@"%@",[gCXMPPController.xmppStream myJID]]componentsSeparatedByString:@"/"] objectAtIndex:0]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //14-5-14
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObjects: sortDescriptor, nil]];
    //end
    
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *aMessage = [[NSMutableArray alloc] init ];
    [aMessage addObjectsFromArray: [moc executeFetchRequest:request error:&error]];
    for(XMPPMessageArchiving_Message_CoreDataObject *message in aMessage)
    {
        if([message.fileaction isEqualToString:@"downloaded"]||[message.fileaction isEqualToString:@"uploaded"])
        {
            if([message.outgoing boolValue]==YES)
            {
                NewPhoto *photo = [[NewPhoto alloc] init];
                photo.originalUrl = message.filelocalpath;
                [arrPhotos addObject:photo];
            }
            else
            {
                if([message.fileaction isEqualToString:@"downloaded"])
                {
                    NewPhoto *photo = [[NewPhoto alloc] init];
                    photo.originalUrl = message.filelocalpath;
                    [arrPhotos addObject:photo];
                }
            }
        }
    }
}
- (void)getDatabaseImagesInSession
{
    NSManagedObjectContext *moc = [gCXMPPController messagesStoreMainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSString *user = nil;
    if([chatWithUser rangeOfString:@"/"].length>0)
    {
        user = [[chatWithUser componentsSeparatedByString:@"/"] objectAtIndex:0];
    }
    else
    {
        user = chatWithUser;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ and streamBareJidStr == %@ and mediaType == \"image\" and timestamp > %@ and konnect == 0 and blackMessage = 'no'",user, [[[NSString stringWithFormat:@"%@",[gCXMPPController.xmppStream myJID]]componentsSeparatedByString:@"/"] objectAtIndex:0],lastRecordTimestamp];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //14-5-14
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObjects: sortDescriptor, nil]];
    //end
    
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *aMessage = [[NSMutableArray alloc] init ];
    [aMessage addObjectsFromArray: [moc executeFetchRequest:request error:&error]];
    for(XMPPMessageArchiving_Message_CoreDataObject *message in aMessage)
    {
        if([message.fileaction isEqualToString:@"downloaded"]||[message.fileaction isEqualToString:@"uploaded"])
        {
            if([message.outgoing boolValue]==YES)
            {
                NewPhoto *photo = [[NewPhoto alloc] init];
                photo.originalUrl = message.filelocalpath;
                [arrPhotos addObject:photo];
            }
            else
            {
                if([message.fileaction isEqualToString:@"downloaded"])
                {
                    NewPhoto *photo = [[NewPhoto alloc] init];
                    photo.originalUrl = message.filelocalpath;
                    [arrPhotos addObject:photo];
                }
            }
        }
    }
}
-(void)initiateUIInputToolBar{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    /* Create toolbar */
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    yAxis =screenFrame.size.height-kDefaultToolbarHeight;
    if ([iOSVersion floatValue]>=7.0)
    {
        yAxis+=20;
    }
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, yAxis, screenFrame.size.width, kDefaultToolbarHeight)];
    [self.view addSubview:self.inputToolbar];
    inputToolbar.inputDelegate = self;
    //    inputToolbar.textView.placeholder = LocalizedString(@"Type Here",nil);
    inputToolbar.textView.textColor=[UIColor blackColor];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //  PrintFrame([[UIApplication sharedApplication] statusBarFrame]);
    if (self.inputToolbar.keyBoardStatus == eKeyBoardNormal && !CGRectIsNull(kKeyBoardFrame) && !CGRectIsEmpty(kKeyBoardFrame))
    {
        
        NSInteger y=[[UIApplication sharedApplication] statusBarFrame].size.height>20?20:0;
        
        [self.inputToolbar setFrame:CGRectMake(0, kKeyBoardFrame.origin.y-self.inputToolbar.frame.size.height-y, 320, self.inputToolbar.frame.size.height)];
        
        //    [self.inputToolbar setFrame:CGRectMake(0,(self.view.frame.size.height-kKeyboardHeightPortrait)-self.inputToolbar.frame.size.height, 320, self.inputToolbar.frame.size.height)];
        
        
    }
    //    NSLog([[UIApplication sharedApplication] statusBarFrame]);
}
-(void)keyboardFrameDidChange:(NSNotification*)notification{
    
    NSLog(@" keyb info %d", self.inputToolbar.keyBoardStatus);
    
    NSDictionary* info = [notification userInfo];
    
    if (self.inputToolbar.keyBoardStatus == eKeyBoardNormal)
    {
        
        
        //  NSLog(@"%f Height",self.inputToolbar.frame.size.height );
        kKeyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSInteger y=[[UIApplication sharedApplication] statusBarFrame].size.height>20?20:0;
        
        
        if (kKeyBoardFrame.origin.y>0) {
            keyboardIsVisible = YES;
            
        }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        [self.inputToolbar setFrame:CGRectMake(0, kKeyBoardFrame.origin.y-self.inputToolbar.frame.size.height-y, 320, self.inputToolbar.frame.size.height)];
        [tView setFrame:CGRectMake(0,64, 320, [UIScreen mainScreen].bounds.size.height-(kKeyBoardFrame.size.height+self.inputToolbar.frame.size.height+64))];
        //  self.tView.frame=rect;
        [UIView commitAnimations];
        
        
        if (self.isMediaOpened == YES)
        {
            return;
        }
        if (![messages count]==0) {
            
            //changed5-12-13 chat
            
            //	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
            //												   inSection:0];
            if(isMenuOpened)
            {
                return;
            }
            
            NSString *groupKey = [self.allKeysOfDate lastObject];
            if (groupKey&&![[NSString stringWithFormat:@"%@",groupKey] isEqualToString:@"Loader"])
            {
                int sec = self.allKeysOfDate.count - 1;
                int row = [[self.msgGroupedByDate objectForKey: groupKey] count] - 1;
                
                NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:row
                                                               inSection:sec];
                
                [self.tView scrollToRowAtIndexPath:topIndexPath
                                  atScrollPosition:UITableViewScrollPositionMiddle
                                          animated:YES];
                
                
            }
            //end
        }
        
        
    }else if(self.inputToolbar.keyBoardStatus == eKeyBoardNone){
        
    }
    else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        
        [self.inputToolbar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-(kKeyboardHeightPortrait+self.inputToolbar.frame.size.height), 320, self.inputToolbar.frame.size.height)];
        [tView setFrame:CGRectMake(0,64, 320, [UIScreen mainScreen].bounds.size.height-(kKeyboardHeightPortrait+self.inputToolbar.frame.size.height+64))];
        //  self.tView.frame=rect;
        [UIView commitAnimations];
    }
    
    
}
//Pankaj
-(void)setInputViewDefaultFrameWithCustomKeyBoardOpen{
    
    if(isKeyBoard)
        return;
    isKeyBoard=YES;
    
    if (!panRecognizer) {
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        panRecognizer.delegate = self;
        [self.tView addGestureRecognizer:panRecognizer];
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
    [self.inputToolbar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-(kKeyboardHeightPortrait+self.inputToolbar.frame.size.height), 320, self.inputToolbar.frame.size.height)];
    [tView setFrame:CGRectMake(0,64, 320, [UIScreen mainScreen].bounds.size.height-(kKeyboardHeightPortrait+self.inputToolbar.frame.size.height))];
    //  self.tView.frame=rect;
    [UIView commitAnimations];
    if ([messages count]>0) {
        NSString *groupKey = [self.allKeysOfDate lastObject];
        if (groupKey&&![[NSString stringWithFormat:@"%@",groupKey] isEqualToString:@"Loader"])
        {
            int sec = self.allKeysOfDate.count - 1;
            int row = [[self.msgGroupedByDate objectForKey: groupKey] count] - 1;
            
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:row
                                                           inSection:sec];
            
            [self.tView scrollToRowAtIndexPath:topIndexPath
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
            
            
        }
    }
}
//nehaa 25-03-2014
-(NSString *)CheckPresenceOfFriend
{
    
    NSManagedObjectContext *moc = [gCXMPPController managedObjectContext_roster];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                              inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr LIKE[c] %@ AND displayName LIKE[c] %@",[[NSUserDefaults standardUserDefaults ]objectForKey:kXMPPmyJID1],[chatWithUser lowercaseString]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    if([array count]>0)
    {
        XMPPUserCoreDataStorageObject *user = [array lastObject];
        //        NSLog(@"%@",user.displayName);
        //        NSLog(@"%@",user.sectionNum);
        if([user.sectionNum intValue]==0)
        {
            self.isUnavailable=NO;
            self.lblTyping.text = @"Online";
            return @"Online";
        }
        else
        {
            {
                if([user.sectionNum intValue]==1)
                {
                    self.isUnavailable=NO;
                    //                    [gCXMPPController.xmppLastSeen sendLastActivityQueryToJID:[XMPPJID jidWithString:chatWithUser]];
                    NSString *string = [NSString stringWithFormat:@"Last seen %@",[self convertedDate:user.lastSeen]];
                    self.lblTyping.text = string;
                    return string;
                }
                else
                {
                    self.isUnavailable = YES;
                    [gCXMPPController.xmppLastSeen sendLastActivityQueryToJID:[XMPPJID jidWithString:chatWithUser]];
                    NSString *string = @"";//[NSString stringWithFormat:@"Last seen %@",[self convertedDate:user.lastSeen]];
                    return string;
                }
            }
        }
    }
    
    else
    {
        if([gCXMPPController isConnected])
        {
            [gCXMPPController.xmppRoster acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:[chatWithUser lowercaseString]] andAddToRoster:YES];
            
            self.inputToolbar.btnSend.enabled = YES;
            self.inputToolbar.btnRecord.enabled = YES;
            self.inputToolbar.btnFileUpload.enabled = YES;
            self.inputToolbar.isConnected = YES;
            self.activity.hidden = YES;
            self.lblUsername.hidden = NO;
            return @"";
        }
        else
        {
            self.inputToolbar.btnSend.enabled = NO;
            self.inputToolbar.btnRecord.enabled = NO;
            self.inputToolbar.btnFileUpload.enabled = NO;
            self.activity.hidden = NO;
            self.lblUsername.hidden = YES;
            self.inputToolbar.isConnected = NO;
            if([self.lblTyping.text length]>0)
                return self.lblTyping.text;
            else
                return @"Connecting...";
        }
        //        return LocalizedString(@"Connecting...", nil);
    }
}
//end
- (void)removeAllObeservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MESSAGE_PROCESSED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"STOPAUDIO" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ImageCollectedFromGallery" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    if(inIndexPath!=nil)
        [self stopPlayer];
    AppDelegate *appDel =   APP_DELEGATE;
    [appDel setChatWindowOpenedStatusBySender: chatWithUser andBool: NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [self.tableLoadMoreView hideAndShowLoadMore: NO];
    self.tableLoadMoreView.ActivityIndicator.hidden = YES;
    [self setLastDeliveredDate:nil];
    //20-5-14
    [self hideKeyboard];
    //end
    if(!isMediaOpened)
    {
        
//          if([[[NSUserDefaults standardUserDefaults] valueForKey:MESSAGE_COUNTER] count]>0)
//          {
//             [[[[[APP_DELEGATE tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] valueForKey:MESSAGE_COUNTER] count]]];
//          }
//        else
//        {
//            [[[[[APP_DELEGATE tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
//        }
        if(self.inputToolbar.textView.text.length > 0)
        {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_IN_TEXTFIELD]];
            [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:chatWithUser,kchatUserName,self.inputToolbar.textView.text,@"text", nil]];
            [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:array] forKey:MESSAGE_IN_TEXTFIELD];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [self.navigationController setNavigationBarHidden:NO];
        [self removeAllObeservers];
        if ([self isDownloadingAndUploadingAreInPending] == NO)
        {        gCXMPPController._messageDelegate = nil;
            [self releaseThisViewWhenUploadingAndDownloadingIsNotInPending];
        }
    }
    [super viewWillDisappear:animated];
    
    
}
- (NSString *)convertedDate:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterShortStyle;
    df.dateStyle = NSDateFormatterMediumStyle;
    df.doesRelativeDateFormatting = YES;  // this enables relative dates like yesterday, today, tomorrow...
    
    return  [df stringFromDate:date];
}
-(void)sendAllDisplayedDeliveryreportAfterDelay
{
    NSString *aSender = nil;
    if([chatWithUser rangeOfString:@"/"].length>0)
    {
        aSender = [[chatWithUser componentsSeparatedByString:@"/"] objectAtIndex:0];
    }
    else
    {
        aSender = chatWithUser;
    }
    
    NSPredicate *aPredicate1 = [NSPredicate predicateWithFormat:@"isdelivered=0"];
    NSPredicate *aPredicate2 = [NSPredicate predicateWithFormat:@"isdelivered=1"];
    NSPredicate *aPredicate3 = [NSPredicate predicateWithFormat:@"isdelivered=2"];
    
    NSArray *orPredicateList = [NSArray arrayWithObjects:aPredicate1,aPredicate2,aPredicate3, nil];
    NSPredicate *orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates: orPredicateList];
    
    NSPredicate *aPredicate4 = [NSPredicate predicateWithFormat:@"outgoing=0"];
    NSArray *andPredicateList = [NSArray arrayWithObjects:aPredicate4,orPredicate, nil];
    
    NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates: andPredicateList];
    NSArray *filteredMsg = [messages filteredArrayUsingPredicate: andPredicate];
    
    for (NSDictionary *aMsgDic in filteredMsg)
    {
        //        [self sendDisplayedReportByChatId: [aMsgDic objectForKey:@"chatid"]];
    }
}
-(void)sendDisplayedReportByChatId:(NSString *)inChatId
{
    NSString *from =[[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID1 ] lowercaseString] ;
    NSString *to = [chatWithUser lowercaseString];
    NSString *chatid = inChatId;
    [self doDisplayMessage:[NSDictionary dictionaryWithObjectsAndKeys:from,@"to",chatid,@"id",to,@"sender", nil]];
}
//end

//-(void)setTableViewFrame{
//    [self.tView setBackgroundColor:[UIColor clearColor]];
//    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
//    [tView setFrame:CGRectMake(0, 65, 320, screenFrame.size.height-kDefaultToolbarHeight)];
//}
//14-4-14
-(void )setTotalCount
{
    
    if (self.msgTotalCount > 0)
    {
        return;
    }
    NSManagedObjectContext *moc = [gCXMPPController messagesStoreMainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSString *user = nil;
    if([chatWithUser rangeOfString:@"/"].length>0)
    {
        user = [[chatWithUser componentsSeparatedByString:@"/"] objectAtIndex:0];
    }
    else
    {
        user = chatWithUser;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ and streamBareJidStr == %@ and blackMessage = 'no' and konnect == 0",user, [[[NSString stringWithFormat:@"%@",[gCXMPPController.xmppStream myJID]]componentsSeparatedByString:@"/"] objectAtIndex:0]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]]];
    NSError *error;
    NSArray *message = [moc executeFetchRequest:request error:&error];
    
    
    if(!error && message && message.count>0)
    {
        self.msgTotalCount = message.count;
        self.msgCurrfetchedCount = self.msgTotalCount;
        self.shownMsgCount = self.msgTotalCount;
    }
    
}
-(long )getFetchCursor
{
    [self setTotalCount];
    
    long  toReturn = 0;
    
    if (self.msgTotalCount == 0)
    {
        return  toReturn;
        
    }
    
    else if (self.msgCurrfetchedCount == self.msgTotalCount)
    {
        if (self.msgTotalCount <= MaxMsgCountAtOneTime)
        {
            //all record from 0th row when maxcount greater than total msg count.
            toReturn = 0;
        }
        else
        {
            //minimum count at first Time
            toReturn = self.msgTotalCount - MaxMsgCountAtOneTime;
            self.msgCurrfetchedCount = toReturn;
        }
        
        
    }
    //fetching cursor moved up side.
    else if(self.msgCurrfetchedCount > 0)
    {
        long tempCount = self.msgCurrfetchedCount - MaxMsgCountAtOneTime;
        
        if (tempCount >= 0)
        {
            self.msgCurrfetchedCount = tempCount;
            toReturn = self.msgCurrfetchedCount;
        }
        else
        {
            self.msgCurrfetchedCount = 0;
            toReturn = self.msgCurrfetchedCount;
            
        }
    }
    //    NSLog(@" Fetch from %li",toReturn);
    //    self.shownMsgCount = toReturn;
    
    return  toReturn;
}
-(void)fetchInitialMsgsInSession
{
    
    NSMutableArray *aMessage = nil;
    
    @autoreleasepool {
        
        NSManagedObjectContext *moc = [gCXMPPController messagesStoreMainThreadManagedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                             inManagedObjectContext:moc];
        NSString *user = nil;
        if([chatWithUser rangeOfString:@"/"].length>0)
        {
            user = [[chatWithUser componentsSeparatedByString:@"/"] objectAtIndex:0];
        }
        else
        {
            user = chatWithUser;
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ and streamBareJidStr == %@ and blackMessage = 'no' and timestamp > %@ and konnect == 0",user, [[[NSString stringWithFormat:@"%@",[gCXMPPController.xmppStream myJID]]componentsSeparatedByString:@"/"] objectAtIndex:0],lastRecordTimestamp];
        
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        //14-5-14
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObjects: sortDescriptor, nil]];
        //end
        
        [request setEntity:entityDescription];
        [request setPredicate:predicate];
        
        NSError *error;
        aMessage = [[NSMutableArray alloc] init ];
        [aMessage addObjectsFromArray: [moc executeFetchRequest:request error:&error]];
        //[moc executeFetchRequest:request error:&error];
        
        
        
        
        for (XMPPMessageArchiving_Message_CoreDataObject *message in aMessage) {
            
            NSString *m = message.body;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            UIView *chatView = nil;
            
            /////////////
            //            NSLog(@"%@ %@",message.timestamp,message.body);
            
            if(m !=NULL)
            {
                [dic setObject:[m substituteEmoticons] forKey:@"msg"];
            }
            else
            {
                [dic setObject:@" " forKey:@"msg"];
            }
            
            //27-2-14 displayed
            [dic setObject:[NSNumber numberWithInt:message.isdelivered]  forKey:@"isdelivered"];
            [dic setObject: message.chatid  forKey:@"chatid"];
            [dic setObject: [NSNumber numberWithInt:[message.outgoing intValue]] forKey:@"outgoing"];
            
            //end
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"hh:mm a"];
            
            //19-5-14
            //            NSString *dateString = [dateFormat stringFromDate: message.timestamp];
            NSString *dateString = [dateFormat stringFromDate: message.dispatchTimestamp];
            
            //end
            
            [dic setObject:dateString forKey:@"time"];
            
            NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
            [date_formater setDateFormat:@"yyyy-MM-dd"];
            NSString *aDateStr = [date_formater stringFromDate: message.timestamp];
            [dic setObject:[date_formater dateFromString:aDateStr ] forKey:@"timestamp"];
            //19-5-14
            //            [dic setObject:message.timestamp forKey:@"sendTimestampDate"];
            [dic setObject:message.dispatchTimestamp forKey:@"sendTimestampDate"];
            
            //end
            if([message.outgoing boolValue]==YES)
            {
                [dic setObject:@"you" forKey:@"sender"];
                if([message.imgstr length]>0 || [message.mediaType isEqualToString:@"location"])
                {
                    if ([message.mediaType isEqualToString:@"soundit"])
                    {
                        //nehaa thumbnail
                        chatView = [self bubbleView:message.imgstr from:YES andMediaType:eMediaTypeSound andMediaOrientation: message.isPortrait andThumbString:nil];
                        //end thumbnail
                        [dic setObject:[[[message imgstr] componentsSeparatedByString:@"$$$"] objectAtIndex:0] forKey:@"link"];
                    }
                    else
                    {
                        [dic setObject:message.imgstr forKey:@"attachment"];
                        
                        if ([message.mediaType isEqualToString:@"image"])
                        {
                            //nehaa thumbnail
                            //                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeImage andMediaOrientation:message.isPortrait];
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeImage andMediaOrientation: message.isPortrait andThumbString: message.thumbBase64String];
                            //end thumbnail
                            
                        }
                        else if ([message.mediaType isEqualToString:@"location"])
                        {
                            //nehaa thumbnail
                            //                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeImage andMediaOrientation:message.isPortrait];
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeLocation andMediaOrientation: message.isPortrait andThumbString: message.thumbBase64String];
                            //end thumbnail
                            
                            CLocation *aLocation =  [AppManager getLocationByLocationStr: message.filelocalpath ];
                            [dic setObject: aLocation.LocationName forKey:@"locationName"];
                        }
                        
                        
                        else if ([message.mediaType isEqualToString:@"video"])
                        {
                            //nehaa thumbnail
                            //                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeVideo andMediaOrientation: message.isPortrait];
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeVideo andMediaOrientation:message.isPortrait andThumbString: message.thumbBase64String];
                            //end thumbnail
                            
                        }
                        else if ([message.mediaType isEqualToString:@"audio"])
                        {
                            //nehaa thumbnail
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeAudeo andMediaOrientation: message.isPortrait andThumbString:nil];
                            //end thumbnail
                            
                        }
                        
                        CustomUplaodingView *
                        cstView = [[chatView subviews] objectAtIndex: 1];
                        
                        cstView.fileServerUrlStr = message.imgstr;
                        cstView.fileLocalUrlStr = message.filelocalpath;
                        cstView.chatId = message.chatid;
                        cstView.fileSize = message.fileSize;
                        
                        if ([message.mediaType isEqualToString:@"image"] || [message.mediaType isEqualToString:@"location"])
                        {
                            cstView.eventType = eTypeUpldUpLoaded;
                            
                        }
                        else if ([message.mediaType isEqualToString:@"video"]
                                 || [message.mediaType isEqualToString:@"audio"])
                        {
                            cstView.eventType = eTypeUpldUpLoaded;
                            if([message.mediaType isEqualToString:@"audio"])
                            {
                                UIButton *btn = [cstView.subviews objectAtIndex:0];
                                btn.enabled = NO;
                                UIImageView *imgPlay = [cstView.subviews objectAtIndex:4];
                                imgPlay.hidden = NO;
                                UIProgressView *progress = [cstView.subviews objectAtIndex:5];
                                progress.hidden = NO;
                                NSString* fullPath = @"";
                                fullPath = [NSString stringWithFormat:@"ChatAudios/%@",message.filelocalpath];
                                fullPath =  [SHFileUtil getFullPathFromPath:fullPath] ;
                                NSURL *url = [NSURL fileURLWithPath:fullPath];
                                NSError *error=nil;
                                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
                                [self.player prepareToPlay];
                                UILabel *lbl = [cstView.subviews objectAtIndex:6];
                                //                                NSLog(@"%f",player.duration);
                                int minutes = (int)self.player.duration / 60;
                                int seconds = (int)self.player.duration % 60;
                                //                                NSLog(@"%@",[NSString stringWithFormat:@"%d:%02d",minutes,seconds]);
                                lbl.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
                                [self.player stop];
                                self.player = nil;
                            }
                            
                        }
                        
                        {
                            [cstView UpdateUIContents];
                            [dic setObject: message.filelocalpath  forKey:@"filelocalpath"];
                            [dic setObject: message.fileaction  forKey:@"fileaction"];
                            [dic setObject: message.fileNameWithExt  forKey:@"fileName"];
                            [dic setObject: message.chatid  forKey:@"chatid"];
                            //10-2-14
                            if (message.fileSize.length > 0)
                            {
                                [dic setObject:message.fileSize forKey:@"fileSize"];
                            }
                            
                        }
                        
                        /////////
                        
                    }
                    
                    
                }
                else
                {
                    //nehaa thumbnail
                    [dic setObject: message.chatid  forKey:@"chatid"];
                    
                    chatView = [self bubbleView:[NSString stringWithFormat:@"%@", [m substituteEmoticons]] from:YES andMediaType: eMediaTypeNone andMediaOrientation: message.isPortrait andThumbString:nil];
                    //end thumbnail
                }
                
                [dic setObject:@"self"  forKey:@"speaker"];
                
                [dic setObject:[NSNumber numberWithInt:message.isdelivered]  forKey:@"isdelivered"];
                [dic setObject:message.chatid  forKey:@"chatid"];
                
                [dic setObject:chatView  forKey:@"view"];
                
            }
            else
            {
                [dic setObject:chatWithUser forKey:@"sender"];
                if(message.isdelivered==0||message.isdelivered==1)
                {
                    NSString *from =[[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID1 ] lowercaseString] ;
                    ///
                    NSString *to = [chatWithUser lowercaseString];
                    NSString *chatid = message.chatid;
                    [self doDisplayMessage:[NSDictionary dictionaryWithObjectsAndKeys:from,@"to",chatid,@"id",to,@"sender", nil]];
                }
                
                UIView *chatView = nil;
                
                if([message.imgstr length]>0 || [message.mediaType isEqualToString:@"location"])
                {
                    if ([message.mediaType isEqualToString:@"soundit"])
                    {
                        //nehaa thumbnail
                        chatView = [self bubbleView:message.imgstr from:NO andMediaType:eMediaTypeSound andMediaOrientation:  message.isPortrait andThumbString:nil];
                        //end thumbnail
                        [dic setObject:[[[message imgstr] componentsSeparatedByString:@"$$$"] objectAtIndex:0] forKey:@"link"];
                        
                    }
                    else
                    {
                        if ([message.mediaType isEqualToString:@"image"])
                        {
                            if([message.filelocalpath rangeOfString:@"http:"].length>0)
                            {
                                //nehaa thumbnail
                                //                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeImage andMediaOrientation: message.isPortrait];
                                chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeImage andMediaOrientation: message.isPortrait andThumbString: message.thumbBase64String];
                                //end thumbnail
                            }
                            else
                            {
                                //nehaa thumbnail
                                chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.imgstr] from:NO andMediaType: eMediaTypeImage andMediaOrientation: message.isPortrait andThumbString:message.thumbBase64String];
                                //end thumbnail
                            }
                            
                        }
                        if ([message.mediaType isEqualToString:@"location"])
                        {
                            //nehaa thumbnail
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeLocation andMediaOrientation: message.isPortrait andThumbString:message.thumbBase64String];
                            CLocation *aLocation =  [AppManager getLocationByLocationStr: message.filelocalpath ];
                            [dic setObject: aLocation.LocationName forKey:@"locationName"];
                            
                        }
                        
                        else if ([message.mediaType isEqualToString:@"video"])
                        {
                            //nehaa thumbnail
                            //                        chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeVideo andMediaOrientation: message.isPortrait];
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeVideo andMediaOrientation: message.isPortrait andThumbString: message.thumbBase64String];
                            
                            //end thumbnail
                        }
                        else if ([message.mediaType isEqualToString:@"audio"])
                        {
                            //nehaa thumbnail
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeAudeo andMediaOrientation: message.isPortrait andThumbString:nil];
                            //end thumbnail
                        }
                        
                        CustomUplaodingView *
                        cstView = [[chatView subviews] objectAtIndex: 1];
                        
                        if ([message.fileaction isEqualToString:@"downloaded"])
                        {
                            cstView.isDownloaded = YES;
                            cstView.eventType = eTypeUpldDownLoaded;
                            if([message.mediaType isEqualToString:@"audio"])
                            {
                                UIButton *btn = [cstView.subviews objectAtIndex:0];
                                btn.enabled = NO;
                                UIImageView *imgPlay = [cstView.subviews objectAtIndex:4];
                                imgPlay.hidden = NO;
                                UIProgressView *progress = [cstView.subviews objectAtIndex:5];
                                progress.hidden = NO;
                                NSString* fullPath = @"";
                                fullPath =  [SHFileUtil getFullPathFromPath:message.filelocalpath] ;
                                NSURL *url = [NSURL fileURLWithPath:fullPath];
                                NSError *error=nil;
                                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
                                [self.player prepareToPlay];
                                UILabel *lbl = [cstView.subviews objectAtIndex:6];
                                //                                NSLog(@"%f",player.duration);
                                int minutes = (int)self.player.duration / 60;
                                int seconds = (int)self.player.duration % 60;
                                //                                NSLog(@"%@",[NSString stringWithFormat:@"%d:%02d",minutes,seconds]);
                                lbl.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
                                
                                [self.player stop];
                                self.player = nil;
                            }
                            
                            
                        }
                        else
                        {
                            cstView.isDownloaded = NO;
                            cstView.eventType = eTypeUpldDownLoad;
                        }
                        
                        if ([message.mediaType isEqualToString:@"location"])
                        {
                            cstView.isDownloaded = YES;
                            cstView.eventType = eTypeUpldDownLoaded;
                        }
                        
                        
                        
                        {
                            
                            cstView.fileServerUrlStr = message.imgstr;
                            cstView.fileLocalUrlStr = message.filelocalpath;
                            cstView.fileSize = message.fileSize;
                            cstView.chatId = message.chatid;
                            
                            [dic setObject: message.filelocalpath  forKey:@"filelocalpath"];
                            [dic setObject: message.fileaction  forKey:@"fileaction"];
                            [dic setObject: message.chatid  forKey:@"chatid"];
                            
                            //                            if ([message.fileaction isEqualToString:@"downloaded"])
                            //                            {
                            //                                cstView.isDownloaded = YES;
                            //                                cstView.eventType = eTypeUpldDownLoaded;
                            //                            }
                            //                            if ([message.mediaType isEqualToString:@"location"])
                            //                            {
                            //                                cstView.fileServerUrlStr = message.imgstr;
                            //                                cstView.fileLocalUrlStr = message.filelocalpath;
                            //                                cstView.fileSize = message.fileSize;
                            //                                cstView.chatId = message.chatid;
                            //
                            //                                [dic setObject: message.filelocalpath  forKey:@"filelocalpath"];
                            //                                [dic setObject: message.fileaction  forKey:@"fileaction"];
                            //                                [dic setObject: message.chatid  forKey:@"chatid"];
                            //
                            //                                if ([message.fileaction isEqualToString:@"downloaded"])
                            //                                {
                            //                                    cstView.isDownloaded = YES;
                            //                                    cstView.eventType = eTypeUpldDownLoaded;
                            //                                }
                            //                                if ([message.mediaType isEqualToString:@"location"])
                            //                                {
                            //                                    cstView.isDownloaded = YES;
                            //                                    cstView.eventType = eTypeUpldDownLoaded;
                            //                                }
                            //
                            //                                [cstView UpdateUIContents];
                            //
                            //                            }
                            
                            
                        }
                        
                        [cstView UpdateUIContents];
                        
                        ///end
                        
                    }
                    
                }
                else
                {
                    //nehaa thumbnail
                    [dic setObject: message.chatid  forKey:@"chatid"];
                    
                    chatView = [self bubbleView:[NSString stringWithFormat:@"%@", [m substituteEmoticons]] from:NO andMediaType: eMediaTypeNone andMediaOrientation: message.isPortrait andThumbString:nil];
                    //end thumbnail
                }
                
                [dic setObject:@"other"  forKey:@"speaker"];
                
                [dic setObject:chatView  forKey:@"view"];
                
            }
            
            if(message.mediaType!=nil)
            {
                
                [dic setObject:message.mediaType forKey:@"media"];
            }
            if ([self isAlreadyExistMsgByChatId:  message.chatid] == NO)
            {
                [messages addObject: dic];
                
            }
            
        }
    }
    [self updateMsgListViewIfNeededByTotalMesg: messages];
    if([messages count]>0)
    {
        NSString *groupKey = [self.allKeysOfDate lastObject];
        if (groupKey)
        {
            int sec = self.allKeysOfDate.count-1;
            int row = [[self.msgGroupedByDate objectForKey: groupKey] count]-1;
            
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:row
                                                           inSection:sec];
            
            [self.tView scrollToRowAtIndexPath:topIndexPath
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:NO];
            
        }
    }
}
-(NSMutableArray *)fetchMsgByFetchingCursor:(long)inFetchingCursor
{
    NSMutableArray *aMessage = nil;
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    @autoreleasepool {
        
        NSManagedObjectContext *moc = [gCXMPPController messagesStoreMainThreadManagedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                             inManagedObjectContext:moc];
        NSString *user = nil;
        if([chatWithUser rangeOfString:@"/"].length>0)
        {
            user = [[chatWithUser componentsSeparatedByString:@"/"] objectAtIndex:0];
        }
        else
        {
            user = chatWithUser;
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ and streamBareJidStr == %@ and blackMessage = 'no' and konnect == 0",user, [[[NSString stringWithFormat:@"%@",[gCXMPPController.xmppStream myJID]]componentsSeparatedByString:@"/"] objectAtIndex:0]];
        
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        //14-5-14
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObjects: sortDescriptor, nil]];
        //end
        
        [request setEntity:entityDescription];
        [request setPredicate:predicate];
        [request setFetchOffset: inFetchingCursor];
        [request setFetchLimit: MaxMsgCountAtOneTime];
        
        
        
        NSError *error;
        aMessage = [[NSMutableArray alloc] init ];
        [aMessage addObjectsFromArray: [moc executeFetchRequest:request error:&error]];
        //[moc executeFetchRequest:request error:&error];
        
        
        
        
        for (XMPPMessageArchiving_Message_CoreDataObject *message in aMessage) {
            
            NSString *m = message.body;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            UIView *chatView = nil;
            
            /////////////
            //            NSLog(@"%@ %@",message.timestamp,message.body);
            
            if(m !=NULL)
            {
                [dic setObject:[m substituteEmoticons] forKey:@"msg"];
            }
            else
            {
                [dic setObject:@" " forKey:@"msg"];
            }
            
            //27-2-14 displayed
            [dic setObject:[NSNumber numberWithInt:message.isdelivered]  forKey:@"isdelivered"];
            [dic setObject: message.chatid  forKey:@"chatid"];
            [dic setObject: [NSNumber numberWithInt:[message.outgoing intValue]] forKey:@"outgoing"];
            
            //end
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"hh:mm a"];
            
            //19-5-14
            //            NSString *dateString = [dateFormat stringFromDate: message.timestamp];
            NSString *dateString = [dateFormat stringFromDate: message.dispatchTimestamp];
            
            //end
            
            [dic setObject:dateString forKey:@"time"];
            
            NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
            [date_formater setDateFormat:@"yyyy-MM-dd"];
            NSString *aDateStr = [date_formater stringFromDate: message.timestamp];
            [dic setObject:[date_formater dateFromString:aDateStr ] forKey:@"timestamp"];
            //19-5-14
            //            [dic setObject:message.timestamp forKey:@"sendTimestampDate"];
            [dic setObject:message.dispatchTimestamp forKey:@"sendTimestampDate"];
            
            //end
            if([message.outgoing boolValue]==YES)
            {
                [dic setObject:@"you" forKey:@"sender"];
                if([message.imgstr length]>0 || [message.mediaType isEqualToString:@"location"])
                {
                    if ([message.mediaType isEqualToString:@"soundit"])
                    {
                        //nehaa thumbnail
                        chatView = [self bubbleView:message.imgstr from:YES andMediaType:eMediaTypeSound andMediaOrientation: message.isPortrait andThumbString:nil];
                        //end thumbnail
                        [dic setObject:[[[message imgstr] componentsSeparatedByString:@"$$$"] objectAtIndex:0] forKey:@"link"];
                    }
                    else
                    {
                        [dic setObject:message.imgstr forKey:@"attachment"];
                        
                        if ([message.mediaType isEqualToString:@"image"])
                        {
                            //nehaa thumbnail
                            //                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeImage andMediaOrientation:message.isPortrait];
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeImage andMediaOrientation: message.isPortrait andThumbString: message.thumbBase64String];
                            //end thumbnail
                            
                        }
                        else if ([message.mediaType isEqualToString:@"location"])
                        {
                            //nehaa thumbnail
                            //                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeImage andMediaOrientation:message.isPortrait];
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeLocation andMediaOrientation: message.isPortrait andThumbString: message.thumbBase64String];
                            //end thumbnail
                            
                            CLocation *aLocation =  [AppManager getLocationByLocationStr: message.filelocalpath ];
                            [dic setObject: aLocation.LocationName forKey:@"locationName"];
                        }
                        
                        
                        else if ([message.mediaType isEqualToString:@"video"])
                        {
                            //nehaa thumbnail
                            //                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeVideo andMediaOrientation: message.isPortrait];
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeVideo andMediaOrientation:message.isPortrait andThumbString: message.thumbBase64String];
                            //end thumbnail
                            
                        }
                        else if ([message.mediaType isEqualToString:@"audio"])
                        {
                            //nehaa thumbnail
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:YES andMediaType: eMediaTypeAudeo andMediaOrientation: message.isPortrait andThumbString:nil];
                            //end thumbnail
                            
                        }
                        
                        CustomUplaodingView *
                        cstView = [[chatView subviews] objectAtIndex: 1];
                        
                        cstView.fileServerUrlStr = message.imgstr;
                        cstView.fileLocalUrlStr = message.filelocalpath;
                        cstView.chatId = message.chatid;
                        cstView.fileSize = message.fileSize;
                        
                        if ([message.mediaType isEqualToString:@"image"] || [message.mediaType isEqualToString:@"location"])
                        {
                            cstView.eventType = eTypeUpldUpLoaded;
                            
                        }
                        else if ([message.mediaType isEqualToString:@"video"]
                                 || [message.mediaType isEqualToString:@"audio"])
                        {
                            cstView.eventType = eTypeUpldUpLoaded;
                            if([message.mediaType isEqualToString:@"audio"])
                            {
                                UIButton *btn = [cstView.subviews objectAtIndex:0];
                                btn.enabled = NO;
                                UIImageView *imgPlay = [cstView.subviews objectAtIndex:4];
                                imgPlay.hidden = NO;
                                UIProgressView *progress = [cstView.subviews objectAtIndex:5];
                                progress.hidden = NO;
                                NSString* fullPath = @"";
                                fullPath = [NSString stringWithFormat:@"ChatAudios/%@",message.filelocalpath];
                                fullPath =  [SHFileUtil getFullPathFromPath:fullPath] ;
                                NSURL *url = [NSURL fileURLWithPath:fullPath];
                                NSError *error=nil;
                                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
                                [self.player prepareToPlay];
                                UILabel *lbl = [cstView.subviews objectAtIndex:6];
                                //                                NSLog(@"%f",player.duration);
                                int minutes = (int)self.player.duration / 60;
                                int seconds = (int)self.player.duration % 60;
                                //                                NSLog(@"%@",[NSString stringWithFormat:@"%d:%02d",minutes,seconds]);
                                lbl.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
                                [self.player stop];
                                self.player = nil;
                            }
                            
                        }
                        
                        {
                            [cstView UpdateUIContents];
                            [dic setObject: message.filelocalpath  forKey:@"filelocalpath"];
                            [dic setObject: message.fileaction  forKey:@"fileaction"];
                            [dic setObject: message.fileNameWithExt  forKey:@"fileName"];
                            [dic setObject: message.chatid  forKey:@"chatid"];
                            //10-2-14
                            if (message.fileSize.length > 0)
                            {
                                [dic setObject:message.fileSize forKey:@"fileSize"];
                            }
                            
                        }
                        
                        /////////
                        
                    }
                    
                    
                }
                else
                {
                    //nehaa thumbnail
                    [dic setObject: message.chatid  forKey:@"chatid"];
                    
                    chatView = [self bubbleView:[NSString stringWithFormat:@"%@", [m substituteEmoticons]] from:YES andMediaType: eMediaTypeNone andMediaOrientation: message.isPortrait andThumbString:nil];
                    //end thumbnail
                }
                
                [dic setObject:@"self"  forKey:@"speaker"];
                
                [dic setObject:[NSNumber numberWithInt:message.isdelivered]  forKey:@"isdelivered"];
                [dic setObject:message.chatid  forKey:@"chatid"];
                
                [dic setObject:chatView  forKey:@"view"];
                
            }
            else
            {
                [dic setObject:chatWithUser forKey:@"sender"];
                if(message.isdelivered==0||message.isdelivered==1)
                {
                    NSString *from =[[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID1 ] lowercaseString] ;
                    ///
                    NSString *to = [chatWithUser lowercaseString];
                    NSString *chatid = message.chatid;
                    [self doDisplayMessage:[NSDictionary dictionaryWithObjectsAndKeys:from,@"to",chatid,@"id",to,@"sender", nil]];
                }
                
                UIView *chatView = nil;
                
                if([message.imgstr length]>0 || [message.mediaType isEqualToString:@"location"])
                {
                    if ([message.mediaType isEqualToString:@"soundit"])
                    {
                        //nehaa thumbnail
                        chatView = [self bubbleView:message.imgstr from:NO andMediaType:eMediaTypeSound andMediaOrientation:  message.isPortrait andThumbString:nil];
                        //end thumbnail
                        [dic setObject:[[[message imgstr] componentsSeparatedByString:@"$$$"] objectAtIndex:0] forKey:@"link"];
                        
                    }
                    else
                    {
                        if ([message.mediaType isEqualToString:@"image"])
                        {
                            if([message.filelocalpath rangeOfString:@"http:"].length>0)
                            {
                                //nehaa thumbnail
                                //                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeImage andMediaOrientation: message.isPortrait];
                                chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeImage andMediaOrientation: message.isPortrait andThumbString: message.thumbBase64String];
                                //end thumbnail
                            }
                            else
                            {
                                //nehaa thumbnail
                                chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.imgstr] from:NO andMediaType: eMediaTypeImage andMediaOrientation: message.isPortrait andThumbString:message.thumbBase64String];
                                //end thumbnail
                            }
                            
                        }
                        if ([message.mediaType isEqualToString:@"location"])
                        {
                            //nehaa thumbnail
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeLocation andMediaOrientation: message.isPortrait andThumbString:message.thumbBase64String];
                            CLocation *aLocation =  [AppManager getLocationByLocationStr: message.filelocalpath ];
                            [dic setObject: aLocation.LocationName forKey:@"locationName"];
                            
                        }
                        
                        else if ([message.mediaType isEqualToString:@"video"])
                        {
                            //nehaa thumbnail
                            //                        chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeVideo andMediaOrientation: message.isPortrait];
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeVideo andMediaOrientation: message.isPortrait andThumbString: message.thumbBase64String];
                            
                            //end thumbnail
                        }
                        else if ([message.mediaType isEqualToString:@"audio"])
                        {
                            //nehaa thumbnail
                            chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message.filelocalpath] from:NO andMediaType: eMediaTypeAudeo andMediaOrientation: message.isPortrait andThumbString:nil];
                            //end thumbnail
                        }
                        
                        CustomUplaodingView *
                        cstView = [[chatView subviews] objectAtIndex: 1];
                        
                        if ([message.fileaction isEqualToString:@"downloaded"])
                        {
                            cstView.isDownloaded = YES;
                            cstView.eventType = eTypeUpldDownLoaded;
                            if([message.mediaType isEqualToString:@"audio"])
                            {
                                UIButton *btn = [cstView.subviews objectAtIndex:0];
                                btn.enabled = NO;
                                UIImageView *imgPlay = [cstView.subviews objectAtIndex:4];
                                imgPlay.hidden = NO;
                                UIProgressView *progress = [cstView.subviews objectAtIndex:5];
                                progress.hidden = NO;
                                NSString* fullPath = @"";
                                fullPath =  [SHFileUtil getFullPathFromPath:message.filelocalpath] ;
                                NSURL *url = [NSURL fileURLWithPath:fullPath];
                                NSError *error=nil;
                                if(self.player)
                                {
                                    self.player = nil;
                                }
                                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
                                [self.player prepareToPlay];
                                UILabel *lbl = [cstView.subviews objectAtIndex:6];
                                //                                NSLog(@"%f",self.player.duration);
                                int minutes = (int)self.player.duration / 60;
                                int seconds = (int)self.player.duration % 60;
                                //                                NSLog(@"%@",[NSString stringWithFormat:@"%d:%02d",minutes,seconds]);
                                lbl.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
                                
                                [self.player stop];
                                self.player = nil;
                            }
                            
                            
                        }
                        else
                        {
                            cstView.isDownloaded = NO;
                            cstView.eventType = eTypeUpldDownLoad;
                        }
                        
                        if ([message.mediaType isEqualToString:@"location"])
                        {
                            cstView.isDownloaded = YES;
                            cstView.eventType = eTypeUpldDownLoaded;
                        }
                        
                        
                        
                        {
                            
                            cstView.fileServerUrlStr = message.imgstr;
                            cstView.fileLocalUrlStr = message.filelocalpath;
                            cstView.fileSize = message.fileSize;
                            cstView.chatId = message.chatid;
                            
                            [dic setObject: message.filelocalpath  forKey:@"filelocalpath"];
                            [dic setObject: message.fileaction  forKey:@"fileaction"];
                            [dic setObject: message.chatid  forKey:@"chatid"];
                            
                            //                            if ([message.fileaction isEqualToString:@"downloaded"])
                            //                            {
                            //                                cstView.isDownloaded = YES;
                            //                                cstView.eventType = eTypeUpldDownLoaded;
                            //                            }
                            //                            if ([message.mediaType isEqualToString:@"location"])
                            //                            {
                            //                                cstView.fileServerUrlStr = message.imgstr;
                            //                                cstView.fileLocalUrlStr = message.filelocalpath;
                            //                                cstView.fileSize = message.fileSize;
                            //                                cstView.chatId = message.chatid;
                            //
                            //                                [dic setObject: message.filelocalpath  forKey:@"filelocalpath"];
                            //                                [dic setObject: message.fileaction  forKey:@"fileaction"];
                            //                                [dic setObject: message.chatid  forKey:@"chatid"];
                            //
                            //                                if ([message.fileaction isEqualToString:@"downloaded"])
                            //                                {
                            //                                    cstView.isDownloaded = YES;
                            //                                    cstView.eventType = eTypeUpldDownLoaded;
                            //                                }
                            //                                if ([message.mediaType isEqualToString:@"location"])
                            //                                {
                            //                                    cstView.isDownloaded = YES;
                            //                                    cstView.eventType = eTypeUpldDownLoaded;
                            //                                }
                            //
                            //                                [cstView UpdateUIContents];
                            //
                            //                            }
                            
                            
                        }
                        
                        [cstView UpdateUIContents];
                        
                        ///end
                        
                    }
                    
                }
                else
                {
                    //nehaa thumbnail
                    [dic setObject: message.chatid  forKey:@"chatid"];
                    
                    chatView = [self bubbleView:[NSString stringWithFormat:@"%@", [m substituteEmoticons]] from:NO andMediaType: eMediaTypeNone andMediaOrientation: message.isPortrait andThumbString:nil];
                    //end thumbnail
                }
                
                [dic setObject:@"other"  forKey:@"speaker"];
                
                [dic setObject:chatView  forKey:@"view"];
                
            }
            
            if(message.mediaType!=nil)
            {
                
                [dic setObject:message.mediaType forKey:@"media"];
            }
            if ([self isAlreadyExistMsgByChatId:  message.chatid] == NO)
            {
                [tempArr addObject: dic];
                
            }
            
        }
    }
    return tempArr;
}
-(void)updateMsgListViewIfNeededByTotalMesg:(NSMutableArray *)inMsgArr
{
    //    [self sortAllMsgByTimeStampInDescendingOrder: messages];
    //    self.shownMsgCount = messages.count;
    //
    //    [self createLoadMoreViewIfNeeded];
    //
    //    [self setMsgByCount];
    //    [self.tView reloadData];
    
    //14-4-14
    
    [self sortAllMsgByTimeStampInDescendingOrder: messages];
    self.shownMsgCount = messages.count;
    
    [self doGroupMsgByDate: self.messages];
    
    self.msgTotalCount = inMsgArr.count;
    [self.tView reloadData];
    
    //end
}
//end

-(void)doGroupMsgByDate:(NSArray *)inMsgArr
{
    
    if (self.allKeysOfDate == nil)
    {
        self.allKeysOfDate = [[NSMutableArray alloc] init];
    }
    if (self.msgGroupedByDate == nil)
    {
        self.msgGroupedByDate = [[NSMutableDictionary alloc] init];
    }
    
    NSArray *uniqueByTime = [inMsgArr valueForKeyPath:@"@distinctUnionOfObjects.timestamp"];
    
    [self.allKeysOfDate removeAllObjects];
    
    [self.allKeysOfDate addObjectsFromArray: uniqueByTime];
    
    
    [self.msgGroupedByDate removeAllObjects];
    
    for (id aDate in self.allKeysOfDate)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp = %@",aDate];
        
        NSArray *filteredArray = [inMsgArr filteredArrayUsingPredicate:predicate];
        
        //19-5-14
        //        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sendTimestampDate" ascending:YES];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
        
        //end
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        filteredArray = [[filteredArray sortedArrayUsingDescriptors:sortDescriptors] copy];
        
        
        [self.msgGroupedByDate setObject: filteredArray forKey: aDate];
    }
    //    NSLog(@"groupedBySender = %@",self.msgGroupedByDate);
    
    [self sortAllKeysOfDatesInDescOrder];
    
}

-(void)sortAllMsgByTimeStampInDescendingOrder:(NSMutableArray *)inMsgArr
{
    
    
    //19-5-14
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sendTimestampDate" ascending:YES];
    //end
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedMsg = [NSArray arrayWithArray: [inMsgArr sortedArrayUsingDescriptors:sortDescriptors]];
    [messages removeAllObjects];
    [messages addObjectsFromArray: sortedMsg];;
    
    
}

-(void)createLoadMoreViewIfNeeded
{
    NSLog(@"createLoadMoreViewIfNeeded");
    if (self.tableLoadMoreView == nil)
    {
        self.tableLoadMoreView = [[ChatFirstRowCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil] ;
        self.tableLoadMoreView.selectionStyle=UITableViewCellSelectionStyleNone;
        self.tableLoadMoreView.Delegate = self;
        
    }
    self.tableLoadMoreView.backgroundColor = [UIColor clearColor];
    
}

//14-4-14
-(BOOL)setMsgByCount
{
    NSLog(@"setMsgByCount method");
    
    [self createLoadMoreViewIfNeeded];//new
    
    NSMutableArray *oldMsgBasedOnCursor = [self fetchMsgByFetchingCursor: [self getFetchCursor]];//new
    
    
    BOOL toReturn = NO;
    int count = 0;
    
    
    
    if (self.shownMsgCount <= 0)
    {
        self.tableLoadMoreView.isShownLoadMore = NO;
        return  toReturn;
    }
    NSMutableArray *tempArrOld = [[NSMutableArray alloc] init];
    
    if (self.messages.count > 0)
    {
        [tempArrOld addObjectsFromArray: self.messages];
        [self.messages removeAllObjects];
        
    }
    self.shownMsgCount = self.shownMsgCount - MaxMsgCountAtOneTime;
    
    if (self.shownMsgCount > 0)
    {
        
        self.tableLoadMoreView.isShownLoadMore = YES;
        
        //        self.shownMsgCount  = 0;
        
        for (int i = 0 ; i < oldMsgBasedOnCursor.count; i++)
        {
            [self.messages addObject: [oldMsgBasedOnCursor objectAtIndex: i]];
            
            count++;
            
        }
        
        toReturn = YES;
    }
    else
    {
        self.tableLoadMoreView.isShownLoadMore = NO;
        
        for (int i = 0 ; i < oldMsgBasedOnCursor.count; i++)
        {
            [self.messages addObject: [oldMsgBasedOnCursor objectAtIndex: i]];
            
            count++;
            
        }
        
        toReturn = YES;
    }
    
    if (tempArrOld && tempArrOld.count > 0)
    {
        if (self.msgCurrfetchedCount == 0 && self.msgTotalCount > MaxMsgCountAtOneTime)//cursor reached  to zero or -ve values
        {
            
            //            NSLog(@" %li",self.msgCurrfetchedCount);
            
            
            NSArray *oldMsgChatIdArr1 = [tempArrOld valueForKeyPath:@"@distinctUnionOfObjects.chatid"];
            
            NSArray *oldMsgChatIdArr2 = [oldMsgBasedOnCursor valueForKeyPath:@"@distinctUnionOfObjects.chatid"];
            
            for (int i = 0; i<[oldMsgChatIdArr2 count]; i++) {
                if([oldMsgChatIdArr1 containsObject:[oldMsgChatIdArr2 objectAtIndex:i]])
                {
                    [self.messages removeObject:[oldMsgChatIdArr2 objectAtIndex:i]];
                }
            }
        }
        
        
        [self.messages addObjectsFromArray: tempArrOld];
    }
    //14-5-14
    [self sortAllMsgByTimeStampInDescendingOrder: self.messages];
    //end
    self.shownMsgCount = self.shownMsgCount ;//+ count;
    [self doGroupMsgByDate: self.messages];
    //27-2-14 displayed
    [self performSelector:@selector(sendAllDisplayedDeliveryreportAfterDelay) withObject:Nil afterDelay: 2.0];
    //end
    
    
    [tView reloadData];//new
    
    return  toReturn;
    
}


//end



-(void)sortAllKeysOfDatesInDescOrder
{
    NSMutableArray *aTempArr = [NSMutableArray array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    aTempArr = [[self.allKeysOfDate sortedArrayUsingDescriptors:sortDescriptors] copy];
    
    [self.allKeysOfDate removeAllObjects];
    if(self.tableLoadMoreView.isShownLoadMore==YES)
    {
        [self.allKeysOfDate addObject:@"Loader"];
    }
    [self.allKeysOfDate  addObjectsFromArray: aTempArr];
    
}

//end

- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket {
    [turnSockets removeObject:sender];
}

- (void)turnSocketDidFail:(TURNSocket *)sender {
    
    //	NSLog(@"TURN Connection failed!");
    [turnSockets removeObject:sender];
    
}



#pragma mark -
#pragma mark Actions

- (IBAction) closeChat
{
        [self.navigationController popToRootViewControllerAnimated: YES];

    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
//        NSArray *arr = [self.navigationController viewControllers];
//        ChatHomeScreenController *ObjMySession=nil;
//        for (int i = 0; i< arr.count ; i++)
//        {
//            UIViewController *aviewCont = [arr objectAtIndex:i];
//            if ([aviewCont isKindOfClass:[ChatHomeScreenController class]])
//            {
//                ObjMySession = [arr objectAtIndex:i];
//                break;
//            }
//        }
//        if(_isComingFromAddressBook){
//            [self.navigationController popViewControllerAnimated: YES];
//        }
//        else if(ObjMySession){
//            [self.navigationController popToViewController:ObjMySession animated:YES];
//        }
//        else
//        {
//        }
//    }
    //	[self dismissViewControllerAnimated:YES completion:nil];
    //end
}

- (IBAction)addGroupChatButtonClicked:(id)sender {
    
}

- (void)updateLastMessage:(NSString *)msg withDate:(NSDate *)date
{
    //last message
//    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[[chatWithUser componentsSeparatedByString:@"@"] objectAtIndex:0],kchatUserName,msg,@"message", date,@"sendDate",nil];
//    [[Database database]addMessage:dictionary withMessage:msg fromPrivate:NO];
}
-(NSString *)chatID
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *dtstring = [dateFormate stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%u%@",(unsigned int) arc4random(),dtstring];
}
-(void)doSendMessage:(NSString *)inMessage
{
    
    [self sendChatState:kOTRChatStateInactive];
    //    for(int i = 1;i<=1000;i++)
    //    {
    NSString *messageStr = inMessage;
    //        NSString *messageStr = [NSString stringWithFormat:@"Hello: %d",i];
    messageStr = [messageStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if([messageStr length] > 0)
    {
        //        NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
        //        [dateFormate setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        //
        //        NSString *currDateStr = [dateFormate stringFromDate: [NSDate date]];
        
        //        NSString *chatId = [NSString stringWithFormat:@"%u%@",(unsigned int) arc4random(),currDateStr];
        
        
        
        //NSString *chatId = [NSString stringWithFormat:@"%u",(unsigned int) arc4random()];
        //end
        //9-5-14
        NSDate *sendTimestampDate = [NSDate date];
        //end
        NSString *chatId = [self chatID];
        NSLog(@"do send message CHATID: %@",chatId);
#pragma mark - XMPP MessageStatus
//        [[Database database] insertNewMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"0",kIsMedia,messageStr,kMessage,[NSString stringWithFormat:@"%f",[sendTimestampDate timeIntervalSince1970]],kSendtimestamp,chatWithUser,kChatWithUser,chatId,kChatId, nil]from:@"chat"];
#pragma end
        
        
        
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"id" stringValue:chatId];
        [message addAttributeWithName:@"to" stringValue:chatWithUser];
        
        //
        //        NSLog(@"%@",chatWithUser);
        //        NSLog(@"%@",userName);
        //
        
        [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1]];
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
        NSXMLElement *request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [message addChild:body];
        NSXMLElement *fullName = [NSXMLElement elementWithName:@"fullName" stringValue:[[NSUserDefaults standardUserDefaults] valueForKey:kFullname]];
        [message addChild:fullName];
        
        NSXMLElement *chatFlow = [NSXMLElement elementWithName:@"chatFlow" stringValue:@"anonymous"];
        [message addChild:chatFlow];
        
        NSXMLElement *userId = [NSXMLElement elementWithName:@"userId"];
        [userId setStringValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kUserId]]];
        [message addChild:userId];
        NSXMLElement *imageURL = [NSXMLElement elementWithName:@"imgURL"];
        [imageURL setStringValue:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImage_url_100],[[NSUserDefaults standardUserDefaults] valueForKey:kProfileImage]]];
        [message addChild:imageURL];

        //9-5-14
        NSXMLElement *sendTimestampDateTag = [NSXMLElement elementWithName:@"sendTimestampDate"];
        [sendTimestampDateTag setStringValue: [NSString stringWithFormat:@"%f",[sendTimestampDate timeIntervalSince1970]]];
        
        [message addChild:sendTimestampDateTag];
        
        //end
        
        //3-2-14
        //urn:xmpp:delay
        //        NSXMLElement *delay = [NSXMLElement elementWithName:@"delay"];
        //        [delay addAttributeWithName:@"xmlns" stringValue:@"urn:xmpp:delay"];
        //        [delay addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1]];
        //
        //        [delay addAttributeWithName:@"stamp" stringValue:[dateFormate stringFromDate: [[NSDate date]addTimeInterval: 1]]];
        //
        //        [delay setStringValue:@"Offline Storage"];
        //        [message addChild:delay];
        ///end
        
        [message addChild:request];
        
        //
        //        NSLog(@"%@",message);
        //
        //       if(gCXMPPController.xmppStream.isConnected)
        
        
        [self.xmppStream sendElement:message];
        
        NSLog(@"XML : %@",message);
        // saving last message to show in chat home view
        [self updateLastMessage:messageStr withDate:[NSDate date]];
        //end
        // send push notification if user is not available
        if(self.isUnavailable == YES)
        {
//            NSString *msg = nil;
//            if([messageStr length]>108)
//            {
////                msg =  [NSString stringWithFormat:@"%@: %@",self.chatWithUser,[messageStr substringToIndex:108]];
//                msg =  [NSString stringWithFormat:@"%@: %@",[[NSUserDefaults standardUserDefaults] objectForKey:kFullName],[messageStr substringToIndex:108]];
//            }
//            else
//            {
////                msg =  [NSString stringWithFormat:@"%@: %@",[[NSUserDefaults standardUserDefaults] objectForKey:kfullName],messageStr];
//                msg =  [NSString stringWithFormat:@"%@: %@",[[NSUserDefaults standardUserDefaults] objectForKey:kFullName],messageStr];
//
//            }
//            NetworkService *obj = [NetworkService sharedInstance];
//            NSDictionary *aDict=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"userId",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"],@"sessionToken",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,@"sendXmppPushNotification",@"option",kDevice,kDeviceType,msg,@"message",[[self.chatWithUser componentsSeparatedByString:@"@"] firstObject],kchatUserName,[[NSUserDefaults standardUserDefaults] objectForKey:kFullName],kFullName,nil];
//            [obj sendAsynchRequestByPostToServer:@"pushnotification" dataToSend:aDict delegate:nil contentType:eAppJsonType andReqParaType:eJson header:NO];
        }
        //end
        
        
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        [m setObject:[messageStr substituteEmoticons] forKey:@"msg"];
        [m setObject:@"you" forKey:@"sender"];
        
        
        NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
        [date_formater setDateFormat:@"yyyy-MM-dd"];
        NSString *aDateStr = [date_formater stringFromDate: [NSDate date]];
        [m setObject:[date_formater dateFromString:aDateStr ] forKey:@"timestamp"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"hh:mm a"];
        
        NSString *dateString = [dateFormat stringFromDate: [NSDate date]];
        
        
        
        [m setObject: dateString forKey:@"time"];
        
        //9-5-14
        [m setObject: sendTimestampDate forKey:@"sendTimestampDate"];
        //end
        
        
        //nehaa thumbnail
        UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@", [messageStr substituteEmoticons]]
                                       from:YES andMediaType: eMediaTypeNone andMediaOrientation: eMediaLandscape andThumbString:nil];
        //end thumbnail
        
        [m setObject:chatView  forKey:@"view"];
        
        [m setObject:@"self"  forKey:@"speaker"];
        
        [m setObject: chatId forKey:@"chatid"];
        
        [m setObject:[NSNumber numberWithInt: 0]  forKey:@"isdelivered"];
        [messages addObject:m];
        [self doGroupMsgByDate: messages];
        
        //        [self saveToChatHistory:m];
        
        //14-4-14
        //        [self.cacheMsgArr addObject: m];
        //        [self doGroupMsgByDate: cacheMsgArr];
        
        //end
        [self.tView reloadData];
        
        //}
    }
    else
    {
        return;
    }
    //changed5-12-13 chat
    
    //	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
    //												   inSection:0];
    
    @try {
        NSString *groupKey = [self.allKeysOfDate lastObject];
        if (groupKey)
        {
            int sec = self.allKeysOfDate.count - 1;
            int row = [[self.msgGroupedByDate objectForKey: groupKey] count] - 1;
            
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:row
                                                           inSection:sec];
            
            [self.tView scrollToRowAtIndexPath:topIndexPath
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:NO];
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    //end
    //}
}
//end

- (IBAction)sendMessage :(NSString *)Message
{
    
    if(!isStickerClicked)
    {
        //to autocorrect the last word, add spacebar forcefully
        self.inputToolbar.textView.text = [self.inputToolbar.textView.text stringByAppendingString:@" "];
        /////
        Message = [NSString stringWithString:self.inputToolbar.textView.text];
        self.inputToolbar.textView.text = @"";
        
    }
    
    //5-3-14
    [self doSendMessage: Message];
    
    isStickerClicked = NO;
    self.msgText = @"";
    //end
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length

{
    //    NSLog(@"called");
    return 0;
}

#pragma mark - image picker methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //    [self setPicker:nil];
    //	if(!self.picker)
    //    {
    //        self.picker= [[UIImagePickerController alloc] init];
    //        self.picker.delegate = self;
    //    }
    //    //    NSLog(@"%d",buttonIndex);
    //    switch (buttonIndex) {
    //		case 0:
    //            self.picker.sourceType =UIImagePickerControllerSourceTypeCamera ;
    //            self.picker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString*) kUTTypeImage, nil];
    //            [self presentViewController:self.picker animated:YES completion:nil];
    //         	break;
    //        case 1:
    //            self.picker.sourceType =UIImagePickerControllerSourceTypeCamera ;
    //            self.picker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString*) kUTTypeMovie, nil];
    //            self.picker.allowsEditing=YES;
    //            self.picker.videoMaximumDuration=20.0f;
    //            self.picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    //            [self presentViewController:self.picker animated:YES completion:nil];
    //         	break;
    //		case 2:
    //			self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //            self.picker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString*) kUTTypeImage, nil];
    //            [self presentViewController:self.picker animated:YES completion:nil];
    //			break;
    //        case 3:
    //			self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //            self.picker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString*) kUTTypeMovie, nil];
    //            self.picker.allowsEditing=YES;
    //            self.picker.videoMaximumDuration=20.0f;
    //            self.picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    //            [self presentViewController:self.picker animated:YES completion:nil];
    //			break;
    //            //        case 2:
    //            //
    //            //            self.picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    //            //            self.picker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString*) kUTTypeMovie, nil];
    //            //            self.picker.editing = NO;
    //            //            [self presentViewController:self.picker animated:YES completion:nil];
    //            //            break;
    //            //
    //            //        case 3:
    //            //            [self addAudio];
    //
    //		default:
    //			break;
    //	}
    switch (buttonIndex) {
        case 0:
            [self ChoosePhotoOrVideo];
            break;
        case 1:
            [self ChooseExistingPhoto];
            break;
        case 2:
            [self ChooseExistingVideo];
            break;
        default:
            break;
    }
}
-(void)ChoosePhotoOrVideo{
    return;
    self.isMediaOpened = YES;
    
    picker=[[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [UIImagePickerController  availableMediaTypesForSourceType:picker.sourceType];
    
    picker.allowsEditing = NO;
    
    picker.videoMaximumDuration=20.0f;
    //    imagePicker.showsCameraControls=NO;
    // imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.videoQuality = UIImagePickerControllerQualityType640x480;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)ChooseExistingPhoto{
    return;
    self.isMediaOpened = YES;
    
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
    
    imagePicker.allowsEditing = NO;
    
    imagePicker.videoMaximumDuration=20.0f;
    //    imagePicker.showsCameraControls=NO;
    // imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    //  imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
-(void)ChooseExistingVideo{
    return;
    self.isMediaOpened = YES;
    
    picker=[[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeMovie, nil];
    
    picker.allowsEditing = YES;
    
    picker.videoMaximumDuration=20.0f;
    
    picker.videoQuality = UIImagePickerControllerQualityType640x480;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)addAudio {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
    mediaPicker.delegate = self;
    mediaPicker.prompt = @"Select Audio";
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

#pragma mediaPicke deligate only for Audio
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    NSArray * SelectedSong = [mediaItemCollection items];
    if([SelectedSong count]>0){
        MPMediaItem * SongItem = [SelectedSong objectAtIndex:0];
        NSURL *SongURL = [SongItem valueForProperty: MPMediaItemPropertyAssetURL];
        NSString*Title = [SongItem valueForProperty: MPMediaItemPropertyTitle];
        //([[info objectForKey:@"UIMediaPickerControllerMediaType"] isEqualToString:@"public.image"])
        
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"public.audio",@"UIMediaPickerControllerMediaType",SongURL ,@"UIMediaPickerControllerMediaURL",nil];
        if (Title && Title.length > 0)
        {
            [infoDic setObject: Title forKey:@"Title"];
        }
        [self uploadImage: infoDic];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)exportMP3:(NSURL*)url toFileUrl:(NSString*)fileURL
{
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil] ;
    AVAssetReader *reader=[[AVAssetReader alloc] initWithAsset:asset error:nil];
    NSMutableArray *myOutputs =[[NSMutableArray alloc] init];
    for(id track in [asset tracks])
    {
        AVAssetReaderTrackOutput *output=[AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:nil];
        [myOutputs addObject:output];
        [reader addOutput:output];
    }
    [reader startReading];
    NSFileHandle *fileHandle ;
    NSFileManager *fm=[NSFileManager defaultManager];
    if(![fm fileExistsAtPath:fileURL])
    {
        [fm createFileAtPath:fileURL contents:[[NSData alloc] init] attributes:nil];
    }
    fileHandle=[NSFileHandle fileHandleForUpdatingAtPath:fileURL];
    [fileHandle seekToEndOfFile];
    
    AVAssetReaderOutput *output=[myOutputs objectAtIndex:0];
    int totalBuff=0;
    while(TRUE)
    {
        CMSampleBufferRef ref=[output copyNextSampleBuffer];
        if(ref==NULL)
            break;
        //copy data to file
        //read next one
        AudioBufferList audioBufferList;
        NSMutableData *data=[[NSMutableData alloc] init];
        CMBlockBufferRef blockBuffer;
        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(ref, NULL, &audioBufferList, sizeof(audioBufferList), NULL, NULL, 0, &blockBuffer);
        
        for( int y=0; y<audioBufferList.mNumberBuffers; y++ )
        {
            AudioBuffer audioBuffer = audioBufferList.mBuffers[y];
            Float32 *frame = audioBuffer.mData;
            
            
            //  Float32 currentSample = frame[i];
            [data appendBytes:frame length:audioBuffer.mDataByteSize];
            
            //  written= fwrite(frame, sizeof(Float32), audioBuffer.mDataByteSize, f);
            ////NSLog(@"Wrote %d", written);
            
        }
        totalBuff++;
        //        CFRelease(blockBuffer);
        //        CFRelease(ref);
        [fileHandle writeData:data];
        //  //NSLog(@"writting %d frame for amounts of buffers %d ", data.length, audioBufferList.mNumberBuffers);
    }
    //  //NSLog(@"total buffs %d", totalBuff);
    //    fclose(f);
    [fileHandle closeFile];
    
    
    
}

- (BOOL)validIpodLibraryURL:(NSURL*)url {
    NSString* IPOD_SCHEME = @"file";
    if (nil == url) return NO;
    if (nil == url.scheme) return NO;
    if ([url.scheme compare:IPOD_SCHEME] != NSOrderedSame) return NO;
    if ([url.pathExtension compare:@"mp3"] != NSOrderedSame &&
        [url.pathExtension compare:@"aif"] != NSOrderedSame &&
        [url.pathExtension compare:@"m4a"] != NSOrderedSame &&
        [url.pathExtension compare:@"wav"] != NSOrderedSame) {
        return NO;
    }
    return YES;
}

- (NSString*)extensionForAssetURL:(NSURL*)assetURL {
    if (nil == assetURL)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"nil assetURL" userInfo:nil];
    if (![self validIpodLibraryURL:assetURL])
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Invalid iPod Library URL: %@", assetURL] userInfo:nil];
    return assetURL.pathExtension;
}

//29-1-14
-(void)showMsgWhenMediaSizeBeyondTheLimit:(NSString *)inTitle
{
    
    [Utils showAlertView: @"" message:@"Media size is beyond the limit!"delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
}
//end

- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler
{
    
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset: urlAsset presetName:AVAssetExportPresetLowQuality];
    session.outputURL = outputURL;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(session);
         
     }];
}


- (void)uploadImage:(NSDictionary*)info
{
    if(![gCXMPPController isConnected])
    {
        return;
    }
    NSString *mediaType ;
    NSData *mediaData;
    NSString *filePath;
    NSString *localUrl;
    NSRange range;
    NSString *subUrl;
    NSString*aDateTimeStr;
    MediaType eMediaType = eMediaTypeNone;
    NSString *fileNameWihExt;
    int isImage = 1;
    //    NSData *vedioThumb;
    NSString *thumbNailfilePath;
    //27-3-14 p
    enMediaOrientation mediaOrient;
    //end
    NSInteger mediaSizeInMb = 0;
    NSData *thumbnailImageData;
    
    aDateTimeStr = [NSString stringWithFormat:@"%u%@",(unsigned int) arc4random(),[NSDate date]];
    aDateTimeStr =[aDateTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    aDateTimeStr =[aDateTimeStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
    aDateTimeStr =[aDateTimeStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    aDateTimeStr =[aDateTimeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    if([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.movie"])
    {
        isImage =2;
        id mediaUrl = info[UIImagePickerControllerMediaURL];
        thumbnailImage= [Utils thumbnailImageForVideo: mediaUrl atTime:0];
        mediaType = [NSString stringWithFormat:@"video"];
        NSError *error;
        mediaData = [NSData dataWithContentsOfURL:[info objectForKey:@"UIImagePickerControllerMediaURL"] options:NSDataReadingMappedIfSafe error: &error];
        mediaSizeInMb = (([mediaData length])/(1024*1024));
        if (mediaSizeInMb > 16)
        {
            [self showMsgWhenMediaSizeBeyondTheLimit:mediaType];
            return;
        }
        if (localUrl == nil)
        {
            
            localUrl = [NSString stringWithFormat:@"%@",[info objectForKey:@"UIImagePickerControllerMediaURL"]];
            
            subUrl = [[localUrl componentsSeparatedByString:@"."] lastObject];
            
            fileNameWihExt = [NSString stringWithFormat:@"%@.%@",aDateTimeStr,subUrl];
            
            subUrl = [NSString stringWithFormat:@"%@",fileNameWihExt];
            filePath = [NSString stringWithFormat:@"ChatVideos/%@",subUrl];
        }
        else
        {
            range =  [localUrl rangeOfString:@"?id="];
            subUrl = [localUrl substringFromIndex: range.length + range.location];
            
            NSArray *fileInfo = [subUrl componentsSeparatedByString:@"&"];
            NSArray *fileExtArr = [[fileInfo objectAtIndex: 1] componentsSeparatedByString:@"="];
            
            
            fileNameWihExt = [NSString stringWithFormat:@"%@.%@",aDateTimeStr,[fileExtArr objectAtIndex: 1]];
            
            filePath = [NSString stringWithFormat:@"ChatVideos/%@",fileNameWihExt];
        }
        
    }
    else if ([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"])
    {
        isImage = 1;
        mediaType = [NSString stringWithFormat:@"image"];
        
        
        UIImage *imageOrignal      =   [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        
        imageOrignal = [Utils rotateImageToItsOrignalOrientation :imageOrignal];
        
        imageOrignal = [UIImage scaleDownOriginalImage:imageOrignal ProportionateTo: 960];
        mediaData = UIImageJPEGRepresentation(imageOrignal,0.5);
        
        localUrl = [NSString stringWithFormat:@"%@",[info objectForKey:@"UIImagePickerControllerReferenceURL"]];
        
        //29-1-14
        mediaSizeInMb = (([mediaData length])/(1024*1024));
        if (mediaSizeInMb > 16)
        {
            [self showMsgWhenMediaSizeBeyondTheLimit:mediaType];
            return;
        }
        //and
        
        //when We taking from camera
        if ([localUrl isEqualToString:@"(null)"])
        {
            //26-1-14 issue 300/2
            //save image to Photo Album
            //            if([[info objectForKey:@"fromlibrary"]isEqualToString:@"no"])
            //            {
            //                UIImageWriteToSavedPhotosAlbum(imageOrignal, nil, nil, nil);
            //            }
            //end
            
            subUrl = [aDateTimeStr stringByAppendingFormat:@"capturedImage.JPG"];
            fileNameWihExt = [NSString stringWithFormat:@"%@",subUrl];
            
            filePath = [NSString stringWithFormat:@"ChatImages/%@",fileNameWihExt];
            
        }
        // when we are picking from library
        else
        {
            range =  [localUrl rangeOfString:@"?id="];
            subUrl = [localUrl substringFromIndex: range.length + range.location];
            NSArray *fileInfo = [subUrl componentsSeparatedByString:@"&"];
            NSArray *fileExtArr = [[fileInfo objectAtIndex: 1] componentsSeparatedByString:@"="];
            fileNameWihExt = [NSString stringWithFormat:@"%@Image.%@",aDateTimeStr,[fileExtArr objectAtIndex: 1]];
            filePath = [NSString stringWithFormat:@"ChatImages/%@",fileNameWihExt];
        }
    }
    
    else if ([[info objectForKey:@"UIMediaPickerControllerMediaType"] isEqualToString:@"public.audio"])
    {
        
        isImage = 3;
        mediaType = [NSString stringWithFormat:@"audio"];
        
        NSURL *url = [info objectForKey:@"UIMediaPickerControllerMediaURL"];
        localUrl = [NSString stringWithFormat:@"%@",[info objectForKey:@"UIMediaPickerControllerMediaURL"]];
        
        filePath = [[[NSString stringWithFormat:@"%@",url] componentsSeparatedByString:@"/"] lastObject];
        fileNameWihExt = filePath;
     }
    
    if ([mediaType isEqualToString:@"audio"])//for Audio file
    {
        mediaData = [NSData dataWithContentsOfFile:self.inputToolbar.audioFilePath];//[SHFileUtil readFileFromCache:filePath];
        
        //29-1-14
        mediaSizeInMb = (([mediaData length])/(1024*1024));
        if (mediaSizeInMb > 16)
        {
            [self showMsgWhenMediaSizeBeyondTheLimit:mediaType];
            [SHFileUtil deleteItemAtPath: localUrl];
            return;
        }
        //and
        //27-3-14
        mediaOrient = eMediaLandscape;
        
        //end
        
    }
    else
    {
        //22-1-14 thumbnail
        if ([mediaType isEqualToString:@"image"])
        {
            thumbNailfilePath = [Utils getThumbNailImagePathByItsImagePath: filePath];
            
            if (thumbNailfilePath.length >0)
            {
                
                UIImage *aOrignalImage = [UIImage imageWithData: mediaData];
                
                //25-3-14
                float height = 0;
                if (aOrignalImage.size.height > aOrignalImage.size.width)
                {
                    //27-3-14 p
                    //                    height =  KImageSizeHeight;
                    height =  KImageSizeWidth;
                    
                    mediaOrient = eMediaPortrait;
                    
                    //end
                    
                }
                else
                {
                    //27-3-14 p
                    height =  KImageSizeLandscapeHeight;
                    
                    mediaOrient = eMediaLandscape;
                    //end
                    
                }
                UIImage *aThumbNailImage = [UIImage scaleDownOriginalImage: [info objectForKey:@"UIImagePickerControllerOriginalImage"] ProportionateTo: 180];
                
                thumbnailImageData = UIImageJPEGRepresentation(aThumbNailImage, 0.4);
                
                [SHFileUtil writeFileInCache: mediaData toPartialPath: filePath];
            }
            
        }
        //27-3-14
        if ([mediaType isEqualToString:@"video"])
        {
            
            
            //25-3-14
            float height = 0;
            if (thumbnailImage.size.height > thumbnailImage.size.width)
            {
                //27-3-14 p
                height =  KImageSizeWidth;
                
                mediaOrient = eMediaPortrait;
                
                //end
                
            }
            else
            {
                //                    height =  KImageSizeWidth;
                height =  KImageSizeLandscapeHeight;
                
                mediaOrient = eMediaLandscape;
                //end
                
            }
            
            [SHFileUtil writeFileInCache: mediaData toPartialPath: filePath];
            
            
        }
     }
    
    NSDate *sendTimestampDate = [NSDate date];
    NSString *chatId = [self chatID];
    
    NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
    [m setObject:@"you" forKey:@"sender"];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a"];
    
    NSString *dateString = [dateFormat stringFromDate: sendTimestampDate];
    
    [m setObject:dateString forKey:@"time"];
    
     [m setObject: sendTimestampDate forKey:@"sendTimestampDate"];
    
    NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
    [date_formater setDateFormat:@"yyyy-MM-dd"];
    
    NSString *aDateStr = [date_formater stringFromDate: sendTimestampDate];
    
    //end
    
    [m setObject:[date_formater dateFromString:aDateStr ] forKey:@"timestamp"];
    
    //nehaa thumbnail
    NSData *videoThumbnailImageData = nil;
    if ([mediaType isEqualToString:@"video"])
    {
        thumbNailfilePath = [Utils getVideoThumbNailImagePathByItsImagePath: chatId];
        
        videoThumbnailImageData = UIImageJPEGRepresentation(thumbnailImage,0.4);
        
    }
    //end thumbnail
    
    UIView *chatView;
    if ([mediaType isEqualToString:@"image"])
    {
        
        //nehaa thumbnail
        NSString *thumbString = [NSString stringWithFormat:@"%@",[thumbnailImageData base64Encoding]];
        [m setObject: thumbString forKey:KThumbBase64String];
        
        chatView  = [self bubbleView:[NSString stringWithFormat:@"%@",filePath] from:YES andMediaType: eMediaTypeImage andMediaOrientation:mediaOrient andThumbString:thumbString];
        eMediaType = eMediaTypeImage;
        //end thumbnail
        
    }
    else if ([mediaType isEqualToString:@"video"])
    {
        
        //nehaa thumbnail
        NSString *thumbString = [NSString stringWithFormat:@"%@",[videoThumbnailImageData base64Encoding]];
        [m setObject: thumbString forKey:KThumbBase64String];
        chatView  = [self bubbleView:[NSString stringWithFormat:@"%@",filePath] from:YES andMediaType: eMediaTypeVideo andMediaOrientation: mediaOrient andThumbString:thumbString];
        //end thumbnail
        eMediaType = eMediaTypeVideo;
        
    }
    else if ([mediaType isEqualToString:@"audio"])
    {
        //nehaa thumbnail
        chatView  = [self bubbleView:[NSString stringWithFormat:@"%@",filePath] from:YES andMediaType: eMediaTypeAudeo andMediaOrientation: mediaOrient andThumbString:nil];
        //end thumbnail
        eMediaType = eMediaTypeAudeo;
        
    }
    
    CustomUplaodingView *
    cstView = [[chatView subviews] objectAtIndex: 1];
    
    cstView.eventType = eTypeUpldUpLoading;
    cstView.currentState = eStateTypeuploading;
    cstView.mediaType = eMediaType;
    
    [self.uploadingStatusDic setObject:[NSNumber numberWithInt: eStateTypeuploading] forKey: chatId];
    
    cstView.chatId = chatId;
    
    [cstView UpdateUIContents];
    
    
    [m setObject:chatView  forKey:@"view"];
    
    [m setObject:@"self"  forKey:@"speaker"];
    
    [m setObject: chatId forKey:@"chatid"];
    
    [m setObject:[NSNumber numberWithInt: 0]  forKey:@"isdelivered"];
    
    
    [m setObject: mediaType forKey:@"media"];
    [m setObject: filePath forKey:@"filelocalpath"];
    [m setObject: @"uploading" forKey:@"fileaction"];
    [m setObject: fileNameWihExt forKey:@"fileName"];
    NSString *fileSize = [NSString stringWithFormat:@"%d",mediaData.length];
    [m setObject:fileSize forKey:@"fileSize"];
    //end
    
    
    [messages addObject:m];
    
    [self doGroupMsgByDate: messages];
    
    [self.tView reloadData];
    
    
    NSString *groupKey = [self.allKeysOfDate lastObject];
    if (groupKey)
    {
        int sec = self.allKeysOfDate.count - 1;
        int row = [[self.msgGroupedByDate objectForKey: groupKey] count] - 1;
        
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:row
                                                       inSection:sec];
        
        [self.tView scrollToRowAtIndexPath:topIndexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:NO];
        
        
    }
    NSString *api = [NSString stringWithFormat:@"%@chat",kBaseURL];
    
    
//    if(isImage == 1)
//    {
//        NSMutableDictionary *aDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"userId",@"1",@"fileType",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"],@"sessionToken",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,kDevice,kDeviceType,@"uploadChatFiles",@"option",mediaData ,@"profileImage",thumbnailImageData,@"postThumb",nil];
//        [[NetworkService sharedInstance] sendAsynchronusUploadImageByGetUsingMultiPart:api dataToSend:aDict boundry:@"111000111" header:NO andDelegate:self andChatId:chatId andMediaType:mediaType andfileName:fileNameWihExt];
//    }
//    else if (isImage == 2)
//    {
//        NSMutableDictionary *aDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"userId",@"2",@"fileType",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"],@"sessionToken",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,kDevice,kDeviceType,@"uploadChatFiles",@"option",mediaData ,@"profileData",videoThumbnailImageData,@"postThumb",nil];
//        
//        [[NetworkService sharedInstance] sendAsynchronusUploadImageByGetUsingMultiPart:api dataToSend:aDict boundry:@"111000111" header:NO andDelegate:self andChatId:chatId andMediaType:mediaType andfileName:fileNameWihExt];
//    }
//    else
//    {
//        NSMutableDictionary *aDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"userId",@"3",@"fileType",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"],@"sessionToken",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,kDevice,kDeviceType,@"uploadChatFiles",@"option",mediaData,@"profileData",nil];
//        
//        [[NetworkService sharedInstance] sendAsynchronusUploadImageByGetUsingMultiPart:api dataToSend:aDict boundry:@"111000111" header:NO andDelegate:self andChatId:chatId andMediaType:mediaType andfileName:fileNameWihExt];
//    }
    
    //Set for background task
    UIApplication *app = [UIApplication sharedApplication];
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
}

-(void)doUploadPendingWhenNetworkAvailable
{
    //4-2-14
    
    NSArray *aChatIds = [self.uploadingStatusDic allKeys];
    
    for (NSString *aChatId in aChatIds)
    {
        int stateValue = [[self.uploadingStatusDic objectForKey: aChatId]integerValue];
        
        if (stateValue == eStateTypePending)
        {
            NSDictionary *aMsgDic = [self getMsgDicByChatId: aChatId];
            [self reuploadingMediaByMsgDiv: aMsgDic];
            
        }
    }
    //end
}

-(void)reuploadingMediaByMsgDiv:(NSDictionary *)inMsgDic
{
    
    NSString *aFileLocalParh = [inMsgDic objectForKey:@"filelocalpath"];
    NSString *aChatId = [inMsgDic objectForKey:@"chatid"];
    NSString *mediaType = [inMsgDic objectForKey:@"media"];
    NSData *vedioThumb;
    NSString *thumbNailfilePath;
    enMediaOrientation mediaOrient;
    NSData *thumbnailImageData;
    NSString *fileNameWihExt = @"";
    if([mediaType isEqualToString:@"audio"])
    {
        fileNameWihExt =[NSString stringWithFormat:@"ChatAudios/%@", [inMsgDic objectForKey:@"fileName"]];
    }
    else if ([mediaType isEqualToString:@"image"])
    {
        fileNameWihExt =[NSString stringWithFormat:@"ChatImages/%@", [inMsgDic objectForKey:@"fileName"]];
    }
    else
    {
        
        fileNameWihExt = [NSString stringWithFormat:@"ChatVideos/%@", [inMsgDic objectForKey:@"fileName"]];
    }
    
    NSData * mediaData = [SHFileUtil readFileFromCache:fileNameWihExt];
    NSString *api =[NSString stringWithFormat:@"%@chat",kBaseURL];
    
    UIView *aChatView = [inMsgDic objectForKey:@"view"];
    CustomUplaodingView *
    cstView = [[aChatView subviews] objectAtIndex: 1];
    //24-3-14 media
    if (cstView.eventType == eTypeUpldCancel)
    {
        //        NSLog(@"Uplaoding cencelling...");
        return;
    }
    //end
    
    if ([Utils isInternetAvailable ] == NO)
    {
        cstView.eventType = eTypeUpldUpLoad;
        return;
    }
    //end
    
    
    //end
    cstView.eventType = eTypeUpldUpLoading;
    cstView.currentState = eStateTypeuploading;
    cstView.ProgressView.progress = 0.0;
    
    //4-2-14
    //    [self.uploadingStatusDic setObject:[NSNumber numberWithBool: YES] forKey: aChatId];
    [self.uploadingStatusDic setObject:[NSNumber numberWithInt: eStateTypeuploading] forKey: aChatId];
    
    //end
    
    [cstView.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cstView.btnCancel.tag = eTypeUpldCancel;
    [cstView UpdateUIContents];
    
    self.isUploading = YES;
    
    if ([mediaType isEqualToString:@"image"])
    {
        thumbNailfilePath = [Utils getThumbNailImagePathByItsImagePath: aFileLocalParh];
        
        if (thumbNailfilePath.length >0)
        {
            
            UIImage *aOrignalImage = [UIImage imageWithData: mediaData];
            
            //25-3-14
            float height = 0;
            if (aOrignalImage.size.height > aOrignalImage.size.width)
            {
                //27-3-14 p
                //                    height =  KImageSizeHeight;
                height =  KImageSizeWidth;
                
                mediaOrient = eMediaPortrait;
                
                //end
                
            }
            else
            {
                //27-3-14 p
                //                    height =  KImageSizeWidth;
                height =  KImageSizeLandscapeHeight;
                
                mediaOrient = eMediaLandscape;
                //end
                
            }
            //27-3-14
            //getImageWidthByOrientationFlag(mediaOrient,height);
            //end
            
            UIImage *aThumbNailImage = [UIImage scaleDownOriginalImage: aOrignalImage ProportionateTo: 300];
            //
            //                NSData *thumbnailImageData = UIImageJPEGRepresentation(aThumbNailImage, 0.5);
            
            thumbnailImageData = UIImageJPEGRepresentation(aThumbNailImage, 0.5);
            
            //end
            
            [SHFileUtil writeFileInCache: thumbnailImageData toPartialPath: thumbNailfilePath];
            
            [SHFileUtil writeFileInCache: mediaData toPartialPath: aFileLocalParh];
        }
        
    }
    
    NSData *videoThumbnailImageData = Nil;
    if ([mediaType isEqualToString:@"video"])
    {
        
        thumbNailfilePath = [Utils getVideoThumbNailImagePathByItsImagePath: aChatId];
        videoThumbnailImageData = UIImageJPEGRepresentation(thumbnailImage, 1);
        
        [SHFileUtil writeFileInCache: videoThumbnailImageData toPartialPath: thumbNailfilePath];
    }
    
    //Set for background task
    UIApplication *app = [UIApplication sharedApplication];
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    //end
    
//    if([mediaType isEqualToString:@"image"])
//    {
//        NSMutableDictionary *aDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"userId",@"1",@"fileType",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"],@"sessionToken",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,kDevice,kDeviceType,@"uploadChatFiles",@"option",mediaData ,@"profileImage",thumbnailImageData,@"postThumb",nil];
//        [[NetworkService sharedInstance] sendAsynchronusUploadImageByGetUsingMultiPart:api dataToSend:aDict boundry:@"111000111" header:NO andDelegate:self andChatId:aChatId andMediaType:mediaType andfileName:fileNameWihExt];
//    }
//    else if ([mediaType isEqualToString:@"video"])
//    {
//        NSMutableDictionary *aDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"userId",@"2",@"fileType",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"],@"sessionToken",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,kDevice,kDeviceType,@"uploadChatFiles",@"option",mediaData ,@"profileData",videoThumbnailImageData,@"postThumb",nil];
//        [[NetworkService sharedInstance] sendAsynchronusUploadImageByGetUsingMultiPart:api dataToSend:aDict boundry:@"111000111" header:NO andDelegate:self andChatId:aChatId andMediaType:mediaType andfileName:fileNameWihExt];
//    }
//    else
//    {
//        NSMutableDictionary *aDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"userId",@"3",@"fileType",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"],@"sessionToken",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,kDevice,kDeviceType,@"uploadChatFiles",@"option",mediaData,@"profileData",nil];
//        [[NetworkService sharedInstance] sendAsynchronusUploadImageByGetUsingMultiPart:api dataToSend:aDict boundry:@"111000111" header:NO andDelegate:self andChatId:aChatId andMediaType:mediaType andfileName:fileNameWihExt];
//    }
//
    
}




-(void)doDownloadPendingWhenNetworkAvailable
{
    //4-2-14
    NSArray *aChatIds = [self.downloadingStatusDic allKeys];
    
    for (NSString *aChatId in aChatIds)
    {
        int aStateVaule = [[self.downloadingStatusDic objectForKey: aChatId] integerValue];
        
        if (aStateVaule == eStateTypePending)
        {
            [self doDownloadFileByChatId: aChatId];
            
        }
        
    }
    //end
}
//end


- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //22-1-14 thumbnail
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: info];
    [picker1 dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(uploadImage:) withObject:dic];
    if([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.movie"])
    {
        NSURL *videoURL = [info objectForKey:@"UIImagePickerControllerMediaURL"];
        
        
        if (![[info allKeys]containsObject:@"UIImagePickerControllerReferenceURL"]) {
            UISaveVideoAtPathToSavedPhotosAlbum([videoURL relativePath], self,@selector(movie:didFinishSavingWithError:contextInfo:), nil);
        }
        
        
    }else{
        if(![[info allKeys]containsObject:@"UIImagePickerControllerReferenceURL"])
        {
            UIImage *image = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
            
            
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:),
                                           NULL);
        }
        
        
    }
    //end
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)   movie:(NSURL *)url
didFinishSavingWithError:(NSError *)error
     contextInfo:(void *)contextInfo
{
    NSString *message = @"This video has been saved to your Photos album";
    if (error) {
        message = [error localizedDescription];
        NSLog(@"%@",message);
    }
    
}
- (void)   savedPhotoImage:(UIImage *)image
  didFinishSavingWithError:(NSError *)error
               contextInfo:(void *)contextInfo
{
    NSString *message = @"This image has been saved to your Photos album";
    if (error) {
        message = [error localizedDescription];
        NSLog(@"%@",message);
    }
    
}
-(void)soundLink:(NSDictionary *)dict
{
    NSString *aChatId = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    MediaType eMediaType = eMediaTypeSound;
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"id" stringValue:aChatId];
    [message addAttributeWithName:@"to" stringValue:chatWithUser];
    
    
    [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1]];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    NSXMLElement *media = [NSXMLElement elementWithName:@"media"];
    
    [media setStringValue:@"soundit"];
    NSXMLElement *request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addAttributeWithName:@"attachment" stringValue:[NSString stringWithFormat:@"%@$$$%@",[dict objectForKey:@"link"],[dict objectForKey:@"title"]]];
    
    [body addChild:media];

    NSXMLElement *fullName = [NSXMLElement elementWithName:@"fullName" stringValue:[[NSUserDefaults standardUserDefaults] valueForKey:kFullname]];
    [message addChild:fullName];
    
    NSXMLElement *chatFlow = [NSXMLElement elementWithName:@"chatFlow" stringValue:@"anonymous"];
    [message addChild:chatFlow];
    
    NSXMLElement *userId = [NSXMLElement elementWithName:@"userId"];
    [userId setStringValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kUserId]]];
    [message addChild:userId];
    NSXMLElement *imageURL = [NSXMLElement elementWithName:@"imgURL"];
    [imageURL setStringValue:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImage_url_100],[[NSUserDefaults standardUserDefaults] valueForKey:kProfileImage]]];
    [message addChild:imageURL];

    
    [message addChild:body];
    [message addChild:request];
    [self.xmppStream sendElement:message];
    if(self.isUnavailable == YES)
    {
//        NSString *msg = nil;
//        msg =  [NSString stringWithFormat:@"%@: SoundIt",[[NSUserDefaults standardUserDefaults] objectForKey:kfullName]];
//        NetworkService *obj = [NetworkService sharedInstance];
//        NSDictionary *aDict=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"userId",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"],@"sessionToken",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,@"sendXmppPushNotification",@"option",kDevice,kDeviceType,msg,@"message",friendNameId,@"toUserId",[[NSUserDefaults standardUserDefaults] valueForKey:kchatUserName],kchatUserName,[[NSUserDefaults standardUserDefaults] objectForKey:kfullName],kfullName,nil];
//        [obj sendAsynchRequestByPostToServer:@"pushnotification" dataToSend:aDict delegate:nil contentType:eAppJsonType andReqParaType:eJson header:NO];
    }
    
    UIView *chatView;
    chatView  = [self bubbleView:[NSString stringWithFormat:@"%@$$$%@",[dict objectForKey:@"link"],[dict objectForKey:@"title"]] from:YES andMediaType:eMediaType andMediaOrientation:  eMediaLandscape andThumbString:nil];
    
    NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
    [m setObject:@"you" forKey:@"sender"];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    
    NSString *dateString = [dateFormat stringFromDate: [NSDate date]];
    
    [m setObject:dateString forKey:@"time"];
    
    
    NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
    [date_formater setDateFormat:@"yyyy-MM-dd"];
    NSString *aDateStr = [date_formater stringFromDate: [NSDate date]];
    [m setObject:[date_formater dateFromString:aDateStr ] forKey:@"timestamp"];
    [m setObject:chatView  forKey:@"view"];
    
    [m setObject:@"self"  forKey:@"speaker"];
    
    [m setObject: aChatId forKey:@"chatid"];
    [m setObject:[NSNumber numberWithInt: 0]  forKey:@"isdelivered"];
    [m setObject:@"soundit"  forKey:@"media"];
    [m setObject:[dict objectForKey:@"link"] forKey:@"link"];
    [messages addObject:m];
    [self doGroupMsgByDate: messages];
    
    [self.tView reloadData];
    
    
}
#pragma mark - button clicked methods
- (void)btnImageChangeClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo or Video",@"Choose Existing Photo",@"Choose Existing Video",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag=1;
    [actionSheet showInView:self.view];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CommentCellIdentifier = @"CommentCell";
    ChatCustomCell *cell = (ChatCustomCell*)[tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatCustomCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }

    float siftedPad = 0.0;
    NSString *groupKey = [self.allKeysOfDate objectAtIndex: indexPath.section];
    NSDictionary *chatInfo = [[self.msgGroupedByDate objectForKey :groupKey] objectAtIndex: indexPath.row];
    // Set up the cell...
    UIView *chatView = [chatInfo objectForKey:@"view"];
    
    NSString *speaker = [NSString stringWithFormat:@"%@",[chatInfo objectForKey:@"speaker"]];
    [cell.contentView addSubview:chatView];
    
      CustomChatView* aCustChatView;
    NSArray * subviews =[[chatInfo objectForKey:@"view"] subviews];
    for ( id aVIew in subviews)
    {
        if ([aVIew isKindOfClass:[ CustomChatView class]])
        {
            aCustChatView = (CustomChatView *)aVIew;
            aCustChatView.IndexPath = indexPath;
            aCustChatView.MediaType = [NSString stringWithFormat:@"%@",[chatInfo objectForKey:@"media"]];
            aCustChatView.ChatId = [NSString stringWithFormat:@"%@",[chatInfo objectForKey:@"chatid"]];
            break;
        }
    }
    
    //locationAddress
    UILabel *lblLocation;
    NSString *aMediaType= [chatInfo objectForKey:@"media"];
    
    if ([aMediaType isEqualToString:@"location"])
    {
        lblLocation = [[UILabel alloc] initWithFrame: CGRectZero];
        lblLocation.backgroundColor = [UIColor clearColor];
        lblLocation.textColor = [UIColor blackColor];
        lblLocation.font = [UIFont systemFontOfSize:12.0];
        lblLocation.tag = 1005;
        lblLocation.text = [chatInfo objectForKey:@"locationName"];
    }
    //TimeStamp
    
    UILabel *lblTimeStamp = [[UILabel alloc] initWithFrame: CGRectZero];
    lblTimeStamp.backgroundColor = [UIColor clearColor];
    lblTimeStamp.font = [UIFont fontWithName:@"Roboto-Regular" size:9.0];
    if([speaker isEqualToString:@"self"])
    {
        lblTimeStamp.textColor = [UIColor whiteColor];
    }
    else
    {
        lblTimeStamp.textColor = [UIColor blackColor];
    }
    lblTimeStamp.textAlignment = NSTextAlignmentRight;
    
    CGRect timeStampRect ;
    
    timeStampRect.size.width = 43.0;
    timeStampRect.size.height = 21;
    
    
     lblTimeStamp.tag = 1002;
    //Pending Image
    UIImageView *aPendingImgView = [[UIImageView alloc] initWithFrame: CGRectZero];
    aPendingImgView.tag = 1001;
    //end
    CGRect pendingRect;
    pendingRect.size.width = 5;
    pendingRect.size.height = 5;
    UILabel *lblPending = [[UILabel alloc]initWithFrame:aPendingImgView.frame];
    lblPending.font = [UIFont systemFontOfSize:12];
    lblPending.textColor = [UIColor blackColor];
    if ([[self.msgGroupedByDate objectForKey: groupKey] count] > 0)
    {
        lblTimeStamp.text = [chatInfo objectForKey:@"time"];
        
    }
    
    UIView *aView = (UIView *)[[chatView subviews] objectAtIndex: 0];
    
    if ([speaker isEqualToString:@"self"])
    {
        UIImage *aImagePending ;
        int isDelivered = [[chatInfo objectForKey:@"isdelivered"] intValue];
        if(isDelivered == 0)
        {
            aImagePending = [UIImage imageNamed: @"NotReceived"];
        }
        else if (isDelivered == 2)
        {
            
            aImagePending = [UIImage imageNamed: @"Received"];
            
        }
        else if (isDelivered == 3)
        {
            
            aImagePending = [UIImage imageNamed: @"Read"];
            
        }
        else if (isDelivered == 4)//for failed condition
        {
            aImagePending = [UIImage imageNamed: @"failed"];
        }
        
        if ([[aView viewWithTag: 100] isKindOfClass:[UIImageView class]]) //with bubble view
        {
            UIImageView *bubbleView = (UIImageView*)[aView viewWithTag: 100];
            
            CGRect aRectBubble = bubbleView.frame;
            
            pendingRect.origin.y = bubbleView.frame.size.height - pendingRect.size.height - 5 + siftedPad;
            
            pendingRect.origin.x = bubbleView.frame.size.width - pendingRect.size.width - 12;
            
            aPendingImgView.frame = pendingRect;
            
            
            
            timeStampRect.origin.y = aRectBubble.size.height - 18 + siftedPad;
            timeStampRect.origin.x = aRectBubble.size.width - timeStampRect.size.width - pendingRect.size.width - 19;
            lblTimeStamp.frame = timeStampRect;
            
            
            for (UIImageView * pendImg in [(UIView *)[aView viewWithTag: 100] subviews])
            {
                if (pendImg.tag == 1001)
                {
                    [pendImg removeFromSuperview];
                }
            }
            for (UILabel * timeStmp in [(UIView *)[aView viewWithTag: 100] subviews])
            {
                if (timeStmp.tag == 1002)
                {
                    [timeStmp removeFromSuperview];
                }
            }
            //locationAdd
            for (id aView in [chatView subviews])
            {
                if ([aView isKindOfClass:[CustomUplaodingView class ]])
                {
                    [[aView viewWithTag: 1005] removeFromSuperview];
                    break;
                    
                }
            }
            
            
            NSString *mediaType= [chatInfo objectForKey:@"media"];
            if (mediaType && mediaType.length > 0)
            {
                lblTimeStamp.frame = CGRectMake(305-(lblTimeStamp.frame.size.width +15), lblTimeStamp.frame.origin.y, lblTimeStamp.frame.size.width, lblTimeStamp.frame.size.height);
                aPendingImgView.frame = CGRectMake((lblTimeStamp.frame.origin.x+lblTimeStamp.frame.size.width)+5, aPendingImgView.frame.origin.y, aPendingImgView.frame.size.width, aPendingImgView.frame.size.height);
                lblTimeStamp.textColor = [UIColor whiteColor];
                
                //locationAdd
                for (id aView in [chatView subviews])
                {
                    if ([aView isKindOfClass:[CustomUplaodingView class ]])
                    {
                        CustomUplaodingView *aTempView = (CustomUplaodingView *)aView;
                        CGRect locationRect;
                        locationRect.size.width = aTempView.frame.size.width - 10;
                        locationRect.size.height = 21;
                        locationRect.origin.x = 320-aTempView.frame.size.width -15;
                        locationRect.origin.y =  aTempView.frame.size.height +aTempView.frame.origin.y-30;
                        lblLocation.frame = locationRect;
                        [cell.contentView addSubview: lblLocation];
                        
                        break;
                        
                    }
                }
                
                //end
                [cell.contentView addSubview:lblTimeStamp];
                [cell.contentView addSubview:aPendingImgView];
            }
            else
            {
                
                [[aView viewWithTag: 100] addSubview: aPendingImgView];
                
                [[aView viewWithTag: 100] addSubview: lblTimeStamp];
            }
            
            pendingRect.origin.x = timeStampRect.origin.x + timeStampRect.size.width + 5;
            pendingRect.origin.y = (timeStampRect.origin.y + timeStampRect.size.height)/2 + siftedPad;
            
            aPendingImgView.image = aImagePending;
            
            
        }
        else  //  non bubble view
        {
            
            pendingRect.origin.y = chatView.frame.size.height - pendingRect.size.height - 15;
            
            pendingRect.origin.x = 320.0 - pendingRect.size.width -20;

            aPendingImgView.frame = pendingRect;
            
            timeStampRect.origin.y = pendingRect.origin.y ;//- 6;
            
            timeStampRect.origin.x =  pendingRect.origin.x + pendingRect.size.width - timeStampRect.size.width - 15;
            pendingRect.origin.y = pendingRect.origin.y + 8;
            pendingRect.origin.x = pendingRect.origin.x -3;
            aPendingImgView.image = aImagePending;
            
            aPendingImgView.frame = pendingRect;
            lblTimeStamp.frame = timeStampRect;
            
            
            
            lblTimeStamp.textColor=[UIColor darkGrayColor];
            [cell.contentView addSubview: aPendingImgView];
            [cell.contentView addSubview: lblTimeStamp];
            
            
        }
    }
    else if ([speaker isEqualToString:@"other"])
    {
        if ([[aView viewWithTag: 100] isKindOfClass:[UIImageView class]]) //with bubble view
        {
            UIImageView *bubbleView = (UIImageView*)[aView viewWithTag: 100];
            
            CGRect aRectBubble = bubbleView.frame;
            
            timeStampRect.origin.y = aRectBubble.size.height - timeStampRect.size.height + 3 ;

            timeStampRect.origin.x = aRectBubble.size.width - timeStampRect.size.width - 7;
            
            lblTimeStamp.frame = timeStampRect;
            
            
            for (UIImageView * pendImg in [(UIView *)[aView viewWithTag: 100] subviews])
            {
                if (pendImg.tag == 1001)
                {
                    [pendImg removeFromSuperview];
                }
            }
            for (UILabel * timeStmp in [(UIView *)[aView viewWithTag: 100] subviews])
            {
                if (timeStmp.tag == 1002)
                {
                    [timeStmp removeFromSuperview];
                }
            }
            for (id aView in [chatView subviews])
            {
                if ([aView isKindOfClass:[CustomUplaodingView class ]])
                {
                    [[aView viewWithTag: 1005] removeFromSuperview];
                    break;
                    
                }
            }
            
            NSString *mediaType= [chatInfo objectForKey:@"media"];
            if (mediaType && mediaType.length > 0)
            {

                CGRect rect = lblTimeStamp.frame;
                rect.origin.x = rect.origin.x;
                rect.origin.y = rect.origin.y -2;
                lblTimeStamp.frame = rect;
                if([mediaType isEqualToString:@"image"]||[mediaType isEqualToString:@"video"] || [mediaType isEqualToString:@"location"])
                {
                    lblTimeStamp.textColor = [UIColor whiteColor];
                }
                //locationAdd
                for (id aView in [chatView subviews])
                {
                    if ([aView isKindOfClass:[CustomUplaodingView class ]])
                    {
                        CustomUplaodingView *aTempView = (CustomUplaodingView *)aView;
                        CGRect locationRect;
                        locationRect.size.width = aTempView.frame.size.width - 10;
                        locationRect.size.height = 21;
                        locationRect.origin.x = 15;
                        locationRect.origin.y =  aTempView.frame.size.height +aTempView.frame.origin.y-30;// - locationRect.size.height;
                        lblLocation.frame = locationRect;
                        [cell.contentView addSubview: lblLocation];
                        
                        break;
                        
                    }
                }
                
                //end
                
                [cell.contentView addSubview:lblTimeStamp];
            }
            else
            {
                [[aView viewWithTag: 100] addSubview: lblLocation];
                
                [[aView viewWithTag: 100] addSubview: lblTimeStamp];
            }
            
            
        }
        else  //  non bubble view
        {
            
            timeStampRect.origin.y = chatView.frame.size.height - timeStampRect.size.height - 3;
            
            timeStampRect.origin.x = chatView.frame.size.width -40;
            
            lblTimeStamp.frame = timeStampRect;
            [lblTimeStamp setTextColor:[UIColor darkGrayColor]];
            [cell.contentView addSubview: lblTimeStamp];
            
            
        }
    }

    NSString *mediaType= [chatInfo objectForKey:@"media"];
    
    if (mediaType && mediaType.length > 0)
    {
        CustomUplaodingView *aCstView = (CustomUplaodingView *)[[chatView subviews] objectAtIndex: 1];
//        if([[dictSettings objectForKey:kCHAT_SETTINGS_AUTODOWNLOAD]integerValue]==1)
//        {
            if(aCstView.eventType == eTypeUpldDownLoad)
            {
                [self doDownloadFileByChatId:aCstView.chatId];
            }
            
            [aCstView UpdateUIContents];
//        }
    }
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height;
    NSDictionary *chatInfo = [[self.msgGroupedByDate objectForKey: [self.allKeysOfDate objectAtIndex: indexPath.section]] objectAtIndex: indexPath.row];
    
    UIView *chatView = [chatInfo objectForKey:@"view"];
    
    height = chatView.frame.size.height;
    
    return height;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int row = 0;
    row = [[self.msgGroupedByDate objectForKey: [self.allKeysOfDate objectAtIndex: section]] count];
    
    return  row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 30.0;
    if (section  == 0 && self.tableLoadMoreView.isShownLoadMore)
    {
        height = 30;//height for first header view
    }
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  // custom view for header. will be adjusted to default or specified header height
{
    
    if (section  == 0 && self.tableLoadMoreView.isShownLoadMore == YES)
    {
        //end
        CGRect rectHeader = CGRectMake(0, 0, 320, 30);
        
        UIView *headerView = [[[UIView alloc] init] initWithFrame: rectHeader];
        
        
        if (self.tableLoadMoreView == nil)
        {
            self.tableLoadMoreView = [[ChatFirstRowCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil] ;
            self.tableLoadMoreView.selectionStyle=UITableViewCellSelectionStyleNone;
            self.tableLoadMoreView.Delegate = self;
        }
        self.tableLoadMoreView.backgroundColor = [UIColor clearColor];
        
        CGRect  cellRect = rectHeader;
        cellRect.origin.y = 0.0;
        cellRect.size.height = 30;
        self.tableLoadMoreView.frame =cellRect;
        
        [headerView addSubview: self.tableLoadMoreView];
        return headerView;
    }
    else
    {
        UIFont *font =  [UIFont fontWithName:@"Roboto-Regular" size:9];
        
        CGRect rectHeaderlbl;
        rectHeaderlbl.size.width = [[UIScreen mainScreen] bounds].size.width;
        rectHeaderlbl.size.height = 18.0;
        rectHeaderlbl.origin.x = 0;
        
        rectHeaderlbl.origin.y = 0;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rectHeaderlbl];
        [imgView setImage:[UIImage imageNamed:@"chatDateBg"]];
        
        UILabel *lblHeader = [[UILabel alloc] initWithFrame:rectHeaderlbl];
        lblHeader.textColor = [UIColor whiteColor];
        lblHeader.textAlignment = NSTextAlignmentCenter;
        lblHeader.font = font;
        
        NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
        [dateFormate setDateFormat:@"dd MMM, yyyy"];
        
        NSString *aDateStr = [NSString stringWithString:[dateFormate stringFromDate: [self.allKeysOfDate objectAtIndex: section]]];
        lblHeader.text = aDateStr;
        
        //22-12-13
        if (section  == 0 && self.tableLoadMoreView.isShownLoadMore == NO)
        {
            CGRect rectHeader = CGRectMake(0, 0, 320, 26);
            
            UIView *headerView = [[[UIView alloc] init] initWithFrame: rectHeader];
            [headerView setBackgroundColor:[UIColor clearColor]];
            
            rectHeaderlbl.origin.y = 0;
            lblHeader.frame = rectHeaderlbl;
            imgView.frame = rectHeaderlbl;
            [headerView addSubview:imgView];
            [headerView addSubview:lblHeader];
            return    headerView;
        }
         else
        {
            CGRect rectHeader = CGRectMake(0, 0, 320, 26);
            
            UIView *headerView = [[[UIView alloc] init] initWithFrame: rectHeader];
            [headerView setBackgroundColor:[UIColor clearColor]];
            [headerView addSubview:imgView];
            [headerView addSubview:lblHeader];
            return    headerView;
        }
    }
}

//end


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //changed5-12-13 chat
    
    return  self.allKeysOfDate.count;
    //	return 1;
    //end
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aMsgDic = [[self.msgGroupedByDate objectForKey: [self.allKeysOfDate objectAtIndex: indexPath.section]] objectAtIndex: indexPath.row];
    NSString *mediaType = [aMsgDic objectForKey: @"media"];
    
    NSString *isFrom = [aMsgDic objectForKey:@"speaker"];
    NSString *fileaction = [aMsgDic objectForKey: @"fileaction"];
    NSString *chatId = [aMsgDic objectForKey:@"chatid"];
    NSString *aFileLocalPath = [aMsgDic objectForKey:@"filelocalpath"];
    
    if ([isFrom isEqualToString:@"self"])
    {
        //10-2-14
        UIView * aView = [aMsgDic objectForKey: @"view"];
        
        //nehaa 28-02-2014
        if([[aView subviews] count]<2)
        {
            [self tapped: nil];
            return;
        }
        //end
        CustomUplaodingView *
        cstView = [[aView subviews] objectAtIndex: 1];
        //11-2-14 2
        if ([[aMsgDic allKeys] containsObject:@"media"] && ( cstView.eventType == eTypeUpldError  || cstView.eventType ==  eTypeUpldUpLoad))
        {
            
            [self reuploadingMediaByMsgDiv:[self getMsgDicByChatId:chatId]];
        }
        if([[aMsgDic allKeys]containsObject:@"media"])
        {
            if(![[aMsgDic objectForKey:@"media"]isEqualToString:@"soundit"])
            {
                if([mediaType isEqualToString:@"audio"])
                {
                    NSString* fullPath = @"";
                    fullPath = [NSString stringWithFormat:@"ChatAudios/%@",aFileLocalPath];
                    fullPath =  [SHFileUtil getFullPathFromPath:fullPath] ;
                    if(!inIndexPath)
                    {
                        inIndexPath = indexPath;
                        
                        UIImageView *imgView = [[cstView subviews] objectAtIndex:4];
                        imgView.image = [UIImage imageNamed:@"chatPauseIconWhite"];
                        NSError *error;
                        NSURL *url = [NSURL fileURLWithPath:fullPath];
                        
                        if(self.player)
                        {
                            self.player = nil;
                        }
                        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
                        
                        self.player.numberOfLoops = 0;
                        self.player.volume = 1.0f;
                        self.player.delegate = self;
                        UIProgressView *progress = [cstView.subviews objectAtIndex:5];
                        progress.progress=0.0;
                        
                        [self.player prepareToPlay];
                        
                        if (self.player == nil)
                            NSLog(@"%@", [error description]);
                        else
                        {
                            //                           NSLog(@"%f",player.duration);
                            [self.player play];
                            [self startTimer];
                        }
                    }
                    else
                    {
                        [self.player stop];
                        self.player = nil;
                        if(inIndexPath != indexPath)
                        {
                            NSDictionary *MsgDic = [[self.msgGroupedByDate objectForKey: [self.allKeysOfDate objectAtIndex: inIndexPath.section]] objectAtIndex: inIndexPath.row];
                            UIView * OldView = [MsgDic objectForKey: @"view"];
                            CustomUplaodingView *
                            cView = [[OldView subviews] objectAtIndex: 1];
                            UIProgressView *progress = [cView.subviews objectAtIndex:5];
                            progress.progress=0.0;
                            [self.timerForPlaying invalidate];
                            self.timerForPlaying = nil;
                            UIImageView *imgView = [[cView subviews] objectAtIndex:4];
                            imgView.image = [UIImage imageNamed:@"chatPlayIconWhite"];
                        }
                        else
                        {
                            UIImageView *imgView = [[cstView subviews] objectAtIndex:4];
                            imgView.image = [UIImage imageNamed:@"chatPlayIconWhite"];
                        }
                        inIndexPath = nil;
                    }
                    [self.tView reloadData];
                    
                }
            }
            else
            {
                if(!inIndexPath)
                {
                    inIndexPath = indexPath;
                    
                    UIImageView *imgView = [[cstView subviews] objectAtIndex:6];
                    imgView.image = [UIImage imageNamed:@"chatPauseIconWhite"];
                    NSError *error;
                    NSBundle* bundle = [NSBundle mainBundle];
                    NSString* bundleDirectory = (NSString*)[bundle bundlePath];
                    
                    NSURL *url = [NSURL fileURLWithPath:[bundleDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",[aMsgDic objectForKey:@"link"]]]];
                    
                    if(self.player)
                    {
                        self.player = nil;
                    }
                    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
                    
                    self.player.numberOfLoops = 0;
                    self.player.volume = 1.0f;
                    self.player.delegate = self;
                    [self.player prepareToPlay];
                    
                    if (self.player == nil)
                        NSLog(@"%@", [error description]);
                    else
                        [self.player play];
                }
                else
                {
                    [self.player stop];
                    self.player = nil;
                    if(inIndexPath != indexPath)
                    {
                        NSDictionary *MsgDic = [[self.msgGroupedByDate objectForKey: [self.allKeysOfDate objectAtIndex: inIndexPath.section]] objectAtIndex: inIndexPath.row];
                        UIView * OldView = [MsgDic objectForKey: @"view"];
                        CustomUplaodingView *
                        cView = [[OldView subviews] objectAtIndex: 1];
                        
                        UIImageView *imgView = [[cView subviews] objectAtIndex:6];
                        imgView.image = [UIImage imageNamed:@"chatPlayIconWhite"];
                    }
                    else
                    {
                        UIImageView *imgView = [[cstView subviews] objectAtIndex:6];
                        imgView.image = [UIImage imageNamed:@"chatPlayIconWhite"];
                    }
                    inIndexPath = nil;
                }
                [self.tView reloadData];
            }
        }
        //end
        [self tapped: nil];
        
    }
    else
    {
        if ([mediaType isEqualToString: @"image"])
        {
            if ([fileaction isEqualToString:@"uploaded"])
            {
                //do download
                [self doDownloadFileByChatId: chatId];
            }
            else if ([fileaction isEqualToString:@"downloaded"])
            {
                // do view
                [self doViewImageBYFileLocalPath: aFileLocalPath];
            }
            else if ([fileaction isEqualToString:@"downloading"])
            {
                 [self.downloadingStatusDic setObject:[NSNumber numberWithInt:eStateTypeCancel] forKey: chatId];
                
                self.isDownloading = NO;
            }
            
        }
        if ([mediaType isEqualToString: @"location"])
        {
            //do show mamview
            UIView * aView = [aMsgDic objectForKey: @"view"];
            CustomUplaodingView *
            cstView = [[aView subviews] objectAtIndex: 1];
            [self doShowSharedLocation:cstView.Location];
        }
        else if ([mediaType isEqualToString: @"video"])
        {
            if ([fileaction isEqualToString:@"uploaded"])
            {
                //do download
                [self doDownloadFileByChatId: chatId];
            }
            else if ([fileaction isEqualToString:@"downloaded"])
            {
                // do view
                [self doPlayVideoByFileLocalPath : aFileLocalPath];
            }
            else if ([fileaction isEqualToString:@"downloading"])
            {
                // do Cancel downloading
                
                //not Responde Canceling
                [self.downloadingStatusDic setObject:[NSNumber numberWithBool: NO] forKey: chatId];
                //end
                self.isDownloading = NO;
            }
            
        }
        else if ([mediaType isEqualToString: @"audio"])
        {
            UIView * aView = [aMsgDic objectForKey: @"view"];
            CustomUplaodingView *
            cstView = [[aView subviews] objectAtIndex: 1];
            if ([fileaction isEqualToString:@"uploaded"])
            {
                //do download
                [self doDownloadFileByChatId: chatId];
            }
            else if ([fileaction isEqualToString:@"downloaded"])
            {
                // do view
                NSString* fullPath = @"";
                if([aFileLocalPath rangeOfString:@"Caches"].length>0)
                {
                    fullPath = aFileLocalPath;
                }
                else
                {
                    fullPath =  [SHFileUtil getFullPathFromPath:aFileLocalPath];
                }
                
                if(!inIndexPath)
                {
                    inIndexPath = indexPath;
                    
                    UIImageView *imgView = [[cstView subviews] objectAtIndex:4];
                    imgView.image = [UIImage imageNamed:@"chatPauseIcon"];
                    NSError *error;
                    NSURL *url = [NSURL fileURLWithPath:fullPath];
                    
                    if(self.player)
                    {
                        self.player = nil;
                    }
                    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
                    UIProgressView *progress = [cstView.subviews objectAtIndex:5];
                    progress.progress=0.0;
                    
                    self.player.numberOfLoops = 0;
                    self.player.volume = 1.0f;
                    self.player.delegate = self;
                    [self.player prepareToPlay];
                    
                    if (self.player == nil)
                        NSLog(@"%@", [error description]);
                    else
                    {
                        [self.player play];
                        [self startTimer];
                    }
                }
                else
                {
                    [self.player stop];
                    self.player = nil;
                    
                    if(inIndexPath != indexPath)
                    {
                        NSDictionary *MsgDic = [[self.msgGroupedByDate objectForKey: [self.allKeysOfDate objectAtIndex: inIndexPath.section]] objectAtIndex: inIndexPath.row];
                        UIView * OldView = [MsgDic objectForKey: @"view"];
                        CustomUplaodingView *
                        cView = [[OldView subviews] objectAtIndex: 1];
                        UIProgressView *progress = [cView.subviews objectAtIndex:5];
                        progress.progress=0.0;
                        [self.timerForPlaying invalidate];
                        self.timerForPlaying = nil;
                        
                        UIImageView *imgView = [[cView subviews] objectAtIndex:4];
                        imgView.image = [UIImage imageNamed:@"chatPlayIcon"];
                    }
                    else
                    {
                        UIImageView *imgView = [[cstView subviews] objectAtIndex:4];
                        imgView.image = [UIImage imageNamed:@"chatPlayIcon"];
                    }
                    inIndexPath = nil;
                }
                [self.tView reloadData];
            }
            else if ([fileaction isEqualToString:@"downloading"])
            {
                // do Cancel downloading
                //not Respond Canceling
                [self.downloadingStatusDic setObject:[NSNumber numberWithBool: NO] forKey: chatId];
                //end
                self.isDownloading = NO;
            }
            [self tapped: nil];
        }
        if([mediaType isEqualToString: @"soundit"])
        {
            UIView * aView = [aMsgDic objectForKey: @"view"];
            if([[aView subviews] count]<2)
            {
                [self tapped: nil];
                return;
            }
            CustomUplaodingView *
            cstView = [[aView subviews] objectAtIndex: 1];
            if(!inIndexPath)
            {
                inIndexPath = indexPath;
                
                UIImageView *imgView = [[cstView subviews] objectAtIndex:6];
                imgView.image = [UIImage imageNamed:@"chatPauseIcon"];
                NSError *error;
                NSBundle* bundle = [NSBundle mainBundle];
                NSString* bundleDirectory = (NSString*)[bundle bundlePath];
                
                NSURL *url = [NSURL fileURLWithPath:[bundleDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",[aMsgDic objectForKey:@"link"]]]];
                
                if(self.player)
                {
                    self.player = nil;
                }
                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
                
                self.player.numberOfLoops = 0;
                self.player.volume = 1.0f;
                self.player.delegate = self;
                [self.player prepareToPlay];
                
                if (self.player == nil)
                    NSLog(@"%@", [error description]);
                else
                    [self.player play];
            }
            else
            {
                [self.player stop];
                self.player = nil;
                if(inIndexPath != indexPath)
                {
                    NSDictionary *MsgDic = [[self.msgGroupedByDate objectForKey: [self.allKeysOfDate objectAtIndex: inIndexPath.section]] objectAtIndex: inIndexPath.row];
                    UIView * OldView = [MsgDic objectForKey: @"view"];
                    CustomUplaodingView *
                    cView = [[OldView subviews] objectAtIndex: 1];
                    
                    UIImageView *imgView = [[cView subviews] objectAtIndex:6];
                    imgView.image = [UIImage imageNamed:@"chatPlayIcon"];
                }
                else
                {
                    UIImageView *imgView = [[cstView subviews] objectAtIndex:6];
                    imgView.image = [UIImage imageNamed:@"chatPlayIcon"];
                }
                inIndexPath = nil;
            }
            [self.tView reloadData];
        }
    }
}


#pragma mark -text field methods

- (void)keyboardDidShow: (NSNotification *) notif{
    
}
- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
    isKeyBoard=NO;
}
#pragma mark-animating a view
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1]; // if you want to slide up the view
    
    CGRect rect = self.viewMessage.frame;
    
    if (movedUp)
    {
        
        //isKeyBoardDown = NO;
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        if([UIScreen mainScreen].bounds.size.height>480)
        {
            rect.origin.y -= 216;
        }
        else
        {
            rect.origin.y -= 216;
        }
    }
    else
    {
        
        // revert back to the normal state.
        if([UIScreen mainScreen].bounds.size.height>480)
        {
            rect.origin.y += 216;
        }
        else
        {
            rect.origin.y += 216;
        }
    }
    self.viewMessage.frame = rect;
    [UIView commitAnimations];
}
-(void)keyboardWillShow:(NSNotification *)notification {
    
    self.inputToolbar.keyBoardStatus = eKeyBoardNormal;
    
    if(isKeyBoard)
        return;
    isKeyBoard=YES;
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panRecognizer.delegate = self;
    [self.tView addGestureRecognizer:panRecognizer];
    
}

-(void)keyboardWillHide:(NSNotification *)notification {
    
    /* Move toolbar and tableview back to bottom of the screen */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    CGRect frame = self.inputToolbar.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    CGRect rect=self.tView.frame;
    rect.origin.y = rect.origin.y + kKeyboardHeightPortrait; ;
    self.tView.frame=rect;
    if (isAnyKeyBoardShowing == NO)
    {
        self.inputToolbar.frame = frame;
        
    }
    [UIView commitAnimations];
    
    if([UIScreen mainScreen].bounds.size.height>480)
    {
        [tView setFrame:CGRectMake(0,64, 320, 464)];
    }
    else
    {
        [tView setFrame:CGRectMake(0,64, 320, 376)];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"viewdidappear");
    if([UIScreen mainScreen].bounds.size.height>480)
    {
        [tView setFrame:CGRectMake(0,64, 320, 464)];
    }
    else
    {
        [tView setFrame:CGRectMake(0,64, 320, 376)];
    }

    
    [self.loadingMsgIndicator setHidden:YES];
    if (self.isMediaOpened == YES)
    {
        NSLog(@"ismediaopened");
        
        self.isMediaOpened = NO;
        
        return;
    }
    else
    {
        NSLog(@"FetchInitialMessages");
        
        //when we are not coming from existing view controller
        if ([self isDownloadingAndUploadingAreInPending] == NO)
        {
            [self fetchInitialMsgs];
            [self getDatabaseImages];
            if(isMediaAvailable)
            {
                [self uploadImage:[ NSDictionary dictionaryWithDictionary:self.dictMessageMedia]];
                isMediaAvailable = NO;
                self.dictMessageMedia = nil;
            }
        }
        else
        {
            lastRecordTimestamp = [[messages lastObject] objectForKey:@"timestamp"];
            [self fetchInitialMsgsInSession];
            [self getDatabaseImagesInSession];
        }
        [self performSelector:@selector(CheckXMPPConnection) withObject: nil afterDelay: 0.5];
    }
}
-(BOOL)checkForWhiteSpaces:(NSString*)postText{
    
    NSCharacterSet *set = [NSCharacterSet decomposableCharacterSet];
    if ([[postText stringByTrimmingCharactersInSet: set] length] == 0)
    {
        return YES;
    }
    return NO;
}
-(void)inputButtonPressed:(NSString *)inputText
{
    
    NSCharacterSet *characterset=[NSCharacterSet characterSetWithCharactersInString:@"\ufffc"];;
    NSRange range=[inputText rangeOfCharacterFromSet:characterset];
    if (range.location != NSNotFound && range.length==1)
    {
        return;
    }
    
    
    if ([inputText length] > kMaxMessageTextLength) {
        [Utils showAlertView:kAlertTitle message:@"Message limit is 2000 characters." delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles:Nil];
        return;
    }
    
    
    [self sendChatState:kOTRChatStateInactive];
    /* Called when toolbar button is pressed */
    //5-3-14
    [self performSelector:@selector(sendMessage:) withObject: inputText];
    self.msgText = @"";
    
    //[self performSelector:@selector(sendMessage:) withObject:inputText];
    //end
}
- (void)inputImageButtonPressed
{
    [self performSelector:@selector(btnImageChangeClicked:) withObject:nil];
}

-(void)swipe:(UISwipeGestureRecognizer*)gesture
{
}
-(void)tapped:(UITapGestureRecognizer*)gesture
{
    //7-4-14
    if(self.inputToolbar.keyBoardStatus == eKeyBoardNone)
    {
        return;
    }
    //end
    
    //changed11-9-13
    self.inputToolbar.btnCustomEmoji.tag = eKeyBoardCustom;
    [self hideBothKeyBoard];
    //end
    
}

-(void)hideBothKeyBoard
{
    isKeyBoard = NO;
    isMenuOpened = NO;
    
    [self.tView removeGestureRecognizer:panRecognizer];
    panRecognizer = nil;
    
    self.inputToolbar.keyBoardStatus = eKeyBoardNone;
    [self.inputToolbar.btnFileUpload setImage:[UIImage imageNamed:@"chatAdd"] forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    CGRect frame = self.inputToolbar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    CGRect rect=self.tView.frame;
    float addY = 0;
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    if ([iOSVersion floatValue]>=7.0)
    {
        addY+=20;
    }
    rect.size.height=[UIScreen mainScreen].bounds.size.height-self.inputToolbar.frame.size.height-64;
    self.tView.frame=rect;
    self.inputToolbar.frame = frame;
    [UIView commitAnimations];
    if (![messages count]==0)
    {
        
    }
    
    [self.inputToolbar.textView resignFirstResponder];
    chatCustomKeyboardViewController.view.hidden = YES;
    
    
}

-(void)showKeyBoardWithSender:(UIButton *)inSender
{
    switch (self.inputToolbar.keyBoardStatus)
    {
        case eKeyBoardNone:
        case eKeyBoardNormal:
            self.inputToolbar.keyBoardStatus = eKeyBoardCustom;
            [self showCustomKeyboard];
            
            break;
            
        case eKeyBoardCustom:
            self.inputToolbar.keyBoardStatus = eKeyBoardNormal;
            [self showNormalKeyboard];
            break;
            
        default:
            break;
    }
}
//end
#pragma mark- InputToolBar delegate Methods
-(void)showKeyboard: (id)inToolBar andSender:(UIButton *)inSender
{
    switch (inSender.tag)
    {
        case eKeyBoardCustom:
            
            [self showKeyBoardWithSender:  inSender];
            break;
            
        case eKeyBoardUpload:
            
            [self hideBothKeyBoard];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Media" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Library",@"Video",@"Audio",nil];
                [action setActionSheetStyle:UIActionSheetStyleBlackOpaque];
                [action setTag:99];
                [action showInView:self.view];
                return;
            }
            [self setPicker:nil];
            if(!self.picker)
            {
                self.picker = [[UIImagePickerController alloc] init];
                self.picker.delegate = self;
            }
            self.picker.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            self.picker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString*) kUTTypeImage, nil];
            
            [self presentViewController:self.picker animated:YES completion:nil];
            
            break;
            
        default:
            
            [self showKeyBoardWithSender:  inSender];
            
            break;
    }
}
#pragma end
-(void)showNormalKeyboard
{
    chatCustomKeyboardViewController.view.hidden = YES;
    [self.inputToolbar.btnFileUpload setImage:[UIImage imageNamed:@"chatAdd"] forState:UIControlStateNormal];
    [self.inputToolbar.textView becomeFirstResponder];
}

-(void)showCustomKeyboard
{
    [self.inputToolbar.btnFileUpload setImage:[UIImage imageNamed:@"chatKeyboardIcon"] forState:UIControlStateNormal];
    chatCustomKeyboardViewController.view.hidden = NO;
    [chatCustomKeyboardViewController showOptionView];
    [self.inputToolbar.textView resignFirstResponder];
    [self setInputViewDefaultFrameWithCustomKeyBoardOpen];
}


-(void)customSmileyClicked:(NSString *)smileyname
{
    isMediaOpened= YES;
    if (self.shareLVController == nil)
    {
        self.shareLVController = [[ShareLocationViewController alloc] initWithNibName: nil bundle: nil];
        self.shareLVController.delegate = self;
        
    }
    [self.navigationController pushViewController: self.shareLVController animated:YES];
    
//    return;
//    
//    
//    
//    NSRange aRange = self.inputToolbar.textView.selectedRange;
//    
//    aRange.location = aRange.location + smileyname.length;
//    NSMutableString *newStr = [[NSMutableString alloc] initWithString: self.inputToolbar.textView.text];
//    [newStr insertString: smileyname atIndex: self.inputToolbar.textView.selectedRange.location];
//    
//    self.inputToolbar.textView.text = newStr;
//    self.msgText  = newStr;
//    [self.inputToolbar.textView setSelectedRange: aRange];
}

-(void)customEmoticonsClicked:(NSString *)emoticonName{
    
    
    
    NSRange aRange = self.inputToolbar.textView.selectedRange;
    
    aRange.location = aRange.location + emoticonName.length;
    NSMutableString *newStr = [[NSMutableString alloc] initWithString: self.inputToolbar.textView.text];
    [newStr insertString: emoticonName atIndex: self.inputToolbar.textView.selectedRange.location];
    
    self.inputToolbar.textView.text = newStr;
    self.msgText  = newStr;
    [self.inputToolbar.textView setSelectedRange: aRange];
}

-(void)customStickersClicked:(NSString *)stickerName
{
    //    NSLog(@"stickerName");
    if(![gCXMPPController isConnected])
    {
        return;
    }
    isStickerClicked = YES;
    self.msgText = stickerName;
    [self performSelector:@selector(sendMessage:) withObject:stickerName];
}


-(void)doShowSharedLocation:(CLocation *)inLocation
{
    MapViewController *aMapViewCon = [[MapViewController alloc] initWithNibName: nil bundle: nil];
    
    if (inLocation.isSelf)
    {
//        NSString *firstName = [[NSUserDefaults standardUserDefaults] objectForKey:kfirstName];
//        NSString *lastName = [[NSUserDefaults standardUserDefaults] objectForKey:klastName];
        NSString *firstName = [[self.chatWithUser componentsSeparatedByString:@"@"] firstObject];
        NSString *lastName = nil;
        if (lastName)
        {
            firstName = [firstName stringByAppendingFormat:@" %@", lastName];
        }
        inLocation.UserName = firstName;
    }
    else
    {
        inLocation.UserName = [NSString stringWithFormat:@"%@",userName];
    }
    
    aMapViewCon.SelectedLocation = inLocation;
    self.isMediaOpened = YES;
    
    [self.navigationController pushViewController: aMapViewCon animated: YES];
}
#pragma mark - Share location Delegate
-(void) shareSelectedLocation:(FSVenue*)selectedVenue
{
    NSString *location = [NSString stringWithFormat:@"%f,%f,%@",selectedVenue.location.coordinate.latitude,selectedVenue.location.coordinate.longitude,selectedVenue.name];
    
    NSDate *sendTimestampDate = [NSDate date];
    
    NSString *aChatId = [self chatID];
    
    NSMutableDictionary *msgDic = [[NSMutableDictionary alloc] init];
    [msgDic setObject:@"you" forKey:@"sender"];
    [msgDic setObject:@"self" forKey:@"speaker"];
    [msgDic setObject:aChatId forKey:@"chatid"];
    
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a"];
    
    NSString *dateString = [dateFormat stringFromDate: [NSDate date]];
    
    [msgDic setObject:dateString forKey:@"time"];
    
    [msgDic setObject: sendTimestampDate forKey:@"sendTimestampDate"];
    
    NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
    [date_formater setDateFormat:@"yyyy-MM-dd"];
    
    NSString *aDateStr = [date_formater stringFromDate: sendTimestampDate];
    [msgDic setObject:[date_formater dateFromString:aDateStr ] forKey:@"timestamp"];
    
    [msgDic setObject:location forKey:@"attachment"];
    [msgDic setObject:@"uploaded" forKey:@"fileaction"];
    [msgDic setObject:@"location" forKey:@"media"];
    [msgDic setObject:location forKey:@"filelocalpath"];
    [msgDic setObject:@"" forKey:@"fileSize"];
    [msgDic setObject:@"" forKey:@"fileName"];
    
    
    UIView *chatView;
    chatView  = [self bubbleView:[NSString stringWithFormat:@"%@",location] from:YES andMediaType: eMediaTypeLocation andMediaOrientation:eMediaPortrait andThumbString:nil];
    [msgDic setObject:chatView  forKey:@"view"];
    
    CustomUplaodingView *csView = [[chatView subviews] objectAtIndex: 1];
    csView.chatId = aChatId;
    [msgDic setObject:selectedVenue.name forKey:@"locationName"];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"id" stringValue:aChatId];
    [message addAttributeWithName:@"to" stringValue:chatWithUser];
    
    
    [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1]];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    NSXMLElement *media = [NSXMLElement elementWithName:@"media"];
    //27-3-14
    
    NSXMLElement *mediaOrientation = [NSXMLElement elementWithName:KMediaOrientation];
    [mediaOrientation setStringValue:[NSString stringWithFormat:@"1"]];
    
    //end
    
    //nehaa thumbnail
    NSXMLElement *thumbBase64String = [NSXMLElement elementWithName:KThumbBase64String];
    [thumbBase64String setStringValue:@""];
    [message addChild:thumbBase64String];
    //end thumbnail
    
    
    NSXMLElement *filelocalpath = [NSXMLElement elementWithName:@"filelocalpath"];
    NSXMLElement *fileaction = [NSXMLElement elementWithName:@"fileaction"];
    NSXMLElement *fileSize = [NSXMLElement elementWithName:@"fileSize"];
    NSXMLElement *fileName = [NSXMLElement elementWithName:@"fileName"];
    
    
    [media setStringValue:@"location"];
    NSXMLElement *request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addAttributeWithName:@"attachment" stringValue: location];
    [fileaction setStringValue:@"uploaded"];
    
    
    NSXMLElement *sendTimestampDateTag = [NSXMLElement elementWithName:@"sendTimestampDate"];
    [sendTimestampDateTag setStringValue: [NSString stringWithFormat:@"%f",[sendTimestampDate timeIntervalSince1970]]];
    [message addChild:sendTimestampDateTag];
    
    
    [filelocalpath setStringValue: location];
    [fileSize setStringValue:@""];
    [fileName setStringValue:@""];
    
    [message addChild:filelocalpath];
    [message addChild:fileaction];
    [message addChild:fileSize];
    [message addChild:fileName];
    
    
    [body addChild:media];
    //27-3-14
    [body addChild:mediaOrientation];
    //end
    NSXMLElement *fullName = [NSXMLElement elementWithName:@"fullName" stringValue:[[NSUserDefaults standardUserDefaults] valueForKey:kFullname]];
    [message addChild:fullName];
    
    NSXMLElement *chatFlow = [NSXMLElement elementWithName:@"chatFlow" stringValue:@"anonymous"];
    [message addChild:chatFlow];
    
    NSXMLElement *userId = [NSXMLElement elementWithName:@"userId"];
    [userId setStringValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kUserId]]];
    [message addChild:userId];
    NSXMLElement *imageURL = [NSXMLElement elementWithName:@"imgURL"];
    [imageURL setStringValue:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImage_url_100],[[NSUserDefaults standardUserDefaults] valueForKey:kProfileImage]]];
    [message addChild:imageURL];

    [message addChild:body];
    [message addChild:request];
    [self.xmppStream sendElement:message];
    [self updateLastMessage:@"📍 Location" withDate:[NSDate date]];
    if(self.isUnavailable == YES)
    {
//        NSString *msg = nil;
//        msg = @"shared location";
//        msg = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:kFullName],msg];
//        
//        NetworkService *obj = [NetworkService sharedInstance];
//        NSDictionary *aDict=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"userId",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"],@"sessionToken",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,@"sendXmppPushNotification",@"option",kDevice,kDeviceType,msg,@"message",@"",@"toUserId",[[NSUserDefaults standardUserDefaults] valueForKey:kchatUserName],kchatUserName,[[NSUserDefaults standardUserDefaults] objectForKey:kFullName],kFullName,nil];
//        [obj sendAsynchRequestByPostToServer:@"pushnotification" dataToSend:aDict delegate:nil contentType:eAppJsonType andReqParaType:eJson header:NO];
    }
    //end
    
    [messages addObject:msgDic];
    
    [self saveToChatHistory:msgDic];
    
    [self doGroupMsgByDate: messages];
    [self.tView reloadData];
    NSString *groupKey = [self.allKeysOfDate lastObject];
    if (groupKey)
    {
        int sec = self.allKeysOfDate.count - 1;
        int row = [[self.msgGroupedByDate objectForKey: groupKey] count] - 1;
        
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:row
                                                       inSection:sec];
        
        [self.tView scrollToRowAtIndexPath:topIndexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:NO];
        
        
    }
    
    
    
}


#pragma mark-text field delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


#pragma mark Chat delegates

#pragma mark Chat delegates
- (IBAction)vibrate:(id)sender {
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}
- (void)doDisplayMessage:(NSDictionary *)dispMsg
{
    //27-2-14 displayed
    AppDelegate *del = APP_DELEGATE;
    if ([del getChatWindowOpenedStatusBySender: chatWithUser] == YES)
    {
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"from" stringValue:[dispMsg objectForKey:@"to"]];
        [message addAttributeWithName:@"id" stringValue:@""];
        [message addAttributeWithName:@"to" stringValue:[dispMsg objectForKey:@"sender"]];
        
        NSXMLElement *received = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
        [received addAttributeWithName:@"type" stringValue:@"displayed"];
        [received addAttributeWithName:@"id" stringValue:[dispMsg objectForKey:@"id"]];
        [received addAttributeWithName:@"chatType" stringValue:@"chat"];
        
        [message addChild:received];
        
        [self.xmppStream sendElement:message];
    }
    //end
}
- (void)newPrivateMessageReceived:(NSDictionary *)messageContent
{
    
}

- (void)newMessageReceived:(NSDictionary *)messageContent  {
    
    ///discard  duplicate msg
     NSString *aChatId = [messageContent objectForKey:@"id"];
    if ([self isAlreadyExistMsgByChatId: aChatId])
    {
        NSLog(@"*** Duplicate msg is discarded ***");
        return;
    }
    ///end
    
    //    NSLog(@"%@ and chatting with %@",[messageContent objectForKey:@"sender"],chatWithUser);
    if([[messageContent objectForKey:@"sender"]rangeOfString:chatWithUser].length==0)
    {
        NSString *msgBody = nil;
        [[[messageContent objectForKey:@"msg"] componentsSeparatedByString:@"/"] objectAtIndex:0];
        if([[messageContent objectForKey:@"msg"] rangeOfString:@"{/"].length>0)
        {
            msgBody = @"Sticker";
        }
        else if([[messageContent objectForKey:@"msg"] rangeOfString:@"(/"].length>0)
        {
            msgBody = [messageContent objectForKey:@"msg"];
            msgBody = [msgBody stringByReplacingOccurrencesOfString:@"(/" withString:@""];
            msgBody = [msgBody stringByReplacingOccurrencesOfString:@")" withString:@""];
        }
        else if([[messageContent objectForKey:@"msg"] rangeOfString:@"[/"].length>0)
        {
            msgBody = [messageContent objectForKey:@"msg"];
            msgBody = [msgBody stringByReplacingOccurrencesOfString:@"[/" withString:@""];
            msgBody = [msgBody stringByReplacingOccurrencesOfString:@"]" withString:@""];
        }
        
        else
        {
            msgBody = [[[messageContent objectForKey:@"msg"] componentsSeparatedByString:@"/"] objectAtIndex:0];
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.imgView.image,@"image",[[[messageContent objectForKey:@"sender"] componentsSeparatedByString:@"@"] objectAtIndex:0],@"sender",msgBody,@"msg", nil];
        //        [JHNotificationManager notificationWithMessage:dic];
        [TopNotificationManager notificationWithMessage:dic];
        
        return;
    }
#pragma mark - used for check setting for viberate in app
//    if([[NSUserDefaults standardUserDefaults] boolForKey:kInAppVibrate])
//    {
//        [self vibrate:nil];
//    }
    [Utils playSound:@"ReceivedMessage"];
#pragma end
    
    NSMutableArray *array =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_COUNTER]];
    [array removeObject:chatWithUser];
    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithArray:array] forKey:MESSAGE_COUNTER];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"hh:mm a"];
    
    NSDate *sendTimestampDate = [messageContent objectForKey:@"sendTimestampDate"];
    NSString *dateString = [format stringFromDate:sendTimestampDate];
    NSString *m = [messageContent objectForKey:@"msg"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init ];
    [dic setObject:[m substituteEmoticons] forKey:@"msg"];
    [dic setObject:dateString forKey:@"time"];
    [dic setObject: sendTimestampDate forKey:@"sendTimestampDate"];
    NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
    [date_formater setDateFormat:@"yyyy-MM-dd"];
    NSString *aDateStr = [date_formater stringFromDate: [messageContent objectForKey:@"timestamp"]];
    [dic setObject:[date_formater dateFromString:aDateStr ] forKey:@"timestamp"];
    NSString *chatId = [messageContent objectForKey:@"id"];
    [dic setObject:chatId forKey:@"chatid"];
    NSString *fileaction = [messageContent objectForKey:@"fileaction"];
    NSString *filelocalpath = [messageContent objectForKey:@"filelocalpath"];
    NSString *fileSize = [messageContent objectForKey:@"fileSize"];
    NSString *mediaType = [messageContent objectForKey:@"media"];
    NSString *fileNameWithExt = [messageContent objectForKey:@"fileName"];
    NSString *mediaOrientation = [messageContent objectForKey:KMediaOrientation];
    NSString *thumbBase64String = [messageContent objectForKey:KThumbBase64String];
    [dic setObject:@"other"  forKey:@"speaker"];
    UIView *chatView=nil;
    if([[messageContent allKeys] containsObject:@"attachment"])
    {
        if(![mediaType isEqualToString:@"soundit"])
        {
            [dic setObject:fileaction forKey:@"fileaction"];
            [dic setObject:filelocalpath forKey:@"filelocalpath"];
            [dic setObject:fileSize forKey:@"fileSize"];
            [dic setObject:fileNameWithExt forKey:@"fileName"];
            [dic setObject:mediaOrientation forKey:KMediaOrientation];
            [dic setObject:thumbBase64String forKey:KThumbBase64String];
        }
        else
        {
            [dic setObject:[[[messageContent objectForKey:@"attachment"] componentsSeparatedByString:@"$$$"] objectAtIndex:0] forKey:@"link"];
        }
        [dic setObject: mediaType forKey:@"media"];
        if([mediaType isEqualToString:@"soundit"])
        {
            chatView = [self bubbleView:[messageContent objectForKey:@"attachment"] from:NO andMediaType: eMediaTypeSound andMediaOrientation: [mediaOrientation integerValue] andThumbString:nil];
        }
        else
        {
            if ([mediaType isEqualToString:@"image"])
            {
                chatView = [self bubbleView:[messageContent objectForKey:@"attachment"] from:NO andMediaType: eMediaTypeImage andMediaOrientation: [mediaOrientation integerValue] andThumbString: thumbBase64String];
            }
            if ([mediaType isEqualToString:@"video"])
            {
                chatView = [self bubbleView:[messageContent objectForKey:@"attachment"] from:NO andMediaType: eMediaTypeVideo andMediaOrientation: [mediaOrientation integerValue] andThumbString: thumbBase64String];
            }
            
            if ([mediaType isEqualToString:@"location"])
            {
                chatView = [self bubbleView:[messageContent objectForKey:@"attachment"] from:NO andMediaType: eMediaTypeLocation andMediaOrientation: [mediaOrientation integerValue] andThumbString: thumbBase64String];
                CLocation *aLocation = [AppManager getLocationByLocationStr: filelocalpath];
                [dic setObject:aLocation.LocationName  forKey:@"locationName"];
            }
            if ([mediaType isEqualToString:@"audio"])
            {
                chatView = [self bubbleView:[messageContent objectForKey:@"attachment"] from:NO andMediaType: eMediaTypeAudeo andMediaOrientation: [mediaOrientation integerValue] andThumbString:nil];
            }
            
            CustomUplaodingView *
            cstView = [[chatView subviews] objectAtIndex: 1];
            cstView.fileServerUrlStr = [messageContent objectForKey:@"attachment"];
            cstView.eventType = eTypeUpldDownLoad;
            
            if ([mediaType isEqualToString:@"location"])
            {
                cstView.eventType = eTypeUpldDownLoaded;
            }
            
            cstView.chatId = chatId;
            cstView.fileSize = fileSize;
            [cstView UpdateUIContents];
            
        }
    }
    else
    {
        chatView = [self bubbleView:[NSString stringWithFormat:@"%@", [m substituteEmoticons]] from:NO andMediaType: eMediaTypeNone andMediaOrientation: [mediaOrientation integerValue] andThumbString:nil];
    }
    
    [dic setObject:chatView  forKey:@"view"];
    //end
    
    [messages addObject:dic];
    [self doGroupMsgByDate: messages];
    
    [self.tView reloadData];
    
    @try {
        NSString *groupKey = [self.allKeysOfDate lastObject];
        if (groupKey)
        {
            int sec = self.allKeysOfDate.count - 1;
            int row = [[self.msgGroupedByDate objectForKey: groupKey] count] - 1;
            
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:row
                                                           inSection:sec];
            
            [self.tView scrollToRowAtIndexPath:topIndexPath
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:NO];
            
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    AppDelegate *appDel =   APP_DELEGATE;
    if ([appDel getChatWindowOpenedStatusBySender:chatWithUser])
    {
        
    }
    
}

- (void)isDelivered:(NSDictionary *)messageContent
{
    
    NSString *aChatId = [messageContent objectForKey:@"chatid"];
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"chatid==%@",aChatId];
    NSMutableArray * aArr = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate: aPredicate]];
    NSMutableDictionary * aDic = [aArr lastObject];
    int indexOfObj = [messages indexOfObject: aDic];
    
    if([[aDic allKeys]containsObject:@"isdelivered"])
    {
        if([[aDic objectForKey:@"isdelivered"] integerValue]==3)
        {
            return;
        }
    }
    
    [aDic setObject:[NSNumber numberWithInt: 2]  forKey:@"isdelivered"];
    
    if(aDic)
    {
        [messages replaceObjectAtIndex: indexOfObj withObject: aDic];
    }
    
    [self setLastDeliveredDate:[NSDate date]];
    
    [self.tView reloadData];
    
}
-(void)isDisplayed:(NSDictionary *)messageContent
{
    [Utils playSound:@"SentMessage"];
    NSString *aChatId = [messageContent objectForKey:@"chatid"];
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"chatid==%@",aChatId];
    NSMutableArray * aArr = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate: aPredicate]];
    NSMutableDictionary * aDic = [aArr lastObject];
    int indexOfObj = [messages indexOfObject: aDic];
    if([[aDic allKeys]containsObject:@"isdelivered"])
    {
        if([[aDic objectForKey:@"isdelivered"] integerValue]==3)
        {
            return;
        }
    }
    [aDic setObject:[NSNumber numberWithInt:3]  forKey:@"isdelivered"];
    if(aDic)
    {
        [messages replaceObjectAtIndex: indexOfObj withObject: aDic];
    }
    
    [self.tView reloadData];
    
}
- (void)StopAudioRecorder
{
    if(recorder)
    {
        self.inputToolbar.btnFileUpload.hidden= NO;
        self.inputToolbar.textView.hidden = NO;
        self.inputToolbar.imgView.hidden = NO;
        self.inputToolbar.lblSwipeToDelete.hidden = YES;
        self.inputToolbar.lblWhite.hidden = YES;
        self.inputToolbar.imgViewRecording.hidden = YES;
        self.inputToolbar.lblRecordingTime.hidden=YES;
        [self.inputToolbar.timer invalidate];
        [self.inputToolbar swiped];
        [self stopRecording];
    }
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setLblUsername:nil];
    [self setBtnBack:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)newGroupMessageReceived:(NSDictionary *)messageContent
{
    
}


-(NSDate*)getLastDeliveredDate
{
    NSDate *aDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSentDate"];
    return  aDate;
}
-(void)setLastDeliveredDate:(NSDate *)inDate
{
    [[NSUserDefaults standardUserDefaults] setObject:inDate forKey:@"lastSentDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setFailedMesImage
{
    
    if (isProcessFailedMsg == NO)
    {
        isProcessFailedMsg = YES;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isdelivered = 0"];
        
        NSArray *filteredArray = [messages filteredArrayUsingPredicate:predicate];
        
        if (filteredArray.count > 0)
        {
            for(NSMutableDictionary *dict in filteredArray)
            {
                NSString *aChatId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"chatid"]];
                int indexOfObj = [messages indexOfObject: dict];
                
                [dict setObject: @"4" forKey:@"isdelivered"];
                
                [messages replaceObjectAtIndex: indexOfObj withObject: dict];
                
                NSDictionary * updationDic = [NSDictionary dictionaryWithObjectsAndKeys:aChatId,@"chatid", nil];
                NSNotificationCenter * aMsgCenter = [NSNotificationCenter defaultCenter];
                NSNotification * msg =	[NSNotification notificationWithName: @"updateFailedMsg" object: updationDic userInfo: nil];
                [aMsgCenter postNotification: msg];
                /////
            }
            [self updateMsgListViewIfNeededByTotalMesg: messages];
            
        }
        
        isProcessFailedMsg = NO;
    }
    
}
//end


-(void)userPresence:(NSDictionary *)presence
{
    if (presence == nil)
    {
        return;
    }
    if(self.inputToolbar.textView.text.length>0)
    {
        self.inputToolbar.btnSend.enabled = YES;
        [self.inputToolbar setSendBtnProperty:@"send"];
        self.inputToolbar.btnFileUpload.enabled = YES;
    }
    //nehaa 26-04-14
    //add this because of server unavailability
    NSString *status = [presence objectForKey:@"XmppStatus"];
    if(status &&  [status isEqualToString:@"Disconnected"])
    {
        self.inputToolbar.btnSend.enabled = NO;
        self.inputToolbar.btnRecord.enabled = NO;
        self.activity.hidden = NO;
        self.lblUsername.hidden = YES;
        self.inputToolbar.isConnected=NO;
        self.inputToolbar.btnFileUpload.enabled = NO;
        self.lblTyping.text =@"Waiting for network...";
        isUnavailable = YES;
        return;
    }
    //end 26-04-14
    if([[presence allKeys]containsObject:@"UNSUBSCRIBE"])
    {
        [gCXMPPController.xmppLastSeen sendLastActivityQueryToJID:[XMPPJID jidWithString:chatWithUser]];
        return;
    }
    XMPPPresence *userPresence = [presence objectForKey:@"unavailable"];
    if(userPresence)
    {
        if([[[[userPresence fromStr] componentsSeparatedByString:@"/"] objectAtIndex:0]isEqualToString:chatWithUser])
        {
            isUnavailable = YES;
            return;
        }
    }
    
    userPresence = [presence objectForKey:@"NORMAL"];
    if(!userPresence)
    {
        return;
    }
    if([[userPresence toStr]isEqualToString:[userPresence fromStr]])
    {
        
        self.lblUsername.hidden = NO;
        self.activity.hidden = YES;
        self.inputToolbar.btnSend.enabled = YES;
        self.inputToolbar.btnRecord.enabled = YES;
        self.inputToolbar.btnFileUpload.enabled = YES;
        self.inputToolbar.isConnected = YES;
        self.lblTyping.text = [self CheckPresenceOfFriend];
        [self resendDisputedMessageswithTimeStamp:[NSDate date]];
    }
    if([chatWithUser rangeOfString:[[[userPresence fromStr] componentsSeparatedByString:@"/"] objectAtIndex:0]].length>0)
    {
        self.lblUsername.hidden = NO;
        self.activity.hidden = YES;
        self.inputToolbar.btnSend.enabled = YES;
        self.inputToolbar.btnRecord.enabled = YES;
        self.inputToolbar.btnFileUpload.enabled = YES;
        self.inputToolbar.isConnected = YES;
        [self performSelector:@selector(CheckPresenceOfFriend) withObject:nil afterDelay:0.2];
        
    }
}
- (NSString *)stringFromHexString:(NSString *)hexString {
    
    // The hex codes should all be two characters.
    if (([hexString length] % 2) != 0)
        return nil;
    
    NSMutableString *string = [NSMutableString string];
    
    for (NSInteger i = 0; i < [hexString length]; i += 2) {
        
        NSString *hex = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSInteger decimalValue = 0;
        sscanf([hex UTF8String], "%x", &decimalValue);
        [string appendFormat:@"%c", decimalValue];
    }
    
    return string;
}

#pragma mark - chatStatus Methods
-(void)sendChatState:(int)chatState
{
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:chatWithUser];
    XMPPMessage * xMessage = [XMPPMessage messageFromElement:message];
    
    BOOL shouldSend = YES;
    
    switch (chatState)
    {
        case kOTRChatStateActive  :
            [xMessage addActiveChatState];
            break;
        case kOTRChatStateComposing  :
            [xMessage addComposingChatState];
            break;
        case kOTRChatStateInactive:
            [xMessage addInactiveChatState];
            break;
        case kOTRChatStatePaused:
            [xMessage addPausedChatState];
            break;
        case kOTRChatStateGone:
            [xMessage addGoneChatState];
            break;
        default :
            shouldSend = NO;
            break;
    }
    
    if(shouldSend)
        [self.xmppStream sendElement:message];
    
    
}
- (void) messageProcessedNotification:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    if(![[[[userInfo objectForKey:@"from"] componentsSeparatedByString:@"/"] objectAtIndex:0]isEqualToString:chatWithUser])
    {
        return;
    }
    if([[userInfo objectForKey:@"chatStatus"] intValue]==kOTRChatStateComposing)
    {
        self.lblTyping.text = @"typing..." ;
    }
    else if([[userInfo objectForKey:@"chatStatus"] intValue]==kOTRChatStateInactive)
    {
        self.lblTyping.text = @"Online";
    }
    else if([[userInfo objectForKey:@"chatStatus"] intValue]==kOTRChatStateActive)
    {
        self.lblTyping.text = @"Online";
    }
    else
    {
    }
}
-(int )getLenghtOfIdentifierFromLastInMsg:(NSString *)inMsg
{
    NSString * startIdentifier;
    NSString * endIdentifier;
    BOOL isFoundIdentifier = NO;
    if ( [inMsg hasSuffix: EmotionEND_FLAG])
    {
        isFoundIdentifier   =   YES;
        startIdentifier     =   EmotionBEGIN_FLAG;
        endIdentifier       =   EmotionEND_FLAG;
    }
    else if ( [inMsg hasSuffix: EmojiEND_FLAG])
    {
        isFoundIdentifier   =   YES;
        startIdentifier     =   EmojiBEGIN_FLAG;
        endIdentifier       =   EmojiEND_FLAG;
        
    }
    else if ([inMsg hasSuffix: NativeEmojiEND_FLAG])
    {
        isFoundIdentifier   =   YES;
        startIdentifier     =   NativeEmojiBEGIN_FLAG;
        endIdentifier       =   NativeEmojiEND_FLAG;
    }
    if (isFoundIdentifier)
    {
        int len = 0;
        for (int i = inMsg.length - 1 ; i >= 0; i --)
        {
            len = len + 1;
            NSString *subStr = [inMsg substringFromIndex: i];
            if ( [subStr hasPrefix : startIdentifier])
            {
                return len;
            }
        }
    }
    
    
    
    return 1;
}
#pragma mark - textfield collapse or expand delegate methods
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    return YES;
}

- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView
{
    return YES;
}

-(void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
 }
-(void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    [self.inputToolbar.btnFileUpload setImage:[UIImage imageNamed:@"chatAdd"] forState:UIControlStateNormal];
}


-(BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL toReturn  = YES;
    if(range.location==0&&text.length>0)
    {
        
        [self sendChatState:kOTRChatStateComposing];
    }
    if(range.location==0&&text.length==0)
    {
        [self sendChatState:kOTRChatStateInactive];
    }
    return toReturn;
}


//27-3-14 p added mediaorientation attribute
#pragma mark- emoji without webview
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf andMediaType:(MediaType)inMediaType andMediaOrientation:(enMediaOrientation)inMediaOrient andThumbString:(NSString *)inThumbStr
{
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectZero];
    cellView.backgroundColor = [UIColor clearColor];
    ChatComponent * aChatCompo;
    UIView *returnView;
    UIView * animatedStickerView;
    
    BOOL isHasSticker = [self isContainStickerInMsg: text];
    // build single chat bubble cell with given text
    
    aChatCompo = [[ChatComponent alloc] init];
    aChatCompo.delegate = self;
    
    
    BOOL isMediaType = NO;
    if(inMediaType == eMediaTypeImage || inMediaType == eMediaTypeVideo || inMediaType == eMediaTypeAudeo
       || inMediaType == eMediaTypeLocation )
    {
        returnView = [aChatCompo ImageView:text isSelf:fromSelf andMediaType: inMediaType andMediaOrientation: inMediaOrient andThumbString: inThumbStr];
        
        isMediaType = YES;
    }
    else if(inMediaType == eMediaTypeSound)
    {
        returnView = [aChatCompo Sound:text isSelf:fromSelf andMediaType:inMediaType];
    }
    else if (isHasSticker == NO)
    {
        returnView =  [aChatCompo createChatViewOfMsg: text andLanguageType:eLangEnglish andFromSelf: fromSelf];
    }
    else
    {
        animatedStickerView = [aChatCompo createStickerViewByImageName: text];
    }
    float imageWidth = 0;
    float imageHeight = 0;
    getImageWidthByOrientationFlag(inMediaOrient,imageWidth);
    
    getImageHeightByOrientationFlag(inMediaOrient,imageHeight);
    
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"chatBubbleRed":@"chatBubbleWhite" ofType:@"png"]];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:26 topCapHeight:18]];
    
    bubbleImageView.tag = 100;
    CGRect rectBubble = bubbleImageView.frame;
    rectBubble.size.width = rectBubble.size.width + 20;
    bubbleImageView.frame = rectBubble;
    
    if(fromSelf)
    {
        if (isHasSticker)
        {
            cellView.frame = CGRectMake(320.0f - RightPaddingForSticker - KStickerSizeWidth, 0, KStickerSizeWidth, KStickerSizeHeight + VericalPaddingForTime);
        }
        else if(isMediaType)
        {
            if(inMediaType == eMediaTypeAudeo)
            {
                UIView *cst = [returnView.subviews objectAtIndex:0];
                bubbleImageView.frame = CGRectMake(returnView.frame.origin.x-4,
                                                   returnView.frame.origin.y-4,
                                                   cst.frame.size.width+14,
                                                   cst.frame.size.height+8);
                cellView.frame = CGRectMake(0, 0 , 320, bubbleImageView.frame.size.height+10);
                
                UIImageView *imgView = [returnView.subviews objectAtIndex:2];
                
//                NSDictionary *dict = [AppManager createDifferentUrlFromUrl:[[NSUserDefaults standardUserDefaults] objectForKey:kprofileImage]];
                [imgView setImage:[UIImage imageNamed:@"chatDefault"]];
//                [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kServerUrl],[[NSUserDefaults standardUserDefaults] valueForKey:kprofileImage]]] placeholderImage:[UIImage imageNamed:@"chatDefault"]];
                
            }
            else
            {
                UIView *cst = [returnView.subviews objectAtIndex:0];
                bubbleImageView.frame = CGRectMake(320-(cst.frame.size.width+14),
                                                   returnView.frame.origin.y-4,
                                                   cst.frame.size.width+14,
                                                   cst.frame.size.height+8);
                CGRect rect = returnView.frame;
                rect.origin.x = bubbleImageView.frame.origin.x+4;
                returnView.frame = rect;
                cellView.frame = CGRectMake(0, 0 , 320, bubbleImageView.frame.size.height+10);
                
            }
            
        }
        else
        {
            returnView.frame= CGRectMake(RightPaddingForChatV, VericalPaddingChatV , returnView.frame.size.width, returnView.frame.size.height);
            
            bubbleImageView.frame = CGRectMake(returnView.frame.origin.x - BubblePadding/2,
                                               returnView.frame.origin.y - BubblePadding/2,
                                               returnView.frame.size.width+(BubblePadding*2),
                                               returnView.frame.size.height+(BubblePadding*1.2));
            
            cellView.frame = CGRectMake(320.0f- RightPaddingForChatV - bubbleImageView.frame.size.width, 0.0f,bubbleImageView.frame.size.width, bubbleImageView.frame.size.height+6.0f);
        }
    }
    else
    {
        CGRect animatedVRect = animatedStickerView.frame;
        if (isHasSticker)
        {
            cellView.frame = CGRectMake(0.0f, 0.0f,KStickerSizeWidth,KStickerSizeHeight+VericalPaddingForTime );
            
            animatedVRect.origin.x = LeftPaddingForChatV;
            animatedStickerView.frame = animatedVRect;
            
        }
        else if(isMediaType)
        {
            if(inMediaType == eMediaTypeAudeo)
            {
                
                UIView *cst = [returnView.subviews objectAtIndex:0];
                animatedVRect = returnView.frame;
                
                bubbleImageView.frame = CGRectMake(returnView.frame.origin.x-4,
                                                   returnView.frame.origin.y-4,
                                                   cst.frame.size.width + 14,
                                                   cst.frame.size.height+8);
                animatedVRect.origin.x =LeftPaddingForChatV;
                returnView.frame = animatedVRect;
                cellView.frame = CGRectMake(0.0f, 0.0f,320,bubbleImageView.frame.size.height+10 );
                UIImageView *imgView = [returnView.subviews objectAtIndex:2];
                [imgView sd_setImageWithURL:[NSURL URLWithString:self.imageString] placeholderImage:[UIImage imageNamed:@"chatDefault"]];
                
                
            }
            else
            {
                UIView *cst = [returnView.subviews objectAtIndex:0];
                animatedVRect = returnView.frame;
                
                bubbleImageView.frame = CGRectMake(returnView.frame.origin.x-4,
                                                   returnView.frame.origin.y-4,
                                                   cst.frame.size.width + 14,
                                                   cst.frame.size.height+8);
                animatedVRect.origin.x =LeftPaddingForChatV;
                returnView.frame = animatedVRect;
                cellView.frame = CGRectMake(0.0f, 0.0f,320,bubbleImageView.frame.size.height+10 );
                
            }
        }
        else
        {
            
            returnView.frame= CGRectMake(10.0f, VericalPaddingChatV, returnView.frame.size.width, returnView.frame.size.height);
            bubbleImageView.frame = CGRectMake(returnView.frame.origin.x - 4 - BubblePadding/2,
                                               returnView.frame.origin.y - BubblePadding/2,
                                               returnView.frame.size.width+(BubblePadding*2),
                                               returnView.frame.size.height+(BubblePadding*1.2));
            
            cellView.frame = CGRectMake(0.0f, 0.0f, bubbleImageView.frame.size.width+30.0f,bubbleImageView.frame.size.height+VericalPaddingForTimeOther-24);
        }
        
    }
    CGRect rectCellView = cellView.frame;
    rectCellView.size.height = rectCellView.size.height + 20;
    if (isHasSticker)
    {
        [cellView addSubview: animatedStickerView];
    }
    else if (isMediaType)
    {
        [cellView addSubview:bubbleImageView];
        CGRect rect= returnView.frame;
        rect.size.height = rect.size.height - 20;
        
        [cellView addSubview:returnView];
    }
    else
    {
        
        [cellView addSubview:bubbleImageView];
        [cellView addSubview:returnView];
    }
    
    if (fromSelf == NO)
    {
    }
    
    return cellView ;
    
}

-(void)doOpenWebLink:(WebLinkButton *)inSender
{
    inSender.webLink =  [inSender.webLink stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@",inSender.webLink];
    if ([urlStr hasPrefix:@"http://"] == NO)
    {
        urlStr = [NSString stringWithFormat :@"http://%@",urlStr];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range2=[message rangeOfString: EmojiBEGIN_FLAG];
    NSRange range1=[message rangeOfString: EmojiEND_FLAG];
    
    NSRange range4=[message rangeOfString: EmotionBEGIN_FLAG];
    NSRange range3=[message rangeOfString: EmotionEND_FLAG];
    
    
    if ([message hasPrefix: EmojiBEGIN_FLAG] )
    {
        if (range2.location != NSNotFound)//for emoji
        {
            [array addObject:[message substringToIndex:range2.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range2.location, range1.location+1-range2.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }
        else
        {
            NSString *nextstr1=[message substringWithRange:NSMakeRange(range2.location, range1.location+1-range2.location)];
            
            if (![nextstr1 isEqualToString:@""]) {
                [array addObject:nextstr1];
                NSString *str=[message substringFromIndex:range1.location+1];
                
                [self getImageRange:str :array];
            }
            
            else
            {
                return;
            }
            
        }
    }
    else if ([message hasPrefix: EmotionBEGIN_FLAG])
    {
        if (range4.length>0 && range3.length>0)
        {
            if (range4.location != NSNotFound)//for emotion
            {
                [array addObject:[message substringToIndex:range4.location]];
                [array addObject:[message substringWithRange:NSMakeRange(range4.location, range3.location+1-range4.location)]];
                NSString *str=[message substringFromIndex:range3.location+1];

                [self getImageRange:str :array];
            }
            else
            {
                
                //for emotion
                NSString *nextstr2=[message substringWithRange:NSMakeRange(range4.location, range3.location+1-range4.location)];
                
                if (![nextstr2 isEqualToString:@""]) {
                    [array addObject:nextstr2];
                    NSString *str=[message substringFromIndex:range3.location+1];
                    
                    [self getImageRange:str :array];
                }
                else
                {
                    return;
                }
            }
            
        }
        
    }
    else if((range2.length>0 && range1.length>0)|| (range4.length>0 && range3.length>0))
    {
        if (range2.location > range4.location)
        {
            [array addObject:[message substringToIndex:range4.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range4.location, range3.location+1-range4.location)]];
            NSString *str=[message substringFromIndex:range3.location+1];
            
            [self getImageRange:str :array];
            
        }
        else if (range2.location < range4.location)
        {
            [array addObject:[message substringToIndex:range2.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range2.location, range1.location+1-range2.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];

            [self getImageRange:str :array];
            
            
        }
    }
    
    else if (message != nil) {
        [array addObject:message];
    }
}

-(UIView *)assembleMessageAtIndex : (NSString *) message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = [NSArray arrayWithArray: array];
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    BOOL isAnyImage  = [self isContainAnyEmojiAndEmoticonInMsg: data];
    BOOL isAnyImage1  = NO;
    
    if (data)
    {
        
        if (fromself)
        {
            
            for (int i=0;i < [data count];i++) {
                NSString *str=[data objectAtIndex:i];
                
                if ([str hasPrefix: EmojiBEGIN_FLAG] && [str hasSuffix: EmojiEND_FLAG])
                {
                    
                    if (upX >= MAX_WIDTH_SELF)
                    {
                        upY = upY + KEmojiSizeHeight;
                        upX = 0;
                        X = MAX_WIDTH_SELF;
                        Y = upY;
                    }
                    NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                    UIImageView *aImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                    aImage.frame = CGRectMake(upX, upY - 5, KEmojiSizeWidth, KEmojiSizeHeight );
                    [returnView addSubview:aImage];
                    upX=KEmojiSizeWidth+upX;
                    if (X<MAX_WIDTH_SELF)
                    {
                        X = upX;
                    }
                }
                else if ([str hasPrefix: EmotionBEGIN_FLAG] && [str hasSuffix: EmotionEND_FLAG])
                {
                    if (upX >= MAX_WIDTH_SELF)
                    {
                        upY = upY + KEmotionSizeHeight + 10;
                        upX = 0;
                        X = MAX_WIDTH_SELF;
                        Y = upY;
                    }

                    NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                    UIImageView *aImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                    aImage.frame = CGRectMake(upX, upY+4, KEmotionSizeWidth, KEmotionSizeHeight );
                    [returnView addSubview:aImage];

                    upX=KEmotionSizeWidth+upX;
                    if (X < MAX_WIDTH_SELF) X = upX;
                    
                }
                
                else
                {
                    for (int j = 0; j < [str length]; j++) {
                        NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                        if (upX >= MAX_WIDTH_SELF)
                        {
                            isAnyImage1  = [self isMsgHasAnyEmojiAndEmoticon: str];
                            
                            upY = upY + kTextHeight;
                            if (isAnyImage1)
                            {
                                upY= upY + 20;
                                isAnyImage1 = NO;
                            }
                            upX = 0;
                            X = MAX_WIDTH_SELF;
                            Y =upY;
                        }
                        
                        CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                        
                        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY-5,size.width,size.height)];
                        if (isAnyImage == YES)
                        {
                            la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY + 5,size.width,size.height)];
                            
                        }
                        la.font = fon;
                        la.text = temp;
                        la.textColor = [UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:114.0/255.0 alpha:1];
                        la.backgroundColor = [UIColor clearColor];
                        [returnView addSubview:la];

                        upX=upX+ size.width;
                        if (X < MAX_WIDTH_SELF)
                        {
                            X = upX;
                        }
                    }
                }
            }
        }
        else
        {
            
            for (int i=0;i < [data count];i++) {
                NSString *str=[data objectAtIndex:i];

                if ([str hasPrefix: EmojiBEGIN_FLAG] && [str hasSuffix: EmojiEND_FLAG])
                {
                    
                    if (upX >= MAX_WIDTH_OTHER)
                    {
                        upY = upY + KEmojiSizeHeight;
                        upX = 0;
                        X = MAX_WIDTH_OTHER;
                        Y = upY;
                    }

                    NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                    UIImageView *aImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                    aImage.frame = CGRectMake(upX, upY - 5, KEmojiSizeWidth, KEmojiSizeHeight );
                    [returnView addSubview:aImage];

                    upX=KEmojiSizeWidth+upX;
                    if (X<MAX_WIDTH_OTHER)
                    {
                        X = upX;
                    }
                }
                else if ([str hasPrefix: EmotionBEGIN_FLAG] && [str hasSuffix: EmotionEND_FLAG])
                {
                    isAnyImage = YES;
                    
                    if (upX >= MAX_WIDTH_OTHER)
                    {
                        upY = upY + KEmotionSizeHeight + 10;
                        upX = 0;
                        X = MAX_WIDTH_OTHER;
                        Y = upY;
                    }

                    NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                    UIImageView *aImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                    aImage.frame = CGRectMake(upX, upY+4, KEmotionSizeWidth, KEmotionSizeHeight );
                    [returnView addSubview:aImage];

                    upX=KEmotionSizeWidth+upX;
                    if (X < MAX_WIDTH_OTHER) X = upX;
                    
                }
                
                else
                {
                    for (int j = 0; j < [str length]; j++) {
                        NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                        if (upX >= MAX_WIDTH_OTHER)
                        {
                            isAnyImage1  = [self isMsgHasAnyEmojiAndEmoticon: str];
                            
                            upY = upY + kTextHeight;
                            
                            if (isAnyImage1)
                            {
                                upY= upY + 20;
                                isAnyImage1 = NO;
                            }
                            upX = 0;
                            X = MAX_WIDTH_OTHER;
                            Y =upY;
                        }
                        
                        CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                        
                        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY-5,size.width,size.height)];
                        if (isAnyImage == YES)
                        {
                            la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY + 5,size.width,size.height)];
                            
                        }
                        la.font = fon;
                        la.text = temp;
                        la.textColor = [UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:114.0/255.0 alpha:1];
                        la.backgroundColor = [UIColor clearColor];
                        [returnView addSubview:la];

                        upX=upX+ size.width;
                        if (X < MAX_WIDTH_OTHER)
                        {
                            X = upX;
                        }
                    }
                }
            }
            
        }
        
    }
    
    if (isAnyImage)
    {
        returnView.frame = CGRectMake(15.0f,1.0f, X, Y + 20);
        
    }
    else
    {
        returnView.frame = CGRectMake(15.0f,1.0f, X, Y );
    }
     return returnView;
}
-(void)getImageRangeForNativEmotions:(NSString*)message : (NSMutableArray*)array
{
    NSRange range=[message rangeOfString: NativeEmojiBEGIN_FLAG];
    NSRange range1=[message rangeOfString: NativeEmojiEND_FLAG];
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+2-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+2];
            [self getImageRangeForNativEmotions:str :array];
        }
        else
        {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+2-range.location)];
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+2];
                [self getImageRangeForNativEmotions:str :array];
            }
            else
            {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

-(BOOL)isMsgHasAnyEmojiAndEmoticon:(NSString *)inMsg
{
    
    if (([inMsg hasPrefix: EmotionBEGIN_FLAG] && [inMsg hasSuffix: EmotionEND_FLAG]) ||
        ([inMsg hasPrefix: EmojiBEGIN_FLAG] && [inMsg hasSuffix: EmojiEND_FLAG])
        || ([inMsg hasPrefix: NativeEmojiBEGIN_FLAG] && [inMsg hasSuffix: NativeEmojiEND_FLAG]))
    {
        return  YES;
    }
    return NO;
}
-(BOOL)isContainAnyEmojiAndEmoticonInMsg:(NSArray *)inData
{
    for (int i=0;i < [inData count];i++)
    {
        NSString *inMsg=[inData objectAtIndex:i];
        
        if (([inMsg hasPrefix: EmotionBEGIN_FLAG] && [inMsg hasSuffix: EmotionEND_FLAG]) ||
            ([inMsg hasPrefix: EmojiBEGIN_FLAG] && [inMsg hasSuffix: EmojiEND_FLAG]))
        {
            return  YES;
        }
    }
    return NO;
}
-(UIImageView *)createStickerView :(NSString *)inMeg  :(BOOL)from
{
    
    UIImageView *returnView = nil;
    
    if ([inMeg hasPrefix: StickerBEGIN_FLAG] && [inMeg hasSuffix: StickerEND_FLAG])
    {
        NSString *imageName=[inMeg substringWithRange:NSMakeRange(2, inMeg.length - 3)];
        returnView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        if (from)
        {
            returnView.frame = CGRectMake(0, 0, KStickerSizeWidth, KStickerSizeHeight );
        }
        else
        {
            returnView.frame = CGRectMake(60, 0, KStickerSizeWidth, KStickerSizeHeight );
            
        }
        
    }
    return  returnView;
}

-(BOOL)isContainStickerInMsg:(NSString *)inMsg
{
    
    if (([inMsg hasPrefix: StickerBEGIN_FLAG] && [inMsg hasSuffix: StickerEND_FLAG]))
    {
        return  YES;
    }
    return NO;
}
-(NSString *)getMsgInProperFormat:(NSArray *)inData
{
    NSString *aMsg = nil;
    
    for (int i=0;i < [inData count];i++)
    {
        NSString *inMsg=[inData objectAtIndex:i];
        
        if (([inMsg hasPrefix: EmotionBEGIN_FLAG] && [inMsg hasSuffix: EmotionEND_FLAG]) ||
            ([inMsg hasPrefix: EmojiBEGIN_FLAG] && [inMsg hasSuffix: EmojiEND_FLAG]))
        {
        }
    }
    
    return  aMsg;
}
#pragma mark - end


- (IBAction)btnChatHistory:(id)sender {
    
    
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addAttributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%u",(unsigned int) arc4random()]];
    NSXMLElement *retrieve = [NSXMLElement elementWithName:@"retrieve" xmlns:@"http://www.xmpp.org/extensions/xep-0136.html#ns"];
    [retrieve addAttributeWithName:@"with" stringValue:[NSString stringWithFormat:@"%@",[[gCXMPPController.xmppStream myJID] full]]];
    [retrieve addAttributeWithName:@"start" stringValue:@"2013-12-05T08:19:48Z"];
    
    NSXMLElement *set = [NSXMLElement elementWithName:@"set" xmlns:@"http://jabber.org/protocol/rsm"];
    NSXMLElement *max = [NSXMLElement elementWithName:@"max"];
    [max setStringValue:@"100"];
    [set addChild:max];
    [retrieve addChild:set];
    [iq addChild:retrieve];
    [gCXMPPController.xmppStream sendElement:iq];
}

- (IBAction)btnFullUserImageViewClicked:(id)sender {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.navigationController.navigationBarHidden = NO;
    [self hideBothKeyBoard];
    self.isMediaOpened = YES;
    ShowFullProfileImageViewController *showFullImage =nil;
    showFullImage = [[ShowFullProfileImageViewController alloc] initWithNibName:nil bundle:nil];
    showFullImage.imgString =self.imageString;
    showFullImage.isComingFromChat = YES;
    [self.navigationController pushViewController:showFullImage animated:YES];
    
}


#pragma File


-(NSDictionary *)getMsgDicByIndexPath:(NSIndexPath*)inIndexPath
{
    return [messages objectAtIndex: inIndexPath.row];
}
-(NSDictionary *)getMsgDicByChatId:(NSString*)inChatId;
{
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"chatid==%@",inChatId];
    NSMutableArray * aArr = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate: aPredicate]];
    
    return [aArr lastObject];
}

-(BOOL )isAlreadyExistMsgByChatId:(NSString*)inChatId;
{
    BOOL toReturn = NO;
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"chatid==%@",inChatId];
    NSMutableArray * aArr = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate: aPredicate]];
    if (aArr && aArr.count >0)
    {
        toReturn = YES;
    }
    return  toReturn;
}


-(void)doDownloadFileByChatId :(NSString *)inChatId
{
    
    if ([Utils isInternetAvailable] == NO)
    {
        return;
    }
    
    
    NSDictionary *chatInfo = [self getMsgDicByChatId: inChatId];
    UIView * aView = [chatInfo objectForKey: @"view"];
    
    CustomUplaodingView *
    cstView = [[aView subviews] objectAtIndex: 1];
    
    if (cstView.eventType == eTypeDownloadCancel)
    {
        return;
    }
    
    
    NSString *fileServerPath = cstView.fileServerUrlStr;
    cstView.eventType = eTypeUpldDownLoading;
    cstView.currentState = eStateTypeDownloading;
    
    cstView.ProgressView.progress = 0.0;
    [cstView.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cstView.btnCancel.tag = eTypeUpldCancel;
    
    cstView.eventType = eTypeUpldDownLoading;
    cstView.btnStatus.hidden = YES;
    cstView.btnDownload.hidden = YES;
    
    self.isDownloading = YES;
    
     [self.downloadingStatusDic setObject:[NSNumber numberWithInt:eStateTypeDownloading] forKey: inChatId];
     
    cstView.chatId = inChatId;
    
    [cstView UpdateUIContents];
    
    //Set for background task
    UIApplication *app = [UIApplication sharedApplication];
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    NSString *mediaUrl = [Utils getMediaURL: fileServerPath];
    [[NetworkService sharedInstance] downloadFileAsynchronusByGet: mediaUrl dataToSend: nil header:NO andDelegate: self andChatId: inChatId];
    
}


-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    if([[inResponseDic objectForKey:@"status"]integerValue] == 0)
    {
        return;
    }
    NSString *aChatId = inReqIdentifier;
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"chatid==%@",aChatId];
    NSMutableArray * aFilteredArr = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate: aPredicate]];
    NSMutableDictionary * aDic = [aFilteredArr lastObject];
    if (aDic == nil || aDic.count == 0)
    {
        return;
    }
    UIView * aView = [aDic objectForKey: @"view"];
    CustomUplaodingView *
    cstView = [[aView subviews] objectAtIndex: 1];
    
    [cstView.mixedIndicator updateWithTotalBytes: 1 downloadedBytes: 1];

    NSString *mainFile = @"";
    
    
    if([[inResponseDic objectForKey:@"status"] isEqualToString:@"1"]){

        if([[inResponseDic objectForKey:@"file"]rangeOfString:kThumbUrlDelimeter].length >0)
        {
            NSArray *thumbArray = [[inResponseDic objectForKey:@"file"] componentsSeparatedByString:kThumbUrlDelimeter];
            mainFile = [NSString stringWithFormat:@"%@%@%@%@%@",[inResponseDic objectForKey:@"serverUrl"],[thumbArray objectAtIndex:0],kThumbUrlDelimeter,[inResponseDic objectForKey:@"serverUrl"],[thumbArray objectAtIndex:1]];
        }
        else
        {
            mainFile = [NSString stringWithFormat:@"%@%@",[inResponseDic objectForKey:@"serverUrl"],[inResponseDic objectForKey:@"file"]];
        }
        
        if (aDic)
        {
            
            int indexOfObj = [messages indexOfObject: aDic];
            [aDic setObject:@"uploaded" forKey:@"fileaction"];
            [messages replaceObjectAtIndex: indexOfObj withObject: aDic];
            
        }

        cstView.eventType = eTypeUpldUpLoaded;
        [cstView UpdateUIContents];
        
        NSDate *sendTimestampDate = [aDic valueForKey:@"sendTimestampDate"];
        
#pragma mark - XMPP MessageStatus
//        [[Database database] insertNewMessage:[NSDictionary dictionaryWithObjectsAndKeys:@"1",kIsMedia,@"",kMessage,[NSString stringWithFormat:@"%f",[sendTimestampDate timeIntervalSince1970]],kSendtimestamp,chatWithUser,kChatWithUser,aChatId,kChatId,mainFile,kAttachment,[aDic objectForKey:@"filelocalpath"],kFilelocalpath,cstView.fileSize,kFileSize,[aDic objectForKey:@"fileName"],kFileName,@"uploaded",kFileaction,[aDic objectForKey:@"media"],kMedia,[NSString stringWithFormat:@"%d",cstView.mediaOrientation],KMediaOrientation,[aDic objectForKey:KThumbBase64String],KThumbBase64String, nil] from:@"chat"];
#pragma end
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"id" stringValue:aChatId];
        [message addAttributeWithName:@"to" stringValue:chatWithUser];
        
        
        [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1]];
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        NSXMLElement *media = [NSXMLElement elementWithName:@"media"];
        //27-3-14
        
        NSXMLElement *mediaOrientation = [NSXMLElement elementWithName:KMediaOrientation];
        [mediaOrientation setStringValue:[NSString stringWithFormat:@"%d",cstView.mediaOrientation]];
        
        //end
        
        //nehaa thumbnail
        NSXMLElement *thumbBase64String = [NSXMLElement elementWithName:KThumbBase64String];
        [thumbBase64String setStringValue:[aDic objectForKey:KThumbBase64String]];
        [message addChild:thumbBase64String];
        //end thumbnail
        
        
        NSXMLElement *filelocalpath = [NSXMLElement elementWithName:@"filelocalpath"];
        NSXMLElement *fileaction = [NSXMLElement elementWithName:@"fileaction"];
        NSXMLElement *fileSize = [NSXMLElement elementWithName:@"fileSize"];
        NSXMLElement *fileName = [NSXMLElement elementWithName:@"fileName"];
        
        
        [media setStringValue:[aDic objectForKey:@"media"]];
        NSXMLElement *request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [message addAttributeWithName:@"attachment" stringValue:mainFile];
        [fileaction setStringValue:@"uploaded"];
        
        
        //9-5-14
        NSXMLElement *sendTimestampDateTag = [NSXMLElement elementWithName:@"sendTimestampDate"];
        [sendTimestampDateTag setStringValue: [NSString stringWithFormat:@"%f",[sendTimestampDate timeIntervalSince1970]]];
        [message addChild:sendTimestampDateTag];
        
        [aDic setObject:@"uploaded" forKey:@"fileaction"];
        
         [filelocalpath setStringValue:[aDic objectForKey:@"filelocalpath"]];
        NewPhoto *photo = [[NewPhoto alloc] init];
        photo.originalUrl = [aDic objectForKey:@"filelocalpath"];
        [arrPhotos addObject:photo];
        
        [aDic setObject:mainFile forKey:@"attachment"];
        
         [fileSize setStringValue:cstView.fileSize];
        [fileName setStringValue:[aDic objectForKey:@"fileName"]];
        
        [message addChild:filelocalpath];
        [message addChild:fileaction];
        [message addChild:fileSize];
        [message addChild:fileName];
        
        
        [body addChild:media];
         [body addChild:mediaOrientation];

        NSXMLElement *fullName = [NSXMLElement elementWithName:@"fullName" stringValue:[[NSUserDefaults standardUserDefaults] valueForKey:kFullname]];
        [message addChild:fullName];
        
        NSXMLElement *chatFlow = [NSXMLElement elementWithName:@"chatFlow" stringValue:@"anonymous"];
        [message addChild:chatFlow];
        
        NSXMLElement *userId = [NSXMLElement elementWithName:@"userId"];
        [userId setStringValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kUserId]]];
        [message addChild:userId];
        NSXMLElement *imageURL = [NSXMLElement elementWithName:@"imgURL"];
        [imageURL setStringValue:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImage_url_100],[[NSUserDefaults standardUserDefaults] valueForKey:kProfileImage]]];
        [message addChild:imageURL];

         [message addChild:body];
        
        [message addChild:request];
        
        [self.xmppStream sendElement:message];
        
        if([[aDic objectForKey:@"media"]isEqualToString:@"image"])
        {
            [self updateLastMessage:@"Image" withDate:[NSDate date]];
        }
        if([[aDic objectForKey:@"media"]isEqualToString:@"video"])
        {
            [self updateLastMessage:@"Video" withDate:[NSDate date]];
        }
        if([[aDic objectForKey:@"media"]isEqualToString:@"audio"])
        {
            [self updateLastMessage:@"🔊 Voice message" withDate:[NSDate date]];
        }
        if(self.isUnavailable == YES)
        {
//            NSString *msg= nil;
//            if([[aDic objectForKey:@"media"] rangeOfString:@"image"].length>0)
//            {
//                msg = @"sent you an image";
//                msg = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:  kFullName],msg];
//                msg = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:kFullName],msg];
//
//            }
//            else if([[aDic objectForKey:@"media"] rangeOfString:@"video"].length>0)
//            {
//                msg = @"sent you an video";
//                msg = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:kFullName],msg];
//            }
//            else if([[aDic objectForKey:@"media"] rangeOfString:@"location"].length>0)
//            {
//                msg = @"sent you an location";
//                msg = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:kFullName],msg];
//            }
//            
//            else
//            {
//                msg = @"sent you a voice message";
//                msg = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:kFullName],msg];
//            }
//            //             = [NSString stringWithFormat:@"%@: %@",[[NSUserDefaults standardUserDefaults] objectForKey:kfullName],[aDic objectForKey:@"media"]];
//            NetworkService *obj = [NetworkService sharedInstance];
//            NSDictionary *aDict=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"userId",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"],@"sessionToken",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,@"sendXmppPushNotification",@"option",kDevice,kDeviceType,msg,@"message",@"",@"toUserId",[[NSUserDefaults standardUserDefaults] valueForKey:kchatUserName],kchatUserName,[[NSUserDefaults standardUserDefaults] objectForKey:kFullName],kFullName,nil];
//            [obj sendAsynchRequestByPostToServer:@"pushnotification" dataToSend:aDict delegate:nil contentType:eAppJsonType andReqParaType:eJson header:NO];
        }
        
        self.isAnyMediaUploaded = YES;
        if([[aDic objectForKey:@"media"] isEqualToString:@"audio"])
        {
            UIButton *btn = [cstView.subviews objectAtIndex:0];
            btn.enabled = NO;
            UIImageView *imgPlay = [cstView.subviews objectAtIndex:4];
            imgPlay.hidden = NO;
            UIProgressView *progress = [cstView.subviews objectAtIndex:5];
            progress.hidden = NO;
            NSString* fullPath = @"";
            fullPath =  [SHFileUtil getFullPathFromPath:[NSString stringWithFormat:@"ChatAudios/%@",[aDic objectForKey:@"filelocalpath"]]] ;
            NSURL *url = [NSURL fileURLWithPath:fullPath];
            NSError *error=nil;
            if(self.player)
            {
                self.player = nil;
            }
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            [self.player prepareToPlay];
            UILabel *lbl = [cstView.subviews objectAtIndex:6];
            //            NSLog(@"%f",player.duration);
            int minutes = (int)self.player.duration / 60;
            int seconds = (int)self.player.duration % 60;
            //            NSLog(@"%@",[NSString stringWithFormat:@"%d:%02d",minutes,seconds]);
            lbl.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
            //            lbl.text = [NSString stringWithFormat:@"%f",player.duration];
            [self.player stop];
            self.player = nil;
        }
        
        //4-2-14
        //        NSNumber *aStatusValue =  [self.uploadingStatusDic objectForKey: aChatId];
        int aStatusValue =  [[self.uploadingStatusDic objectForKey: aChatId] integerValue];
        
        
        if (aStatusValue == eStateTypeuploading)
        {
            [self.uploadingStatusDic removeObjectForKey: aChatId];
            
        }
        //end
        
        cstView.mixedIndicator.hidden=YES;
    }
    else
    {
        
        NSLog(@"*** File Not uploaded successfully ***");
        
        //29-1-14 re uploading if amazon server create error
        
        /*
         [SHFileUtil deleteItemAtPath: [aDic objectForKey:@"filelocalpath"]];
         
         //22-1-14 thumbnail
         if ([[aDic objectForKey:@"media"] isEqualToString: @"image"])
         {
         [SHFileUtil deleteItemAtPath: [Utils getThumbNailImagePathByItsImagePath:[aDic objectForKey:@"filelocalpath"]]];
         }
         //end
         
         
         int index = [messages indexOfObject: aDic];
         [messages removeObjectAtIndex: index];
         [self.tView reloadData];
         */
        
        //        NSNumber *aNumber = [ self.uploadingStatusDic objectForKey: aChatId]
        
        int aStateValue = [[ self.uploadingStatusDic objectForKey: aChatId] integerValue]
        ;
        
        if (aStateValue ==  eStateTypeuploading)
        {
            int aStatusValue =  [[self.uploadingStatusDic objectForKey: aChatId] integerValue];
            
            
            if (aStatusValue == eStateTypeuploading)
            {
                [self.uploadingStatusDic removeObjectForKey: aChatId];
                
            }
            
            NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"chatid==%@",aChatId];
            NSMutableArray * aArr = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate: aPredicate]];
            NSMutableDictionary * aDic = [aArr lastObject];
            int indexOfObj = [messages indexOfObject: aDic];
            
            UIView *ChatView = [aDic objectForKey: @"view"];
            CustomUplaodingView *aCstView = (CustomUplaodingView *)[[ChatView subviews] objectAtIndex: 1];
            //    aCstView.currentState = eStateTypeNone;
            aCstView.eventType = eTypeUpldUpLoad;
            
            aCstView.ProgressView.progress = 0.0;
            aCstView.downloadedFileSize = 0.0;
            //20-3-14
            [aCstView.mixedIndicator updateWithTotalBytes: 1.0 downloadedBytes:0.0];
            //end
            [aCstView.btnStatus setTitle:@"Try again!" forState:UIControlStateNormal];
            [aCstView.btnDownload setBackgroundImage:[UIImage imageNamed:@"iconUpload"] forState:UIControlStateNormal];
            
            [aDic setObject:@"uploading" forKey:@"fileaction"];
            
            [aCstView UpdateUIContents];
            [messages replaceObjectAtIndex: indexOfObj withObject: aDic];
            //7-1-14 not Responde Canceling
            [self updateMsgListViewIfNeededByTotalMesg: messages];
            //end
            if([[aDic objectForKey:@"media"] isEqualToString:@"audio"])
            {
                UIButton *btn = [cstView.subviews objectAtIndex:0];
                btn.enabled = YES;
                UIImageView *imgPlay = [cstView.subviews objectAtIndex:4];
                imgPlay.hidden = YES;
                UIProgressView *progress = [cstView.subviews objectAtIndex:5];
                progress.hidden = YES;
                
            }
            
            [self.tView reloadData];
        }
        
        //        if (aStateValue ==  eStateTypeuploading)
        //        {
        //            NSDictionary *aDataDic = [self getMsgDicByChatId: inReqIdentifier];
        //            UIView *aChatView = [aDataDic objectForKey:@"view"];
        //            CustomUplaodingView *
        //            cstView = [[aChatView subviews] objectAtIndex: 1];
        //
        //            cstView.eventType = eTypeUpldUpLoad;
        //            cstView.currentState = eStateTypeuploading;
        //            //            [self.uploadingStatusDic setObject:[NSNumber numberWithBool: YES] forKey: aChatId];
        //            [self.uploadingStatusDic setObject:[NSNumber numberWithInt: eStateTypeuploading] forKey: aChatId];
        //
        //            [cstView.btnCancel setTitle:@"Upload" forState:UIControlStateNormal];
        //           cstView.btnCancel.tag = eTypeUpldUpLoad;
        //            [cstView UpdateUIContents];
        //            //11-2-14
        //            cstView.btnCancel.hidden = NO;
        //            //end
        //
        //        }
        
        //end
        
        
        
        
    }
    //29-1-14 Bg Task
    UIApplication *app = [UIApplication sharedApplication];
    
    if (bgTask != UIBackgroundTaskInvalid) {
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
    //end
    
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    NSLog(@"*** Request Url: %@ and Error : %@ ***",inReqIdentifier,[inError description]);
    
    //4-2-14
    
    NSString *aChatId = [NSString stringWithFormat:@"%@",inReqIdentifier];
    
    //reuest timeout
    if([inError code] == NSURLErrorTimedOut)
    {
        NSLog(@"NSURLErrorTimedOut");
        
        
        //        NSNumber *aNumber = [ self.uploadingStatusDic objectForKey: aChatId]
        
        
        int aStateValue = [[ self.uploadingStatusDic objectForKey: aChatId] integerValue]
        ;
        if (aStateValue == eStateTypeuploading)
        {
            NSDictionary *aDataDic = [self getMsgDicByChatId: inReqIdentifier];
            UIView *aChatView = [aDataDic objectForKey:@"view"];
            CustomUplaodingView *
            cstView = [[aChatView subviews] objectAtIndex: 1];
            
            cstView.eventType = eTypeUpldUpLoad;
            cstView.currentState = eStateTypeuploading;
            
            //  [self.uploadingStatusDic setObject:[NSNumber numberWithBool: YES] forKey: aChatId];
            
            [self.uploadingStatusDic setObject:[NSNumber numberWithInt: eStateTypePending] forKey: aChatId];
            
            [cstView.btnCancel setTitle:@"Upload" forState:UIControlStateNormal];
            //15-3-14
            [cstView.lblState setText:@"Upload"];
            //end
            cstView.btnCancel.tag = eTypeUpldUpLoad;
            //20-3-14
            [cstView.btnStatus setTitle:@"Try again!" forState:UIControlStateNormal];
            cstView.eventType = eTypeUpldUpLoad;
            [cstView.mixedIndicator updateWithTotalBytes: 1.0 downloadedBytes:0.0];
            //end
            //21-3-14 sh1
            [cstView.btnDownload setBackgroundImage:[UIImage imageNamed:@"iconUpload"] forState:UIControlStateNormal];
            //end
            
            
            [cstView UpdateUIContents];
            //            return;
            
        }
        
        //        aNumber = [ self.downloadingStatusDic objectForKey: aChatId];
        aStateValue = [[ self.downloadingStatusDic objectForKey: aChatId] integerValue];
        
        if (aStateValue == eStateTypeDownloading)
        {
            NSDictionary *aDataDic = [self getMsgDicByChatId: inReqIdentifier];
            UIView *aChatView = [aDataDic objectForKey:@"view"];
            CustomUplaodingView *
            cstView = [[aChatView subviews] objectAtIndex: 1];
            
            cstView.eventType = eTypeUpldDownLoad;
            cstView.currentState = eStateTypeDownloading;
            
            //            [self.downloadingStatusDic setObject:[NSNumber numberWithBool: YES] forKey: aChatId];
            [self.downloadingStatusDic setObject:[NSNumber numberWithInt: eStateTypePending] forKey: aChatId];
            
            
            [cstView.btnCancel setTitle:@"Download" forState:UIControlStateNormal];
            //15-3-14
            [cstView.lblState setText:@"Download"];
            //end
            
            cstView.btnCancel.tag = eTypeUpldDownLoad;
            //20-3-14
            [cstView.btnStatus setTitle:@"Try again!" forState:UIControlStateNormal];
            cstView.eventType = eTypeUpldDownLoad;
            [cstView.mixedIndicator updateWithTotalBytes: 1.0 downloadedBytes:0.0];
            //end
            
            
            [cstView UpdateUIContents];
            //            return;
            
        }
        
    }
    //connection appears offline
    else //if([inError code] == kCFURLErrorNotConnectedToInternet)
    {
        NSLog(@"kCFURLErrorNotConnectedToInternet");
        
        
        //        NSNumber *aNumber = [ self.uploadingStatusDic objectForKey: aChatId]
        int aStateValue = [[ self.uploadingStatusDic objectForKey: aChatId] integerValue];
        
        if (aStateValue == eStateTypeuploading)
        {
            NSDictionary *aDataDic = [self getMsgDicByChatId: inReqIdentifier];
            UIView *aChatView = [aDataDic objectForKey:@"view"];
            CustomUplaodingView *
            cstView = [[aChatView subviews] objectAtIndex: 1];
            
            cstView.eventType = eTypeUpldError;
            cstView.currentState = eStateTypeuploading;
            //            [self.uploadingStatusDic setObject:[NSNumber numberWithBool: YES] forKey: aChatId];
            [self.uploadingStatusDic setObject:[NSNumber numberWithInt: eStateTypePending] forKey: aChatId];
            
            [cstView.btnCancel setTitle:@"No Network" forState:UIControlStateNormal];
            //15-3-14
            [cstView.lblState setText:@"No Network"];
            //end
            
            
            cstView.btnCancel.tag = eTypeUpldError;
            
            //20-3-14
            [cstView.btnStatus setTitle:@"Try again!" forState:UIControlStateNormal];
            cstView.eventType = eTypeUpldUpLoad;
            [cstView.mixedIndicator updateWithTotalBytes: 1.0 downloadedBytes:0.0];
            //end
            
            //21-3-14 sh1
            [cstView.btnDownload setBackgroundImage:[UIImage imageNamed:@"iconUpload"] forState:UIControlStateNormal];
            //end
            
            
            [cstView UpdateUIContents];
            //            return;
            
        }
        
        //        aNumber = [ self.downloadingStatusDic objectForKey: aChatId];
        aStateValue = [[ self.downloadingStatusDic objectForKey: aChatId] integerValue];
        
        if (aStateValue == eStateTypeDownloading)
        {
            NSDictionary *aDataDic = [self getMsgDicByChatId: inReqIdentifier];
            UIView *aChatView = [aDataDic objectForKey:@"view"];
            CustomUplaodingView *
            cstView = [[aChatView subviews] objectAtIndex: 1];
            
            cstView.eventType = eTypeDownloadingError;
            cstView.currentState = eStateTypeDownloading;
            //            [self.downloadingStatusDic setObject:[NSNumber numberWithBool: YES] forKey: aChatId];
            [self.downloadingStatusDic setObject:[NSNumber numberWithInt: eStateTypePending] forKey: aChatId];
            
            [cstView.btnCancel setTitle:@"No Network" forState:UIControlStateNormal];
            //15-3-14
            [cstView.lblState setText:@"No Network"];
            //end
            
            
            cstView.btnCancel.tag = eTypeDownloadingError;
            
            //20-3-14
            [cstView.btnStatus setTitle:@"Try again!" forState:UIControlStateNormal];
            cstView.eventType = eTypeUpldDownLoad;
            [cstView.mixedIndicator updateWithTotalBytes: 1.0 downloadedBytes:0.0];
            //end
            
            
            [cstView UpdateUIContents];
            //            return;
            
        }
        //12-2-14
        if([Utils isInternetAvailable])
        {
            
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"name_id"])
            {
                [self performSelector:@selector(doUploadPendingWhenNetworkAvailable) withObject: nil afterDelay:2.0 ];
                [self performSelector:@selector(doDownloadPendingWhenNetworkAvailable) withObject: nil afterDelay:2.0 ];
                //                [self doUploadPendingWhenNetworkAvailable];
                //                [self doDownloadPendingWhenNetworkAvailable];
            }
        }
    }
    
    
    //End Back ground task
    UIApplication *app = [UIApplication sharedApplication];
    
    if (bgTask != UIBackgroundTaskInvalid) {
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
    //end
    //    [Utils showAlertView:LocalizedString(@"MEKS",nil) message:LocalizedString(@"Unable to get details. Please check your internet connection.",nil) delegate:nil cancelButtonTitle:LocalizedString(@"OK",nil) otherButtonTitles:nil];
    
    
}

-(void)fileUploadingResponseHandler:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
                  totalBytesWritten:(NSInteger)totalBytesWritten
          totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite andRequestIdentifier:(NSString *)inRequestIdentifier
{
    SHBaseRequest *aCurrRequest = (SHBaseRequest *)connection.currentRequest;
    
    
    
    double sentBytes = totalBytesWritten;
    double totalBytes = totalBytesExpectedToWrite;
    double uplpadedBytes = (sentBytes/totalBytes);
    
    NSString *aChatId = inRequestIdentifier;
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"chatid==%@",aChatId];
    NSMutableArray * aFilteredArr = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate: aPredicate]];
    NSMutableDictionary * aDic = [aFilteredArr lastObject];
    
    UIView * aView = [aDic objectForKey: @"view"];
    
    CustomUplaodingView *
    cstView = [[aView subviews] objectAtIndex: 1];
    
    [cstView UpdateProgressBarWithValue: uplpadedBytes];
    
    //15-3-14
    [cstView.mixedIndicator updateWithTotalBytes: totalBytes downloadedBytes: sentBytes];
    //end
    
    if (totalBytesWritten == totalBytesExpectedToWrite)
    {
        cstView.fileSize = [NSString stringWithFormat:@"%f",totalBytes];
        if (cstView.mediaType == eMediaTypeImage)
        {
            cstView.eventType = eTypeUpldViewing;
            
            //            [cstView UpdateUIContents];
            
        }
        else if (cstView.mediaType == eMediaTypeVideo)
        {
            cstView.eventType = eTypeUpldPlaying;
            
        }
        else if (cstView.mediaType == eMediaTypeAudeo)
        {
            cstView.eventType = eTypeUpldPlaying;
            UIButton *btn = [cstView.subviews objectAtIndex:0];
            btn.enabled = NO;
            
        }
        [cstView setNeedsDisplay];
        
    }
    //4-2-14
    //    NSNumber *aStatusValue =  [self.uploadingStatusDic objectForKey: aChatId];
    int aStatusValue =  [[self.uploadingStatusDic objectForKey: aChatId] integerValue];
    
    if (aStatusValue == eStateTypeCancel)
    {
        //21-3-14 sh2
        [cstView.mixedIndicator updateWithTotalBytes: 1 downloadedBytes: 0.0];
        //end
        
        
        aCurrRequest.IsReqStarted = NO;
        [self.uploadingStatusDic removeObjectForKey: aChatId];
        //24-3-14 media
        [connection cancel];
        cstView.eventType = eTypeUpldUpLoad;
        [cstView UpdateUIContents];
        
        //end
        
    }
    //end
    //   NSLog( @"%d bytes out of %d sent.", totalBytesWritten, totalBytesExpectedToWrite);
}


-(void)fileDownLoadingResponseHandler:(NSURLConnection *)inConnection downloadedByte:(double)inBytes andRequestIdentifier:(NSString *)inReqIdentifier
{
    SHBaseRequest *aCurrRequest = (SHBaseRequest *)inConnection.currentRequest;
    
    
    NSString *aChatId = inReqIdentifier;
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"chatid==%@",aChatId];
    NSMutableArray * aFilteredArr = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate: aPredicate]];
    NSMutableDictionary * aDic = [aFilteredArr lastObject];
    
    UIView * aView = [aDic objectForKey: @"view"];
    
    CustomUplaodingView *
    cstView = [[aView subviews] objectAtIndex: 1];
    double filesize = [cstView.fileSize doubleValue];
    
    cstView.downloadedFileSize = cstView.downloadedFileSize + inBytes;
    
    [cstView UpdateProgressBarWithValue: cstView.downloadedFileSize/filesize];
    //15-3-14
    [cstView.mixedIndicator updateWithTotalBytes: filesize downloadedBytes: cstView.downloadedFileSize];
    //end
    
    
    
    int indexOfObj = [messages indexOfObject: aDic];
    [aDic setObject:@"downloading" forKey:@"fileaction"];
    
    [messages replaceObjectAtIndex: indexOfObj withObject: aDic];
    
    //4-2-14
    int aStatusValue =  [[self.downloadingStatusDic objectForKey: aChatId] integerValue];
    
    if (aStatusValue == eStateTypeCancel)
    {
        aCurrRequest.IsReqStarted = NO;
        //        [self cancelDownloading: aChatId];
        self.isDownloading = YES;
        [self.downloadingStatusDic removeObjectForKey: aChatId];
        //24-3-14 media
        [inConnection cancel];
        cstView.eventType = eTypeUpldDownLoad;
        [cstView.mixedIndicator updateWithTotalBytes: 1.0 downloadedBytes:0.0];
        [cstView UpdateUIContents];
        
        //end
    }
    //end
    
    //    NSLog( @"file DownLoad %f out of  = %f",cstView.downloadedFileSize,filesize);
}


-(void)fileDownLoadingDidFinished:(NSURLConnection *)inConnection downloadedByte:(NSData *)inData andRequestIdentifier:(NSString *)inReqIdentifier
{
    //7-1-14
    self.isDownloading = NO;
    //end
    
    NSString *aChatId = inReqIdentifier;
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"chatid==%@",aChatId];
    NSMutableArray * aFilteredArr = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate: aPredicate]];
    NSMutableDictionary * aDic = [aFilteredArr lastObject];
    
    NSString* mediaTypeStr = [aDic objectForKey:@"media"];
    MediaType enMediaType = eMediaTypeNone;
    
    NSString *localUrl = [NSString stringWithFormat:@"%@",inConnection.currentRequest.URL] ;
    
    localUrl = [localUrl stringByReplacingOccurrencesOfString:@"/" withString:@""];
    localUrl = [localUrl stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *filelocalpath;
    if ([mediaTypeStr isEqualToString:@"image"])
    {
        filelocalpath = [NSString stringWithFormat:@"ChatImages/%@",localUrl];
        enMediaType = eMediaTypeImage;
    }
    else if ([mediaTypeStr isEqualToString:@"video"])
    {
        filelocalpath = [NSString stringWithFormat:@"ChatVideoes/%@",localUrl];
        enMediaType = eMediaTypeVideo;
        
    }
    else if ([mediaTypeStr isEqualToString:@"audio"])
    {
        UIView * aView = [aDic objectForKey: @"view"];
        CustomUplaodingView *
        cstView = [[aView subviews] objectAtIndex: 1];
        UIButton *btn = [cstView.subviews objectAtIndex:0];
        btn.enabled = NO;
        UIImageView *imgPlay = [cstView.subviews objectAtIndex:4];
        imgPlay.hidden = NO;
        UIProgressView *progress = [cstView.subviews objectAtIndex:5];
        progress.hidden = NO;
        filelocalpath = [NSString stringWithFormat:@"ChatAudios/%@",localUrl];
        enMediaType = eMediaTypeAudeo;
        
    }
    
    if (enMediaType == eMediaTypeImage)
    {
        //22-1-14 thumbnail
        
        //save image to app Cache.
        
        UIImage *aOrignalImage = [UIImage imageWithData: inData];
        
        UIImage *aThumbNailImage = [Utils resizeImage: aOrignalImage width: 100 height:100];
        
        NSData *thumbnailImageData = UIImageJPEGRepresentation(aThumbNailImage, 0.5);
        
        //thumbnail Image
        NSString *thumbFilePath = [NSString stringWithFormat:@"%@",[Utils getThumbNailImagePathByItsImagePath: filelocalpath]];
        
        [SHFileUtil writeFileInCache: thumbnailImageData toPartialPath: thumbFilePath];
        
        //orignal image
        
        [SHFileUtil writeFileInCache: inData toPartialPath: filelocalpath];
        
        //23-1-14 issue 300/2
        //save image to Photo Album
//        if([[dictSettings objectForKey:kCHAT_SETTINGS_SAVE_INCOMING_MEDIA] integerValue]==1)
//        {
            if([mediaTypeStr isEqualToString:@"image"]||[mediaTypeStr isEqualToString:@"video"])
            {
                UIImage *image = [UIImage imageWithData: inData];
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
//        }
        
        //end
        
    }
    else
    {
        //orignal image
        [SHFileUtil writeFileInCache: inData toPartialPath: filelocalpath];
        
        //save to video library
        if (enMediaType == eMediaTypeVideo)
        {
            NSString *fullPath = [SHFileUtil getFullPathFromPath: filelocalpath];
//            if([[NSUserDefaults standardUserDefaults]boolForKey:kAutoSavingMedia]==YES)
//            {
//                
//                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(fullPath))
//                {
//                    UISaveVideoAtPathToSavedPhotosAlbum(fullPath, nil, nil, nil);
//                }
//            }
        }
        if(enMediaType == eMediaTypeAudeo)
        {
            UIView * aView = [aDic objectForKey: @"view"];
            CustomUplaodingView *
            cstView = [[aView subviews] objectAtIndex: 1];
            NSString* fullPath = @"";
            fullPath =  [SHFileUtil getFullPathFromPath:filelocalpath] ;
            NSURL *url = [NSURL fileURLWithPath:fullPath];
            NSError *error=nil;
            if(self.player)
            {
                self.player = nil;
            }
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            [self.player prepareToPlay];
            UILabel *lbl = [cstView.subviews objectAtIndex:6];
            int minutes = (int)self.player.duration / 60;
            int seconds = (int)self.player.duration % 60;
            lbl.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
            [self.player stop];
            self.player = nil;
            
        }
        
    }
    
    //    //save image to Photo Album
    
    int indexOfObj = [messages indexOfObject: aDic];
    [aDic setObject:@"downloaded" forKey:@"fileaction"];
    [aDic setObject:filelocalpath forKey:@"filelocalpath"];
    
    
    [messages replaceObjectAtIndex: indexOfObj withObject: aDic];
    
    UIView * aView = [aDic objectForKey: @"view"];
    
    CustomUplaodingView *
    cstView = [[aView subviews] objectAtIndex: 1];
    //15-3-14
    [cstView.mixedIndicator updateWithTotalBytes: 1 downloadedBytes:1];
    //end
    
    
    switch (enMediaType)
    {
        case eMediaTypeNone:
            
            break;
        case eMediaTypeImage:
        {
            //22-1-14 thumbnail
            cstView.fileLocalUrlStr =  filelocalpath;
            NewPhoto *photo = [[NewPhoto alloc]init];
            photo.originalUrl = filelocalpath;
            [arrPhotos addObject:photo];
        }
            //end
            break;
        case eMediaTypeVideo:
            
            cstView.downloadedImage = nil;
            cstView.fileLocalUrlStr =  filelocalpath;
            
            break;
        case eMediaTypeAudeo:
            
            cstView.downloadedImage = nil;

            cstView.fileLocalUrlStr =  filelocalpath;
            
            break;
            
            
        default:
            break;
    }
    
    cstView.eventType = eTypeUpldDownLoaded;
    cstView.mediaType = enMediaType;
    [cstView setNeedsDisplay];
    [cstView UpdateUIContents];
    
    
    
    NSDictionary * updationDic = [NSDictionary dictionaryWithObjectsAndKeys:inReqIdentifier,@"chatid",@"downloaded",@"fileaction",filelocalpath,@"filelocalpath", nil];
    NSNotificationCenter * aMsgCenter = [NSNotificationCenter defaultCenter];
    NSNotification * msg =	[NSNotification notificationWithName: @"fileaction" object: updationDic userInfo: nil];
    [aMsgCenter postNotification: msg];
    
    
    //7-1-14 not Responde Canceling
    
    NSNumber *aStatusValue =  [self.downloadingStatusDic objectForKey: aChatId];
    
    if (aStatusValue)
    {
        [self.downloadingStatusDic removeObjectForKey: aChatId];
        
    }
    //end
    
    //29-1-14 Bg Task
    //End Back ground task
    UIApplication *app = [UIApplication sharedApplication];
    
    if (bgTask != UIBackgroundTaskInvalid) {
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
    
    NSLog( @"fileDownLoadingDidFinished Data = %lu",(unsigned long)inData.length);
    
}


#pragma FileAction Delegate
-(void)UploadingFileEventHandler :(id)inHandlerClass

{
    CustomUplaodingView *aCstView = (CustomUplaodingView *)inHandlerClass;
    
    switch (aCstView.eventType)
    {
            
        case eTypeUpldNone:
            
            break;
        case eTypeUpldCancel:
            
            [self doCancelUploadindOrDownloading: aCstView];
            
            break;
            //13-1-14
        case eTypeUpldError:
            
            //10-2-14
            [self reuploadingMediaByMsgDiv:[self getMsgDicByChatId: aCstView.chatId]];
            break;
            //end
            //14-1-14
        case eTypeUpldUpLoad:
            //20-3-14
            aCstView.eventType =eTypeUpldUpLoading;
            
            [self reuploadingMediaByMsgDiv:[self getMsgDicByChatId: aCstView.chatId]];
            break;
            //end
        case eTypeUpldUpLoading:
            //15-3-14
            [self doCancelUploadindOrDownloading: aCstView];
            //end
            
            break;
        case eTypeUpldUpLoaded:
            //15-3-14
            if (aCstView.mediaType == eMediaTypeImage)
            {
                [self doViewImageBYFileLocalPath: aCstView.fileLocalUrlStr];
                
            }
            else if (aCstView.mediaType == eMediaTypeLocation)
            {
                //do show mamview
                [self doShowSharedLocation:aCstView.Location];
                
            }
            else
            {
                [self doPlayVideoByFileLocalPath: aCstView.fileLocalUrlStr];
                
            }
            //end
            
            break;
            
        case eTypeUpldDownLoad:
            [self doDownloadFileByChatId: aCstView.chatId];
            aCstView.eventType = eTypeUpldDownLoading;
            //end
            break;
        case eTypeUpldDownLoaded:
            //15-3-14
            if (aCstView.mediaType == eMediaTypeImage)
            {
                [self doViewImageBYFileLocalPath: aCstView.fileLocalUrlStr];
                
            }
            else if (aCstView.mediaType == eMediaTypeLocation)
            {
                //do show lacation on map
                [self doShowSharedLocation:aCstView.Location];
            }
            
            else
            {
                [self doPlayVideoByFileLocalPath: aCstView.fileLocalUrlStr];
                
            }
            //end
            
            break;
            //15-3-14
        case eTypeUpldDownLoading:
            [self doCancelUploadindOrDownloading: aCstView];
            //24-3-14 media
            //            aCstView.eventType =eTypeUpldDownLoad;
            //end
            
            //            [self doDownloadFileByChatId: aCstView.chatId];
            
            break;
            //end
            
            
            
        case eTypeUpldViewing:
            
            [self doViewImageBYFileLocalPath: aCstView.fileLocalUrlStr];
            
            break;
        case eTypeUpldPlaying:
            [self doPlayVideoByFileLocalPath: aCstView.fileLocalUrlStr];
            
            break;
        default:
            break;
    }
    
    
}

-(void)doViewImageBYFileLocalPath:(NSString *)inFileLocalPath
{
    //7-1-14
    self.isMediaOpened = YES;
    //end
    [self hideBothKeyBoard];
    
    
    NSLog(@"%@",inFileLocalPath);
    
    [self getDatabaseImages];
    
    ShowLargePhotoViewController *showLargeImageView;
    if ([Utils isIPhone5]) {
        showLargeImageView = [[ShowLargePhotoViewController alloc] initWithNibName:@"ShowLargePhotoViewController" bundle:nil];
    }else{
        showLargeImageView = [[ShowLargePhotoViewController alloc] initWithNibName:@"ShowLargePhotoViewController_iPhone4" bundle:nil];
    }
    showLargeImageView.hidesBottomBarWhenPushed=YES;
    
    showLargeImageView.arrayImages = [NSArray arrayWithArray:arrPhotos];
    [AppManager sharedManager].arrImages=[NSMutableArray arrayWithArray:arrPhotos];
    showLargeImageView.strTotalPhotoCount=[NSString stringWithFormat:@"%i",arrPhotos.count];
    
    //    NSInteger index = 0;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"originalUrl == %@",inFileLocalPath];
    NSArray *filteredArr =[arrPhotos filteredArrayUsingPredicate:predicate];
    if (filteredArr.count > 0)
    {
        NewPhoto *photo = [filteredArr objectAtIndex:0];
        showLargeImageView.intArrayIndex = [arrPhotos indexOfObject:photo];
        
        [showLargeImageView setInitializePageViewController];
        [self.navigationController pushViewController:showLargeImageView animated:YES];
        
    }
}

-(void)doPlayVideoByFileLocalPath:(NSString *)inFileLocalPath
{
    if([inFileLocalPath rangeOfString:@"ChatAudios"].length>0)
    {
        return;
    }
    [self hideBothKeyBoard];
    NSString* fullPath =  [SHFileUtil getFullPathFromPath:inFileLocalPath];
    if (fullPath)
    {
        //7-1-14
        self.isMediaOpened = YES;
        //end
        
        NSURL* url = [[NSURL alloc] initFileURLWithPath: fullPath];
        PlayVideoViewController* mPlayer = [[PlayVideoViewController alloc] initWithContentURL: url];
        //       NSLog(@"filelocalpath =%@ ",inFileLocalPath);
        [self presentMoviePlayerViewControllerAnimated:mPlayer];
    }
}

-(void)doCancelUploadindOrDownloading :(CustomUplaodingView *)inCstView
{
    //15-3-14
    [inCstView updateWithTotalBytes:1.00 downloadedBytes:0.0];
    [inCstView setNeedsLayout];
    
    //end
    
    
    switch (inCstView.currentState)
    {
        case eStateTypeNone:
            
            break;
            
        case eStateTypeDownloading:
            
            //4-2-14
            //            [self.downloadingStatusDic setObject:[NSNumber numberWithBool: NO] forKey: inCstView.chatId];
            [self.downloadingStatusDic setObject:[NSNumber numberWithInt: eStateTypeCancel] forKey: inCstView.chatId];
            
            //end
            //14-1-14 not Responde Canceling
            [self cancelDownloading: inCstView.chatId];
            
            //end
            
            self.isDownloading = NO;
            
            
            break;
        case eStateTypeuploading:
            //4-2-14
            //            [self.uploadingStatusDic setObject:[NSNumber numberWithBool: NO] forKey: inCstView.chatId];
            [self.uploadingStatusDic setObject:[NSNumber numberWithInt: eStateTypeCancel] forKey: inCstView.chatId];
            //end
            
            //14-1-14 not Responde Canceling
            [self cancelUploading: inCstView.chatId];
            //end
            self.isUploading = NO;
            break;
            
        default:
            break;
    }
}


-(void)cancelUploading:(NSString *)inChatId
{
    
    //    NSLog(@" File uploading is stopped successfully ");
    
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"chatid==%@",inChatId];
    NSMutableArray * aFilteredArr = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate: aPredicate]];
    NSMutableDictionary * aDic = [aFilteredArr lastObject];
    int indexOfObj = [messages indexOfObject: aDic];
    
    UIView *ChatView = [aDic objectForKey: @"view"];
    CustomUplaodingView *aCstView = (CustomUplaodingView *)[[ChatView subviews] objectAtIndex: 1];
    //    aCstView.currentState = eStateTypeNone;
    aCstView.eventType = eTypeUpldUpLoad;
    aCstView.ProgressView.progress = 0.0;
    aCstView.downloadedFileSize = 0.0;
    //20-3-14
    [aCstView.mixedIndicator updateWithTotalBytes: 1.0 downloadedBytes:0.0];
    //end
    [aCstView.btnStatus setTitle:@"Try again!" forState:UIControlStateNormal];
    [aCstView.btnDownload setBackgroundImage:[UIImage imageNamed:@"iconUpload"] forState:UIControlStateNormal];
    //
    //22-3-14
    [aDic setObject:@"uploading" forKey:@"fileaction"];
    //end
    
    //24-3-14 media
    [self.uploadingStatusDic setObject:[NSNumber numberWithInt: eStateTypeCancel] forKey: inChatId];
    aCstView.currentState = eStateTypeCancel;
    aCstView.eventType = eTypeUpldCancel;
    //end
    
    [aCstView UpdateUIContents];
    [messages replaceObjectAtIndex: indexOfObj withObject: aDic];
    //7-1-14 not Responde Canceling
    [self updateMsgListViewIfNeededByTotalMesg: messages];
    //end
    [self.tView reloadData];
    
    
    //
    //    BOOL isDeleted = [SHFileUtil deleteItemAtPath: [aDic objectForKey:@"filelocalpath"]];
    //    if (isDeleted)
    //    {
    //        int index = [messages indexOfObject: aDic];
    //        [messages removeObjectAtIndex: index];
    //
    //        //29-1-14 crash
    //        if (messages.count == 0)
    //        {
    //            [self.cacheMsgArr removeAllObjects];
    //            [self.msgGroupedByDate removeAllObjects];
    //            [self.allKeysOfDate removeAllObjects];
    //        }
    //        //end
    //
    //        //7-1-14 not Responde Canceling
    //        [self updateMsgListViewIfNeededByTotalMesg: messages];
    //        //end
    //        [self.tView reloadData];
    
    //    }
    
}

-(void)cancelDownloading:(NSString *)inChatId
{
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"chatid==%@",inChatId];
    NSMutableArray * aArr = [NSMutableArray arrayWithArray:[messages filteredArrayUsingPredicate: aPredicate]];
    NSMutableDictionary * aDic = [aArr lastObject];
    int indexOfObj = [messages indexOfObject: aDic];
    
    UIView *ChatView = [aDic objectForKey: @"view"];
    CustomUplaodingView *aCstView = (CustomUplaodingView *)[[ChatView subviews] objectAtIndex: 1];
    
    //24-3-14 media
    //    aCstView.currentState = eStateTypeNone;
    aCstView.currentState = eStateTypeCancel;
    //    aCstView.eventType = eTypeUpldDownLoad;
    aCstView.eventType = eTypeDownloadCancel;
    [self.downloadingStatusDic setObject:[NSNumber numberWithInt: eStateTypeCancel] forKey: inChatId];
    //end
    
    
    [aCstView UpdateUIContents];
    aCstView.ProgressView.progress = 0.0;
    aCstView.downloadedFileSize = 0.0;
    //20-3-14
    [aCstView.mixedIndicator updateWithTotalBytes: 1.0 downloadedBytes:0.0];
    //end
    
    [aDic setObject:@"uploaded" forKey:@"fileaction"];
    
    [messages replaceObjectAtIndex: indexOfObj withObject: aDic];
    //7-1-14 not Responde Canceling
    [self updateMsgListViewIfNeededByTotalMesg: messages];
    //end
    [self.tView reloadData];
    
}
- (void)ReceiveIQ:(XMPPIQ *)IQ
{
    NSLog(@"Last Seen: %@",IQ);
    if([[NSString stringWithFormat:@"%@",IQ] rangeOfString:@"jabber:iq:last"].length>0)
    {
        int timeInterval = [[[IQ elementForName:@"query" xmlns:@"jabber:iq:last"] attributeStringValueForName:@"seconds"] intValue];
        if(timeInterval>0)
        {
            NSDate *date = [[NSDate date] dateByAddingTimeInterval:-timeInterval];
            self.lblTyping.text = [NSString stringWithFormat:@"Last seen %@",[self convertedDate:date]];
        }
        else
        {
            //            [self CheckPresenceOfFriend];
        }
    }
}

-(void)doShowMsgFromCache
{
    
    if ([self setMsgByCount])
    {
        [self.tableLoadMoreView.ActivityIndicator stopAnimating];
        [self.tView reloadData];
        //        int sec = 0 ;
        NSIndexPath *topIndexPath = nil;
        if(self.tableLoadMoreView.isShownLoadMore == YES)
        {
            topIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        }
        else
        {
            topIndexPath = [NSIndexPath indexPathForRow:0
                                              inSection:0];
        }
        
        [self.tView scrollToRowAtIndexPath:topIndexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
        
    }
    else
    {
        [self.tableLoadMoreView.ActivityIndicator stopAnimating];
        
    }
    
    if (self.shownMsgCount == 0)
    {
        [self.tableLoadMoreView hideAndShowLoadMore: YES];
        
    }
    
}


#pragma mark Table Load more Delegate
-(void)tableLoadMore:(id)inCellView
{
    [self stopPlayer];
    ChatFirstRowCell *aCell = (ChatFirstRowCell *)inCellView;
    
    if (self.shownMsgCount == 0)
    {
        return;
    }
    
    [aCell.ActivityIndicator startAnimating];
    
    [self performSelector:@selector(doShowMsgFromCache) withObject: nil afterDelay: 1.0];
    
}

#pragma mark- Save To Chat History
-(void)saveToChatHistory:(NSDictionary *)inMsgDic
{
    NSString *chatUser = nil;
    if([chatWithUser rangeOfString:@"/"].length>0)
    {
        chatUser = [[chatWithUser componentsSeparatedByString:@"/"] objectAtIndex:0];
    }
    else
    {
        chatUser = chatWithUser;
    }
    if([chatUser rangeOfString:@"chatsupport"].length>0)
    {
        return;
    }
    
    
}


//7-1-14
-(void)releaseThisViewWhenUploadingAndDownloadingIsNotInPending
{
    AppDelegate *appDel = APP_DELEGATE;
    
    NSArray *arrayuser = [chatWithUser componentsSeparatedByString:@"@"];
    
    if (arrayuser.count > 0)
    {
        NSString *userId = [NSString stringWithFormat:@"%@",[arrayuser objectAtIndex: 0]];
        //        [userId uppercaseString]
        [appDel performSelector:@selector(releaseChatViewByChatUserNameIfNeeded:) withObject: userId  afterDelay:0.5];
    }
}

-(BOOL)isDownloadingAndUploadingAreInPending
{
    if (self.uploadingStatusDic.count > 0 || self.downloadingStatusDic.count > 0)
    {
        return  YES;
    }
    return NO;
    
}
//end
//nehaa 25-03-2014
-(void)internetConnectionListener:(NSNotification *)inNotification
{
    [self showNetworkView];
    if([Utils isInternetAvailable])
    {
        [gCXMPPController disconnect];
        [gCXMPPController connect];
        
        self.lblTyping.text = @"Connecting...";
        self.inputToolbar.isConnected=NO;
        self.activity.hidden = NO;
        self.lblUsername.hidden = YES;
        [self doUploadPendingWhenNetworkAvailable];
        [self doDownloadPendingWhenNetworkAvailable];
        [self performSelector:@selector(CheckXMPPConnection) withObject:nil afterDelay:1.0];
    }
    else
    {
        self.activity.hidden = NO;
        self.lblTyping.text = @"Waiting for network...";
        self.lblUsername.hidden = YES;
        self.inputToolbar.isConnected=NO;
        self.inputToolbar.btnFileUpload.enabled = NO;
        [gCXMPPController disconnect];
        self.inputToolbar.btnSend.enabled = NO;
        self.inputToolbar.btnRecord.enabled = NO;
    }
    
}

//end
-(void)showNetworkView
{
    lblNetworkMsg.text = @"No network connection";
    
    if ([Utils isInternetAvailable])
    {
        [UIView beginAnimations:@"fade in" context:nil];
        [UIView setAnimationDuration:1.0];
        viewforNetworkConnection.alpha = 0.0;
        [UIView commitAnimations];
        [viewforNetworkConnection removeFromSuperview];
    }
    else
    {
        [self.view addSubview:viewforNetworkConnection];
        viewforNetworkConnection.hidden=NO;
        
        [UIView beginAnimations:@"fade out" context:nil];
        [UIView setAnimationDuration:1.0];
        viewforNetworkConnection.alpha = 1.0;
        [UIView commitAnimations];
    }
}


#pragma mark:- resendDisputedMsg

//7-2-14

-(void)resendDisputedMessageswithTimeStamp:(NSDate *)timeStamp
{
    //    if (self.isUnavailable == YES|| ([chatWithUser rangeOfString:@"chatsupport@conference"].location!=NSNotFound) )
    if([chatWithUser rangeOfString:@"chatsupport@conference"].location!=NSNotFound)
    {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isdelivered = 0 and SELF.sendTimestampDate <= %@ and SELF.sender LIKE[c] %@",timeStamp,@"you"];
    
    
    NSArray *filteredArray = [messages filteredArrayUsingPredicate:predicate];
    if([filteredArray count]>0)
    {
        for(NSDictionary *dic in filteredArray )
        {
            NSArray *allKeys = [dic allKeys];
            
            if ([allKeys containsObject:@"media"] == NO)
            {
                NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
                [message addAttributeWithName:@"type" stringValue:@"chat"];
                [message addAttributeWithName:@"id" stringValue:[dic valueForKey:@"chatid"]];
                [message addAttributeWithName:@"to" stringValue:chatWithUser];
                [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1]];
                NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
                [body setStringValue:[dic valueForKey:@"msg"]];//change here
                NSXMLElement *request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
                [message addChild:body];
                [message addChild:request];
                
                //9-5-14
                NSDate *sendTimestampDate = [dic valueForKey:@"sendTimestampDate"];
                NSXMLElement *sendTimestampDateTag = [NSXMLElement elementWithName:@"sendTimestampDate"];
                [sendTimestampDateTag setStringValue: [NSString stringWithFormat:@"%f",[sendTimestampDate timeIntervalSince1970]]];
                [message addChild:sendTimestampDateTag];
                
                //end
                [self.xmppStream sendElement:message];
            }
            //10-2-14
            //            else if ([allKeys containsObject:@"media"] == YES)
            //            {
            //                continue;
            //                if ([allKeys containsObject:@"fileaction"] && [[dic objectForKey:@"fileaction"] isEqualToString:@"uploaded"])
            //                {
            //                    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
            //
            //                    [message addAttributeWithName:@"type" stringValue:@"chat"];
            //                    [message addAttributeWithName:@"id" stringValue:[dic valueForKey:@"chatid"]];
            //                    [message addAttributeWithName:@"to" stringValue:chatWithUser];
            //
            //
            //                    [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1]];
            //                    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            //                    NSXMLElement *media = [NSXMLElement elementWithName:@"media"];
            //                    //27-3-14 p
            //                    NSXMLElement *mediaOrientation = [NSXMLElement elementWithName:KMediaOrientation];
            //                    [mediaOrientation setStringValue:[NSString stringWithFormat:@"%@",[dic objectForKey: KMediaOrientation]]];
            //
            //                    //end
            //
            //                    //nehaa thumbnail
            //                    NSXMLElement *thumbBase64String = [NSXMLElement elementWithName:KThumbBase64String];
            //                    [thumbBase64String setStringValue:[NSString stringWithFormat:@"%@",[dic objectForKey: KThumbBase64String]]];
            //                    [message addChild:thumbBase64String];
            //
            //                    //end thumbnail
            //
            //                    NSXMLElement *filelocalpath = [NSXMLElement elementWithName:@"filelocalpath"];
            //                    NSXMLElement *fileaction = [NSXMLElement elementWithName:@"fileaction"];
            //                    NSXMLElement *fileSize = [NSXMLElement elementWithName:@"fileSize"];
            //                    NSXMLElement *fileName = [NSXMLElement elementWithName:@"fileName"];
            //
            //
            //                    [media setStringValue:[dic objectForKey:@"media"]];
            //
            //                    NSXMLElement *request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
            //                    //11-2-14 2
            //                    //                    [message addAttributeWithName:@"attachment" stringValue:[dic objectForKey:@"fileserverpath"]];
            //
            //                    [message addAttributeWithName:@"attachment" stringValue:[dic objectForKey:@"attachment"]];
            //                    //end
            //                    //9-5-14
            //                    NSDate *sendTimestampDate = [dic valueForKey:@"sendTimestampDate"];
            //                    NSXMLElement *sendTimestampDateTag = [NSXMLElement elementWithName:@"sendTimestampDate"];
            //                    [sendTimestampDateTag setStringValue: [NSString stringWithFormat:@"%f",[sendTimestampDate timeIntervalSince1970]]];
            //                    [message addChild:sendTimestampDateTag];
            //
            //                    //end
            //
            //                    [fileaction setStringValue:@"uploaded"];
            //                    [filelocalpath setStringValue:[dic objectForKey:@"filelocalpath"]];
            //                    [fileName setStringValue:[dic objectForKey:@"fileName"]];
            //                    [fileSize setStringValue:[dic objectForKey:@"fileSize"]];
            //
            //
            //                    [message addChild:filelocalpath];
            //                    [message addChild:fileaction];
            //                    [message addChild:fileSize];
            //                    [message addChild:fileName];
            //                    //27-3-14 p
            //                    [body addChild:mediaOrientation];
            //                    //end
            //                    [body addChild:media];
            //                    [message addChild:body];
            //                    [message addChild:request];
            //
            //                    [self.xmppStream sendElement:message];
            //
            //                }
            
            
            //            }
            //end
        }
        
    }
    
}
//end

//28-2-14
#pragma mark clipBoardDelegate methods
- (void)hideKeyboard
{
    [self hideBothKeyBoard];
}
-(void)clipBoardCopyFromCell:(id)inCell
{
    CustomChatView *aCell = (CustomChatView *)inCell;
    
    NSDictionary * aMsgDic = [self getMsgDicByChatId: aCell.ChatId];
    NSString *msg = [aMsgDic objectForKey:@"msg"];
    
    if ([aCell.MediaType isEqualToString:@"image"]
        ||[aCell.MediaType isEqualToString:@"video"]
        || [aCell.MediaType isEqualToString:@"audio"] )
    {
        //        NSLog(@"clipBoardCopyFromCell");
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString: msg];
    }
    else
    {
        //        NSLog(@"clipBoardCopyFromCell");
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString: msg];
    }
}
-(void)clipBoardForwardFromCell:(id)inCell
{
    CustomChatView *aCell = (CustomChatView *)inCell;
    
    NSDictionary * aMsgDic = [self getMsgDicByChatId: aCell.ChatId];
    NSString *msg = [aMsgDic objectForKey:@"msg"];
    
    if ([aCell.MediaType isEqualToString:@"image"]
        ||[aCell.MediaType isEqualToString:@"video"]
        || [aCell.MediaType isEqualToString:@"audio"] )
    {
        //        NSLog(@"clipBoardForwardFromCell");
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString: msg];
    }
    else
    {
        //        NSLog(@"clipBoardForwardFromCell");
        
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        
        [pb setStrings:[NSArray arrayWithObjects:msg,kMESSAGEFORWARD, nil] ];
        
        //        [self.navigationController popViewControllerAnimated: YES];
//        NSArray *arr = [self.navigationController viewControllers];
//        ChatHomeScreenController *ObjMySession=nil;
//        for (int i = 0; i< arr.count ; i++)
//        {
//            UIViewController *aviewCont = [arr objectAtIndex:i];
//            if ([aviewCont isKindOfClass:[ChatHomeScreenController class]])
//            {
//                ObjMySession = [arr objectAtIndex:i];
//                break;
//            }
//        }
//        if(ObjMySession){
//            [self.navigationController popToViewController:ObjMySession animated:YES];
//        }
//        else{
            [self.navigationController popViewControllerAnimated: YES];
//        }
//        
    }
}
-(void)clipBoardDeleteFromCell:(id)inCell
{
    if([inCell class]==[CustomUplaodingView class])
    {
        CustomUplaodingView *aCell = (CustomUplaodingView *)inCell;
        NSDictionary * aMsgDic = [self getMsgDicByChatId: aCell.chatId];
        
        if([self.player isPlaying])
        {
            NSString *chatId = [[messages objectAtIndex:inIndexPath.row]objectForKey:@"chatid"];
            
            
            if(![chatId isEqualToString:aCell.chatId])
            {
                int indexToBeDeleted = [messages indexOfObject:aMsgDic];
                if(indexToBeDeleted < inIndexPath.row)
                {
                    inIndexPath = [NSIndexPath indexPathForRow:inIndexPath.row-1 inSection:inIndexPath.section];
                }
            }
            else
            {
                [self.player stop];
                [self stopPlayer];
            }
            
        }
        
        
        int indexOfObj = [messages indexOfObject: aMsgDic];
        
        
        [messages removeObjectAtIndex: indexOfObj];
        [self updateMsgListViewIfNeededByTotalMesg: messages];
        NSLog(@"%@",messages);
        
        if([[[messages lastObject]allKeys]containsObject:@"media"])
        {
            [self updateLastMessage:[[messages lastObject] objectForKey:@"media"] withDate:[[messages lastObject] valueForKey:@"sendTimestampDate"]];
        }
        else
        {
            [self updateLastMessage:[[messages lastObject] objectForKey:@"msg"] withDate:[[messages lastObject] valueForKey:@"sendTimestampDate"]];
        }
        if(aCell.eventType != eTypeUpldUpLoad)
        {
            NSDictionary * updationDic = [NSDictionary dictionaryWithObjectsAndKeys:aCell.chatId ,@"chatid", nil];
            NSNotificationCenter * aMsgCenter = [NSNotificationCenter defaultCenter];
            NSNotification * msgNotification =	[NSNotification notificationWithName: @"delete" object: updationDic userInfo: nil];
            [aMsgCenter postNotification: msgNotification];
            if([[aMsgDic objectForKey:@"media"]isEqualToString:@"image"])
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"originalUrl == %@",aCell.fileLocalUrlStr];
                NewPhoto *photo =    [[arrPhotos filteredArrayUsingPredicate:predicate] objectAtIndex:0];
                [arrPhotos removeObject:photo];
            }
        }
        
        return;
        
    }
    else
    {
        CustomChatView *aCell = (CustomChatView *)inCell;
        
        NSDictionary * aMsgDic = [self getMsgDicByChatId: aCell.ChatId];
        
        int indexOfObj = [messages indexOfObject: aMsgDic];
        
        
        [messages removeObjectAtIndex: indexOfObj];
        [self updateMsgListViewIfNeededByTotalMesg: messages];
        //    NSString *groupKey = [self.allKeysOfDate lastObject];
        //    NSDictionary *chatInfo = [[self.msgGroupedByDate objectForKey :groupKey] lastObject];
        //    UIView *chatView = [chatInfo objectForKey:@"view"];
        
        NSLog(@"%@",messages);
        
        if([[[messages lastObject]allKeys]containsObject:@"media"])
        {
            [self updateLastMessage:[[messages lastObject] objectForKey:@"media"] withDate:[[messages lastObject] valueForKey:@"sendTimestampDate"]];
        }
        else
        {
            [self updateLastMessage:[[messages lastObject] objectForKey:@"msg"] withDate:[[messages lastObject] valueForKey:@"sendTimestampDate"]];
        }
        
        NSDictionary * updationDic = [NSDictionary dictionaryWithObjectsAndKeys:aCell.ChatId ,@"chatid", nil];
        NSNotificationCenter * aMsgCenter = [NSNotificationCenter defaultCenter];
        NSNotification * msgNotification =	[NSNotification notificationWithName: @"delete" object: updationDic userInfo: nil];
        [aMsgCenter postNotification: msgNotification];
        
        
        
        return;
        
        if ([aCell.MediaType isEqualToString:@"image"]
            ||[aCell.MediaType isEqualToString:@"video"]
            || [aCell.MediaType isEqualToString:@"audio"] )
        {
            //        NSLog(@"clipBoardDeleteFromCell");
            //        UIPasteboard *pb = [UIPasteboard generalPasteboard];
            //        [pb setString: msg];
        }
        else
        {
            //        NSLog(@"clipBoardDeleteFromCell");
            //        UIPasteboard *pb = [UIPasteboard generalPasteboard];
            //        [pb setString: msg];
        }
        
    }
}
//end
-(void)stopPlayer
{
    [self stopTimer];
    NSDictionary *MsgDic = [[self.msgGroupedByDate objectForKey: [self.allKeysOfDate objectAtIndex: inIndexPath.section]] objectAtIndex: inIndexPath.row];
    NSString *isFrom = [MsgDic objectForKey:@"speaker"];
    
    UIView * OldView = [MsgDic objectForKey: @"view"];
    CustomUplaodingView *
    cView = [[OldView subviews] objectAtIndex: 1];
    UILabel *lbl = [cView.subviews objectAtIndex:6];
    int minutes = (int)self.player.duration / 60;
    int seconds = (int)self.player.duration % 60;
    
    lbl.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
    UIImageView *imgView = [[cView subviews] objectAtIndex:4];
    UIProgressView *progress =[cView.subviews objectAtIndex:5];
    progress.progress=0;
    if ([isFrom isEqualToString:@"self"])
    {
        imgView.image = [UIImage imageNamed:@"chatPlayIconWhite"];
    }
    else
    {
        imgView.image = [UIImage imageNamed:@"chatPlayIcon"];
    }
    self.player = nil;
    inIndexPath = nil;
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if(inIndexPath==nil)
        return;
    [self stopTimer];
    
    NSDictionary *MsgDic = [[self.msgGroupedByDate objectForKey: [self.allKeysOfDate objectAtIndex: inIndexPath.section]] objectAtIndex: inIndexPath.row];
    NSString *isFrom = [MsgDic objectForKey:@"speaker"];
    
    UIView * OldView = [MsgDic objectForKey: @"view"];
    CustomUplaodingView *
    cView = [[OldView subviews] objectAtIndex: 1];
    UILabel *lbl = [cView.subviews objectAtIndex:6];
    int minutes = (int)self.player.duration / 60;
    int seconds = (int)self.player.duration % 60;
    
    lbl.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
    UIImageView *imgView = [[cView subviews] objectAtIndex:4];
    UIProgressView *progress =[cView.subviews objectAtIndex:5];
    progress.progress=0;
    if ([isFrom isEqualToString:@"self"])
    {
        imgView.image = [UIImage imageNamed:@"chatPlayIconWhite"];
    }
    else
    {
        imgView.image = [UIImage imageNamed:@"chatPlayIcon"];
    }
    self.player = nil;
    inIndexPath = nil;
    [self.tView reloadData];
}
#pragma mark - audio methods

- (void)audioButtonClicked
{
    if (!recorder.recording) {
        if(self.player && [self.player isPlaying])
            [self stopPlayer];
        //audio player
        [self.tView setUserInteractionEnabled:NO];
        NSString *fileName = [NSString stringWithFormat:@"ChatAudios/MyAudioMemoalbum1%f.m4a",[[NSDate date] timeIntervalSince1970]];
        NSString *filePath = [SHFileUtil getFullPathFromPath:fileName];
        NSURL *outputFileURL = [NSURL fileURLWithPath:filePath];
        NSRange range = [fileName rangeOfString: @"/"];
        if(range.location != NSNotFound)
        {
            int lastIndex = (int)([fileName rangeOfString:@"/" options: NSBackwardsSearch].location);
            NSString * directoryPath = [fileName substringToIndex: lastIndex];
            [SHFileUtil createDirectoryWithPath: directoryPath];
        }
        self.inputToolbar.audioFilePath = filePath;
        
        // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        //        [session setCategory:AVAudioSessionCategoryMultiRoute error:nil];
        NSError *setCategoryError = nil;
        if (![session setCategory:AVAudioSessionCategoryPlayAndRecord
                      withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                            error:&setCategoryError]) {
            // handle error
        }
        // Define the recorder setting
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        // Initiate and prepare the recorder
        recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
        [recorder prepareToRecord];
        timeMin = 0;
        timeSec = 0;
        
        //Format the string 00:00
        
        NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", timeMin, timeSec];
        self.inputToolbar.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.inputToolbar.timer  forMode:NSDefaultRunLoopMode];
        
        //Display on your label
        //[timeLabel setStringValue:timeNow];
        self.inputToolbar.lblRecordingTime.text= timeNow;
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
//        [self.inputToolbar.btnRecord setImage:[UIImage imageNamed:@"chatRecordBtnActive"] forState:UIControlStateNormal];
        
    }
}
- (IBAction)stopRecording
{
    if(!recorder)
    {
        return;
    }
    [recorder stop];
    [self.tView setUserInteractionEnabled:YES];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
   // [self.inputToolbar.btnRecord setImage:[UIImage imageNamed:@"chatRecordBtn"] forState:UIControlStateNormal];
    if(self.inputToolbar.audioFilePath.length>0)
    {
        NSURL *SongURL = [NSURL fileURLWithPath:self.inputToolbar.audioFilePath];
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"public.audio",@"UIMediaPickerControllerMediaType",SongURL ,@"UIMediaPickerControllerMediaURL",nil];
        NSError *error=nil;
        if(self.player)
            self.player=nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:SongURL error:&error];
        [self.player prepareToPlay];
        int minutes = (int)self.player.duration / 60;
        int seconds = (int)self.player.duration % 60;
        self.player = nil;
        if(seconds==0&&minutes==0)
        {
            return;
        }
        [self uploadImage: infoDic];
    }
}
- (IBAction)btnPlayClicked:(id)sender {
    if (!recorder.recording){
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [self.player setDelegate:self];
        [self.player play];
    }
    else
    {
        [self.player stop];
        self.player = nil;
    }
}
- (void)timerTick:(NSTimer *)timer {
    timeSec++;
    if (timeSec == 60)
    {
        timeSec = 0;
        timeMin++;
    }
    //Format the string 00:00
    NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", timeMin, timeSec];
    //Display on your label
    self.inputToolbar.lblRecordingTime.text= timeNow;
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    recorder = nil;
    //    [self.btnAudioPlayButton setHidden:NO];
    
}
#pragma mark Timer Methods

- (void)startTimer
{
    self.timerForPlaying= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    [self.timerForPlaying invalidate];
    
    self.timerForPlaying = nil;
}

// This method for updating UISlider when sound start to play.
- (void)updateSlider
{
    if([self.allKeysOfDate count]==0)
        return;
    NSDictionary *MsgDic = [[self.msgGroupedByDate objectForKey: [self.allKeysOfDate objectAtIndex: inIndexPath.section]] objectAtIndex: inIndexPath.row];
    UIView * OldView = [MsgDic objectForKey: @"view"];
    CustomUplaodingView *
    cView = [[OldView subviews] objectAtIndex: 1];
    
    UIProgressView *progress = [[cView subviews] objectAtIndex:5];
    float prog = self.player.currentTime/self.player.duration;
    
    
    NSTimeInterval remaining = self.player.duration - self.player.currentTime;
    int minutes = (int)remaining / 60;
    int seconds = (int)remaining % 60;
    UILabel *lbl = [cView.subviews objectAtIndex:6];
    lbl.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
    [progress setProgress:prog animated:YES];
}
- (void)stopAudio:(NSNotification *)notification
{
    if(inIndexPath!=nil)
    {
        //        [self.player stop];
        //        self.player = nil;
        [self stopPlayer];
    }
}

#pragma mark - Gesture Handler

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    
    
    CGPoint velocity = [gestureRecognizer velocityInView:self.tView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (velocity.y > 0) {
            [self animateKeyboardOffscreen];
        } else {
            [self animateKeyboardReturnToOriginalPosition];
        }
    }
}

#pragma mark -

- (void)animateKeyboardOffscreen {
    
    [self hideBothKeyBoard];
}

- (void)animateKeyboardReturnToOriginalPosition {
    
}


#pragma mark - Selected Image

-(void)imageSelectedFromCamera:(id)dict
{
    //22-1-14 thumbnail
    self.isMediaOpened = YES;
    
    [self performSelector:@selector(uploadImage:) withObject:dict];
    //end
    
}
-(void)videoSelectedFromCamera:(id)dict
{
    //22-1-14 thumbnail
    self.isMediaOpened = YES;
    [self performSelector:@selector(uploadImage:) withObject:dict];
    //end
    
}

//-(AddressBookDB *)getAddressBookDetails:(NSString *)chatWithName
//{
//    NSManagedObjectContext *context = [deleg managedObjectContext];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AddressBookDB" inManagedObjectContext:context];
//    
//    // Setup the fetch request
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entity];
//    
//    // append firstname & lastname
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(orgChatUsername LIKE[c] %@)",chatWithName];
//    [request setPredicate:pred];
//    
//    NSArray *compPredicatesList = [NSArray arrayWithObjects:pred, nil];
//    NSPredicate *CompPrediWithAnd = [NSCompoundPredicate andPredicateWithSubpredicates:compPredicatesList];
//    
//    [request setPredicate: CompPrediWithAnd];
//    // Fetch the records and handle an error
//    NSError *error = nil;
//    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
//    if([mutableFetchResults count]>0)
//    {
//        return [mutableFetchResults objectAtIndex:0];
//    }
//    return nil;
//}
- (IBAction)btnContactInfoClicked:(id)sender {
    return;
//    [self getDatabaseImages];
//    ContactsDetailViewController *contactDetail=[[ContactsDetailViewController alloc] initWithNibName:@"ContactsDetailViewController" bundle:nil];
//    contactDetail.delegate = self;
//    AddressBookDB *address = [[Database database] fetchDataFromDatabaseForEntity:@"AddressBookDB" chatUserName:[[chatWithUser componentsSeparatedByString:@"@"] objectAtIndex:0] keyName:nil];
//    
//    contactDetail.hidesBottomBarWhenPushed=YES;
//    
//    NSMutableArray *arrContacDetail=[[NSMutableArray alloc] init];
//    if(address!=nil)
//    {
//        NSArray *valuesPhone = nil;
//        if (address.phone) {
//            NSData* data = [address.phone dataUsingEncoding:NSUTF8StringEncoding];
//            valuesPhone = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            
//        }
//        
//        NSArray *valuesEmail = nil;
//        if (address.email) {
//            NSData* data = [address.email dataUsingEncoding:NSUTF8StringEncoding];
//            valuesEmail = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            
//        }
//        
//        //    NSMutableDictionary *aDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:address.fullName,kfullName, nil];
//        
//        if (address.fullName) {
//            contactDetail.strFullName=address.fullName;
//        }
//        if (valuesPhone) {
//            NSMutableDictionary *aTemp=[NSMutableDictionary dictionaryWithObjectsAndKeys:valuesPhone,kPhoneNumber, nil];
//            [arrContacDetail addObject:aTemp];
//            
//        }
//        if (valuesEmail) {
//            NSMutableDictionary *aTemp=[NSMutableDictionary dictionaryWithObjectsAndKeys:valuesEmail,kemail, nil];
//            [arrContacDetail addObject:aTemp];
//            
//        }
//        if (address.notes) {
//            NSMutableDictionary *aTemp=[NSMutableDictionary dictionaryWithObjectsAndKeys:address.notes,kNotes, nil];
//            [arrContacDetail addObject:aTemp];
//            CGSize notesHeight=[AppManager frameForText:address.notes sizeWithFont:[UIFont fontWithName:ssFontHelveticaNeue size:17] constrainedToSize:CGSizeMake(250, 1000)];
//            contactDetail.notesHeight=ceil(notesHeight.height);
//        }
//        
//        if ([address.originalUserId integerValue] == 0) {
//            
//            
//            NSMutableDictionary *aTemp=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Invite to MEKS",@"button",[NSNumber numberWithInt:ADDRESSBOOK_DETAIL_BUTTON_TYPE_INVITE_TO_UMMAPP],@"type", nil];
//            
//            NSArray *arrtemp=[NSArray arrayWithObjects:aTemp, nil];
//            NSDictionary *aTempOuter=[NSDictionary dictionaryWithObjectsAndKeys:arrtemp,@"button", nil];
//            
//            
//            [arrContacDetail addObject:aTempOuter];
//            
//        }else{
//            //            NSMutableDictionary *aTemp=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Send Message",@"button",[NSNumber numberWithInt:ADDRESSBOOK_DETAIL_BUTTON_TYPE_SEND_MESSAGE],@"type", nil];
//            NSMutableDictionary *aTemp3=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"View All Media",@"button",[NSNumber numberWithInt:ADDRESSBOOK_DETAIL_BUTTON_TYPE_VIEW_ALL_MEDIA],@"type", nil];
//            
//            NSMutableDictionary *aTemp1=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Email Conversation",@"button",[NSNumber numberWithInt:ADDRESSBOOK_DETAIL_BUTTON_TYPE_EMAIL_CONVERSTAION],@"type", nil];
//            
//            NSMutableDictionary *aTemp2=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Clear Message",@"button",[NSNumber numberWithInt:ADDRESSBOOK_DETAIL_BUTTON_TYPE_CLEAR_CONVERSATION],@"type", nil];
//            
//            NSArray *arrtemp=[NSArray arrayWithObjects:aTemp3,aTemp1,aTemp2, nil];
//            NSDictionary *aTempOuter=[NSDictionary dictionaryWithObjectsAndKeys:arrtemp,@"button", nil];
//            
//            
//            [arrContacDetail addObject:aTempOuter];
//        }
//        
//        contactDetail.strJobTitle=address.jobTitle;
//        contactDetail.arrContactDetail=arrContacDetail;
//        contactDetail.strProfilePic=address.profilePic;
//        contactDetail.originalUserId=[address.originalUserId integerValue];
//        contactDetail.strChatUserName=address.orgChatUsername;
//        //    contactDetail.aDictContactDetail=aDict;
//    }
//    else
//    {
//        
//        //        {
//        //            "type" : "mobile",
//        //            "inMEKS" : 1,
//        //            "profilePic" : "58be5ca817c26c89113c2338d82050c085dc81ee.jpg",
//        //            "chatUsername" : "shakirhusain14060069948097",
//        //            "userStatus" : "Available",
//        //            "isFriend" : 0,
//        //            "MEKSUserId" : "249",
//        //            "appUsername" : "shakirhusain",
//        //            "number" : "919211067117"
//        //        }
//        
//        NSArray *valuesPhone =[NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:@"mobile",@"type",[[imageString componentsSeparatedByString:@"/"] lastObject],@"profilePic",[[chatWithUser componentsSeparatedByString:@"@"] objectAtIndex:0],@"chatUsername",address.userStatus,@"userStatus",@"1",@"isFriend",address.originalUserId,@"MEKSUserId",address.fullName,@"appUsername",address.orgChatUsername,@"number", nil]];
//        
//        NSMutableDictionary *aTemp=[NSMutableDictionary dictionaryWithObjectsAndKeys:valuesPhone,kPhoneNumber, nil];
//        [arrContacDetail addObject:aTemp];
//        
//        NSMutableDictionary *aTemp3=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"View All Media",@"button",[NSNumber numberWithInt:ADDRESSBOOK_DETAIL_BUTTON_TYPE_VIEW_ALL_MEDIA],@"type", nil];
//        
//        NSMutableDictionary *aTemp1=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Email Conversation",@"button",[NSNumber numberWithInt:ADDRESSBOOK_DETAIL_BUTTON_TYPE_EMAIL_CONVERSTAION],@"type", nil];
//        
//        NSMutableDictionary *aTemp2=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Clear Message",@"button",[NSNumber numberWithInt:ADDRESSBOOK_DETAIL_BUTTON_TYPE_CLEAR_CONVERSATION],@"type", nil];
//        
//        NSArray *arrtemp=[NSArray arrayWithObjects:aTemp3, aTemp1,aTemp2, nil];
//        NSDictionary *aTempOuter=[NSDictionary dictionaryWithObjectsAndKeys:arrtemp,@"button", nil];
//        
//        
//        [arrContacDetail addObject:aTempOuter];
//        contactDetail.strFullName=userName;
//        contactDetail.strJobTitle=nil;
//        contactDetail.arrContactDetail=arrContacDetail;
//        contactDetail.strProfilePic=self.imageString;
//        contactDetail.originalUserId=[self.friendNameId integerValue];
//        contactDetail.strChatUserName=[[chatWithUser componentsSeparatedByString:@"@"] objectAtIndex:0];
//        
//    }
//    [self.navigationController pushViewController:contactDetail animated:YES];
}
-(void)DeletedAllHistory
{
    [self.messages removeAllObjects];
    [self.allKeysOfDate removeAllObjects];
    [self.msgGroupedByDate removeAllObjects];
    [self.tView reloadData];
}




@end
