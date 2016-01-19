//
//  URLManager.m
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 28/12/15.
//  Copyright © 2015 Arbab. All rights reserved.
//
//New Pakistan API
//		#define kBaseURL					@"https://www.aaramshop.pk/api/index.php/user/"
// new - // updated on 26 Aug 2015
//		#define kBaseURL                                @"http://www.aaramshop.co.in/api/index.php/user/"




#import "URLManager.h"
URLManager * gURLManager = nil;
@implementation URLManager
+(URLManager *)sharedManager
{
	static URLManager *instance = nil;
	if(instance == nil)
	{
		instance = [[URLManager alloc] init];
		
		gURLManager = instance;
		[gURLManager initializeObjects];
	}
	return instance;
}
+ (void)locateDeviceRegion
{
	NSLocale *theLocale = [NSLocale currentLocale];
	[URLManager sharedManager].baseUrl = @"https://www.aaramshop.pk/api/index.php/merchant/";
	NSString *countryCode = [theLocale objectForKey:NSLocaleCountryCode];
//	if ([countryCode isEqualToString:@"PK"]) {
//		if ([[NSUserDefaults standardUserDefaults] valueForKey:kCountryCode]==nil) {
//			[URLManager sharedManager].baseUrl = @"https://www.aaramshop.pk/api/index.php/user/";
//		}
//		else if ([[[NSUserDefaults standardUserDefaults] valueForKey:kCountryCode] intValue]==92)
//		{
//			[URLManager sharedManager].baseUrl = @"https://www.aaramshop.pk/api/index.php/user/";
//		}
//		else
//		{
//			[URLManager sharedManager].baseUrl = @"http://www.aaramshop.co.in/api/index.php/user/";
//		}
//		
//	}
//	else if ([countryCode isEqualToString:@"IN"])
//	{
//		if ([[NSUserDefaults standardUserDefaults] valueForKey:kCountryCode]==nil) {
//			[URLManager sharedManager].baseUrl = @"http://www.aaramshop.co.in/api/index.php/user/";
//		}
//		else if ([[[NSUserDefaults standardUserDefaults] valueForKey:kCountryCode] intValue]==91)
//		{
//			[URLManager sharedManager].baseUrl = @"http://www.aaramshop.co.in/api/index.php/user/";
//		}
//		else
//		{
//			[URLManager sharedManager].baseUrl = @"https://www.aaramshop.pk/api/index.php/user/";
//		}
//		
//	}

}
+ (void)locateDeviceRegion:(BOOL)isLastVersion
{
	NSLocale *theLocale = [NSLocale currentLocale];
	NSString *countryCode = [theLocale objectForKey:NSLocaleCountryCode];
	NSString *countryName = [theLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
	NSString *currencyCode = [theLocale objectForKey:NSLocaleCurrencyCode];
//	[URLManager sharedManager].baseUrl = @"http://www.aaramshop.co.in/api/index.php/user/";
	if (!isLastVersion) {
		if ([countryCode isEqualToString:@"PK"]) {
			[URLManager sharedManager].baseUrl = @"http://www.aaramshop.pk/api/index.php/user";
		}
		else if ([countryCode isEqualToString:@"IN"])
		{
			[URLManager sharedManager].baseUrl = @"http://www.aaramshop.co.in/api/index.php/user/";
		}
		else
		{
			[URLManager sharedManager].baseUrl = @"http://www.aaramshop.co.in/api/index.php/user/";
		}
		[[NSUserDefaults standardUserDefaults] setObject:[URLManager sharedManager].baseUrl forKey:kBaseURL];
		[[NSUserDefaults standardUserDefaults] setObject:countryName forKey:kCountryName];
		[[NSUserDefaults standardUserDefaults] setObject:currencyCode forKey:kCurrencyCode];
	}
	else
	{
		[URLManager sharedManager].baseUrl = [[NSUserDefaults standardUserDefaults] valueForKey:kBaseURL];
	}
	
}
+ (void)locateDeviceRegion:(CLLocation*)newLocation withGeoCoder:(CLGeocoder*)geoCoder
{
	[geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
	 {
		 if (placemarks == nil)
			 return;
		 
		 CLPlacemark *currentLocPlacemark = [placemarks objectAtIndex:0];
		 NSLog(@"Current country: %@", [currentLocPlacemark country]);
		 NSLog(@"Current country code: %@", [currentLocPlacemark ISOcountryCode]);
		 if ([[currentLocPlacemark ISOcountryCode] isEqualToString:@"IN"]) {
			 if([[NSUserDefaults standardUserDefaults] valueForKey:kStore_id]==nil)
			 {
				 [URLManager sharedManager].baseUrl = @"http://www.aaramshop.co.in/api/index.php/merchant/";
			 }
		 }
		 else if ([[currentLocPlacemark ISOcountryCode] isEqualToString:@"PK"])
		 {
			 
		 }
	 }];
}
- (void)initializeObjects
{
	
}
@end
