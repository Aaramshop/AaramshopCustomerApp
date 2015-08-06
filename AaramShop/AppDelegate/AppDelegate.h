//
//  AppDelegate.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreLocation/CoreLocation.h>
#import "SMChatViewController.h"
#import <CoreData/CoreData.h>
#import "StoreModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate>
{
//	CLGeocoder *geocoder;
	UIBackgroundTaskIdentifier bgTask;
	__weak NSObject <SMMessageDelegate> *_messageDelegate;

}


// Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, strong) CLLocation *myCurrentLocation;
//@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic,  strong) NSArray *arrOptions;
@property (nonatomic, strong) UITabBarController *tabBarControllerRetailer;
@property (nonatomic, strong) StoreModel *objStoreModel;
-(id)getDateAndFromString:(NSString *)strDate andDate:(NSDate *)date needSting:(BOOL)needString dateFormat:(NSString *)dateFormat;
//-(void)findCurrentLocation;

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
#pragma mark - Tab bar Retailer Methods
- (UITabBarController *)createTabBarRetailer;
- (void)removeTabBarRetailer;
@end

