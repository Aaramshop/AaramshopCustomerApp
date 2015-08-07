//
//  AppDelegate.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "HomeSecondViewController.h"
#import "ChatViewController.h"
#import "RetailerShoppingListViewController.h"
#import "RetailerOfferViewController.h"
#import "OrderHistViewController.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface AppDelegate ()
{
    Reachability *aReachability;
}
@end

@implementation AppDelegate
@synthesize navController,myCurrentLocation,arrOptions,isLoggedIn;
@synthesize tabBarControllerRetailer = _tabBarControllerRetailer;
@synthesize objStoreModel = _objStoreModel;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [Fabric with:@[CrashlyticsKit]];
    [self initializeAllSingletonObjects];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
	isLoggedIn = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor blackColor]];
   /////remote notification code
	
	if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"])
	{
		[[NSUserDefaults standardUserDefaults] setValue:@"3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0" forKey:kDeviceId];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	}
	else
	{
		if(![[NSUserDefaults standardUserDefaults]valueForKey:kDeviceId])
		{
			[[NSUserDefaults standardUserDefaults] setValue:@"1234567890" forKey:kDeviceId];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		
		if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
		{
			[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
			
			//            [[UIApplication sharedApplication] registerForRemoteNotifications];
		}
		else
		{
			[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
			 (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
			
		}
		
		
	}
	
	//////////////remote notification code end//////////////////
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kIsLoggedIn] == YES) {
        [[AppManager sharedManager] performSelector:@selector(fetchAddressBookWithContactModel) withObject:nil];

    }

    arrOptions = [NSArray arrayWithObjects:@"Home Address",@"Office Address", @"Others", nil];
    [self registerDeviceForDeviceToken:application];
//    [self findCurrentLocation];

    NSLog(@"value =%f",[UIScreen mainScreen].bounds.size.height);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:kLoginSuccessfulNotificationName object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:kLogoutSuccessfulNotificationName object:nil];
    
	if ([[NSUserDefaults standardUserDefaults] valueForKey:kUserId] && [[[NSUserDefaults standardUserDefaults] valueForKey:kUserId]length]>0 && [[NSUserDefaults standardUserDefaults] boolForKey:kIsLoggedIn]==YES /*&& [[[NSUserDefaults standardUserDefaults] valueForKey:kIs_active] integerValue]==1*/)
	{
		[self loginSuccessful:nil];
	}else{
		[self logout:nil];
	}

	
    return YES;
}
//-(void)findCurrentLocation
//{
//    
//    locationManager = [[CLLocationManager alloc] init];
//    geocoder = [[CLGeocoder alloc] init];
//    
//    if ([CLLocationManager locationServicesEnabled])
//    {
//        locationManager.delegate = self;
//        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//            [locationManager requestWhenInUseAuthorization];
//        }
//        [locationManager startUpdatingLocation];
//        
//    }
//}
#pragma mark - Register Device For Device Token
#pragma mark - Remote Notification Methods
- (void)application:(UIApplication *)application   didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
	//register to receive notifications
	[application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	[[NSUserDefaults standardUserDefaults] setValue:deviceTokenStr forKey:kDeviceId];
	[[NSUserDefaults standardUserDefaults] synchronize];
	// NSLog(@"Registered");
	
	NSLog(@"Device Token: %@ ", deviceTokenStr);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
	//    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
	// NSLog(@"Fail To Register for Push Notification.");
	
	[[NSUserDefaults standardUserDefaults] setValue:@"3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0" forKey:kDeviceId];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"%@ Fail to get register",err);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	// NSLog(@"%@",[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]);
	
	
	//When app is active than only home screen counts should be refreshed
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
		
	}// If app is in Background or in inactive state than in this case we have to open NotificationViewcontroller or friend request received
	else
	{
		NSInteger badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
	}
	
}

//#pragma mark - CLLocationManagerDelegate
//
//- (void)locationManager:(CLLocationManager* )manager didFailWithError:(NSError *)error
//{
//    
//}
//
//
//- (void)locationManager:(CLLocationManager* )manager didUpdateLocations:(NSArray* )locations
//{
//    CLLocation* newLocation = [locations lastObject];
//    
//    [self getUpdatedLocation:newLocation];
//}
//
//
//-(void)getUpdatedLocation:(CLLocation *)newLocation
//{
//    myCurrentLocation = newLocation;
//	[locationManager stopUpdatingLocation];
//}

#pragma mark - Core Data stack

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
 return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AaramShop" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AaramShop.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSDictionary *options =
    @{
      NSMigratePersistentStoresAutomaticallyOption:@YES
      ,NSInferMappingModelAutomaticallyOption:@YES
      };
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


 #pragma mark - Register Device For Device Token
-(void)registerDeviceForDeviceToken:(UIApplication *)application
{
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0" forKey:kDeviceId];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
        {
#ifdef __IPHONE_8_0
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                                 |UIRemoteNotificationTypeSound
                                                                                                 |UIRemoteNotificationTypeAlert) categories:nil];
            [application registerUserNotificationSettings:settings];
#endif
        }
        else {
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            [application registerForRemoteNotificationTypes:myTypes];
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	if([Utils isInternetAvailable])
	{
		[self sendPresence:@"away"];
	}
	[self performSelector:@selector(disconnectXmpp) withObject:nil afterDelay:300];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"STOPAUDIO" object:nil];
	//7-3-14
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
	NSMutableArray *aPasteArr =  [NSMutableArray arrayWithArray: [pb strings]];
	if ([aPasteArr containsObject:kMESSAGEFORWARD])
	{
		[pb setStrings: Nil];
	}
	//end
	UIApplication *app = [UIApplication sharedApplication];
	bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
		NSLog(@"*****beginBackgroundTaskWithExpirationHandler");
		
		[gCXMPPController disconnect];
		//        XMPPPresence *presence = [XMPPPresence presence];
		//        NSXMLElement *status = [NSXMLElement elementWithName:@"status"];
		//        [status setStringValue:@"busy"];
		//        [presence addChild:status];
		//        [presence addAttributeWithName:@"date" stringValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
		//        [gCXMPPController.xmppStream sendElement:presence];
		[app endBackgroundTask:bgTask];
	}];
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)disconnectXmpp
{
	if([[UIApplication sharedApplication] applicationState]==UIApplicationStateBackground)
	{
		NSLog(@"***** Disconnect xmpp *****");
		
		//        [gCXMPPController disconnect];
		XMPPPresence *presence = [XMPPPresence presence];
		NSXMLElement *status = [NSXMLElement elementWithName:@"status"];
		[status setStringValue:@"busy"];
		[presence addChild:status];
		[presence addAttributeWithName:@"date" stringValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
		[gCXMPPController.xmppStream sendElement:presence];
		
	}
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
	
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	if([Utils isInternetAvailable])
	{
		[self sendPresence:@"online"];
	}

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}
#pragma mark - create TabBar for Retailer
- (UITabBarController *)createTabBarRetailer
{
//	HomeSecondViewController.h
//	ChatViewController.h
//	ShoppingListViewController.h
//	OffersViewController.h
//	OrderHistViewController.h
//	UIImage *unselectedImage2 = [UIImage imageNamed:@"tabBarChatIcon"];
//	UIImage *selectedImage2 = [UIImage imageNamed:@"tabBarChatIconActive"];
//	UIImage *unselectedImage3 = [UIImage imageNamed:@"tabBarOrdersIcon"];
//	UIImage *selectedImage3 = [UIImage imageNamed:@"tabBarOrdersIconActive"];
//	UIImage *unselectedImage4 = [UIImage imageNamed:@"tabBarOffersIcon"];
//	UIImage *selectedImage4 = [UIImage imageNamed:@"tabBarOffersIconActive"];

	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	HomeSecondViewController *home = [storyboard instantiateViewControllerWithIdentifier:@"homeSecondScreen"];
	home.tabBarItem.image = [[UIImage imageNamed:@"tabBarHomeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	home.extendedLayoutIncludesOpaqueBars = YES;
	home.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBarHomeIconActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	home.title = @"Home";
	home.strStore_Id = _objStoreModel.store_id;
	home.strStoreImage = _objStoreModel.store_image;
	home.strStore_CategoryName = _objStoreModel.store_name;
	
	UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController: home];
	[nav1.navigationBar setTranslucent:NO];
	[nav1.navigationBar setBarTintColor:[UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0]];

//	nav1.navigationBarHidden = NO;
	//2nd tab
	RetailerShoppingListViewController *shoppingList = [storyboard instantiateViewControllerWithIdentifier:@"retailerShoppingList"];
	shoppingList.tabBarItem.image = [[UIImage imageNamed:@"tabBarMyListIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	shoppingList.extendedLayoutIncludesOpaqueBars = YES;
	shoppingList.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBarMyListIconActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	shoppingList.title = @"Shop List";
	
	UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController: shoppingList];
	[nav2.navigationBar setTranslucent:NO];
	[nav2.navigationBar setBarTintColor:[UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0]];

//	nav2.navigationBarHidden = YES;
	//3rd tab
	ChatViewController *chatView = [storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
	chatView.tabBarItem.image = [[UIImage imageNamed:@"tabBarChatIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	chatView.extendedLayoutIncludesOpaqueBars = YES;
	chatView.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBarChatIconActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	chatView.title = @"Chat";
	
	UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController: chatView];
	[nav3.navigationBar setTranslucent:NO];
	[nav3.navigationBar setBarTintColor:[UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0]];

//	nav3.navigationBarHidden = YES;
	//4th tab
	OrderHistDetailViewCon *order = [storyboard instantiateViewControllerWithIdentifier:@"orderHistViewController"];
	order.tabBarItem.image = [[UIImage imageNamed:@"tabBarOrdersIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	order.extendedLayoutIncludesOpaqueBars = YES;
	order.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBarOrdersIconActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	order.title = @"Orders";
	
	UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController: order];
	[nav4.navigationBar setTranslucent:NO];
	[nav4.navigationBar setBarTintColor:[UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0]];

//	nav4.navigationBarHidden = YES;
	//5th tab
	
	RetailerOfferViewController *offer = [storyboard instantiateViewControllerWithIdentifier:@"retailerOffersViewController"];
	offer.tabBarItem.image = [[UIImage imageNamed:@"tabBarOffersIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	offer.extendedLayoutIncludesOpaqueBars = YES;
	offer.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBarOffersIconActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	offer.title = @"Offers";
	
	UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController: offer];
	[nav5.navigationBar setTranslucent:NO];
	[nav5.navigationBar setBarTintColor:[UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0]];
//	nav5.navigationBarHidden = YES;
	
	NSArray* controllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nav4,nav5, nil];
	self.tabBarControllerRetailer = [[UITabBarController alloc]init];

	self.tabBarControllerRetailer.viewControllers = controllers;
	
	self.tabBarControllerRetailer.selectedIndex=0;
	
	self.tabBarControllerRetailer.delegate = self;
	
	self.tabBarControllerRetailer.tabBar.translucent = NO;
	return self.tabBarControllerRetailer;
//	[self.navController pushViewController:self.tabBarControllerRetailer animated:YES];
}
- (void)removeTabBarRetailer
{
	self.objStoreModel = nil;
	UINavigationController *viewController = (UINavigationController *)[self.tabBarControllerRetailer parentViewController];
	viewController.navigationBarHidden = NO;
	[viewController popViewControllerAnimated:YES];
}
#pragma mark - Chatting Methods

- (XMPPStream *)xmppStream {
	return [gCXMPPController xmppStream];
}
-(void)initializeAllSingletonObjects
{
	[CXMPPController sharedXMPPController];
	[AppManager sharedManager];
}

-(SMChatViewController *)createChatViewByChatUserNameIfNeeded:(NSString *)inChatUser
{
	UINavigationController *navcon = (UINavigationController*)self.tabBarController.selectedViewController;
	
	if (self.AllChatViewConDic == nil)
	{
		self.AllChatViewConDic = [[NSMutableDictionary alloc] init];
		
	}
	SMChatViewController *aChatViewCon = [self.AllChatViewConDic objectForKey: inChatUser];
	NSUInteger index=[[navcon childViewControllers] indexOfObject:aChatViewCon];
	
	
	if (aChatViewCon)
	{
		if (index == NSNotFound)
		{
			aChatViewCon.isAlreadyInStack= NO;
			aChatViewCon.eSMChatStatus = SMCHAT_NOT_IN_STACK;
			
		}
		else if (index == [[navcon childViewControllers] count]-1)
		{
			aChatViewCon.isAlreadyInStack= YES;
			aChatViewCon.eSMChatStatus = SMCHAT_AT_TOP_OF_STACK;
			
		}
		else
		{
			aChatViewCon.isAlreadyInStack= YES;
			aChatViewCon.eSMChatStatus = SMCHAT_EXIST_BUT_NOT_ON_TOP;
			
		}
	}
	else
	{
		
		aChatViewCon = [[SMChatViewController alloc] initWithNibName:@"SMChatViewController" bundle:nil];
		[self.AllChatViewConDic setObject: aChatViewCon forKey: inChatUser];
		
		aChatViewCon.isAlreadyInStack= NO;
		aChatViewCon.eSMChatStatus=SMCHAT_NOT_IN_STACK;
	}
	return  aChatViewCon;
	return nil;
}

-(SMChatViewController *)getChatViewDelegateByChatUserName:(NSString *)inChatUser
{
	SMChatViewController *aChatViewCon = [self.AllChatViewConDic objectForKey: inChatUser];
	return  aChatViewCon;
}

-(void)releaseChatViewByChatUserNameIfNeeded:(NSString *)inChatUser
{
	id aChatViewCon = [self.AllChatViewConDic objectForKey: inChatUser];
	
	if (aChatViewCon)
	{
		[self.AllChatViewConDic removeObjectForKey: inChatUser];
		
	}
}
-(void)sendPresence:(NSString *)type
{
	if([type isEqualToString:@"away"])
	{
		XMPPPresence *presence = [XMPPPresence presence];
		NSXMLElement *show = [NSXMLElement elementWithName:@"show" stringValue:@"away"];
		NSXMLElement *status = [NSXMLElement elementWithName:@"status" stringValue:@"away"];
		[presence addChild:show];
		[presence addChild:status];
		[presence addAttributeWithName:@"date" stringValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
		[gCXMPPController.xmppStream sendElement:presence];
	}
	else
	{
		XMPPPresence *presence = [XMPPPresence presence];
		NSXMLElement *status = [NSXMLElement elementWithName:@"status"];
		[status setStringValue:@"online"];
		[presence addChild:status];
		[presence addAttributeWithName:@"date" stringValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
		[gCXMPPController.xmppStream sendElement:presence];
	}
}


//-(BOOL)openChatViewfromNotificationViewByFriendDetail:(FriendsDetails *)inFrndDetail
//{
//
//}
-(void)setChatWindowOpenedStatusBySender:(NSString*)inSender andBool:(BOOL)inBool
{
	if(inBool)
	{
		[[NSUserDefaults standardUserDefaults] setValue:inSender forKey:kMessageChatWithUser];
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kMessageChatWithUser];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	
}
-(BOOL)getChatWindowOpenedStatusBySender:(NSString*)inSender
{
	if(inSender==nil)
		return NO;
	
	BOOL aStatus = NO;
	if([[[NSUserDefaults standardUserDefaults] valueForKey:kMessageChatWithUser]isEqualToString:inSender])
	{
		aStatus = YES;
	}
	return  aStatus;
}
-(BOOL)openChatViewfromNotificationViewByFriendDetailAnonymous:(NSString *)inFrndDetail
{
	//    UINavigationController *navcon = (UINavigationController*)self.tabBarController.selectedViewController;
	//    if([self getChatWindowOpenedStatusBySender:inFrndDetail])
	//    {
	//        if([navcon.topViewController isKindOfClass:[SMChatViewController class]])
	//            return NO;
	//    }
	//    SMChatViewController *chatView = nil;
	//    chatView = [self createChatViewByChatUserNameIfNeeded: inFrndDetail];
	//    chatView.chatWithUser =[[[inFrndDetail lowercaseString] stringByAppendingString:[NSString stringWithFormat:@"@%@",STRChatServerURL]]lowercaseString];
	//    chatView.userName = inFrndDetail;
	//    chatView.imageString = nil;
	//
	//    chatView.friendNameId = nil;
	//
	//    switch (chatView.eSMChatStatus) {
	//        case SMCHAT_AT_TOP_OF_STACK:
	//            return NO;
	//            break;
	//        case SMCHAT_EXIST_BUT_NOT_ON_TOP:
	//            [navcon popToViewController:chatView animated:YES];
	//            return YES;
	//            break;
	//        case SMCHAT_NOT_IN_STACK:
	//            [navcon pushViewController:chatView animated:YES];
	//            return YES;
	//            break;
	//        default:
	//            break;
	//    }
	return NO;
	
}
//-(BOOL)openChatViewfromNotificationViewByFriendDetail:(AddressBookDB *)inFrndDetail
//{
//    UINavigationController *navcon = (UINavigationController*)self.tabBarController.selectedViewController;
//    if([self getChatWindowOpenedStatusBySender:inFrndDetail.orgChatUsername])
//    {
//        if([navcon.topViewController isKindOfClass:[SMChatViewController class]])
//            return NO;
//    }
//    SMChatViewController *chatView = nil;
//    chatView = [self createChatViewByChatUserNameIfNeeded: [inFrndDetail.orgChatUsername lowercaseString]];
//    chatView.chatWithUser =[[[inFrndDetail.orgChatUsername lowercaseString] stringByAppendingString:[NSString stringWithFormat:@"@%@",STRChatServerURL]]lowercaseString];
//    chatView.userName = inFrndDetail.fullName;
//    chatView.imageString = inFrndDetail.profilePic;
//
//    chatView.friendNameId = [NSString stringWithFormat:@"%@",inFrndDetail.userId];
//
//    switch (chatView.eSMChatStatus) {
//        case SMCHAT_AT_TOP_OF_STACK:
//            return NO;
//            break;
//        case SMCHAT_EXIST_BUT_NOT_ON_TOP:
//            [navcon popToViewController:chatView animated:YES];
//            return YES;
//            break;
//        case SMCHAT_NOT_IN_STACK:
//            [navcon pushViewController:chatView animated:YES];
//            return YES;
//            break;
//        default:
//            break;
//    }
//
//
//}
#pragma mark check internet avalability method

-(void)internetConnectionListener:(NSNotification *)inNotification
{
    if([Utils isInternetAvailable])
    {
		
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        {
            if([[aReachability currentReachabilityString]isEqualToString:@"Cellular"])
            {
                [gCXMPPController disconnect];
            }
            if(![gCXMPPController isConnected])
            {
				
                [gCXMPPController connect];
            }
            [self sendPresence:@"away"];
        }
        else
        {
            [gCXMPPController disconnect];
            [gCXMPPController connect];
            [self sendPresence:@"online"];
            
        }
        
    }
    else
    {
    }
}
-(id)getDateAndFromString:(NSString *)strDate andDate:(NSDate *)date needSting:(BOOL)needString dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:dateFormat];
    if(needString)
    {
        return [format stringFromDate:date];
    }
    else
    {
        return [format dateFromString:strDate];
    }
}
#pragma mark - tabbar methods

- (void) loginSuccessful:(NSNotification *) aNotification{

	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	self.tabBarController=[storyboard instantiateViewControllerWithIdentifier:@"tabbarScreen"];
	[self setTabBarImages];
	[gCXMPPController connect];
	self.tabBarController.delegate = self;
	[self.window setRootViewController:self.tabBarController];
	[self.tabBarController setSelectedIndex:0];
	self.navController = nil;
}
- (void) logout:(NSNotification *) aNotification{
	
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	self.navController = [storyboard instantiateViewControllerWithIdentifier:@"optionNav"];
	[self.window setRootViewController:self.navController];
	self.tabBarController = nil;
	[self.window makeKeyAndVisible];

}
- (void) setTabBarImages{
	for(int i = 0 ; i < 5 ; i ++){
		UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:i];
		UIImage *image;
		UIImage *image_sel;
		
		switch (i) {
			case 0:
				
				image = [UIImage imageNamed:@"tabBarHomeIcon"];
				image_sel = [UIImage imageNamed:@"tabBarHomeIconActive"];
				tabBarItem.title = @"Home";
				break;
			case 1:
				
				image = [UIImage imageNamed:@"tabBarMyListIcon"];
				image_sel = [UIImage imageNamed:@"tabBarMyListIconActive"];
				tabBarItem.title = @"My List";
				
				break;
			case 2:
				
				image = [UIImage imageNamed:@"tabBarChatIcon"];
				image_sel = [UIImage imageNamed:@"tabBarChatIconActive"];
				tabBarItem.title = @"Chat";
				
				break;
			case 3:
				
				image = [UIImage imageNamed:@"tabBarOrdersIcon"];
				image_sel = [UIImage imageNamed:@"tabBarOrdersIconActive"];
				tabBarItem.title = @"Orders";
				
				break;
			case 4:
				
				image = [UIImage imageNamed:@"tabBarOffersIcon"];
				image_sel = [UIImage imageNamed:@"tabBarOffersIconActive"];
				tabBarItem.title = @"Offers";
				
				break;
			default:
				break;
		}
		if([image respondsToSelector:@selector(imageWithRenderingMode:)]){
			image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
			image_sel = [image_sel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		}
		[tabBarItem setImage:image];
		[tabBarItem setSelectedImage:image_sel];
		[[UITabBar appearance] setTintColor:[UIColor colorWithRed:254.0/255.0f green:56.0/255.0f blue:45.0/255.0f alpha:1.0f]];
		[tabBarItem imageInsets];
	}
}

@end
