//
//  ChatDefines.h
//  AaramShopApp
//
//  Created by Neha Saxena on 20/10/2014.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//
#define APP_DELEGATE (AppDelegate*)[[UIApplication sharedApplication]delegate]

#ifndef UmmApp_ChatDefines_h
#define UmmApp_ChatDefines_h

typedef enum
{
    eChatNone = 0,
    eOne2OneChat,
    eGroupChat,
    eChatHistory
}
enChatType;

typedef enum {
    VIEW_STATUS_NOT_POPPED,
    VIEW_STATUS_POPPED
}ViewStatus;


#define kXMPPmyJID1            @"kXMPPmyJID"
#define kXMPPmyPassword1  @"kXMPPmyPassword"
#define STRChatServerURL    @"chat.reach-out.mobi" // live
#define kchatUserName           @"chatUsername"


#define kUMMAPPFORWARD @"W1231@UMMAPP%#@#UMMAPP"
#define KMediaOrientation @"MediaOrientation"
#define KThumbBase64String @"ThumbBase64String"
#define KImageSizePortraitHeight 160.0
#define KImageSizeLandscapeHeight 160.0//end
#define getImageHeightByOrientationFlag( f,height )	\
if(f){height = KImageSizeWidth;}else{height = KImageSizeLandscapeHeight;}

#define getImageWidthByOrientationFlag( f,width )	\
if(f){width = KImageSizeLandscapeHeight;}else{width = KImageSizeWidth;}
#endif

#define kThumbUrlDelimeter     @"{{thumb}}"
#define MESSAGE_LAST            @"MessageLast"
#define MESSAGE_PROCESSED_NOTIFICATION @"MessageProcessedNotification"
#define MESSAGE_IN_TEXTFIELD @"TextInTextField"
#define MESSAGE_COUNTER @"MessageCounter"
#define kMessageChatWithUser @"messageChatWithUser"
#define kUMMAPPFORWARD @"W1231@UMMAPP%#@#UMMAPP"
//=================== FourSquare =================
#define kFourSquareClientId @"5P1OVCFK0CCVCQ5GBBCWRFGUVNX5R4WGKHL2DGJGZ32FDFKT"
#define kFourSquareSecretId @"UPZJO0A0XL44IHCD1KQBMAYGCZ45Z03BORJZZJXELPWHPSAR"

#define kAddPalsBlueColor     [UIColor colorWithRed:88.0/255.0f green:100.0/255.0f blue:236/255.0f alpha:1.0]
//
#define kbgImage   @"bgImage"
#define kUploadProfilePic           @"uploadProfilePic"
