//
//  DataBase.h
//  AaramShop
//
//  Created by Approutes on 19/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject

+ (DataBase *)database;
//-(void)SaveAddressBookDataBase:(NSMutableArray*)array from:(BOOL)updatedArray;
-(NSArray *)CallForGetContacts;
-(NSArray *)fetchDataFromDatabaseForEntity:(NSString *)entityName;
-(void)DeleteAddressBookFromDatabase:(NSString*)idsToBeDelete;
@end
