//
//  ShareContactsCell.m
//  AaramShop
//
//  Created by Approutes on 29/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AddContactsToShareCell.h"


@implementation AddContactsToShareCell

- (void)awakeFromNib {
    // Initialization code
    
    imgUser.layer.cornerRadius = imgUser.frame.size.height/2;
    imgUser.clipsToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(IBAction)actionSelectContact:(id)sender
{
    if ([self.delegateContactList respondsToSelector:@selector(selectContact:)])
    {
        [self.delegateContactList selectContact:_indexPath];
    }
}



-(void)updateContactsListCell:(ContactsData *)contactModel
{
    imgUser.image = [UIImage imageNamed:@"shoppingListDefaultImage"];
    
    if (contactModel.profilePic)
    {
        imgUser.image = contactModel.profilePic;
    }
    
    lblUserName.text = contactModel.username;
    
    if ([contactModel.isSelected integerValue]==1)
    {
        [btnSelectContact setSelected:YES];
    }
    else
    {
        [btnSelectContact setSelected:NO];
    }
    
    
}

@end
