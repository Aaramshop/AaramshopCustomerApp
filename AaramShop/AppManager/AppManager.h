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
@property (nonatomic, strong) NSMutableDictionary *notifyDict;
@property(nonatomic,strong) NSMutableArray *arrImages;
@property(nonatomic, assign) BOOL isFetchingContacts;
@property (nonatomic, strong) NSMutableDictionary *dicAppSettings;
@property(nonatomic,strong) NSURL *urlSelectedVideo;
#pragma Methods
+(AppManager *)sharedManager;
+(CLocation *)getLocationByLocationStr:(NSString *)inLocationStr;
+(void)saveUserDatainUserDefault;
+(void)saveDataToNSUserDefaults:(NSDictionary*)responseDic;
+(void)stopStatusbarActivityIndicator;
+(void)startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:(BOOL)status;
+(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

+(NSString*)stringFromDate:(NSDate*)date;
+(NSDate*)DateFromString:(NSString*)strDate;


+(void)removeDataFromNSUserDefaults;
+(void)callWebserviceToUpdateGeoLocationToServer:(NSDictionary *)aDic;
-(void)uploadRestImageswithDictionary:(NSMutableDictionary *)dict;
-(void)uploadVideowithDictionary:(NSMutableDictionary *)dict;
@end
extern AppManager *gAppManager;