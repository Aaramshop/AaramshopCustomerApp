//
//  ShareContactsCell.m
//  AaramShop
//
//  Created by Approutes on 29/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AddContactsToShareCell.h"


@implementation AddContactsToShareCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self setUI];
    }
    return self;
}


-(void)setUI
{
    //
    imgUser = [[UIImageView alloc]initWithFrame:CGRectMake(5, 7, 44, 44)];
    imgUser.contentMode = UIViewContentModeScaleAspectFit;
    
    //
    lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(71, 18, 190, 21)];
    lblUserName.font = [UIFont fontWithName:kRobotoRegular size:15];
    lblUserName.textColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0];
    
    //
    btnSelectContact = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSelectContact setImage:[UIImage imageNamed:@"checkBoxInactive.png"] forState:UIControlStateNormal];
    [btnSelectContact setImage:[UIImage imageNamed:@"checkBoxActive.png"] forState:UIControlStateSelected];
    
    [btnSelectContact addTarget:self action:@selector(actionSelectContact:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [self.contentView addSubview:imgUser];
    [self.contentView addSubview:lblUserName];
    [self.contentView addSubview:btnSelectContact];

}

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
