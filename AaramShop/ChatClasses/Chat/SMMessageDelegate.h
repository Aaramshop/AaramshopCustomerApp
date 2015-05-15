//
//  SMMessageDelegate.h
//  jabberClient
//
//  Created by cesarerocchi on 8/2/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPIQ.h"

@protocol SMMessageDelegate
- (void)newMessageReceived:(NSDictionary *)messageContent;
- (void)newGroupMessageReceived:(NSDictionary *)messageContent;
- (void)newPrivateMessageReceived:(NSDictionary *)messageContent;
- (void)isDelivered:(NSDictionary *)messageContent;
- (void)userPresence:(NSDictionary *)presence;
- (void)ReceiveIQ:(XMPPIQ *)IQ;
- (void)StopAudioRecorder;
//27-1-14 displayed
- (void)isDisplayed:(NSDictionary *)messageContent;
//end

@end
