//
//  AppDelegate.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SMChatViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate>
{
CLGeocoder *geocoder;
    
        
    
}


@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) UINavigationController *navController;
@property (nonatomic, strong) CLLocation *myCurrentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;


#pragma mark - chat
@property(nonatomic,assign)BOOL isChatViewOpened;
@property (strong, nonatomic) NSMutableDictionary *AllChatViewConDic;
@property (nonatomic, strong) SMChatViewController *chatViewController;

-(void)setChatWindowOpenedStatusBySender:(NSString*)inSender andBool:(BOOL)inBool;

-(BOOL)getChatWindowOpenedStatusBySender:(NSString*)inSender;
-(SMChatViewController *)createChatViewByChatUserNameIfNeeded:(NSString *)inChatUser;

-(void)releaseChatViewByChatUserNameIfNeeded:(NSString *)inChatUser;

-(SMChatViewController *)getChatViewDelegateByChatUserName:(NSString *)inChatUser;
-(void)sendPresence:(NSString *)type;
//-(BOOL)openChatViewfromNotificationViewByFriendDetail:(AddressBookDB *)inFrndDetail;
-(BOOL)openChatViewfromNotificationViewByFriendDetailAnonymous:(NSString *)inFrndDetail;

@end

