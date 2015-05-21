//
//  AppDelegate.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    Reachability *aReachability;
}
@end

@implementation AppDelegate
@synthesize navController,myCurrentLocation,locationManager,arrOptions;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor blackColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
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
    }
    [[AppManager sharedManager] performSelector:@selector(fetchAddressBookWithContactModel) withObject:nil];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kIsLoggedIn] == NO) {
    }

    arrOptions = [NSArray arrayWithObjects:@"Home Address",@"Office Address", @"Others", nil];
    [self registerDeviceForDeviceToken:application];
    [self findCurrentLocation];

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    navController = [storyboard instantiateViewControllerWithIdentifier:@"optionNav"];
    navController.delegate = self;
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
-(void)findCurrentLocation
{
    locationManager=[[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.headingFilter = 1;
        
        locationManager.distanceFilter = kCLDistanceFilterNone;//5; // Don't use other value than - 'kCLDistanceFilterNone', else the local notification will not work.
        
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
        
        
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager* )manager didFailWithError:(NSError *)error
{
    //    NSLog(@"didFailWithError: %@", error);
    //    UIAlertView *errorAlert = [[UIAlertView alloc]
    //                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [errorAlert show];
}


- (void)locationManager:(CLLocationManager* )manager didUpdateLocations:(NSArray* )locations
{
    CLLocation* newLocation = [locations lastObject];
    
    [self getUpdatedLocation:newLocation];
}


-(void)getUpdatedLocation:(CLLocation *)newLocation
{
    myCurrentLocation = newLocation;
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         
//         if (error == nil && [placemarks count] > 0)
////         {
////             placemark = [placemarks lastObject];
////             
////             NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
////             NSString * strCurrentAddress = [lines componentsJoinedByString:@" "];
////             
////             
////             if (strCurrentAddress != nil)
////             {
////                 appDataManager.addressByLocation = strCurrentAddress;
////                 
////                 // when source address is not available and user already started commute ..
////                 if ([[appDataManager.sourceAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
////                 {
////                     [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyToUpdateSourceAddress" object:nil];
////                 }
////             }
////             
////         } else
//         {
//             NSLog(@"%@", error.debugDescription);
//         }
//     } ];
    
    
//    NSDate* eventDate = appDataManager.lastLocation.timestamp;
//    
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    
//    if (abs(howRecent) > KNotificationTime)
//    {
//        
//        //        if (appDataManager.isCommuteStopped==NO && appDataManager.isCommuteStarted == YES )
//        
//        if (appDataManager.commuteType == eMyCommuteSingleCommuter && appDataManager.isCommuteStopped==NO && appDataManager.isCommuteStarted == YES )
//        {
//            [self setupLocalNotifications];
//        }
//        
//    }
//    else if (  [appDataManager.lastLocation distanceFromLocation:newLocation] > kUpdateLocationAfterDistance)
//    {
//        [alert dismissWithClickedButtonIndex:0 animated:YES]; // when user suddenly move from idle state to running state
//        
//        appDataManager.lastLocation = newLocation;
//    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Neha.EmoteIt" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TrackBuddy" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PoppuhApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
 #pragma mark - Remote Notification Methods


////////////////////// FOR iOS 8 & iOS 7 /////////////////////

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
       // [[NSNotificationCenter defaultCenter] postNotificationName:KGetPush object:nil];
        
    }
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [[NSUserDefaults standardUserDefaults] setValue:deviceTokenStr forKey:kDeviceId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecieveDeviceToken object:nil];
    
    
    NSLog(@"Device Token: %@ ", deviceTokenStr);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    
    [[NSUserDefaults standardUserDefaults] setValue:@"3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0" forKey:kDeviceId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Chatting Methods

- (XMPPStream *)xmppStream {
    return [gCXMPPController xmppStream];
}
-(void)initializeAllSingletonObjects
{
    [CXMPPController sharedXMPPController];
}

-(SMChatViewController *)createChatViewByChatUserNameIfNeeded:(NSString *)inChatUser
{
    //    UINavigationController *navcon = (UINavigationController*)self.tabBarController.selectedViewController;
    //
    //    if (self.AllChatViewConDic == nil)
    //    {
    //        self.AllChatViewConDic = [[NSMutableDictionary alloc] init];
    //
    //    }
    //    SMChatViewController *aChatViewCon = [self.AllChatViewConDic objectForKey: inChatUser];
    //    NSUInteger index=[[navcon childViewControllers] indexOfObject:aChatViewCon];
    //
    //
    //    if (aChatViewCon)
    //    {
    //        if (index == NSNotFound)
    //        {
    //            aChatViewCon.isAlreadyInStack= NO;
    //            aChatViewCon.eSMChatStatus = SMCHAT_NOT_IN_STACK;
    //
    //        }
    //        else if (index == [[navcon childViewControllers] count]-1)
    //        {
    //            aChatViewCon.isAlreadyInStack= YES;
    //            aChatViewCon.eSMChatStatus = SMCHAT_AT_TOP_OF_STACK;
    //
    //        }
    //        else
    //        {
    //            aChatViewCon.isAlreadyInStack= YES;
    //            aChatViewCon.eSMChatStatus = SMCHAT_EXIST_BUT_NOT_ON_TOP;
    //
    //        }
    //    }
    //    else
    //    {
    //
    //        aChatViewCon = [[SMChatViewController alloc] initWithNibName:@"SMChatViewController" bundle:nil];
    //        [self.AllChatViewConDic setObject: aChatViewCon forKey: inChatUser];
    //
    //        aChatViewCon.isAlreadyInStack= NO;
    //        aChatViewCon.eSMChatStatus=SMCHAT_NOT_IN_STACK;
    //    }
    //    return  aChatViewCon;
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

@end
