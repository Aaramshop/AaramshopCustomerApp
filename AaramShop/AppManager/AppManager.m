
//
//  AppManager.m
//  SocialParty
//
//  Created by Pankaj on 1/3/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import "AppManager.h"

AppManager * gAppManager = nil;
@implementation AppManager

+(AppManager *)sharedManager
{
    static AppManager *instance = nil;
    if(instance == nil)
    {
        instance = [[AppManager alloc] init];
       
        gAppManager = instance;
        [gAppManager initializeObjects];
    }
    return instance;
}

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}
-(void)initializeObjects
{
}
+(CLocation *)getLocationByLocationStr:(NSString *)inLocationStr
{
    CLocation *aLocation = [[CLocation alloc] init];
    
    NSArray *aLocationComponents = [inLocationStr componentsSeparatedByString:@","];
    
    CLLocationCoordinate2D  aCoordinate ;
    
    aCoordinate.latitude = [[aLocationComponents objectAtIndex:0] doubleValue];
    aCoordinate.longitude = [[aLocationComponents objectAtIndex:1] doubleValue];
    aLocation.Coordinates = aCoordinate;
    aLocation.LocationName = [NSString stringWithFormat:@"%@",[aLocationComponents objectAtIndex:2]];
    return aLocation;
}

+(void)saveUserDatainUserDefault
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLoggedIn];
}

#pragma mark - NetWork Indicator on status bar
+(void)startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:(BOOL)status{
    
    if (!status) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


+(void)stopStatusbarActivityIndicator{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

+(NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *strDate=[formatter stringFromDate:date];
    return strDate;
}
+(NSDate*)DateFromString:(NSString*)strDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date=[formatter dateFromString:strDate];
    return date;
}


+(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size{
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    CGRect frame = [text boundingRectWithSize:size
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:attributesDictionary
                                      context:nil];
    
    // This contains both height and width, but we really care about height.
    return frame.size;
}




+(void)saveDataToNSUserDefaults:(id)responseDic
{
    NSDictionary *dict = (NSDictionary *)responseDic;
    
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kAddress] forKey:kAddress];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kAdultFemale] forKey:kAdultFemale];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kAdultMale] forKey:kAdultMale];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kChatUsername] forKey:kChatUsername];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kCity] forKey:kCity];
    
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kDeviceId] forKey:kDeviceId];
        [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kDob] forKey:kDob];
    
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kEmail] forKey:kEmail];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kFemaleChild] forKey:kFemaleChild];
    
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kFirstName] forKey:kFirstName];

    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kGender] forKey:kGender];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kIncome] forKey:kIncome];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kLastName] forKey:kLastName];

    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kMaleChild] forKey:kMaleChild];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kMobile] forKey:kMobile];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kMobile_verified] forKey:kMobile_verified];
    
    if([[dict objectForKey:kProfileImage]length]>0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kProfileImage] forKey:kProfileImage];
    }
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kQualification] forKey:kQualification];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kState] forKey:kState];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kToddlers] forKey:kToddlers];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kUserId] forKey:kUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)saveAddressInToDefaults
{
    
}

+(void)removeDataFromNSUserDefaults
{
    
}



@end
