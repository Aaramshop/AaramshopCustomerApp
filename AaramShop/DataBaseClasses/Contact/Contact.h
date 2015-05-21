//
//  Contact.h
//  AaramShop
//
//  Created by Approutes on 20/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * uniqueContactID;
@property (nonatomic, retain) NSString * modifiedDate;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * adultFemale;
@property (nonatomic, retain) NSString * adultMale;
@property (nonatomic, retain) NSString * chatUsername;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * dob;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * femaleChild;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * income;
@property (nonatomic, retain) NSString * maleChild;
@property (nonatomic, retain) NSString * profileImage;
@property (nonatomic, retain) NSString * qualification;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * toddlers;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * firstNameServer;
@property (nonatomic, retain) NSString * lastNameServer;
@property (nonatomic, assign) Boolean  isAppUser;

@end
