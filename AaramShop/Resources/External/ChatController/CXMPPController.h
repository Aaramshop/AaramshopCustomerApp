//
//  CXMPPController.h
//  iPhoneXMPP
//
//  Created by AppRoutes on 19/03/13.
//
//

#ifndef __CXMPPController_H__
#define __CXMPPController_H__

#pragma once

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SMChatDelegate.h"
#import "SMMessageDelegate.h"
#import "XMPPFramework.h"
#import "XMPPRoster.h"
#import "XMPPMUC.h"
#import "XMPPReconnect.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPCapabilities.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import "XMPPRoom.h"
#import "XMPPLastActivity.h"
#import "XMPPRoomCoreDataStorage.h"
#include <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
typedef void(^FirsBlock)(BOOL success);

@interface CXMPPController : NSObject <XMPPRosterDelegate,XMPPMUCDelegate,UIAlertViewDelegate>
{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;
    XMPPMUC *xmppMUC;
    XMPPRoom *xmppRoom;
    XMPPRoomCoreDataStorage *xmppRoomCoreDataStorage;
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    __weak NSObject <SMChatDelegate> *_chatDelegate;
	__weak NSObject <SMMessageDelegate> *_messageDelegate;
    
        AVAudioPlayer *newPlayer;

}
+(void)sharedXMPPController;

//nehaa 17-4-14
@property (nonatomic, assign)   BOOL isConnected;
//end 17-4-14
@property (nonatomic, readonly) NSManagedObjectContext *messagesStoreMainThreadManagedObjectContext;
@property (nonatomic, readonly) NSManagedObjectContext *groupMessagesStoreMainThreadManagedObjectContext;
@property (nonatomic, assign) id  _chatDelegate;
@property (nonatomic, assign) id  _messageDelegate;
//group chat
@property (nonatomic, strong) XMPPMUC *xmppMUC;
@property (nonatomic, strong) XMPPRoom *xmppRoom;
@property (nonatomic, strong, readonly) XMPPRoomCoreDataStorage *xmppRoomCoreDataStorage;
//
@property (nonatomic, strong, readonly) NSMutableArray *turnSockets;

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPLastActivity *xmppLastSeen;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;
@property(nonatomic , strong) FirsBlock myBlock;
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (void)removeEnsembles;
- (void)syncWithCompletion:(void(^)(void))completion;
- (BOOL)connect;
- (void)disconnect;
#pragma mark - icloud methods

- (NSURL *)storeURL;

@end
extern CXMPPController* gCXMPPController;


#endif //__CXMPPController_H__
