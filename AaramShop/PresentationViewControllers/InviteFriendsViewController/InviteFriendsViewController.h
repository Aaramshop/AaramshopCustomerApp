//
//  InviteFriendsViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 08/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookLoginClass.h"
#import "InviteFriendsTableCell.h"

@interface InviteFriendsViewController : UIViewController<AaramShop_ConnectionManager_Delegate,InviteUserdelegate,UITextViewDelegate>
{
	NSMutableArray *arrFBUsers;
	__weak IBOutlet UITableView *tblView;
	
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	BOOL isLoading;
	int totalNoOfPages;
	NSString *selectedFBId;
	AppDelegate *appDeleg;
	__weak IBOutlet UIView *viewFBLogin;
	UITextView *tvFBMessage;
	UIView *viewFBMessage;
	NSString *fbPage_no;
}
@end
