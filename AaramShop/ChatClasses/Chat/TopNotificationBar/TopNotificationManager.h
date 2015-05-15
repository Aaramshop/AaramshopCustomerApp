//
//  JHNotificationManager.h
//  Notification
//
//  Created by Jeff Hodnett on 13/09/2011.
//  Copyright 2011 Applausible. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TopNotificationManager : NSObject {
    
@private
    // The notificatin views array
    NSMutableArray *notificationQueue;
    
    // Are we showing a notification
    BOOL showingNotification;
}
@property (nonatomic, retain)NSMutableArray *arrFriends;
@property (nonatomic, retain)UIView *notificationView;
+(TopNotificationManager *)sharedManager;

+(void)notificationWithMessage:(NSDictionary *)message;

-(void)addNotificationViewWithMessage:(NSDictionary *)message;
-(void)showNotificationView:(UIView *)notificationView;

@end
