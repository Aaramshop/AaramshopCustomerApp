//
//  PostAutoSuggestionCell.m
//  SocialParty
//
//  Created by JTMD Innovations GmbH on 16/06/14.
//  Copyright (c) 2014 Chapp GmbH. All rights reserved.
//

#import "PostAutoSuggestionCell.h"

@implementation PostAutoSuggestionCell
@synthesize lblFullName,lblUserName,profileImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //User Profile Image
        profileImage=[[UIImageView alloc]initWithFrame:CGRectMake(6,5,26,26)];
//        profileImage.image=[UIImage imageNamed:@"homeImage.png"];
        [profileImage.layer setCornerRadius:4.0];
        profileImage.clipsToBounds = YES;
    
        profileImage.layer.cornerRadius = 2.0;
        profileImage.layer.masksToBounds = YES;
        
        //Label Full Name
        lblFullName=[[UILabel alloc]initWithFrame:CGRectMake(10,4,290,16)];
        lblFullName.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
        lblFullName.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
        lblFullName.backgroundColor=[UIColor clearColor];
        
        //Label User Name
        lblUserName=[[UILabel alloc]initWithFrame:CGRectMake(38,22,290,16)];
        lblUserName.textColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0];
//        lblUserName.font = [UIFont fontWithName:ssFontHelveticaNeue size:13];
        lblUserName.backgroundColor=[UIColor clearColor];
        
        
        [self addSubview:profileImage];
        [self addSubview:lblFullName];
        [self addSubview:lblUserName];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
