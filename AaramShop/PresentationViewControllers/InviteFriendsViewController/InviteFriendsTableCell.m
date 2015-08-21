//
//  InviteFriendsTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 08/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "InviteFriendsTableCell.h"

@implementation InviteFriendsTableCell

- (void)awakeFromNib {
	// Initialization code
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	imgUser.layer.cornerRadius = imgUser.frame.size.width/2;
	imgUser.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}
-(void)updateInviteFriendCellWithData:(id)user
{
		
		//        imgUser.image = [UIImage imageNamed:[user valueForKey:@"profilePic"]];
		[imgUser sd_setImageWithURL:[NSURL URLWithString:[user valueForKey:@"profilePic"]] placeholderImage:[UIImage imageNamed:@"defaultProfilePic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			//
		}];
		lblUsername.text = [user valueForKey:@"username"];
		
		
		if ([[user valueForKey:@"isInvited"] integerValue]==1)
		{
			[btnInvite setSelected:YES];
		}
		else
		{
			[btnInvite setSelected:NO];
		}
		
	
	
}
-(IBAction)actionInviteUser:(id)sender
{
	if ([self.delegateInvite respondsToSelector:@selector(btnInviteClicked:isFromFacebook:)])
	{
		[self.delegateInvite btnInviteClicked:_indexPath isFromFacebook:YES];
	}
}

@end
