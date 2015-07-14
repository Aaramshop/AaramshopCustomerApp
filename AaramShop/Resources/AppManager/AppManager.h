//
//  AppManager.h
//  Junction
//
//  Created by Neha Saxena on 1/3/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLocation.h"
#import <AddressBook/AddressBook.h>
#import "StoreModel.h"

typedef enum {
    eMapDefaultType =0,
    eMapSatelliteType,
    eMapHybridType
}enMapViewType;

void MyAddressBookExternalChangeCallback (
                                          ABAddressBookRef addressBook,
                                          CFDictionaryRef info,
                                          void *context
                                          );
#pragma Properties
@class  CMCountryList;
@interface AppManager : NSObject{
    ABAddressBookRef addressBookRef;
}
@property (nonatomic , assign) BOOL isComingFromChat;
@property(nonatomic,strong) NSMutableArray *arrImages;
@property(nonatomic,assign)BOOL isFetchingContacts;
@property(nonatomic,strong) CMCountryList *cmCountryList;
@property(nonatomic, strong) UIImage *imgProfile;

#pragma Methods
+(AppManager *)sharedManager;
+(CLocation *)getLocationByLocationStr:(NSString *)inLocationStr;
+(void)saveUserDatainUserDefault;
-(void)countryCodeData;
-(NSArray *)getcountryList;
+(void)saveDataToNSUserDefaults:(NSDictionary*)responseDic;
+(void)stopStatusbarActivityIndicator;
+(void)startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:(BOOL)status;
+(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size;
-(void)fetchAddressBookWithContactModel;
+(NSString*)stringFromDate:(NSDate*)date;
+(NSMutableArray*)simplifiedArray:(NSArray*)arrPeoplee;
+(BOOL)IsStringEmptyWithoutWhiteSpaces:(NSString*)string;
+(NSDate*)DateFromString:(NSString*)strDate;
+(void)callAddressBookWebService:(NSDictionary*)userData;
+(void)clearAllConversation;
-(void)createDefaultValuesForDictionay;
+(void)removeDataFromNSUserDefaults;
+(NSString *)getDistance:(StoreModel *)objStoreModel;
@end
extern AppManager *gAppManager;