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
#import <CoreData/CoreData.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate>
{
CLGeocoder *geocoder;
}


// Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) CLLocation *myCurrentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic,  strong) NSArray *arrOptions;
-(id)getDateAndFromString:(NSString *)strDate andDate:(NSDate *)date needSting:(BOOL)needString dateFormat:(NSString *)dateFormat;


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

