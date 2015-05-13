//
//  AppDelegate.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize navController,myCurrentLocation;

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
    [self registerDeviceForDeviceToken:application];
  //  [self findCurrentLocation];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    navController = [storyboard instantiateViewControllerWithIdentifier:@"optionNav"];
    navController.delegate = self;
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
-(void)findCurrentLocation
//{
//    locationManager=[[CLLocationManager alloc] init];
//    geocoder = [[CLGeocoder alloc] init];
//
//    if ([CLLocationManager locationServicesEnabled])
//    {
//        locationManager.delegate = self;
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//        locationManager.headingFilter = 1;
//
//        locationManager.distanceFilter = kCLDistanceFilterNone;//5; // Don't use other value than - 'kCLDistanceFilterNone', else the local notification will not work.
//        
//        
//        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
//        {
//            [locationManager requestWhenInUseAuthorization];
//        }
//        //[locationManager startUpdatingLocation];
//        
//        
//    }
//}
//#pragma mark - CLLocationManagerDelegate
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    //    NSLog(@"didFailWithError: %@", error);
//    //    UIAlertView *errorAlert = [[UIAlertView alloc]
//    //                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    //    [errorAlert show];
//}
//
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation* newLocation = [locations lastObject];
//    
//    [self getUpdatedLocation:newLocation];
//}
//
//
//-(void)getUpdatedLocation:(CLLocation *)newLocation
//{
//  //  appDataManager.UpdatedLocation=newLocation;
//    
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray placemarks, NSError error)
//     {
//         
//         if (error == nil && [placemarks count] > 0)
//         {
//             placemark = [placemarks lastObject];
//             
//             NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
//             NSString * strCurrentAddress = [lines componentsJoinedByString:@" "];
//             
//             
//             if (strCurrentAddress != nil)
//             {
//                 appDataManager.addressByLocation = strCurrentAddress;
//                 
//                 // when source address is not available and user already started commute ..
//                 if ([[appDataManager.sourceAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
//                 {
//                     [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyToUpdateSourceAddress" object:nil];
//                 }
//             }
//             
//         } else
//         {
//             NSLog(@"%@", error.debugDescription);
//         }
//     } ];
//    
//    
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
//        if (appDataManager.commuteType == eMyCommuteCarpool && appDataManager.isCommuteStarted)
//        {
//            [appDataManager callWebServiceForCarpoolerPathTracking];
//            NSLog(@" car pool update path");
//        }
//        else if (appDataManager.commuteType == eMyCommuteSingleCommuter && appDataManager.isCommuteStarted)
//        {
//            [appDataManager callWebServiceForPathTracking];
//            NSLog(@" singal update path");
//        }
//        
//        
//    }
//}
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


////////////////////// FOR iOS 8 & iOS 7 /////////////////////

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:KGetPush object:nil];
        
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

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
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

#pragma mark - Location delegate

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    if (locations)
//    {
//        myCurrentLocation = [locations lastObject];
//
////        if ( [[NSUserDefaults standardUserDefaults] valueForKey:kIsLoggedIn] && [[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] length]>0 && ([myCurrentLocation distanceFromLocation:[locations lastObject]] > 5 || !myCurrentLocation))
////        {
////            myCurrentLocation = [locations lastObject];
////        }
////        
//    }
//}
//
//
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"%@", error.localizedDescription);
//}

@end
