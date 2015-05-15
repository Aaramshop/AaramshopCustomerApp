//
//  AppManager.h
//  Junction
//
//  Created by Neha Saxena on 1/3/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLocation.h"
#import "AFHTTPSessionManager.h"


#pragma Properties

@interface AppManager : NSObject

#pragma Methods
+(AppManager *)sharedManager;
//+(CLocation *)getLocationByLocationStr:(NSString *)inLocationStr;
+(void)saveUserDatainUserDefault;
+(void)saveDataToNSUserDefaults:(NSDictionary*)responseDic;
+(void)stopStatusbarActivityIndicator;
+(void)startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:(BOOL)status;
+(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

+(NSString*)stringFromDate:(NSDate*)date;
+(NSDate*)DateFromString:(NSString*)strDate;


+(void)removeDataFromNSUserDefaults;
@end
extern AppManager *gAppManager;