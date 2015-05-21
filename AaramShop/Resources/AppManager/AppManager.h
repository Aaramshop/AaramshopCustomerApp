//
//  AppManager.h
//  Junction
//
//  Created by Neha Saxena on 1/3/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLocation.h"
typedef enum {
    eMapDefaultType =0,
    eMapSatelliteType,
    eMapHybridType
}enMapViewType;


typedef enum {
    ADDRESSBOOK_CONTACT_REGISTERED_ON_UMMAPP=0,
    ADDRESSBOOK_CONTACT_NOT_REGISTERED_ON_UMMAPP,
}AddressBookContactType;
typedef enum {
    ADDRESSBOOK_DETAIL_BUTTON_TYPE_INVITE_TO_UMMAPP,
    ADDRESSBOOK_DETAIL_BUTTON_TYPE_SEND_MESSAGE,
    ADDRESSBOOK_DETAIL_BUTTON_TYPE_EMAIL_CONVERSTAION,
    ADDRESSBOOK_DETAIL_BUTTON_TYPE_CLEAR_CONVERSATION,
    ADDRESSBOOK_DETAIL_BUTTON_TYPE_VIEW_ALL_MEDIA
}AddressBookDetailButtonType;

#import <AddressBook/AddressBook.h>
void MyAddressBookExternalChangeCallback (
                                          ABAddressBookRef addressBook,
                                          CFDictionaryRef info,
                                          void *context
                                          );
#pragma Properties

@interface AppManager : NSObject{
    ABAddressBookRef addressBookRef;
}
@property(nonatomic,strong) NSMutableArray *arrImages;
@property(nonatomic, assign) BOOL isFetchingContacts;
#pragma Methods
+(AppManager *)sharedManager;
+(CLocation *)getLocationByLocationStr:(NSString *)inLocationStr;
+(void)saveUserDatainUserDefault;
+(NSArray*)getCountryCodeList;
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

@end
extern AppManager *gAppManager;