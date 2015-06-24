
//
//  AppManager.m
//  SocialParty
//
//  Created by Pankaj on 1/3/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import "AppManager.h"
#import "CMCountryList.h"

#define kMax_No_Of_contacts 300


AppManager * gAppManager = nil;
UIAlertView *alert = nil;
@implementation AppManager
@synthesize cmCountryList,imgProfile;
AppDelegate *appDeleg;
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
        if (!addressBookRef) {
            addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRegisterExternalChangeCallback (addressBookRef,
                                                         MyAddressBookExternalChangeCallback,
                                                         (__bridge void *)(self)
                                                         );
        }
        
    }
    return self;
}
-(void)createDefaultValuesForDictionay
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kAddressForLocation]) {
        
        NSMutableArray *arrAddress = [[NSMutableArray alloc]init];
        
        for (int z=0; z<2; z++) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:@"" forKey:kAddress];
            [dict setObject:@"" forKey:kState];
            [dict setObject:@"" forKey:kCity];
            [dict setObject:@"" forKey:kLocality];
            [dict setObject:@"" forKey:kPincode];
            
            if (z==0) {
                [dict setObject:@"Home" forKey:kTitle];
                [arrAddress addObject:dict];
            }
            else if (z==1) {
                [dict setObject:@"Office" forKey:kTitle];
                [arrAddress addObject:dict];
            }
            else if (z==2) {
                [dict setObject:@"" forKey:kTitle];
                [arrAddress addObject:dict];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:arrAddress forKey:kAddressForLocation];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}

-(void)initializeObjects
{
    cmCountryList = [[CMCountryList alloc] init];
    appDeleg = APP_DELEGATE;
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
    
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kImage_url_100] forKey:kImage_url_100];
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kImage_url_320] forKey:kImage_url_320];
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kImage_url_640] forKey:kImage_url_640];
    [[NSUserDefaults standardUserDefaults]setObject:[dict objectForKey:kProfileImage] forKey:kProfileImage];
    
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kAddress] forKey:kAddress];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kAdultFemale] forKey:kAdultFemale];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kAdultMale] forKey:kAdultMale];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kChatUsername] forKey:kChatUsername];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@@%@",[dict objectForKey:kChatUsername],STRChatServerURL] forKey:kXMPPmyJID1];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kCity] forKey:kCity];
    
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kDeviceId] forKey:kDeviceId];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kDob] forKey:kDob];
    
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kEmail] forKey:kEmail];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kFemaleChild] forKey:kFemaleChild];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kGender] forKey:kGender];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kIncome] forKey:kIncome];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kFullname] forKey:kFullname];
    
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kMaleChild] forKey:kMaleChild];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kMobile] forKey:kMobile];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kMobile_verified] forKey:kMobile_verified];
    
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kQualification] forKey:kQualification];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kState] forKey:kState];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kToddlers] forKey:kToddlers];
    [[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:kUserId] forKey:kUserId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSArray *)getcountryList
{
    NSArray *arrCountryData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryList" ofType:@"plist"]];
    return arrCountryData;
}
-(void)countryCodeData{

   NSArray *arrCountryData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryList" ofType:@"plist"]];
    
  NSLocale *locale = [NSLocale currentLocale];
  NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];

  NSString *countryName = [locale displayNameForKey: NSLocaleCountryCode value: countryCode];
    
    for (NSDictionary *dictCountry in arrCountryData) {
        if ([[dictCountry objectForKey:@"CountryName"] isEqualToString:countryName]) {
            self.cmCountryList.CountryName = [dictCountry objectForKey:@"CountryName"];
            self.cmCountryList.CountryCode = [dictCountry objectForKey:@"CountryCode"];
            self.cmCountryList.CountryFlag = [dictCountry objectForKey:@"CountryFlag"];
            break;
        }
    }
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
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"modifiedDate"]) {
        
        NSDate *preModifiedDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"modifiedDate"] ;
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            ABRecordRef person=(__bridge ABRecordRef)evaluatedObject;
            CFTypeRef theProperty = ABRecordCopyValue(person, kABPersonPhoneProperty);
            CFRelease(theProperty);
            BOOL result=NO;
            NSDate* modifiedDate = (__bridge NSDate*) ABRecordCopyValue((person),  kABPersonModificationDateProperty);
            if ([modifiedDate compare:preModifiedDate] == NSOrderedDescending) {
                result = YES;
            }else
                result = NO;
            
            return result;
        }];
        NSArray *states = [allPeople filteredArrayUsingPredicate:predicate];
        
        NSString *strToBeDelete = [AppManager CheckForDeletedContacts:allPeople];
        
        if (states.count > 0 ) {
            
            NSArray *newArrayFromAddressBook = (NSArray*)[AppManager simplifiedArray:states];
            
            NSMutableSet *set1 = [NSMutableSet setWithArray: [newArrayFromAddressBook valueForKey:@"uniqueContactID"]];
            NSArray *resultArray = [set1 allObjects];
            
            NSString *strToBeDeleteNow=@"";
            for (id obj  in resultArray) {
                strToBeDeleteNow=[strToBeDeleteNow stringByAppendingFormat:@"%@,",obj];
            }
            if ([strToBeDeleteNow length]>0) {
                strToBeDeleteNow = [strToBeDeleteNow substringToIndex:[strToBeDeleteNow length]-1];
                if ([strToBeDelete length]>0) {
                    strToBeDelete=[strToBeDelete stringByAppendingFormat:@",%@",strToBeDeleteNow];

                }
                else
                    strToBeDelete = strToBeDeleteNow;

            }
        }
        [AppManager NewOrUpdatedAddressBookContacts:states andContactsToBeDeleted:strToBeDelete];
    }
    else
    {
        [AppManager NewOrUpdatedAddressBookContacts:allPeople andContactsToBeDeleted:@""];
 
    }
    
}

+(void)NewOrUpdatedAddressBookContacts:(NSArray *)allPeople andContactsToBeDeleted:(NSString*)strDeleteContactIDs{
    
    NSMutableArray* arrAddressBook= [[NSMutableArray alloc] init];
    NSMutableArray *arrPhoneOnly = [[NSMutableArray alloc]init];

    if ([strDeleteContactIDs length] != 0) {
        
        [[DataBase database] DeleteAddressBookFromDatabase:strDeleteContactIDs];
    }
    dispatch_queue_t  backgroundQueue = dispatch_queue_create("bgQueue", NULL);
    dispatch_async(backgroundQueue, ^{
        for (id person in allPeople)
        {
            NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
            
            ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
            ABMultiValueRef Phone = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
            
            for (CFIndex i = 0; i < ABMultiValueGetCount(Phone); i++) {
                NSString *strPhoneNumber = [AppManager removeSpecialCheractersFromPhoneNumber:(__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(Phone, i)];
                strPhoneNumber = [strPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                NSString *firstname = @"";
                NSString *lastname = @"";
                
                firstname = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonFirstNameProperty);
                lastname = (__bridge_transfer NSString *)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonLastNameProperty);
                
                if (!lastname) {
                    lastname = @"";
                }
                
                if (!firstname) {
                    firstname = @"";
                }
                
                [dictData setObject:firstname forKey:@"firstName"];
                [dictData setObject:lastname forKey:@"lastName"];
                
                NSInteger idstring=(NSInteger )ABRecordGetRecordID((__bridge ABRecordRef)(person));
                [dictData setObject:[NSNumber numberWithInteger:idstring] forKey:@"uniqueContactID"];
                
                NSDate* modifiedDate = (__bridge NSDate*) ABRecordCopyValue( (__bridge ABRecordRef)(person),  kABPersonModificationDateProperty);
                [dictData setObject:[AppManager stringFromDate:modifiedDate] forKey:@"strModifiedDate"];
                
                [dictData setObject:strPhoneNumber forKey:@"phoneNumber"];
                [arrAddressBook addObject:dictData];
                [arrPhoneOnly addObject:strPhoneNumber];
            }
            
            
            CFRelease(Phone);
        }
        [[DataBase database] SaveAddressBookDataBase:arrAddressBook from:NO];
        
        
        if (arrPhoneOnly.count > 0) {
            [self createDataForAddressBook:arrPhoneOnly];
        }

    });

   
    
}
+(void)createDataForAddressBook:(NSMutableArray *)arrAddressContacts
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    NSString *strMobile = [arrAddressContacts componentsJoinedByString:@","];
    [dict setObject:strMobile forKey:kMobile];
    [self callAddressBookWebService:dict];
}
+(void)callAddressBookWebService:(NSDictionary*)userData
{
    if ([Utils isInternetAvailable] == NO)
    {
        return;
    }
    
    AFHTTPSessionManager *manager = [Utils InitSetUpForWebService];
    [manager POST:kUserMobileDataURL parameters:userData
          success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"Sucees");
         NSLog(@"value =%@",userData);
         if ([[responseObject objectForKey:kstatus] intValue] == 1) {
             [[DataBase database] SaveAddressBookDataBase:[responseObject valueForKey:@"users"]from:YES];
             [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"modifiedDate"];
             [AppManager sharedManager].isFetchingContacts=NO;

         }
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"error");
//         if ([Utils isRequestTimeOut:error])
//         {
//             [Utils showAlertView:kAlertTitle message:kRequestTimeOutMessage delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//         }
//         else
//         {
//             [Utils showAlertView:kAlertTitle message:kAlertServiceFailed delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//         }
     }];
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
+(NSString*)CheckForDeletedContacts:(NSArray*)allPeople{
    
    NSArray *arrContacts=[[DataBase database] fetchDataFromDatabaseForEntity:@"Contact"];
    NSMutableSet *set2 = [NSMutableSet setWithArray: [arrContacts valueForKey:@"uniqueContactID"] ];
    
    NSNumber * max = [arrContacts valueForKeyPath:@"@max.uniqueContactID"];
    
    NSArray *newArrayFromAddressBook = [(NSArray*)[AppManager simplifiedArray:allPeople]filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uniqueContactID <= %@", max]];
    
    
    NSMutableSet *set1 = [NSMutableSet setWithArray: [newArrayFromAddressBook valueForKey:@"uniqueContactID"]];
    
    [set2 minusSet: set1];
    NSArray *resultArray = [set2 allObjects];
    
    NSString *strToBeDelete=@"";
    for (id obj  in resultArray) {
        strToBeDelete=[strToBeDelete stringByAppendingFormat:@"%@,",obj];
    }
    if ([strToBeDelete length]>0) {
        strToBeDelete = [strToBeDelete substringToIndex:[strToBeDelete length]-1];
    }
    return strToBeDelete;
}
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


+(NSString *)getDistance:(StoreModel *)objStoreModel
{
    double storeLat,storeLong;
    
    storeLat = (double)[objStoreModel.store_latitude doubleValue];
    storeLong=(double)[objStoreModel.store_longitude doubleValue];
    
    
    NSString* strStoreLoc = [NSString stringWithFormat:@"%f,%f", storeLat, storeLong];
    NSString* strCurrentLoc = [NSString stringWithFormat:@"%f,%f", appDeleg.myCurrentLocation.coordinate.latitude, appDeleg.myCurrentLocation.coordinate.longitude];
    
    NSLog(@"store Location =%@  and my location %@",strStoreLoc,strCurrentLoc);
    
    
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:storeLat longitude:storeLong];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:appDeleg.myCurrentLocation.coordinate.latitude longitude:appDeleg.myCurrentLocation.coordinate.longitude];
    
    NSString *toDistance =[NSString stringWithFormat:@"%.2f Km",[location1 distanceFromLocation:location2]/1000];
    return toDistance;
    
}

@end
