#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPCoreDataStorageProtected.h"
#import "XMPPLogging.h"
#import "NSXMLElement+XEP_0203.h"
#import "XMPPMessage+XEP_0085.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

// Log levels: off, error, warn, info, verbose
// Log flags: trace
#if DEBUG
  static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN; // VERBOSE; // | XMPP_LOG_FLAG_TRACE;
#else
  static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif

@interface XMPPMessageArchivingCoreDataStorage ()
{
	NSString *messageEntityName;
	NSString *contactEntityName;
//    NSManagedObjectContext *moct;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation XMPPMessageArchivingCoreDataStorage

static XMPPMessageArchivingCoreDataStorage *sharedInstance;

+ (instancetype)sharedInstance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		sharedInstance = [[XMPPMessageArchivingCoreDataStorage alloc] initWithDatabaseFilename:nil storeOptions:nil];
	});
	
	return sharedInstance;
}

/**
 * Documentation from the superclass (XMPPCoreDataStorage):
 * 
 * If your subclass needs to do anything for init, it can do so easily by overriding this method.
 * All public init methods will invoke this method at the end of their implementation.
 * 
 * Important: If overriden you must invoke [super commonInit] at some point.
**/
- (void)commonInit
{
	[super commonInit];
//	moct = [self managedObjectContext];
	messageEntityName = @"XMPPMessageArchiving_Message_CoreDataObject";
	contactEntityName = @"XMPPMessageArchiving_Contact_CoreDataObject";
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(updateFileDownloadingStatusByChatId:) name:@"fileaction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(setFailedStatusByChatId:) name:@"updateFailedMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(deleteMsgByChatId:) name:@"delete" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(resendDisputedMessage:) name:@"resend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePrivateMsgByChatId:) name:@"deleteprivate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePrivateMessagebyChatId:) name:@"updateViewFor" object:nil];
    //end

}
//30-1-14
-(void)setFailedStatusByChatId:(NSNotification *)inNotification
{
    
    [self scheduleBlock:^{
        
        if ([[inNotification name] isEqualToString:@"updateFailedMsg"])
        {
            NSDictionary *objectDic = [inNotification object];
            NSString *chatid = [objectDic objectForKey:@"chatid"];
            NSManagedObjectContext *moc = [self managedObjectContext];
            XMPPMessageArchiving_Message_CoreDataObject *result = nil;
            
            NSEntityDescription *messageEntity = [self messageEntity:moc];
            // Order matters:
            // 1. composing - most likely not many with it set to YES in database
            // 2. bareJidStr - splits database by number of conversations
            // 3. outgoing - splits database in half
            // 4. streamBareJidStr - might not limit database at all
            
            NSString *predicateFrmt = @"chatid == %@";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,chatid];
            
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            fetchRequest.entity = messageEntity;
            fetchRequest.predicate = predicate;
            fetchRequest.fetchLimit = 1;
            
            NSError *error = nil;
            NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
            
            if (results == nil)
            {
                //                SHLogs(eLLDebugInfo, eLAUI, @"***  ***");
            }
            else
            {
                result = (XMPPMessageArchiving_Message_CoreDataObject *)[results lastObject];
                result.isdelivered = 4;
            }
            
            if (![moc save:&error]) {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
                 */
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
            fetchRequest = nil;
            
        }
    }];
}

//end

/**
 * Documentation from the superclass (XMPPCoreDataStorage):
 * 
 * Override me, if needed, to provide customized behavior.
 * For example, you may want to perform cleanup of any non-persistent data before you start using the database.
 * 
 * The default implementation does nothing.
**/
- (void)didCreateManagedObjectContext
{
	// If there are any "composing" messages in the database, delete them (as they are temporary).
	
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *messageEntity = [self messageEntity:moc];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"composing == YES"];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = messageEntity;
	fetchRequest.predicate = predicate;
	fetchRequest.fetchBatchSize = saveThreshold;
	
	NSError *error = nil;
	NSArray *messages = [moc executeFetchRequest:fetchRequest error:&error];
	
	if (messages == nil)
	{
		XMPPLogError(@"%@: %@ - Error executing fetchRequest: %@", [self class], THIS_METHOD, error);
		return;
	}
	
	NSUInteger count = 0;
	
	for (XMPPMessageArchiving_Message_CoreDataObject *message in messages)
	{
		[moc deleteObject:message];
		
		if (++count > saveThreshold)
		{
			if (![moc save:&error])
			{
				XMPPLogWarn(@"%@: Error saving - %@ %@", [self class], error, [error userInfo]);
				[moc rollback];
			}
		}
	}
	
	if (count > 0)
	{
		if (![moc save:&error])
		{
			XMPPLogWarn(@"%@: Error saving - %@ %@", [self class], error, [error userInfo]);
			[moc rollback];
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Internal API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)willInsertMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message
{
	// Override hook
}

- (void)didUpdateMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message
{
	// Override hook
}

- (void)willDeleteMessage:(XMPPMessageArchiving_Message_CoreDataObject *)message
{
	// Override hook
}

- (void)willInsertContact:(XMPPMessageArchiving_Contact_CoreDataObject *)contact
{
	// Override hook
}

- (void)didUpdateContact:(XMPPMessageArchiving_Contact_CoreDataObject *)contact
{
	// Override hook
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (XMPPMessageArchiving_Message_CoreDataObject *)composingMessageWithJid:(XMPPJID *)messageJid
                                                               streamJid:(XMPPJID *)streamJid
                                                                outgoing:(BOOL)isOutgoing
                                                    managedObjectContext:(NSManagedObjectContext *)moc
{
	XMPPMessageArchiving_Message_CoreDataObject *result = nil;
	
	NSEntityDescription *messageEntity = [self messageEntity:moc];
	
	// Order matters:
	// 1. composing - most likely not many with it set to YES in database
	// 2. bareJidStr - splits database by number of conversations
	// 3. outgoing - splits database in half
	// 4. streamBareJidStr - might not limit database at all
	
	NSString *predicateFrmt = @"composing == YES AND bareJidStr == %@ AND outgoing == %@ AND streamBareJidStr == %@";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,
	                             [messageJid bare], [NSNumber numberWithBool:isOutgoing], [streamJid bare]];
	
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = messageEntity;
	fetchRequest.predicate = predicate;
	fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	fetchRequest.fetchLimit = 1;
	
	NSError *error = nil;
	NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
	
	if (results == nil)
	{
		XMPPLogError(@"%@: %@ - Error executing fetchRequest: %@", THIS_FILE, THIS_METHOD, fetchRequest);
	}
	else
	{
		result = (XMPPMessageArchiving_Message_CoreDataObject *)[results lastObject];
	}
	
	return result;
}
//6-2-14 shakir
- (XMPPMessageArchiving_Message_CoreDataObject *)isAvailableMsgByChatId:(NSString *)inChatId
                                                               outgoing:(BOOL)isOutgoing
                                                   managedObjectContext:(NSManagedObjectContext *)moc
{
	XMPPMessageArchiving_Message_CoreDataObject *result = nil;
	
	NSEntityDescription *messageEntity = [self messageEntity:moc];
	
	// Order matters:
	// 1. composing - most likely not many with it set to YES in database
	// 2. bareJidStr - splits database by number of conversations
	// 3. outgoing - splits database in half
	// 4. streamBareJidStr - might not limit database at all
	
	NSString *predicateFrmt = @"chatid == %@  AND outgoing == %@";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,
                              inChatId, [NSNumber numberWithBool:isOutgoing]];
	
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = messageEntity;
	fetchRequest.predicate = predicate;
	fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	fetchRequest.fetchLimit = 1;
	
	NSError *error = nil;
	NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
	
	if (results == nil)
	{
		XMPPLogError(@"%@: %@ - Error executing fetchRequest: %@", THIS_FILE, THIS_METHOD, fetchRequest);
	}
	else
	{
		result = (XMPPMessageArchiving_Message_CoreDataObject *)[results lastObject];
	}
    
	return result;
}
//end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (XMPPMessageArchiving_Contact_CoreDataObject *)contactForMessage:(XMPPMessageArchiving_Message_CoreDataObject *)msg
{
	// Potential override hook
	
	return [self contactWithBareJidStr:msg.bareJidStr
	                  streamBareJidStr:msg.streamBareJidStr
	              managedObjectContext:msg.managedObjectContext];
}

- (XMPPMessageArchiving_Contact_CoreDataObject *)contactWithJid:(XMPPJID *)contactJid
                                                      streamJid:(XMPPJID *)streamJid
                                           managedObjectContext:(NSManagedObjectContext *)moc
{
	return [self contactWithBareJidStr:[contactJid bare]
	                  streamBareJidStr:[streamJid bare]
	              managedObjectContext:moc];
}

- (XMPPMessageArchiving_Contact_CoreDataObject *)contactWithBareJidStr:(NSString *)contactBareJidStr
                                                      streamBareJidStr:(NSString *)streamBareJidStr
                                                  managedObjectContext:(NSManagedObjectContext *)moc
{
	NSEntityDescription *entity = [self contactEntity:moc];
	
	NSPredicate *predicate;
	if (streamBareJidStr)
	{
		predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ AND streamBareJidStr == %@",
	                                                              contactBareJidStr, streamBareJidStr];
	}
	else
	{
		predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@", contactBareJidStr];
	}
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchLimit:1];
	[fetchRequest setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
	
	if (results == nil)
	{
		XMPPLogError(@"%@: %@ - Fetch request error: %@", THIS_FILE, THIS_METHOD, error);
		return nil;
	}
	else
	{
		return (XMPPMessageArchiving_Contact_CoreDataObject *)[results lastObject];
	}
}

- (NSString *)messageEntityName
{
	__block NSString *result = nil;
	
	dispatch_block_t block = ^{
		result = messageEntityName;
	};
	
	if (dispatch_get_specific(storageQueueTag))
		block();
	else
		dispatch_sync(storageQueue, block);
	
	return result;
}

- (void)setMessageEntityName:(NSString *)entityName
{
	dispatch_block_t block = ^{
		messageEntityName = entityName;
	};
	
	if (dispatch_get_specific(storageQueueTag))
		block();
	else
		dispatch_async(storageQueue, block);
}

- (NSString *)contactEntityName
{
	__block NSString *result = nil;
	
	dispatch_block_t block = ^{
		result = contactEntityName;
	};
	
	if (dispatch_get_specific(storageQueueTag))
		block();
	else
		dispatch_sync(storageQueue, block);
	
	return result;
}

- (void)setContactEntityName:(NSString *)entityName
{
	dispatch_block_t block = ^{
		contactEntityName = entityName;
	};
	
	if (dispatch_get_specific(storageQueueTag))
		block();
	else
		dispatch_async(storageQueue, block);
}

- (NSEntityDescription *)messageEntity:(NSManagedObjectContext *)moc
{
	// This is a public method, and may be invoked on any queue.
	// So be sure to go through the public accessor for the entity name.
	
	return [NSEntityDescription entityForName:[self messageEntityName] inManagedObjectContext:moc];
}

- (NSEntityDescription *)contactEntity:(NSManagedObjectContext *)moc
{
	// This is a public method, and may be invoked on any queue.
	// So be sure to go through the public accessor for the entity name.
	
	return [NSEntityDescription entityForName:[self contactEntityName] inManagedObjectContext:moc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Storage Protocol
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)configureWithParent:(XMPPMessageArchiving *)aParent queue:(dispatch_queue_t)queue
{
	return [super configureWithParent:aParent queue:queue];
}

- (void)archiveMessage:(XMPPMessage *)message outgoing:(BOOL)isOutgoing xmppStream:(XMPPStream *)xmppStream
{
    
    //    if([[message attributeStringValueForName:@"type"]isEqualToString:@"groupchat"] || [[NSString stringWithFormat:@"%@",message]rangeOfString:@"chatstates"].length>0)
    if([message hasChatState])
    {
        return;
    }
    
    // Message should either have a body, or be a composing notification
    
    if ([[[message elementForName:@"body"] stringValue] length] == 0)
    {
        // Message doesn't have a body.
#pragma mark - delivered and displayed updataion by nehaa
        
        if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"delivered"].length>0)
        {
            [self updateArciveForSendingStatus:[[message elementForName:@"received"]attributeStringValueForName:@"id"] :YES :NO];
        }
        if([[NSString stringWithFormat:@"%@",message]rangeOfString:@"displayed"].length>0)
        {
            [self updateArciveForSendingStatus:[[message elementForName:@"received"]attributeStringValueForName:@"id"] :NO :YES];
        }
        
#pragma mark - delivered and displayed updataion end
        return;
    }
    
    [self scheduleBlock:^{
        BOOL isBlackMessage = NO;
        BOOL isMedia = NO;
        if([[message elementForName:@"body"] elementForName:@"media"])
        {
            isMedia = YES;
        }
        if([[NSString stringWithFormat:@"%@",message] rangeOfString:@"blackMessage"].length>0)
        {
            isBlackMessage = YES;
        }
        
        NSManagedObjectContext *moc = [self managedObjectContext];
        
        XMPPJID *myJid = [self myJIDForXMPPStream:xmppStream];
        
        XMPPJID *messageJid = isOutgoing ? [message to] : [message from];
        NSString *msgChatId = [message attributeStringValueForName:@"id"];
        NSString *messageBody = [[message elementForName:@"body"] stringValue];
        
        // Fetch-n-Update OR Insert new message
        
        XMPPMessageArchiving_Message_CoreDataObject *archivedMessage ;
        archivedMessage = [self isAvailableMsgByChatId:msgChatId outgoing:isOutgoing managedObjectContext:moc];
        
        if (archivedMessage == nil)
        {
            archivedMessage=  [self composingMessageWithJid:messageJid
                                                  streamJid:myJid
                                                   outgoing:isOutgoing
                                       managedObjectContext:moc];
        }
        
        XMPPLogVerbose(@"Previous archivedMessage: %@", archivedMessage);
        
        BOOL didCreateNewArchivedMessage = NO;
        if (archivedMessage == nil)
        {
            archivedMessage = (XMPPMessageArchiving_Message_CoreDataObject *)
            [[NSManagedObject alloc] initWithEntity:[self messageEntity:moc]
                     insertIntoManagedObjectContext:nil];
            
            didCreateNewArchivedMessage = YES;
        }
        
        archivedMessage.message = message;
        //			archivedMessage.body = messageBody;
        
        archivedMessage.bareJid = [messageJid bareJID];
        archivedMessage.streamBareJidStr = [myJid bare];
        
        //			NSDate *timestamp = [message delayedDeliveryDate];
        //27-1-14 date issue
        
        //10-4-14
        double disPatchTimeStamp =  [[[message elementForName:@"sendTimestampDate"] stringValue] doubleValue];
        NSDate *disPatchTimestamp = [[NSDate  alloc] initWithTimeIntervalSince1970: disPatchTimeStamp];
        //end
        
        //19-5-14
        if (isOutgoing)
        {
            archivedMessage.timestamp = disPatchTimestamp;
            archivedMessage.dispatchTimestamp = disPatchTimestamp;
            
        }
        else
        {
            archivedMessage.timestamp = [NSDate  date];
            archivedMessage.dispatchTimestamp = disPatchTimestamp;
            
        }
        
        archivedMessage.thread = [[message elementForName:@"thread"] stringValue];
        archivedMessage.isOutgoing = isOutgoing;
        archivedMessage.isComposing = NO;
        archivedMessage.imgstr = [message attachmentStr];
        
        archivedMessage.fileaction = [[message elementForName:@"fileaction"] stringValue];
        
        archivedMessage.filelocalpath = [[message elementForName:@"filelocalpath"] stringValue];
        archivedMessage.fileSize = [[message elementForName:@"fileSize"] stringValue];
        archivedMessage.fileNameWithExt = [[message elementForName:@"fileName"] stringValue];
        if(isBlackMessage)
        {
            archivedMessage.blackMessage = @"yes";
            archivedMessage.expireIn = [[[message elementForName:@"expireIn"] stringValue] intValue];
            archivedMessage.viewFor = [[[message elementForName:@"viewFor"] stringValue] intValue];
            archivedMessage.sentToMe = [[[message elementForName:@"sentToMe"] stringValue] intValue];
        }
        else
        {
            archivedMessage.blackMessage = @"no";
        }
        if([[NSString stringWithFormat:@"%@",message] rangeOfString:@"konnect"].length>0)
        {
            archivedMessage.konnect = YES;
        }
        else
        {
            archivedMessage.konnect = NO;
        }
        
        if(isMedia)
        {
            archivedMessage.mediaType = [[[message elementForName:@"body"] elementForName:@"media"] stringValue];
            //27-3-14 p
            archivedMessage.isPortrait = [[[[message elementForName:@"body"] elementForName:KMediaOrientation] stringValue] integerValue];
            //end
            
            //nehaa thumbnail
            archivedMessage.thumbBase64String = [[message elementForName: KThumbBase64String] stringValue];
            //end thumbnail
        }
        else
        {
            archivedMessage.body = messageBody;
        }
        
        XMPPLogVerbose(@"New archivedMessage: %@", archivedMessage);
        archivedMessage.chatid = msgChatId;
        if(isOutgoing)
        {
            archivedMessage.isdelivered = 0;
        }
        archivedMessage.isdisplayed = NO;
        
        
        if (didCreateNewArchivedMessage) // [archivedMessage isInserted] doesn't seem to work
        {
            XMPPLogVerbose(@"Inserting message...");
            
            [archivedMessage willInsertObject];       // Override hook
            [self willInsertMessage:archivedMessage]; // Override hook
            [moc insertObject:archivedMessage];
        }
        else
        {
            XMPPLogVerbose(@"Updating message...");
            
            [archivedMessage didUpdateObject];       // Override hook
            [self didUpdateMessage:archivedMessage]; // Override hook
        }
        
        // Create or update contact (if message with actual content)
        
        if ([messageBody length] > 0)
        {
            BOOL didCreateNewContact = NO;
            
            XMPPMessageArchiving_Contact_CoreDataObject *contact = [self contactForMessage:archivedMessage];
            XMPPLogVerbose(@"Previous contact: %@", contact);
            
            if (contact == nil)
            {
                contact = (XMPPMessageArchiving_Contact_CoreDataObject *)
                [[NSManagedObject alloc] initWithEntity:[self contactEntity:moc]
                         insertIntoManagedObjectContext:nil];
                
                didCreateNewContact = YES;
            }
            
            contact.streamBareJidStr = archivedMessage.streamBareJidStr;
            contact.bareJid = archivedMessage.bareJid;
            
            contact.mostRecentMessageTimestamp = archivedMessage.timestamp;
            contact.mostRecentMessageBody = archivedMessage.body;
            contact.mostRecentMessageOutgoing = [NSNumber numberWithBool:isOutgoing];
            if(!isOutgoing)
            {
                contact.imgURL = [[message elementForName:@"imgURL"] stringValue];
                contact.nickname = [[message elementForName:@"fullName"] stringValue];
                contact.userId = [[message elementForName:@"userId"] stringValue];
            }
            XMPPLogVerbose(@"New contact: %@", contact);
            
            if (didCreateNewContact) // [contact isInserted] doesn't seem to work
            {
                XMPPLogVerbose(@"Inserting contact...");
                
                [contact willInsertObject];       // Override hook
                [self willInsertContact:contact]; // Override hook
                [moc insertObject:contact];
            }
            else
            {
                XMPPLogVerbose(@"Updating contact...");
                
                [contact didUpdateObject];       // Override hook
                [self didUpdateContact:contact]; // Override hook
            }
        }
        //		}
    }];
}


-(void)updateArciveForSendingStatus :(NSString *)inSendingId :(BOOL)isDelivered :(BOOL)isDisplayed
{

[self scheduleBlock:^{
   NSManagedObjectContext *moc = [self managedObjectContext];
    XMPPMessageArchiving_Message_CoreDataObject *result = nil;
    
    NSEntityDescription *messageEntity = [self messageEntity:moc];
    
    // Order matters:
    // 1. composing - most likely not many with it set to YES in database
    // 2. bareJidStr - splits database by number of conversations
    // 3. outgoing - splits database in half
    // 4. streamBareJidStr - might not limit database at all
    
    NSString *predicateFrmt = @"chatid == %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,inSendingId];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = messageEntity;
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    
    if (results == nil)
    {
        XMPPLogError(@"%@: %@ - Error executing fetchRequest: %@", THIS_FILE, THIS_METHOD, fetchRequest);
    }
    else
    {
        result = (XMPPMessageArchiving_Message_CoreDataObject *)[results lastObject];
        result.chatid = inSendingId;
        if(isDisplayed)
        {
            if(result.isdisplayed == 0)
            {
                result.isdelivered = 3;
                result.isdisplayed = isDisplayed;
            }
        }
        else
        {
            if(result.isdelivered == 0)
            {
                result.isdisplayed = isDisplayed;
                result.isdelivered = 2;
            }
        }
    }
    
        [result didUpdateObject];       // Override hook
        [self didUpdateMessage:result];

}];
}
-(void)updateFileDownloadingStatusByChatId:(NSNotification *)inNotification
{
    [self scheduleBlock:^{
        
        if ([[inNotification name]isEqualToString:@"fileaction"])
        {
            NSDictionary *objectDic = [inNotification object];
            NSString *chatid = [objectDic objectForKey:@"chatid"];
            NSString *fileaction = [objectDic objectForKey:@"fileaction"];
            NSString *filelocalpath = [objectDic objectForKey:@"filelocalpath"];
            
            NSManagedObjectContext *moc = [self managedObjectContext];
            XMPPMessageArchiving_Message_CoreDataObject *result = nil;
            
            NSEntityDescription *messageEntity = [self messageEntity:moc];
            
            // Order matters:
            // 1. composing - most likely not many with it set to YES in database
            // 2. bareJidStr - splits database by number of conversations
            // 3. outgoing - splits database in half
            // 4. streamBareJidStr - might not limit database at all
            
            NSString *predicateFrmt = @"chatid == %@";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,chatid];
            
            //    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            fetchRequest.entity = messageEntity;
            fetchRequest.predicate = predicate;
            //    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            fetchRequest.fetchLimit = 1;
            
            NSError *error = nil;
            NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
            
            if (results == nil)
            {
                XMPPLogError(@"%@: %@ - Error executing fetchRequest: %@", THIS_FILE, THIS_METHOD, fetchRequest);
            }
            else
            {
                result = (XMPPMessageArchiving_Message_CoreDataObject *)[results lastObject];
                result.chatid = chatid;
                result.fileaction = fileaction;
                result.filelocalpath = filelocalpath;
                
            }
            [result didUpdateObject];       // Override hook
            [self didUpdateMessage:result];
//            if (![moct save:&error]) {
//                /*
//                 Replace this implementation with code to handle the error appropriately.
//                 
//                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//                 */
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            }
            
            
        }
    }];
}

//28-2-14
-(void)deleteMsgByChatId:(NSNotification *)inNotification
{
    [self scheduleBlock:^{
        
        if ([[inNotification name]isEqualToString:@"delete"])
        {
            NSDictionary *objectDic = [inNotification object];
            NSString *chatid = [objectDic objectForKey:@"chatid"];
            
            NSManagedObjectContext *moc = [self managedObjectContext];
            XMPPMessageArchiving_Message_CoreDataObject *result = nil;
            
            NSEntityDescription *messageEntity = [self messageEntity:moc];
            
            // Order matters:
            // 1. composing - most likely not many with it set to YES in database
            // 2. bareJidStr - splits database by number of conversations
            // 3. outgoing - splits database in half
            // 4. streamBareJidStr - might not limit database at all
            
            NSString *predicateFrmt = @"chatid == %@";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,chatid];
            
            //    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            fetchRequest.entity = messageEntity;
            fetchRequest.predicate = predicate;
            //    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            fetchRequest.fetchLimit = 1;
            
            NSError *error = nil;
            result = [[moc executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
            
            if (result == nil)
            {
                XMPPLogError(@"%@: %@ - Error executing fetchRequest: %@", THIS_FILE, THIS_METHOD, fetchRequest);
            }
            else
            {
                [moc deleteObject: result];
            }
            
//            if (![moct save:&error]) {
//                /*
//                 Replace this implementation with code to handle the error appropriately.
//                 
//                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//                 */
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            }
            
            
        }
    }];
}
#pragma mark - XMPP message status

#pragma end
- (void)deletePrivateMsgByChatId:(NSNotification *)inNotification
{
    [self scheduleBlock:^{
        
        if ([[inNotification name]isEqualToString:@"deleteprivate"])
        {
            NSDictionary *objectDic = [inNotification object];
            NSMutableArray *chatid = [objectDic objectForKey:@"chatids"];
            
            NSManagedObjectContext *moc = [self managedObjectContext];
            XMPPMessageArchiving_Message_CoreDataObject *result = nil;
            
            NSEntityDescription *messageEntity = [self messageEntity:moc];
            
            // Order matters:
            // 1. composing - most likely not many with it set to YES in database
            // 2. bareJidStr - splits database by number of conversations
            // 3. outgoing - splits database in half
            // 4. streamBareJidStr - might not limit database at all
            NSString *predicateFrmt =  @"chatid == %@";
            NSPredicate *predicate = nil;
            NSFetchRequest *fetchRequest = nil;
            
            for(int i=0;i<[chatid count];i++)
            {
                fetchRequest = [[NSFetchRequest alloc] init];
                predicate = [NSPredicate predicateWithFormat:predicateFrmt,[chatid objectAtIndex:i]];
                
                //    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
                
                fetchRequest.entity = messageEntity;
                fetchRequest.predicate = predicate;
                //    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                fetchRequest.fetchLimit = 1;
                
                NSError *error = nil;
                result = [[moc executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
                
                if (result == nil)
                {
                    XMPPLogError(@"%@: %@ - Error executing fetchRequest: %@", THIS_FILE, THIS_METHOD, fetchRequest);
                }
                else
                {
                    [moc deleteObject: result];
                }
                
                if (![moc save:&error]) {
                    /*
                     Replace this implementation with code to handle the error appropriately.
                     
                     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
                     */
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
                predicate = nil;
                fetchRequest = nil;
                result = nil;
            }
            
        }
    }];
}

- (void)updatePrivateMessagebyChatId:(NSNotification *)inNotification
{
    [self scheduleBlock:^{

        if ([[inNotification name]isEqualToString:@"updateViewFor"])
        {
            NSDictionary *objectDic = [inNotification object];
            NSString *chatid = [objectDic objectForKey:@"chatid"];
            int viewFor = [[objectDic objectForKey:@"viewFor"] intValue];
            
            NSManagedObjectContext *moc = [self managedObjectContext];
            XMPPMessageArchiving_Message_CoreDataObject *result = nil;
            
            NSEntityDescription *messageEntity = [self messageEntity:moc];
            
            // Order matters:
            // 1. composing - most likely not many with it set to YES in database
            // 2. bareJidStr - splits database by number of conversations
            // 3. outgoing - splits database in half
            // 4. streamBareJidStr - might not limit database at all
            
            NSString *predicateFrmt = @"chatid == %@";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,chatid];
            
            //    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            fetchRequest.entity = messageEntity;
            fetchRequest.predicate = predicate;
            //    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            fetchRequest.fetchLimit = 1;
            
            NSError *error = nil;
            NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
            
            if (results == nil)
            {
                XMPPLogError(@"%@: %@ - Error executing fetchRequest: %@", THIS_FILE, THIS_METHOD, fetchRequest);
            }
            else
            {
                result = (XMPPMessageArchiving_Message_CoreDataObject *)[results lastObject];
                result.chatid = chatid;
                result.viewFor = viewFor;
            }
            
            if (![moc save:&error]) {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
                 */
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }];
}
- (void)deleteHistory:(NSString*)frndJID
{
    [self scheduleBlock:^{
        
        NSManagedObjectContext *moc = [self managedObjectContext];
        NSEntityDescription *messageEntity = [self messageEntity:moc];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ AND streamBareJidStr == %@",frndJID, [[NSUserDefaults standardUserDefaults] valueForKey:kXMPPmyJID1]];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = messageEntity;
        fetchRequest.predicate = predicate;
        fetchRequest.fetchBatchSize = saveThreshold;
        
        NSError *error = nil;
        NSArray *messages = [moc executeFetchRequest:fetchRequest error:&error];
        
        if (messages == nil)
        {
            XMPPLogError(@"%@: %@ - Error executing fetchRequest: %@", [self class], THIS_METHOD, error);
            return;
        }
            
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messages)
        {
            [moc deleteObject:message];
        }
	}];
}
@end
