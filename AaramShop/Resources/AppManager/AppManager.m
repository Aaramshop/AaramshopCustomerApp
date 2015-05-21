
//
//  AppManager.m
//  SocialParty
//
//  Created by Pankaj on 1/3/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import "AppManager.h"
#define kMax_No_Of_contacts 300


AppManager * gAppManager = nil;
UIAlertView *alert = nil;
@implementation AppManager
@synthesize notifyDict;
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
        //sharedInstance = self;
        if (!addressBookRef) {
            addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
            //        people = nil;
            //   [self refresh];
            ABAddressBookRegisterExternalChangeCallback (addressBookRef,
                                                         MyAddressBookExternalChangeCallback,
                                                         (__bridge void *)(self)
                                                         );
        }
        
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
+(void)saveDataToNSUserDefaults:(NSDictionary*)responseDic
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
+(NSArray*)getCountryCodeList{
    // Read plist from bundle and get Root Dictionary out of it
    NSArray *arrRoot = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryCodeList" ofType:@"plist"]];
    
    return arrRoot;
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
#pragma mark - Authentication Error Alert
-(void)showAuthenticationFailedAlertView{
    

    
    if (!alert) {
        alert = [[UIAlertView alloc] initWithTitle:kAlertTitle message:@"Authentication failed !" delegate:self
                                 cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    }
    
    
    if (!alert.isVisible) {
        [alert show];
    }
    
    
}

#pragma mark - AddressBook
-(void)fetchAddressBookWithContactModel
{
    if (!addressBookRef) {
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    if(!addressBookRef)
        return ;
    ABAddressBookRevert(addressBookRef);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            
            if (granted) {
                  [AppManager sharedManager].isFetchingContacts=YES;
                [[AppManager sharedManager] PerformTaskAfterContactsPermissionGranted];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
          [AppManager sharedManager].isFetchingContacts=YES;
        [[AppManager sharedManager] PerformTaskAfterContactsPermissionGranted];
    }
    else {
        // Send an alert telling user to change privacy setting in settings app
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kContactsAccessPermission];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // the user has previously denied access - send alert to user to allow access in Settings app
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Settings"
                                                        message:@"This app does not have access to your contacts.  You can enable access in Privacy Settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    
}

-(void)PerformTaskAfterContactsPermissionGranted{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kContactsAccessPermission];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSArray *allPeople = (__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(addressBookRef));
    [AppManager NewOrUpdatedAddressBookContacts:allPeople andContactsToBeDeleted:@""];
    
}
+(void)NewOrUpdatedAddressBookContacts:(NSArray*)allPeople andContactsToBeDeleted:(NSString*)strDeleteContactIDs{
    
    //    NSError *writeError = nil;
    NSMutableArray* arrAddressBook= [[NSMutableArray alloc] init];
    for (id person in allPeople)
    {
        NSString *name = @"";
        NSString *firstname = @"";
        NSString *lastname = @"";
        
        firstname = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonFirstNameProperty);
        lastname = (__bridge_transfer NSString *)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonLastNameProperty);
        
        name = (__bridge_transfer NSString *)ABRecordCopyCompositeName((__bridge ABRecordRef)(person));
        
        if ([name length]==0) {
            name = @" ";
        }
        
        if (!lastname) {
            lastname = @"";
        }
        
        if (!firstname) {
            firstname = @"";
        }
        ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
       // name = [NSString stringWithFormat:@"%@ %@",firstname,lastname];
        
        //        NSMutableAttributedString * stringName = [[NSMutableAttributedString alloc] initWithString:name];
        //        [stringName addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0,firstname.length)];
        
        
        
        ABMultiValueRef Phone = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
//        ABMultiValueRef Email = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonEmailProperty);
        NSMutableDictionary *aTemp=[[NSMutableDictionary alloc]init];
        //            AllContacts *contacts=[[AllContacts alloc] init];
        //            contacts.fullName=stringName;
        //     [aTemp setObject:stringName forKey:kfullName];
        
        NSMutableArray *arrPhone=[[NSMutableArray alloc]init];
        for (CFIndex i = 0; i < ABMultiValueGetCount(Phone); i++) {
            CFStringRef label = ABMultiValueCopyLabelAtIndex(Phone, i);
            
            
            
            NSString *phoneLabel1 =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(label);
            
            NSString *phoneNumber = [AppManager removeSpecialCheractersFromPhoneNumber:(__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(Phone, i)];
            NSMutableDictionary *aTemp=[NSMutableDictionary dictionaryWithObjectsAndKeys:phoneLabel1,kType,phoneNumber,@"number", nil];
            
            [arrPhone addObject:aTemp];
            if (label != NULL)
                CFRelease(label);
        }
        
        NSInteger idstring=(NSInteger )ABRecordGetRecordID((__bridge ABRecordRef)(person));
        [aTemp setObject:[NSString stringWithFormat:@"%ld",(long)idstring] forKey:@"uniqueContactID"];
        
        
        NSDate* modifiedDate = (__bridge NSDate*) ABRecordCopyValue( (__bridge ABRecordRef)(person),  kABPersonModificationDateProperty);
        [aTemp setObject:[AppManager stringFromDate:modifiedDate] forKey:@"strModifiedDate"];
        //        [aTemp setObject:modifiedDate forKey:@"modifiedDate"];
        
        
        
//        if ([arrEmail count] != 0) {
//            
//            //            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrEmail options:NSJSONWritingPrettyPrinted error:&writeError];
//            //            NSString *jsonEmail = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            
//            [aTemp setObject:arrEmail forKey:@"email"];
//        }
        
        
        if ([AppManager IsStringEmptyWithoutWhiteSpaces:name]) {
            name=[NSString stringWithFormat:@"%@",[[arrPhone firstObject] valueForKey:@"number"]];
        }
        [aTemp setObject:name forKey:@"name"];
        
        
        if ([arrPhone count] != 0) {
            [aTemp setObject:arrPhone forKey:@"phone"];
        }
        
        [arrAddressBook addObject:aTemp];
        
        CFRelease(Phone);
    }
//
//        
//        [AppManager callAddressBookWebService:[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:kSessionToken],kSessionToken,[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken],kDeviceToken,[[NSUserDefaults standardUserDefaults] valueForKey:kUserId],kUserId,arrC,kPhoneAddress,kGetPhoneBookFriends,kOption,kDevice,kDeviceType,strDeleteContactIDs,@"idsToBeDelete",nil]];
//        
//    }
    

//    NSArray *contact = [[Database database] fetchDataFromDatabaseForEntity:@"AddressBookDB"];
//    NSMutableArray *realMessages = [NSMutableArray arrayWithArray:[contact valueForKey:@"originalUserId"]];
//    [realMessages removeObject:[NSNumber numberWithInt:[@"0" intValue]]];
//    if([realMessages count]>0)
//    {
//        [AppManager callAddressBookWebService:[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:kSessionToken],kSessionToken,[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken],kDeviceToken,[[NSUserDefaults standardUserDefaults] valueForKey:kUserId],kUserId,arrAddressBook,kPhoneAddress,kGetPhoneBookFriends,kOption,kDevice,kDeviceType,realMessages,@"updatedContactIds",strDeleteContactIDs,@"idsToBeDelete",nil]];
//    }
//    else
//    {
//        [AppManager callAddressBookWebService:[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:kSessionToken],kSessionToken,[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken],kDeviceToken,[[NSUserDefaults standardUserDefaults] valueForKey:kUserId],kUserId,arrAddressBook,kPhoneAddress,kGetPhoneBookFriends,kOption,kDevice,kDeviceType,strDeleteContactIDs,@"idsToBeDelete",nil]];
//    }

    
    //    return arrAddressBook;
}
//This method removes any type of special character from the phone numbers
+(NSString *) removeSpecialCheractersFromPhoneNumber:(NSString *)phoneNumber
{
    NSMutableString *result = [NSMutableString stringWithCapacity:phoneNumber.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:phoneNumber];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO)
    {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer])
        {
            [result appendString:buffer];
        }
        else
        {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    return result;
}
+(BOOL)IsStringEmptyWithoutWhiteSpaces:(NSString*)string{
    //    NSCharacterSet *characterset=[NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimmed.length==0) {
        return YES;
    }
    return NO;
}
//+(NSString*)CheckForDeletedContacts:(NSArray*)allPeople{
//    
//    
//    
//    NSArray *arrContacts=[[Database database] fetchDataFromDatabaseForEntity:@"AddressBookDB"];
//    
//    
//    NSMutableSet *set2 = [NSMutableSet setWithArray: [arrContacts valueForKey:@"uniqueContactID"] ];
//    
//    NSNumber * max = [arrContacts valueForKeyPath:@"@max.uniqueContactID"];
//    
//    NSArray *newArrayFromAddressBook = [(NSArray*)[AppManager simplifiedArray:allPeople] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uniqueContactID <= %@", max]];
//    
//    
//    NSMutableSet *set1 = [NSMutableSet setWithArray: [newArrayFromAddressBook valueForKey:@"uniqueContactID"]];
//    
//    [set2 minusSet: set1];
//    NSArray *resultArray = [set2 allObjects];
//    
//    NSString *strToBeDelete=@"";
//    for (id obj  in resultArray) {
//        strToBeDelete=[strToBeDelete stringByAppendingFormat:@"%@,",obj];
//    }
//    if ([strToBeDelete length]>0) {
//        strToBeDelete = [strToBeDelete substringToIndex:[strToBeDelete length]-1];
//    }
//    return strToBeDelete;
//}
+(NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *strDate=[formatter stringFromDate:date];
    return strDate;
}
+(NSMutableArray*)simplifiedArray:(NSArray*)arrPeoplee{
    NSMutableArray* arrAddressBook= [[NSMutableArray alloc] init];
    for (id person in arrPeoplee)
    {
        
        
        NSMutableDictionary *aTemp=[[NSMutableDictionary alloc] init];
        NSInteger idstring=(NSInteger )ABRecordGetRecordID((__bridge ABRecordRef)(person));
        [aTemp setObject:[NSNumber numberWithInteger:idstring] forKey:@"uniqueContactID"];
        [arrAddressBook addObject:aTemp];
        
    }
    return arrAddressBook;
}
+(NSDate*)DateFromString:(NSString*)strDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date=[formatter dateFromString:strDate];
    return date;
}
void MyAddressBookExternalChangeCallback (
                                          ABAddressBookRef addressBook,
                                          CFDictionaryRef info,
                                          void *context
                                          )
{
    NSLog(@"MyAddressBookExternalChangeCallback called ");
    [[AppManager sharedManager] refreshAB];
}
-(void)refreshAB{
    [[AppManager sharedManager] fetchAddressBookWithContactModel];
}
//+(void)callAddressBookWebService:(NSDictionary*)userData{
//    if(![Utils isInternetAvailable])
//    {
//        [Utils showAlertView:kAlertTitle message:@"Check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    }
//    else
//    {
//        if (!userData) {
//            return;
//        }
//        
//        NetworkService *obj = [NetworkService sharedInstance];
//        [obj sendAsynchRequestByPostToServer:@"friends" dataToSend:userData delegate:self contentType:eAppJsonType andReqParaType:eJson header:NO];
//
//    }
//    
//}
#pragma mark - call web service to update settings
//+(void)callUpdateUserAppSettingWebService:(NSDictionary *)dict serviceType:(NSString *)serviceType{
//    if(![Utils isInternetAvailable])
//    {
//        [Utils showAlertView:kAlertTitle message:@"Check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    }
//    else
//    {
//        
//        NetworkService *obj = [NetworkService sharedInstance];
//        
////        NSMutableDictionary *appSetting=[AppManager getUserAppSettingsFromPlist];
//        if([serviceType isEqualToString:kUpdateUserSettings])
//        {
//            NSDictionary *aDict=[NSDictionary dictionaryWithObjectsAndKeys:kDevice,kDeviceType,[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kSessionToken]],kSessionToken,[[NSUserDefaults standardUserDefaults] valueForKey:kUserId],kUserId,kUpdateUserSettings,kOption,dict,kUserSettings, nil];
//        
//            [obj sendAsynchRequestByPostToServer:kSettings dataToSend:aDict delegate:self contentType:eAppJsonType andReqParaType:eJson header:NO];
//        }
//        else
//        {
//            NSDictionary *aDict=[NSDictionary dictionaryWithObjectsAndKeys:kDevice,kDeviceType,[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kDeviceToken]],kDeviceToken,[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kSessionToken]],kSessionToken,[[NSUserDefaults standardUserDefaults] valueForKey:kUserId],kUserId,kResetUserSettings,kOption, nil];
//            
//            [obj sendAsynchRequestByPostToServer:kSettings dataToSend:aDict delegate:self contentType:eAppJsonType andReqParaType:eJson header:NO];
//        }
//    }
//    
//}


#pragma mark - Wen Service response handler
//+(void)responseHandler :(id)inResponseDic andRequestIdentifier:(NSString *)inReqIdentifier
//{
//    
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    if ([[inResponseDic valueForKey:@"status"] integerValue] == RESPONSE_STATUS_SUCCESS) {
//        
//        
//       if ([[inResponseDic valueForKey:kOption] isEqualToString:kGetPhoneBookFriends])
//        {
//            
//            [[Database database] SaveAddressBookDataBase:[inResponseDic valueForKey:@"phoneData"]from:NO];
//            [[Database database] DeleteAddressBookFromDatabase:[inResponseDic valueForKey:@"idsToBeDelete"]];
//            [[Database database] SaveAddressBookDataBase:[inResponseDic valueForKey:@"updatedUserData"]from:YES];
//            [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"modifiedDate"];
//            [AppManager sharedManager].isFetchingContacts=NO;
//            AppDelegate *appDel=(AppDelegate*)APP_DELEGATE;
//            [appDel refreshFriendsTabbarView];
//        }
//        
//
//    }else if ([[inResponseDic valueForKey:@"status"] integerValue] == RESPONSE_STATUS_AUTHENTICATION_FAIL){
//        
//        [[AppManager sharedManager] showAuthenticationFailedAlertView];
//    }
//    
//    else
//    {
//        
//            [Utils showAlertView:kAlertTitle message:[inResponseDic valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        
//    }
//    
//}

//+(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
//{
//    [AppManager stopStatusbarActivityIndicator];
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    NSLog(@"*** requestErrorHandler Error : %@ and Request Udesntifier AppManager: %@ ****",[inError debugDescription],inReqIdentifier);
//}

#pragma mark- create Url

+(NSMutableDictionary *)createDifferentUrlFromUrl:(NSString *)mainUrl{
    
    NSMutableArray *arrTemp = [NSMutableArray arrayWithArray:[mainUrl componentsSeparatedByString:@"."]];
    [arrTemp removeLastObject];
    NSString *strTempUrl = [arrTemp componentsJoinedByString:@"."];
    
    NSString *profilePic = mainUrl;
    
    NSString *profile105 = [[NSString stringWithFormat:@"%@%d.jpg",strTempUrl,IMAGE_URL_TYPE_CODE_105_PIXELS_IMAGE] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *profile210 = [[NSString stringWithFormat:@"%@%d.jpg",strTempUrl,IMAGE_URL_TYPE_CODE_210_PIXELS_IMAGE] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *profilePicOriginalCompress = [[NSString stringWithFormat:@"%@%d.jpg",strTempUrl,IMAGE_URL_TYPE_CODE_ORIGINAL_COMPRESS_IMAGE] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *profilePicBlur = [[NSString stringWithFormat:@"%@%d.jpg",strTempUrl,IMAGE_URL_TYPE_CODE_BLUR] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    [dict setObject:profilePic forKey:kProfilePic];
//    [dict setObject:profile105 forKey:kprofile105];
//    [dict setObject:profile210 forKey:kprofile210];
//    [dict setObject:profilePicOriginalCompress forKey:kprofilePicOriginalCompress];
//    [dict setObject:profilePicBlur forKey:kprofilePicBlur];
    
    
    return dict;
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

#pragma mark - create App Settings

//+ (void)updateAppSettings:(NSMutableDictionary *)dict withKey:(NSString *)key
//{
//    [AppManager sharedManager].dicAppSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:kAPP_SETTINGS]];
//    if([AppManager sharedManager].dicAppSettings!=nil)
//    {
//        if([[[AppManager sharedManager].dicAppSettings allKeys]containsObject:key])
//        {
//            [[AppManager sharedManager].dicAppSettings removeObjectForKey:key];
//            [[AppManager sharedManager].dicAppSettings setObject:dict forKey:key];
//        }
//    }
//    else
//    {
//        [AppManager sharedManager].dicAppSettings = [[NSMutableDictionary alloc]init];
//        [[AppManager sharedManager].dicAppSettings setObject:dict forKey:key];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:[AppManager sharedManager].dicAppSettings] forKey:kAPP_SETTINGS];
//}
+(void)clearAllConversation
{
    NSManagedObjectContext *context = [gCXMPPController messagesStoreMainThreadManagedObjectContext]; // your managed object context
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // handle error
    } else {
        for (NSManagedObject *object in objects) {
            [context deleteObject:object];
        }
        [context save:&error];
    }
    request = nil;
    request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Contact_CoreDataObject"];
    objects = nil;
    objects = [context executeFetchRequest:request error:&error];
    if(objects == nil)
    {
        
    }
    else
    {
        for (NSManagedObject *object in objects) {
            [context deleteObject:object];
        }
        [context save:&error];
        
    }
}
@end
