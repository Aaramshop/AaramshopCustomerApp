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
#import "ProductsModel.h"
#import "CartProductModel.h"
#import "ContactsData.h"

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
@property (nonatomic, assign) BOOL isComingFromChat;
@property (nonatomic, strong) NSMutableArray *arrImages;
@property (nonatomic, assign)BOOL isFetchingContacts;
@property (nonatomic, assign)NSInteger intCount;
@property (nonatomic, strong) CMCountryList *cmCountryList;
@property (nonatomic, strong) UIImage *imgProfile;

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
+(void)AddOrRemoveFromCart:(CartProductModel *)cartProduct forStore:(NSDictionary *)store add:(BOOL)isAdd fromCart:(BOOL)fromCart;
+(void)saveCountOfProductsInCart:(NSInteger)productQuantity;
+(NSInteger)getCountOfProductsInCart;
+ (void)removeCartBasedOnStoreId:(NSString *)store_id;
+ (NSMutableArray *)getCartProductsByStoreId:(NSString *)store_id;
+ (NSString *)getCountOfProduct:(NSString *)cartProductId withOfferType:(NSString *)offer_type forStore_id:(NSString *)store_id;
+(NSArray *)getAllContacts;
+(NSArray *)addContactToAddressBook;
@end
extern AppManager *gAppManager;