#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XMPP.h"



@interface XMPPMessageArchiving_Message_CoreDataObject : NSManagedObject

@property (nonatomic, strong) XMPPMessage * message;  // Transient (proper type, not on disk)
@property (nonatomic, strong) NSString * messageStr;  // Shadow (binary data, written to disk)

/**
 * This is the bare jid of the person you're having the conversation with.
 * For example: robbiehanson@deusty.com
 * 
 * Regardless of whether the message was incoming or outgoing,
 * this will represent the "other" participant in the conversation.
**/
@property (nonatomic, strong) XMPPJID * bareJid;      // Transient (proper type, not on disk)
@property (nonatomic, strong) NSString * bareJidStr;  // Shadow (binary data, written to disk)

@property (nonatomic, strong) NSString * body;
@property (nonatomic, strong) NSString * thread;

@property (nonatomic, strong) NSNumber * outgoing;    // Use isOutgoing
@property (nonatomic, assign) BOOL isOutgoing;        // Convenience property

@property (nonatomic, strong) NSNumber * composing;   // Use isComposing
@property (nonatomic, assign) BOOL isComposing;       // Convenience property

@property (nonatomic, strong) NSDate * timestamp;

@property (nonatomic, strong) NSString * streamBareJidStr;
@property (nonatomic) int16_t  viewFor;
@property (nonatomic) int16_t expireIn;
@property (nonatomic) int16_t sentToMe;

@property (nonatomic, assign) BOOL konnect; // konnect messages


//19-5-14
@property (nonatomic, strong) NSDate * dispatchTimestamp;
//end
@property (nonatomic, strong) NSString * imgstr;
@property (nonatomic, strong) NSString * chatid;
@property (nonatomic, strong) NSString * mediaType;
@property (nonatomic) int16_t isdelivered;
@property (nonatomic, assign) BOOL       isdisplayed;
@property (nonatomic, strong) NSString * filelocalpath;
@property (nonatomic, strong) NSString * fileaction;
@property (nonatomic, strong) NSString * fileSize;
@property (nonatomic, strong) NSString * fileNameWithExt;
@property (nonatomic, strong) NSString *blackMessage;

//27-3-14 p
@property (nonatomic,assign) int16_t isPortrait;
//end
//nehaa thumbnail
@property (nonatomic,strong) NSString *thumbBase64String;
//end thumbnail

/**
 * This method is called immediately before the object is inserted into the managedObjectContext.
 * At this point, all normal properties have been set.
 * 
 * If you extend XMPPMessageArchiving_Message_CoreDataObject,
 * you can use this method as a hook to set your custom properties.
**/
- (void)willInsertObject;

/**
 * This method is called immediately after the message has been changed.
 * At this point, all normal properties have been updated.
 * 
 * If you extend XMPPMessageArchiving_Message_CoreDataObject,
 * you can use this method as a hook to set your custom properties.
**/
- (void)didUpdateObject;

@end
