//
//  DataBase.m
//  AaramShop
//
//  Created by Approutes on 19/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "DataBase.h"
#import "Contact.h"

static DataBase *_sharedInstance;
AppDelegate *appDeleg;
@implementation DataBase

+ (DataBase *)database {
    @synchronized([DataBase class]) {
        if (!_sharedInstance)
            _sharedInstance = [[self alloc] init];
        
        return _sharedInstance;
    }
    return nil;
}
+ (id)alloc {
    @synchronized([DataBase class]) {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
}

- (id)init {
    if (self = [super init]) {
        //		[self setManagedObjectContext:[AppDelegate managedObjectContext]];
        //        [self.managedObjectContext setRetainsRegisteredObjects:YES];
        //        [self loadMetaData];
    }
    return self;
}
-(void)SaveAddressBookDataBase:(NSArray*)array from:(BOOL)updatedArray
{
    NSManagedObjectContext *context;
    if (!context) {
        appDeleg = (AppDelegate *)APP_DELEGATE;
        context = [appDeleg managedObjectContext];
    }
    NSError *error;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    if(!updatedArray)
    {
        for (id obj in array) {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"phoneNumber MATCHES %@",[obj valueForKey:@"phoneNumber"]];
            
            NSPredicate *finalPred  = nil;
            finalPred =[NSCompoundPredicate orPredicateWithSubpredicates:@[pred]];
            [request setPredicate:finalPred];
            
            
            NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
            Contact *addressBook = nil;
            
            if ([mutableFetchResults count]>0) {
                addressBook = (Contact*)[mutableFetchResults objectAtIndex:0];
            }else
                addressBook = (Contact *)[NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:context];
            addressBook.firstName = [obj valueForKey:@"firstName"];
            addressBook.lastName = [obj valueForKey:@"lastName"];
            if([obj valueForKey:@"uniqueContactID"])
            {
                addressBook.uniqueContactID = [obj valueForKey:@"uniqueContactID"];
            }
            
            if([obj valueForKey:@"strModifiedDate"])
            {
                addressBook.modifiedDate =[obj valueForKey:@"strModifiedDate"];
            }
            
            if ([[obj valueForKey:@"phoneNumber"] length]>0) {
                
                NSArray *arrPhones = [[obj valueForKey:@"phoneNumber"] componentsSeparatedByString:@","];
                
                for (NSString *strPhonesValues in arrPhones) {
                    addressBook.phoneNumber = strPhonesValues;
                }
            }
        }
    }
    else
    {
        for(id obj in array)
        {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"phoneNumber MATCHES %@",[obj valueForKey:@"mobile"]];
            
            NSPredicate *finalPred  = nil;
            finalPred =[NSCompoundPredicate orPredicateWithSubpredicates:@[pred]];
            [request setPredicate:finalPred];
            
            NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
            
            Contact *addressBook = nil;
            
            if ([mutableFetchResults count]>0) {
                addressBook = (Contact*)[mutableFetchResults objectAtIndex:0];
                addressBook.address = [obj valueForKey:kAddress];
                addressBook.adultFemale =[obj valueForKey:kAdultFemale];
                addressBook.adultMale = [obj valueForKey:kAdultMale];
                addressBook.chatUsername = [obj valueForKey:kChatUsername];
                addressBook.city = [obj valueForKey:kCity];
                addressBook.dob = [obj valueForKey:kDob];
                addressBook.userId = [obj valueForKey:kUserId];
                addressBook.email = [obj valueForKey:kEmail];
                addressBook.femaleChild = [obj valueForKey:kFemaleChild];
                addressBook.gender = [obj valueForKey:kGender];
                addressBook.income = [obj valueForKey:kIncome];
                addressBook.maleChild = [obj valueForKey:kMaleChild];
                addressBook.profileImage =[obj valueForKey:kProfileImage];
                addressBook.qualification = [obj valueForKey:kQualification];
                addressBook.state = [obj valueForKey:kState];
                addressBook.toddlers = [obj valueForKey:kToddlers];
                addressBook.userId = [obj valueForKey:kUserId];
                addressBook.firstNameServer =[obj valueForKey:kFirstName];
                addressBook.lastNameServer = [obj valueForKey:kLastName];
                addressBook.isAppUser = YES;
            }
        }
    }
    if (![context save:&error])
    {
        NSLog(@"Error : %@",error);
        abort();
    }
}


#pragma mark - AddressBook
-(void)DeleteAddressBookFromDatabase:(NSString*)idsToBeDelete{
    if (!idsToBeDelete) {
        return;
    }
    NSManagedObjectContext *context;
    if (!context) {
        context = [APP_DELEGATE managedObjectContext];
    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];


    // Fetch the records and handle an error
	NSError *error;

    NSArray *array=[idsToBeDelete componentsSeparatedByString:@","];
    for (id obj in array) {

        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];

        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(uniqueContactID == %d)",[obj integerValue]];
        NSPredicate *finalPred = [NSCompoundPredicate andPredicateWithSubpredicates: @[pred2]];

        [request setPredicate:finalPred];


        NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];

        for (NSManagedObject *managedObject in mutableFetchResults) {
            [context deleteObject:managedObject];
        }
        if (![context save:&error])
        {
            abort();
        }


    }
}

-(NSArray *)fetchDataFromDatabaseForEntity:(NSString *)entityName{
    NSManagedObjectContext *context;
    if (!context) {
        appDeleg = (AppDelegate *)APP_DELEGATE;
        context = [appDeleg managedObjectContext];
    }
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entityName inManagedObjectContext:context];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];

    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];

    if (array == nil)
    {
        // Deal with error...
    }

    return array;

}
-(NSArray *)CallForGetContacts
{
    appDeleg = (AppDelegate *)APP_DELEGATE;
    NSManagedObjectContext *context =[appDeleg managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    
    NSError *error=nil;
    
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error==nil)
    {
        
    }
    else if (error!=nil)
    {
        
    }
    return results;
}


//-(void)SaveAddressBookDataBase:(NSArray*)array from:(BOOL)updatedArray{
//
//    NSManagedObjectContext *context;
//    if (!context) {
//        context = [APP_DELEGATE managedObjectContext];
//    }
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AddressBookDB" inManagedObjectContext:context];
//
//
//  // Fetch the records and handle an error
//	NSError *error;
//    NSString *strBaseImageUrl=[[NSUserDefaults standardUserDefaults] valueForKey:kServerUrl];
//    if(!updatedArray)
//    {
//        for (id obj in array) {
//            NSFetchRequest *request = [[NSFetchRequest alloc] init];
//            [request setEntity:entity];
//
//            NSInteger userId=[[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] integerValue];
//            NSPredicate *pred = [NSPredicate predicateWithFormat:@"(uniqueContactID == %d)",[[obj valueForKey:@"uniqueContactID"] integerValue]];
//            NSPredicate *finalPred  = nil;
//            finalPred =[NSCompoundPredicate orPredicateWithSubpredicates:@[pred]];
//           [request setPredicate:finalPred];
//
//
//            NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
//
//            AddressBookDB *addressBook = nil;
//
//            if ([mutableFetchResults count]>0) {
//                addressBook = (AddressBookDB*)[mutableFetchResults objectAtIndex:0];
//            }else
//            addressBook = (AddressBookDB *)[NSEntityDescription insertNewObjectForEntityForName:@"AddressBookDB" inManagedObjectContext:context];
//
//            addressBook.userId =[NSNumber numberWithInteger:userId];
//
//            if ([[obj valueForKey:@"phone"] count]>0) {
//                NSData *jsonDataEmail = [NSJSONSerialization dataWithJSONObject:[obj valueForKey:@"phone"] options:NSJSONWritingPrettyPrinted error:&error];
//                NSString *jsonEmail = [[NSString alloc] initWithData:jsonDataEmail encoding:NSUTF8StringEncoding];
//                addressBook.phone = jsonEmail;
//            }
//            if ([[obj valueForKey:@"email"] count]>0) {
//                NSData *jsonDataEmail = [NSJSONSerialization dataWithJSONObject:[obj valueForKey:@"email"] options:NSJSONWritingPrettyPrinted error:&error];
//                NSString *jsonEmail = [[NSString alloc] initWithData:jsonDataEmail encoding:NSUTF8StringEncoding];
//                addressBook.email = jsonEmail;
//            }
//            if([obj valueForKey:@"uniqueContactID"])
//            {
//                addressBook.uniqueContactID =[NSNumber numberWithInteger: [[obj valueForKey:@"uniqueContactID"] integerValue]];
//            }
//            if([[obj valueForKey:@"name"] length]>0)
//            {
//                addressBook.fullName=[obj valueForKey:@"name"];
//            }
//            if([obj valueForKey:@"strModifiedDate"])
//            {
//                addressBook.modifiedDate = [AppManager DateFromString:[obj valueForKey:@"strModifiedDate"]];
//                addressBook.strModifiedDate =[obj valueForKey:@"strModifiedDate"];
//            }
//            if([obj valueForKey:kNotes])
//            {
//                addressBook.notes=[obj valueForKey:kNotes];
//            }
//            if([obj valueForKey:kJobTitle])
//            {
//                addressBook.jobTitle=[obj valueForKey:kJobTitle];
//            }
//            if([addressBook.isFriend boolValue]==YES)
//            {
//                addressBook.isFriend=[NSNumber numberWithBool:YES];
//            }
//            else
//            {
//                addressBook.isFriend=[NSNumber numberWithBool:YES];
//            }
//            addressBook.firstName = [obj valueForKey:@"firstname"];
//            addressBook.lastName = [obj valueForKey:@"lastname"];
//        }
//    }
//    else
//    {
//        for(id obj in array)
//        {
//            NSFetchRequest *request = [[NSFetchRequest alloc] init];
//            [request setEntity:entity];
//
//            NSPredicate *pred = [NSPredicate predicateWithFormat:@"phone CONTAINS[cd] %@",[obj valueForKey:@"chatUserName"]];
//            NSPredicate *finalPred  = nil;
//            finalPred =[NSCompoundPredicate orPredicateWithSubpredicates:@[pred]];
//            [request setPredicate:finalPred];
//
//            NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
//
//            AddressBookDB *addressBook = nil;
//
//            if ([mutableFetchResults count]>0) {
//                addressBook = (AddressBookDB*)[mutableFetchResults objectAtIndex:0];
//                addressBook.phone = addressBook.phone;
//                addressBook.email = addressBook.email;
//                addressBook.fullName = addressBook.fullName;
//                addressBook.modifiedDate = addressBook.modifiedDate;
//                addressBook.userId = addressBook.userId;
//                addressBook.uniqueContactID = addressBook.uniqueContactID;
//                addressBook.isFriend = [NSNumber numberWithBool:YES];
//                addressBook.jobTitle = addressBook.jobTitle;
//                addressBook.notes = addressBook.notes;
//                addressBook.strModifiedDate = addressBook.strModifiedDate;
//                addressBook.firstName = [obj valueForKey:@"firstname"];
//                addressBook.lastName = [obj valueForKey:@"lastname"];
//
//                if([obj valueForKey:@"appUserId"])
//                {
//                    addressBook.originalUserId=[NSNumber numberWithInteger:[[obj valueForKey:@"appUserId"] integerValue]];
//                }
//                if([obj valueForKey:@"appUsername"])
//                {
//                    addressBook.orgAppUsername=[obj valueForKey:@"appUsername"];
//                }
//                if([obj valueForKey:@"chatUserName"])
//                {
//                    addressBook.orgChatUsername=[obj valueForKey:@"chatUserName"];
//                }
//                if([obj valueForKey:@"profilePic"])
//                {
//                    addressBook.profilePic=[strBaseImageUrl stringByAppendingString:[obj valueForKey:@"profilePic"]];
//                }
//                if([obj valueForKey:kUserStatus])
//                {
//                    addressBook.userStatus=[obj valueForKey:kUserStatus];
//                }
//            }
//        }
//    }
//    if (![context save:&error])
//    {
//        NSLog(@"Error : %@",error);
//        abort();
//    }
//}

@end
