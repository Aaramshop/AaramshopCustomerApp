//
//  URLManager.h
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 28/12/15.
//  Copyright © 2015 Arbab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface URLManager : NSObject
@property (nonatomic, strong) NSString *baseUrl;
#pragma Methods
+ (URLManager *)sharedManager;
//+ (void)locateDeviceRegion;
+ (void)locateDeviceRegion:(BOOL)isLastVersion;
//+ (void)locateDeviceRegion:(CLLocation*)newLocation withGeoCoder:(CLGeocoder*)geoCoder;
@end
extern URLManager *gURLManager;