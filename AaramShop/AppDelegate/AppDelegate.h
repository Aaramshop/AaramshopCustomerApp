//
//  AppDelegate.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate>
{
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
}


@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) UINavigationController *navController;
@property (nonatomic, strong) CLLocation *myCurrentLocation;


@end

