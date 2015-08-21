//
//  InviteFriendsTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 08/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InviteFriendsTableCelldelegate <NSObject>
-(void)btnInviteClicked:(NSIndexPath *)indexPath isFromFacebook:(BOOL)userType;
@end
@interface InviteFriendsTableCell : UITableViewCell
{
	IBOutlet UIImageView *imgUser;
	IBOutlet UILabel *lblUsername;
	IBOutlet UIButton *btnInvite;
	
	BOOL isUserFromFacebook;
}

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <InviteFriendsTableCelldelegate> delegateInvite;

-(void)updateInviteFriendCellWithData:(id)user;
-(IBAction)actionInviteUser:(id)sender;
@end
