//
//  InviteFriendsTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 08/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsTableCell : UITableViewCell
{
	IBOutlet UIImageView *imgUser;
	IBOutlet UILabel *lblUsername;
	IBOutlet UIButton *btnInvite;
	
	BOOL isUserFromFacebook;
}

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <InviteUserdelegate> delegateInvite;

-(void)updateInviteFriendCellWithData:(id)user;
@end
