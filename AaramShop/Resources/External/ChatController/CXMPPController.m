
//
//  CXMPPController.m
//  iPhoneXMPP
//
//  Created by AppRoutes on 19/03/13.
//
//

//sNSString *const kXMPPmyJID = @"kXMPPmyJID";
//NSString *const kXMPPmyPassword = @"kXMPPmyPassword";DailyReports/Resources/External/XMPP/Extensions/XEP-0136/CoreDataStorage/XMPPMessageArchiving_Message_CoreDataObject.h

#import "CXMPPController.h"
//changed2-12-13
//#import "CMChatHistory.h"
//end
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPMUC.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "TURNSocket.h"

#import <CFNetwork/CFNetwork.h>
#import "AppDelegate.h"

#import "SMChatViewController.h"
//#import "tabBarController.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


CXMPPController * gCXMPPController = nil;


@interface CXMPPController()

-(void)initializeAllMembers ;

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;

- (void)goOffline;

@end



@implementation CXMPPController

@synthesize xmppMUC;
@synthesize turnSockets;
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize xmppMessageArchivingStorage;
@synthesize xmppRoomCoreDataStorage;
@synthesize xmppRoom;
@synthesize _chatDelegate=chatDelegate;
@synthesize _messageDelegate=messageDelegate;
@synthesize messagesStoreMainThreadManagedObjectContext;
@synthesize groupMessagesStoreMainThreadManagedObjectContext;
//nehaa 17-4-14
@synthesize isConnected;
//end 17-4-14
@synthesize managedObjectContext		= __managedObjectContext;
@synthesize managedObjectModel			= __managedObjectModel;
@synthesize persistentStoreCoordinator	= __persistentStoreCoordinator;
@synthesize xmppLastSeen;

+(void)sharedXMPPController
{
    if (gCXMPPController == nil)
    {
        gCXMPPController = [[CXMPPController alloc] init];
    }
    
    // set default values
    [gCXMPPController initializeAllMembers];
    
    // Configure logging framework
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Setup the XMPP stream
    [gCXMPPController setupStream];
}

-(void)initializeAllMembers
{
    //nehaa 17-4-14
    isConnected = NO;
    //end 17-4-14
    // here set the defualt values
    
//    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(listenerLoggedIn:) name: nil object: nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSURL *)storeURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
	
	// Attempt to find a name for this application
	NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
	if (appName == nil) {
		appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	}
	
	if (appName == nil) {
		appName = @"xmppframework";
	}
	
	
	NSString *result = [basePath stringByAppendingPathComponent:appName];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath:result])
	{
		[fileManager createDirectoryAtPath:result withIntermediateDirectories:YES attributes:nil error:nil];
	}
	NSString *storePath = [result stringByAppendingPathComponent:@"XMPPMessageArchiving.sqlite"];

	return [NSURL fileURLWithPath:storePath];
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.

- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    
    xmppMessageArchivingStorage = [[XMPPMessageArchivingCoreDataStorage alloc]init];
//    xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingStorage];
    // Setup message storage
    messagesStoreMainThreadManagedObjectContext = [xmppMessageArchivingStorage mainThreadManagedObjectContext];
    
    // muc setup
    
    
//    xmppRoomCoreDataStorage = [XMPPRoomCoreDataStorage sharedInstance];
////    xmppRoom = [[XMPPRoom alloc]init];
//    groupMessagesStoreMainThreadManagedObjectContext = [xmppRoomCoreDataStorage mainThreadManagedObjectContext];
//    xmppMUC = [[XMPPMUC alloc]init];
    
    //group chat
    
////    	XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",[[[NSUserDefaults standardUserDefaults] valueForKey:kXMPPmyJID1]lowercaseString],STRChatServerURL]];
////    
////    	NSLog(@"Attempting TURN connection to %@", jid);
////    
////    	TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[self xmppStream] toJID:jid];
////    
////    	[turnSockets addObject:turnSocket];
////    NSLog(@"%@",turnSockets);
//    	[turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
//    Setup Last Seen
    
    xmppLastSeen = [[XMPPLastActivity alloc] init];
    
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	[xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    
    
	// Activate xmpp modules
    [xmppMessageArchivingModule activate:xmppStream];
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
//    [xmppRoom              activate:xmppStream];
    [xmppMUC               activate:xmppStream];
    [xmppLastSeen activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    [xmppLastSeen addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppMUC addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];

	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
//    	[xmppStream setHostName:@"talk.google.com"];
//    	[xmppStream setHostPort:5222];
	
    
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
    
//    [self EnsembleSetup];
}

- (void)teardownStream
{
	[xmppStream                 removeDelegate:self];
	[xmppRoster                 removeDelegate:self];
	[xmppMessageArchivingModule removeDelegate:self];
    [xmppRoom                   removeDelegate:self];
    [xmppMessageArchivingModule deactivate];
	[xmppReconnect              deactivate];
	[xmppRoster                 deactivate];
	[xmppvCardTempModule        deactivate];
	[xmppvCardAvatarModule      deactivate];
	[xmppCapabilities           deactivate];
    [xmppRoom                   deactivate];
    [xmppLastSeen deactivate];
	
	[xmppStream disconnect];
	
	xmppStream              = nil;
	xmppReconnect           = nil;
    xmppRoster              = nil;
	xmppRosterStorage       = nil;
	xmppvCardStorage        = nil;
    xmppvCardTempModule     = nil;
	xmppvCardAvatarModule   = nil;
	xmppCapabilities        = nil;
	xmppCapabilitiesStorage = nil;
    xmppRoom                = nil;
}


// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
    XMPPJID *jid = [XMPPJID jidWithString:[[NSUserDefaults standardUserDefaults] valueForKey:kXMPPmyJID1]];
	
	NSLog(@"Attempting TURN connection to %@", jid);
	
	TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[self xmppStream] toJID:jid];
//
	[turnSockets addObject:turnSocket];
//
	[turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];

	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[[self xmppStream] sendElement:presence];
    
//    <iq type='set' id='auto1'>
//    <auto save='true' xmlns='urn:xmpp:archive'/>
//    </iq>

    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [iq addAttributeWithName:@"id" stringValue:[NSString stringWithFormat:@"%u",(unsigned int) arc4random()]];
    NSXMLElement *autosave = [NSXMLElement elementWithName:@"auto" xmlns:@"http://www.xmpp.org/extensions/xep-0136.html#ns"];
    [autosave addAttributeWithName:@"save" stringValue:@"true"];
    [iq addChild:autosave];
    [[self xmppStream] sendElement:iq];
    
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
   [presence addAttributeWithName:@"date" stringValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (BOOL)connect
{
    //    [deleg.messagesChatHistory removeAllObjects];
//    [deleg.messagesChat removeAllObjects];
    
    
 
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    
    // prevent to connect untill friend list is fetched.
//    if ([gAppManager isFriendListAvailable] == NO)
//    {
//        return  NO;
//    }

    
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID1];
	NSString *myPassword = @"123456";//[[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword1];
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
//    NSLog(@"XMPPJID %@",[XMPPJID jidWithString:myJID]);
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
//    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",[[[NSUserDefaults standardUserDefaults] valueForKey:kXMPPmyJID1]lowercaseString],STRChatServerURL]];
//	
//	NSLog(@"Attempting TURN connection to %@", jid);
//	
//	TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[self xmppStream] toJID:jid];
//	
//	[turnSockets addObject:turnSocket];
//	
//	[turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString: STRChatServerURL])
		{
			if ([virtualDomain isEqualToString: STRChatServerURL])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    
    [messageDelegate ReceiveIQ:iq];
    NSLog(@"%@",iq);
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
    if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"chatstates"].length>0)
    {
        if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"error"].length>0)
        {
            return;
        }
        if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"composing"].length>0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:MESSAGE_PROCESSED_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[message attributesAsDictionary] objectForKey:@"from"],@"from",[NSString stringWithFormat:@"%d",kOTRChatStateComposing],@"chatStatus", nil]];
        }
        else if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"inactive"].length>0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:MESSAGE_PROCESSED_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[message attributesAsDictionary] objectForKey:@"from"],@"from",[NSString stringWithFormat:@"%d",kOTRChatStateInactive],@"chatStatus", nil]];
        }
        else if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"active"].length>0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:MESSAGE_PROCESSED_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[message attributesAsDictionary] objectForKey:@"from"],@"from",[NSString stringWithFormat:@"%d",kOTRChatStateActive],@"chatStatus", nil]];
        }
        else
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:MESSAGE_PROCESSED_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[message attributesAsDictionary] objectForKey:@"from"],@"from",[NSString stringWithFormat:@"%d",kOTRChatStateGone],@"chatStatus", nil]];
        }
    }
    
//    FriendsDetails *friend = [[Database database] fetchDataFromDatabaseForEntity:@"FriendsDetails" chatUserName:[[[message fromStr] componentsSeparatedByString:@"@"] objectAtIndex:0] keyName:kchatUserName];
//    id delegate =
    
    if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"urn:xmpp:receipts"].length>0)
    {
        if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"body"].length>0)
        {
            if([[NSString stringWithFormat:@"%@",message]rangeOfString:[NSString stringWithFormat:@"conference.%@",STRChatServerURL]].length==0)
            {
//                if(friend!=nil)
//                {
                    [self doSendMessageAknowledgement:message];
//                }
//                else
//                {
//                    return;
//                }
            }
            else
            {
                [self doSendMessageForGroupAknowledgement: message];
            }
        }
    }
    if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"delivered"].length>0 )
    {
        DDXMLElement * element = [message elementForName: @"received"];
        NSDictionary *aDic = [element attributesAsDictionary];
        NSString* chatid = [aDic objectForKey:@"id"];
        if([messageDelegate respondsToSelector:@selector(isDelivered:)])
            [messageDelegate isDelivered: [NSDictionary dictionaryWithObjectsAndKeys:chatid,@"chatid",nil]];
#pragma mark - XMPP message status
//        [[Database database] deleteMessagesForUser:[[[message fromStr] componentsSeparatedByString:@"/"] objectAtIndex:0] withChatId:chatid];
#pragma end
    }
    
    else if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"displayed"].length>0)
    {
        DDXMLElement * element = [message elementForName: @"received"];
        NSDictionary *aDic = [element attributesAsDictionary];
        NSString * chatid = [aDic objectForKey:@"id"];
        if([messageDelegate respondsToSelector:@selector(isDisplayed:)])
            [messageDelegate isDisplayed : [NSDictionary dictionaryWithObjectsAndKeys:chatid,@"chatid",nil]];
        [self doAknowledgementServer:message];
    }
    else if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"chatstates"].length==0)
    {
//        if([[Database database] isMessageAvailable:[[message attributeForName:@"id"] stringValue]])
//        {
//            return;
//        }
    }
    //end
    
    NSXMLElement * x = [message elementForName:@"x" xmlns:XMPPMUCUserNamespace];
	NSXMLElement * invite  = [x elementForName:@"invite"];
    if(invite)
    {
        return;
    }
    
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
	// A simple example of inbound message handling.
    BOOL isShowLocalNotification = YES;
    
//    NSMutableDictionary *aDictAppSetting=[AppManager getUserAppSettingsFromPlist];
//    if([[aDictAppSetting valueForKey:KNOTIFICATION_SWITCH] intValue]==1)
//    {
//        if([[[aDictAppSetting valueForKey:KIPHONE_NOTIFICATION]valueForKey:KNEW_MESSAGE]intValue]==0)
//        {
//            isShowLocalNotification = NO;
//        }
//    }
//    else
//    {
//        isShowLocalNotification = NO;
//    }

    if(isShowLocalNotification)
    {
        if ([message isChatMessageWithBody])
        {
          
    //		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
    //		                                                         xmppStream:xmppStream
    //		                                               managedObjectContext:[self managedObjectContext_roster]];
            
            NSString *body = [[message elementForName:@"body"] stringValue];
    //		NSString *displayName = [user displayName];
            NSString *type = [[message attributeForName:@"type"] stringValue];
            
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
            {
                 AppDelegate *appDel =   APP_DELEGATE;
                if([appDel getChatWindowOpenedStatusBySender:[[[message fromStr] componentsSeparatedByString:@"/"] objectAtIndex:0]])
                {
//                    if([appDel.nav.topViewController isKindOfClass:[SMChatViewController class]])
                }
                else
                {
                
                    NSString *tone = nil;
                    if([type isEqualToString:@"groupchat"])
                    {
                        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"NotificationTone"]isEqualToString:@"default"])
                        {
                            tone = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"NotificationTone"] componentsSeparatedByString:@"."] objectAtIndex:0];
                            NSString *tapSound = [[NSBundle mainBundle] pathForResource: tone
                                                                                 ofType: @"wav"];
                            if(tapSound !=nil)
                            {
                                
                                NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: tapSound];
                                
                                newPlayer =
                                [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                                                       error: nil];
                                [newPlayer play];
                                
                            }

                        }
                        else
                        {
                            NSString *tapSound = [[NSBundle mainBundle] pathForResource: @"speech_incoming_message"
                                                                                 ofType: @"wav"];
                            if(tapSound !=nil)
                            {
                                
                                NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: tapSound];
                                
                                newPlayer =
                                [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                                                       error: nil];
                                [newPlayer play];
                                
                            }

                        }
                    }
//                    else
//                    {
////                        FriendsDetails *frnz = [[Database database] fetchDataFromDatabaseForEntity:kFriendsDetails chatUserName:[[[message fromStr] componentsSeparatedByString:@"@"] objectAtIndex:0] keyName:kchatUserName];
//                        if(friend)
//                        {
//                            if([[NSUserDefaults standardUserDefaults] objectForKey:KNotificationTone])
//                            {
//                                tone = [[[[NSUserDefaults standardUserDefaults] objectForKey:KNotificationTone] componentsSeparatedByString:@"."] objectAtIndex:0];
//                                
////                                    NSURL *tapSound   = [[NSBundle mainBundle] path: tone
////                                                                                withExtension: @"wav"];
//                               NSString *tapSound = [[NSBundle mainBundle] pathForResource: tone
//                                                                ofType: @"wav"];
//                                if(tapSound !=nil)
//                                {
//                                    
//                                    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: tapSound];
//                                    
//                                    newPlayer =
//                                    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
//                                                                           error: nil];
//                                    [newPlayer play];
//
//                                }
//                                
//                            }
//                            else
//                            {
//                                
//                                NSString *tapSound = [[NSBundle mainBundle] pathForResource: @"Default"
//                                                                                     ofType: @"wav"];
//                                if(tapSound !=nil)
//                                {
//                                    
//                                    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: tapSound];
//                                    
//                                    newPlayer =
//                                    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
//                                                                           error: nil];
//                                    [newPlayer play];
//                                    
//                                }
//                            }
//                        }
//                    }
                }
            }
            else
            {
                NSInteger count = [[UIApplication sharedApplication] applicationIconBadgeNumber];
                count = count+1;
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber:count];
                //            NSLog(@"%@",message);
                if([type isEqualToString:@"groupchat"])
                {
                    if([[message fromStr]rangeOfString:@"chatsupport@conference"].length==0)
                    {
                        NSString *msgBody = nil;
                        [[body componentsSeparatedByString:@"/"] objectAtIndex:0];
                        if([body rangeOfString:@"{/"].length>0)
                        {
                            msgBody = @"Sticker";
                        }
                        else if([body rangeOfString:@"(/"].length>0)
                        {
                            msgBody = body;
                            msgBody = [msgBody stringByReplacingOccurrencesOfString:@"(/" withString:@""];
                            msgBody = [msgBody stringByReplacingOccurrencesOfString:@")" withString:@""];
                        }
                        else if([body rangeOfString:@"[/"].length>0)
                        {
                            msgBody = body;
                            msgBody = [msgBody stringByReplacingOccurrencesOfString:@"[/" withString:@""];
                            msgBody = [msgBody stringByReplacingOccurrencesOfString:@"]" withString:@""];
                        }
                        
                        else
                        {
                            msgBody = [[body componentsSeparatedByString:@"/"] objectAtIndex:0];
                        }
                        // We are not active, so use a local notification instead
    //                    [NSString stringWithFormat:@"%@:\"%@\"",[[[message fromStr] componentsSeparatedByString:@"@"] objectAtIndex:0],msgBody]
                        NSString *groupMsg = nil;
                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                        localNotification.alertAction = @"Ok";
                        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"NotificationTone"]isEqualToString:@"default"])
                        {
                            localNotification.soundName =  [[NSUserDefaults standardUserDefaults] objectForKey:@"NotificationTone"];
                        }
                        else
                        {
                            localNotification.soundName = @"speech_incoming_message.wav";
                        }
                        NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_LAST]];
                        for(NSDictionary *dict in array)
                        {
                            if([[message fromStr]rangeOfString:[dict objectForKey:kchatUserName]].length>0)
                            {
//                                localNotification.userInfo =[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:kfullName],kfullName,[dict objectForKey:@"profilePic"],kprofilePicActual,[dict objectForKey:kUserId],kUserId,[dict objectForKey:kchatUserName],kchatUserName,@"groupchat",@"type", nil];
                                groupMsg= [NSString stringWithFormat:@"\"%@\"",msgBody];
                                break;
                            }
                        }

                        localNotification.alertBody = groupMsg;
                        
    //                    localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[message fromStr], nil]
                        
                        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                    }
                }
                else
                {
//                    FriendsDetails *frnz = [[Database database] fetchDataFromDatabaseForEntity:kFriendsDetails chatUserName:[[[message fromStr] componentsSeparatedByString:@"@"] objectAtIndex:0] keyName:kchatUserName];
//                    if(friend)
//                    {
                        NSString *msgBody = nil;[[body componentsSeparatedByString:@"/"] objectAtIndex:0];
                        if([body rangeOfString:@"{/"].length>0)
                        {
                            msgBody = @"Sticker";
                            msgBody = [NSString stringWithFormat:@"\"%@\"",msgBody];
                        }
                        else if([body rangeOfString:@"(/"].length>0)
                        {
                            msgBody = body;
                            msgBody = [msgBody stringByReplacingOccurrencesOfString:@"(/" withString:@""];
                            msgBody = [msgBody stringByReplacingOccurrencesOfString:@")" withString:@""];
                             msgBody = [NSString stringWithFormat:@"\"%@\"",msgBody];
                        }
                        else if([body rangeOfString:@"[/"].length>0)
                        {
                            msgBody = body;
                            msgBody = [msgBody stringByReplacingOccurrencesOfString:@"[/" withString:@""];
                            msgBody = [msgBody stringByReplacingOccurrencesOfString:@"]" withString:@""];
                             msgBody = [NSString stringWithFormat:@"\"%@\"",msgBody];
                        }
                        else
                        {
                            msgBody = [[body componentsSeparatedByString:@"/"] objectAtIndex:0];
                             msgBody = [NSString stringWithFormat:@"\"%@\"",msgBody];
                        }
                        if([message attributeForName:@"attachment"])
                        {
                            
                            NSString *medType = [[[message elementForName:@"body"] elementForName:@"media"] stringValue];
                            if([medType rangeOfString:@"image"].length>0)
                            {
                                msgBody = @"sent you an image";
                                msgBody = [NSString stringWithFormat:@"%@",msgBody];
                            }
                            else if([medType rangeOfString:@"video"].length>0)
                            {
                                msgBody = @"sent you a video";
                                msgBody = [NSString stringWithFormat:@"%@",msgBody];
                            }
                            else if([medType rangeOfString:@"location"].length>0)
                            {
                                msgBody = @"shared location";
                                msgBody = [NSString stringWithFormat:@"%@",msgBody];
                            }

                            else
                            {
                                msgBody = @"sent you a voice message";
                                msgBody = [NSString stringWithFormat:@"🔊 %@",msgBody];
                            }
                        }
//                        if([[[aDictAppSetting valueForKey:KMESSAGES]valueForKey:kShowPreview]intValue]==0)
//                        {
//                            msgBody = [NSString stringWithFormat:@"Message from %@.",friend.fullName];
//                        }

                        // We are not active, so use a local notification instead
                        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                        localNotification.alertAction = @"Ok";
//                        if([[NSUserDefaults standardUserDefaults] objectForKey:KNotificationTone])
//                        {
//                            if(![[[NSUserDefaults standardUserDefaults] objectForKey:KNotificationTone]isEqualToString:@"None"])
//                            {
//                                localNotification.soundName =  [[[NSUserDefaults standardUserDefaults] objectForKey:KNotificationTone] stringByAppendingString:@".wav"];
//                            }
//                            else
//                            {
//                                localNotification.soundName = nil;
//                            }
//                        }
//                        else
//                        {
//                            localNotification.soundName = @"Default.wav";
//                        }
					NSString *fullname = [[message elementForName:@"fullName"] stringValue];
					NSString *msg = [NSString stringWithFormat:@"%@:\"%@\"",fullname,msgBody];

                        localNotification.alertBody = msg;
//                        localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:friend.fullName,kfullName,friend.profilePic,kprofilePicActual,friend.userId,kUserId,friend.chatUserName,kchatUserName,@"chat",@"type", nil];
                        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//                    }
                }
            }
        }
    }
    
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    if (!msg) {
        return;
    }
    
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *type = [[message attributeForName:@"type"] stringValue];
    ///
    NSString *to = [message attributeStringValueForName:@"to"];
    NSString *chatid = [[message attributeForName:@"id"] stringValue];
    
    
    
    
    ///
    
    NSString *fileObj = @"";
    NSString *fileName = @"";

    NSString *fileaction =  @"";
    NSString *filelocalpath = @"";
    NSString *fileSize = @"";
    NSString *mediaType = @"";
    NSString *mediaViewFor=@"";
    //27-3-14 p
    NSString * mediaOrientatiom = @"";
    //end
    //nehaa thumbnail
    NSString * thumbBase64String = @"";
    //end thumbnail
    if([message attributeForName:@"attachment"])
    {
        fileObj = [[message attributeForName:@"attachment"]stringValue];
        
        fileaction = [[message elementForName:@"fileaction"] stringValue];
        
        filelocalpath = [[message elementForName:@"filelocalpath"] stringValue];
        fileSize = [[message elementForName:@"fileSize"] stringValue];
        fileName = [[message elementForName:@"fileName"] stringValue];

        mediaType = [NSString stringWithFormat:@"%@",[[[message elementForName:@"body"] elementForName:@"media"] stringValue] ];
        if([mediaType rangeOfString:@"image"].length>0)
        {
            msg = @"Image";
        }
        else if([mediaType rangeOfString:@"video"].length>0)
        {
            msg = @"Video";
        }
        else if([mediaType rangeOfString:@"location"].length>0)
        {
            msg = @"📍 Location";
        }
        else
        {
            msg = @"🔊  Voice message";
        }
        //27-3-14
        mediaOrientatiom = [NSString stringWithFormat:@"%@",[[[message elementForName:@"body"] elementForName:KMediaOrientation] stringValue] ];
        //end
        //nehaa thumbnail
        thumbBase64String = [NSString stringWithFormat:@"%@",[[message elementForName:KThumbBase64String] stringValue]];
        //end thumbnail
    }
    if(msg!=nil)
    {
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];

//        NSData *dataenc = [msg dataUsingEncoding:NSNonLossyASCIIStringEncoding];
//        NSString *encodevalue = [[NSString alloc]initWithData:dataenc encoding:NSUTF8StringEncoding];
        [m setObject:msg forKey:@"msg"];

        [m setObject:from forKey:@"sender"];
        [m setObject:type forKey:@"type"];
        
        if ([message attributeForName:@"attachment"])
        {
            if([mediaType isEqualToString:@"soundit"])
            {
                [m setObject:mediaType forKey:@"media"];
            }
            else
            {
                [m setObject:filelocalpath forKey:@"filelocalpath"];
                [m setObject:fileaction forKey:@"fileaction"];
                [m setObject:fileSize forKey:@"fileSize"];
                [m setObject:mediaType forKey:@"media"];
                [m setObject:fileName forKey:@"fileName"];
                //27-3-14
                [m setObject:mediaOrientatiom forKey:KMediaOrientation];
                //end
                
                //nehaa thumbnail
                [m setObject:thumbBase64String forKey:KThumbBase64String];
                //end thumbnail
            }
            
        }
        
        ///
        if(chatid != nil)
        {
            [m setObject:to forKey:@"to"];
            [m setObject:chatid forKey:@"id"];
        }
        //
        if(fileObj.length>0)
        {
            [m setObject:fileObj forKey:@"attachment"];
        }
        //10-5-14
        double disPatchTimeStamp =  [[[message elementForName:@"sendTimestampDate"] stringValue] doubleValue];
        NSDate *disPatchTimestamp = [[NSDate  alloc] initWithTimeIntervalSince1970: disPatchTimeStamp];
        [m setObject:disPatchTimestamp forKey:@"sendTimestampDate"];
        //black message
        if([[NSString stringWithFormat:@"%@",message] rangeOfString:@"blackMessage"].length>0)
        {
            [m setObject:@"yes" forKey:@"blackMessage"];
        }
        //black message end
        
        //end
       
        //19-5-14
        NSDate *timestamp = [NSDate date];
        [m setObject:timestamp forKey:@"timestamp"];
        //end

        if([msg rangeOfString:@"{/"].length>0)
        {
            msg = @"Sticker";
        }
        else if([msg rangeOfString:@"(/"].length>0)
        {
            //        msg = body;
            msg = [msg stringByReplacingOccurrencesOfString:@"(/" withString:@""];
            msg = [msg stringByReplacingOccurrencesOfString:@")" withString:@""];
        }
        else if([msg rangeOfString:@"[/"].length>0)
        {
            //        msg = body;
            msg = [msg stringByReplacingOccurrencesOfString:@"[/" withString:@""];
            msg = [msg stringByReplacingOccurrencesOfString:@"]" withString:@""];
        }
        
        else
        {
            msg = [[msg componentsSeparatedByString:@"/"] objectAtIndex:0];
        }
        if([type isEqualToString:@"chat"])
        {
            if([[NSString stringWithFormat:@"%@",message] rangeOfString:@"blackMessage"].length==0)
            {
//                FriendsDetails *friend = [[Database database] fetchDataFromDatabaseForEntity:@"FriendsDetails" chatUserName:[[[message fromStr] componentsSeparatedByString:@"@"] objectAtIndex:0] keyName:kchatUserName];
//                NSLog(@"%@",friend);
                // message counter
                NSMutableArray *array = nil;
//                if(friend!=nil)
//                {
                    if([[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_COUNTER])
                    {
                        array =  [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_COUNTER]];
                        
                    }
                    else
                    {
                        array = [[NSMutableArray alloc] init];
                    }
                
                
                    [array addObject:[[[m objectForKey:@"sender"] componentsSeparatedByString:@"/"] objectAtIndex:0]];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithArray:array] forKey:MESSAGE_COUNTER];
//                }
//                
//                if(friend!=nil)
//                {
                    if([[m objectForKey:@"sender"]rangeOfString:@"/"].length>0 )
                    {
//                        double disPatchTimeStamp =  [[[message elementForName:@"sendTimestampDate"] stringValue] doubleValue];
//                        NSDate *Timestamp = [[NSDate  alloc] initWithTimeIntervalSince1970: disPatchTimeStamp];
//                        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:friend.chatUserName,kchatUserName,msg,@"message",Timestamp,@"sendDate", nil];
//                        [[Database database]addMessage:dictionary withMessage:msg];
                    }
//                }
//                else
//                {
//                    NSMutableArray *arrLastMessage = nil;
//                    NSDictionary *dictionary = nil;
//                    BOOL isAvail = NO;
//                    if([[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_LAST])
//                    {
//                        arrLastMessage = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_LAST]];
//                    }
//                    else
//                    {
//                        arrLastMessage = [[NSMutableArray alloc] init];
//                    }
//                    for(NSMutableDictionary *dict in arrLastMessage)
//                    {
//                        if([[dict objectForKey:@"chatUserName"]isEqualToString:[[[message fromStr] componentsSeparatedByString:@"@"] objectAtIndex:0]])
//                        {
//                            isAvail = YES;
//                            int index = [arrLastMessage indexOfObject:dict];
//                            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:msg,@"message",[[[message fromStr] componentsSeparatedByString:@"@"] objectAtIndex:0],kchatUserName, nil];
//                            [arrLastMessage replaceObjectAtIndex:index withObject:dictionary];
//                            break;
//                        }
//                    }
//                    if(!isAvail)
//                    {
//                        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:msg,@"message",[[[message fromStr] componentsSeparatedByString:@"@"] objectAtIndex:0],kchatUserName, nil];
//                        [arrLastMessage addObject:dictionary];
//                    }
//                    
//                    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithArray:arrLastMessage] forKey:MESSAGE_LAST];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
//
//                }
                [messageDelegate newMessageReceived:m];
            }

        }
        else
        {
                if([[m objectForKey:@"sender"]rangeOfString:@"/"].length>0 )
                {
                    // message counter
                    NSMutableArray *array = nil;
                    if([[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_COUNTER])
                    {
                        array =  [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_COUNTER]];
                        
                    }
                    else
                    {
                        array = [[NSMutableArray alloc] init];
                    }
                    [array addObject:[[[m objectForKey:@"sender"] componentsSeparatedByString:@"/"] objectAtIndex:0]];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithArray:array] forKey:MESSAGE_COUNTER];
                    
                    
                    //last message
                    NSMutableArray *arrLastMessage = nil;
                    NSDictionary *dictionary = nil;
                    
                    if([[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_LAST])
                    {
                        arrLastMessage = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_LAST]];
                    }
                    else
                    {
                        arrLastMessage = [[NSMutableArray alloc] init];
                    }
                    NSString *imgString    = @"";
                    NSString *groupId       = @"";
                    NSString *groupName = @"";
                    for(NSDictionary *dict in arrLastMessage)
                    {
                        if([[dict objectForKey:@"chatUserName"]isEqualToString:[[[message fromStr] componentsSeparatedByString:@"/"] objectAtIndex:0]])
                        {
                            imgString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"profilePic"]];
                            groupId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
                            groupName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fullName"]];
                            [arrLastMessage removeObject:dict];
                            break;
                        }
                    }
                    
                    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:groupName,@"fullName",imgString,@"profilePic",[[[message fromStr] componentsSeparatedByString:@"/"] objectAtIndex:0],@"chatUserName",msg,@"message",groupId,@"userId",@"groupchat",@"type", nil];
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:arrLastMessage];
                    [arrLastMessage removeAllObjects];
                    [arrLastMessage addObject:dictionary];
                    [arrLastMessage addObjectsFromArray:tempArray];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithArray:arrLastMessage] forKey:MESSAGE_LAST];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            [messageDelegate newGroupMessageReceived:m];
        }
    }
    
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@\n%@", THIS_FILE, THIS_METHOD, presence,[presence fromStr]);
    if([[presence attributeStringValueForName:@"type"]isEqualToString:@"unsubscribe"])
    {
        // flush message counter for blocked user

        NSMutableArray *array =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_COUNTER]];
        [array removeObject:[[[presence fromStr] componentsSeparatedByString:@"/"] objectAtIndex:0]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithArray:array] forKey:MESSAGE_COUNTER];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [xmppRoster unsubscribePresenceFromUser:presence.from];

        [messageDelegate userPresence:[NSDictionary dictionaryWithObject:[presence fromStr] forKey:@"UNSUBSCRIBE"]];
        

        //
        return;
    }
    if([[presence attributeStringValueForName:@"type"]isEqualToString:@"unavailable"])
    {
		if([messageDelegate respondsToSelector:@selector(userPresence:)])
		{
			[messageDelegate userPresence:[NSDictionary dictionaryWithObject:presence forKey:@"unavailable"]];
		}
        return;
    }
//    [messageDelegate userPresence:[NSDictionary dictionaryWithObject:[presence fromStr] forKey:@"presence"]];
    if([[presence fromStr]isEqualToString:[presence toStr]])
    {
        isConnected = YES;
//        [self resendDisputedMessage:nil  andCompletionHandler:^(BOOL success)
//         {
//             if (success)
//             {
//                 NSLog(@"Message Resend Done");
//             }
//             else
//             {
//                 NSLog(@"Message Resend failed");
//
//             }
//
//         }];
        if([[UIApplication sharedApplication] applicationState]==UIApplicationStateBackground)
        {
            //            DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
            if([[NSString stringWithFormat:@"%@",presence] rangeOfString:@"away"].length>0)
            {
                //
            }
            else
            {
                AppDelegate *del = APP_DELEGATE;
                [del sendPresence:@"away"];
                
            }
        }
//        [messageDelegate userPresence:[NSDictionary dictionaryWithObject:@"anonymoususer" forKey:@"AUSER"]];
    }
#pragma mark - XMPP message status
    else
    {
        if([[NSString stringWithFormat:@"%@",presence] rangeOfString:@"online"].length>0)
        {
//            [self resendDisputedMessage:[[[presence fromStr] componentsSeparatedByString:@"/"] objectAtIndex:0] andCompletionHandler:^(BOOL success) {
//                if(success)
//                {
//                    NSLog(@"Message Resend Done");
//                }
//                else
//                {
//                    NSLog(@"Message Resend failed");
//                    
//                }
//
//            }];
        }
    }
#pragma end
    if([messageDelegate respondsToSelector:@selector(userPresence:)])
    {
        [messageDelegate userPresence:[NSDictionary dictionaryWithObject:presence forKey:@"NORMAL"]];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"USERPRESENCE" object:nil userInfo:nil];

//    [self performSelector:@selector(sendUserPresence:) withObject:presence afterDelay:0.1];
}
- (void)sendUserPresence:(XMPPPresence *)presence
{
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[presence fromStr],@"from",[presence valueForKey:@"status"],@"type", nil];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHATPRESENCE" object:nil userInfo:dict];
}
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    //nehaa 17-4-14
    isConnected = NO;
    //end 17-4-14
    NSLog(@"%@",error);
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
//    [messageDelegate userPresence:nil];
    //nehaa 26-04-14
    //add this because of server unavailability
    //nehaa 17-4-14
    isConnected = NO;
    //end 17-4-14
    [messageDelegate userPresence:[NSDictionary dictionaryWithObjectsAndKeys:@"Disconnected",@"XmppStatus", nil]];
    
    //end 26-04-14
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
	
}

- (void)xmppMUC:(XMPPMUC *)sender didReceiveRoomInvitation:(XMPPMessage *)message
{
    NSXMLElement * x = [message elementForName:@"x" xmlns:XMPPMUCUserNamespace];
	NSXMLElement * invite  = [x elementForName:@"invite"];
	NSXMLElement * directInvite = [message elementForName:@"x" xmlns:@"jabber:x:conference"];
    NSString *roomJid = [directInvite.attributesAsDictionary objectForKey:@"jid"];
    //    NSLog(@"%@",roomJid);
    if(invite)
    {
        if(xmppRoom)
            xmppRoom = nil;
        xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomCoreDataStorage jid:[XMPPJID jidWithString:roomJid]];
        
        [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
        // xmppRoomStorage automatically inherits the delegate(s) of it's parent xmppRoom
        
        [xmppRoom activate:xmppStream];
        [xmppRoom joinRoomUsingNickname:[NSString stringWithFormat:@"%@",[[[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1] componentsSeparatedByString:@"@"] objectAtIndex:0]] history:nil];
        NSArray *array = [[NSString stringWithFormat:@"%@",[directInvite.children objectAtIndex:0]] componentsSeparatedByString:@"$"];
        NSMutableArray *arrLastMessage = nil;
        NSDictionary *dictionary = nil;
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_LAST])
        {
            arrLastMessage = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGE_LAST]];
        }
        else
        {
            arrLastMessage = [[NSMutableArray alloc] init];
        }
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[array objectAtIndex:0],@"fullName",[array objectAtIndex:2],@"profilePic",roomJid,@"chatUserName",@"",@"message",[array objectAtIndex:1],@"userId",@"groupchat",@"type", nil];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:arrLastMessage];
        [arrLastMessage removeAllObjects];
        [arrLastMessage addObject:dictionary];
        [arrLastMessage addObjectsFromArray:tempArray];
        [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithArray:arrLastMessage] forKey:MESSAGE_LAST];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [messageDelegate userPresence:[NSDictionary dictionaryWithObject:@"hello" forKey:@"key"]];
    }
}
////changed9-9-13 shakir
//
//-(NSString *)removeParaFromMessage:(NSString *)inMsg
//{
//    NSRange msgRange;
//    NSRange aParaRange;
//    NSString *aParaStr;
//    NSString *msg;
//
//    if([inMsg length] > 0)
//    {
//
//        aParaRange = [inMsg rangeOfString:@"/para/"];
//
//        
//        aParaStr = [inMsg substringWithRange: NSMakeRange( aParaRange.location,inMsg.length - aParaRange.location)];
//
//        
//        msgRange = NSMakeRange(0, inMsg.length - aParaStr.length);
//        msg = [inMsg substringWithRange:msgRange];
//    }
//    return  msg;
//}
//
//// change for acknowledgement
//
-(void)doSendMessageAknowledgement:(XMPPMessage *)inXMPMessage
{
    
    //    NSString *inMessage = [[inXMPMessage elementForName:@"body"] stringValue];
    if([[NSString stringWithFormat:@"%@",inXMPMessage]rangeOfString:@"blackMessage"].length>0)
    {
        return;
    }
    
    NSString *to = [[[[inXMPMessage attributeForName:@"from"] stringValue]componentsSeparatedByString:@"/"] objectAtIndex:0];
    NSString *from = [inXMPMessage attributeStringValueForName:@"to"];
    NSString *chatid = [[inXMPMessage attributeForName:@"id"] stringValue];
    
    //    <message from='love107r@api.yaab.ossclients.com/phone' id='' to='tarun025w@api.yaab.ossclients.com/29550781951379616334705365'><received xmlns='urn:xmpp:receipts' id='355299242' type='delivered'/></message>
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"from" stringValue:from];
    [message addAttributeWithName:@"id" stringValue:@""];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addAttributeWithName:@"id" stringValue:chatid];
    
    NSXMLElement *received = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
//    [received addAttributeWithName:@"type" stringValue:@"delivered"];
    [received addAttributeWithName:@"type" stringValue:@"displayed"];
    [received addAttributeWithName:@"chatType" stringValue:@"chat"];

    [received addAttributeWithName:@"id" stringValue:chatid];
    [message addChild:received];
    
    [xmppStream sendElement:message];
    
}
//end
-(void)doAknowledgementServer:(XMPPMessage *)inXMPMessage
{
    
    //    NSString *inMessage = [[inXMPMessage elementForName:@"body"] stringValue];
    NSString *to = [[inXMPMessage attributeForName:@"from"] stringValue];
    NSString *from = [inXMPMessage attributeStringValueForName:@"to"];
    NSString *chatid = [[inXMPMessage attributeForName:@"id"] stringValue];
    
    //    <message from='love107r@api.yaab.ossclients.com/phone' id='' to='tarun025w@api.yaab.ossclients.com/29550781951379616334705365'><received xmlns='urn:xmpp:receipts' id='355299242' type='delivered'/></message>
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"from" stringValue:from];
    [message addAttributeWithName:@"id" stringValue:@""];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addAttributeWithName:@"type" stringValue:@"chatsuccess"];
    [message addAttributeWithName:@"id" stringValue:chatid];

    NSXMLElement *received = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
    //    [received addAttributeWithName:@"type" stringValue:@"delivered"];
    [message addChild:received];
    
    [xmppStream sendElement:message];
    
}
//end

-(void)doSendMessageForGroupAknowledgement:(XMPPMessage *)inXMPMessage
{
    
    //    NSString *inMessage = [[inXMPMessage elementForName:@"body"] stringValue];
    NSString *to = [[inXMPMessage attributeForName:@"from"] stringValue];
    NSString *from = [inXMPMessage attributeStringValueForName:@"to"];
    NSString *chatid = [[inXMPMessage attributeForName:@"id"] stringValue];
    
    //    <message from='love107r@api.yaab.ossclients.com/phone' id='' to='tarun025w@api.yaab.ossclients.com/29550781951379616334705365'><received xmlns='urn:xmpp:receipts' id='355299242' type='delivered'/></message>
    
    XMPPMessage *message = [XMPPMessage message];
    
    [message addAttributeWithName:@"from" stringValue:from];
    [message addAttributeWithName:@"id" stringValue:@""];
    [message addAttributeWithName:@"to" stringValue:to];
    
    NSXMLElement *received = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
    [received addAttributeWithName:@"type" stringValue:@"delivered"];
    [received addAttributeWithName:@"chatType" stringValue:@"group"];
    [received addAttributeWithName:@"id" stringValue:chatid];
    [message addChild:received];
    [xmppStream sendElement:message];
    
    
}


#pragma mark - Last seen activity delegate methods
- (void)xmppLastActivity:(XMPPLastActivity *)sender didReceiveResponse:(XMPPIQ *)response
{
    [messageDelegate ReceiveIQ:response];
}
- (void)xmppLastActivity:(XMPPLastActivity *)sender didNotReceiveResponse:(NSString *)queryID dueToTimeout:(NSTimeInterval)timeout
{
    [messageDelegate ReceiveIQ:nil];
}

//////////////
//- (void)localSaveOccurred:(NSNotification *)notif
//{
//    [self syncWithCompletion:NULL];
//}
//
//- (void)cloudDataDidDownload:(NSNotification *)notif
//{
//    [self syncWithCompletion:NULL];
//}

//- (void)syncWithCompletion:(void(^)(void))completion
//{
//    if (ensemble.isMerging)
//        return;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //    ViewController *viewController = (id)self.window.rootViewController;
//        //    [viewController.activityIndicator startAnimating];
//        if (!ensemble.isLeeched) {
//            [ensemble leechPersistentStoreWithCompletion:^(NSError *error) {
//                if (error) NSLog(@"Error in leech: %@", error);
////todo : call delegate
//                if (completion) completion();
//            }];
//        }
//        else {
//            [ensemble mergeWithCompletion:^(NSError *error) {
//                if (error) NSLog(@"Error in merge: %@", error);
//                //todo : call delegate
//                if (completion) completion();
//            }];
//        }
//    });
//}

#pragma mark - Notification
//-(void)listenerLoggedIn:(NSNotification *)inNotification
//{
//    NSDictionary *aDic = nil;
//    NSString *aUserId = nil;
//    
//    if ([[inNotification name] isEqualToString: kLoggedInDone])
//    {
//        aDic = [inNotification userInfo];
//        aUserId = [aDic objectForKey: kUserId];
//        NSDictionary *dictMessageSetting=[[AppManager getUserAppSettingsFromPlist] valueForKey:KMESSAGES];
//         NSString *strIcloud_BackUp=[dictMessageSetting valueForKey:KICLOUD_BACKUP];
//        if([strIcloud_BackUp intValue]==0)
//        {
//            [Utils showAlertView:@"MEKS" message:@"Do you want to sync your data on iCloud" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel"];
//        }
//        else
//        {
//            [self EnsembleSetup: aUserId andSuccess: YES];
//        }
//    }
//    else if ([[inNotification name] isEqualToString: kLoggedInOut])
//    {
//        aDic = [inNotification userInfo];
//        aUserId = [aDic objectForKey: kUserId];
//
//        [self removeEnsembles];
//        
//    }
//}

//-(void)resendDisputedMessage:(NSString *)chatWithUser andCompletionHandler:(FirsBlock)inFirstBlock
//{
//        NSArray *array = [NSArray arrayWithArray:[[Database database] fetchMessagesForUser:chatWithUser]];
//        int count = [array count];
//        for(MessageStatus *ms in array)
//        {
////            XMPPMessageArchiving_Message_CoreDataObject *messageXmpp = [xmppMessageArchivingModule isAvailableMsgByChatId:ms.chatId outgoing:YES managedObjectContext:messagesStoreMainThreadManagedObjectContext];
//            if (ms.isMedia == [NSNumber numberWithInt:0])
//            {
//                NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
//                
//                [message addAttributeWithName:@"type" stringValue:@"chat"];
//                [message addAttributeWithName:@"id" stringValue:ms.chatId];
//                [message addAttributeWithName:@"to" stringValue:ms.chatWithUser];
//                [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1]];
//                NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//                [body setStringValue:ms.message];//change here
//                NSXMLElement *request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
//                [message addChild:body];
//                [message addChild:request];
//                
////                if([messageXmpp.blackMessage isEqualToString:@"yes"])
////                {
////                    NSXMLElement *blackMessage = [NSXMLElement elementWithName:@"blackMessage"];
////                    [blackMessage setStringValue: @"yes"];
////                    [message addChild:blackMessage];
////                    NSXMLElement *viewFor = [NSXMLElement elementWithName:@"viewFor"];
////                    [viewFor setStringValue:[NSString stringWithFormat:@"%d",messageXmpp.viewFor]];
////                    [message addChild:viewFor];
////                    NSXMLElement *expireIn = [NSXMLElement elementWithName:@"expireIn"];
////                    [expireIn setStringValue:[NSString stringWithFormat:@"%d",messageXmpp.expireIn]];
////                    [message addChild:expireIn];
////                    NSXMLElement *sentToMe = [NSXMLElement elementWithName:@"sentToMe"];
////                    [sentToMe setStringValue:[NSString stringWithFormat:@"%d",messageXmpp.sentToMe]];
////                    [message addChild:sentToMe];
////                }
//                
//                NSXMLElement *sendTimestampDateTag = [NSXMLElement elementWithName:@"sendTimestampDate"];
//                [sendTimestampDateTag setStringValue: ms.sendtimestamp];
//                [message addChild:sendTimestampDateTag];
//                
//                [gCXMPPController.xmppStream sendElement:message];
//            }
//            //10-2-14
//            else if (ms.isMedia == [NSNumber numberWithInt:1])
//            {
//                
//                NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
//                
//                [message addAttributeWithName:@"type" stringValue:@"chat"];
//                [message addAttributeWithName:@"id" stringValue:ms.chatId];
//                [message addAttributeWithName:@"to" stringValue:ms.chatWithUser];
//                
//                
//                [message addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1]];
//                NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//                NSXMLElement *media = [NSXMLElement elementWithName:@"media"];
//                //27-3-14 p
//                NSXMLElement *mediaOrientation = [NSXMLElement elementWithName:KMediaOrientation];
//                [mediaOrientation setStringValue:[NSString stringWithFormat:@"%@",ms.mediaOrientation]];
//                
//                //end
//                
//                
////                if([messageXmpp.blackMessage isEqualToString:@"yes"])
////                {
////                    NSXMLElement *blackMessage = [NSXMLElement elementWithName:@"blackMessage"];
////                    [blackMessage setStringValue: @"yes"];
////                    [message addChild:blackMessage];
////                    NSXMLElement *viewFor = [NSXMLElement elementWithName:@"viewFor"];
////                    [viewFor setStringValue:[NSString stringWithFormat:@"%d",messageXmpp.viewFor]];
////                    [message addChild:viewFor];
////                    NSXMLElement *expireIn = [NSXMLElement elementWithName:@"expireIn"];
////                    [expireIn setStringValue:[NSString stringWithFormat:@"%d",messageXmpp.expireIn]];
////                    [message addChild:expireIn];
////                    NSXMLElement *sentToMe = [NSXMLElement elementWithName:@"sentToMe"];
////                    [sentToMe setStringValue:[NSString stringWithFormat:@"%d",messageXmpp.sentToMe]];
////                    [message addChild:sentToMe];
////                }
////                else
////                {
//                    //nehaa thumbnail
//                    NSXMLElement *thumbBase64String = [NSXMLElement elementWithName:KThumbBase64String];
//                    [thumbBase64String setStringValue:[NSString stringWithFormat:@"%@",ms.thumbBase64String]];
//                    [message addChild:thumbBase64String];
//                    
//                    //end thumbnail
////                }
//                NSXMLElement *filelocalpath = [NSXMLElement elementWithName:@"filelocalpath"];
//                NSXMLElement *fileaction = [NSXMLElement elementWithName:@"fileaction"];
//                NSXMLElement *fileSize = [NSXMLElement elementWithName:@"fileSize"];
//                NSXMLElement *fileName = [NSXMLElement elementWithName:@"fileName"];
//                
//                
//                [media setStringValue:ms.media];
//                
//                NSXMLElement *request = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
//                //11-2-14 2
//                //                    [message addAttributeWithName:@"attachment" stringValue:[dic objectForKey:@"fileserverpath"]];
//                [message addAttributeWithName:@"attachment" stringValue:ms.attachment];
//                //end
//                //9-5-14
//                NSXMLElement *sendTimestampDateTag = [NSXMLElement elementWithName:@"sendTimestampDate"];
//                [sendTimestampDateTag setStringValue: ms.sendtimestamp];
//                [message addChild:sendTimestampDateTag];
//                
//                //end
//                [fileaction setStringValue:@"uploaded"];
//                [filelocalpath setStringValue:ms.filelocalpath];
//                [fileName setStringValue:ms.fileName];
//                [fileSize setStringValue:ms.fileSize];
//                
//                [message addChild:filelocalpath];
//                [message addChild:fileaction];
//                [message addChild:fileSize];
//                [message addChild:fileName];
//                //27-3-14 p
//                [body addChild:mediaOrientation];
//                //end
//                [body addChild:media];
//                [message addChild:body];
//                [message addChild:request];
//                [gCXMPPController.xmppStream sendElement:message];
//            }
//            count--;
//        }
//    if(count==0)
//    {
//        inFirstBlock(YES);
//    }
//    else
//    {
//        inFirstBlock (NO);
//    }
//}
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
}
@end

