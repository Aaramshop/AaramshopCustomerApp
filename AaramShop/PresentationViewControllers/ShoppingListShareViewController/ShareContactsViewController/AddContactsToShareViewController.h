//
//  ShareContactsViewController.h
//  AaramShop
//
//  Created by Approutes on 29/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddContactsToShareCell.h"
#import "ContactsData.h"


@interface AddContactsToShareViewController : UIViewController <ContactListCellDelegate, AaramShop_ConnectionManager_Delegate,UISearchDisplayDelegate>
{
    __weak IBOutlet UITableView *tblContacts;
    __weak IBOutlet UISearchBar *searchbar;
    
    
    NSMutableArray *arrContactsData;
    NSMutableArray *arrFilteredContactsData;
    
    ContactsData *contacts;
        
}

@property(nonatomic, strong) NSString *strShoppingListId;

@end
