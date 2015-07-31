//
//  ShareContactsCell.h
//  AaramShop
//
//  Created by Approutes on 29/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsData.h"

@protocol ContactListCellDelegate <NSObject>

-(void)selectContact:(NSIndexPath *)indexPath;

@end


@interface AddContactsToShareCell : UITableViewCell
{
    __weak IBOutlet UIImageView *imgUser;
    __weak IBOutlet UILabel *lblUserName;
    __weak IBOutlet UIButton *btnSelectContact;

}

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id <ContactListCellDelegate> delegateContactList;

-(void)updateContactsListCell:(ContactsData *)contactModel;


@end
