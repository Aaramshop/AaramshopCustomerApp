//
//  BroadcastViewController.h
//  AaramShop
//
//  Created by Neha Saxena on 28/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersTableCell.h"
@interface BroadcastViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AaramShop_ConnectionManager_Delegate,OffersTableCellDelegate>
{
	__weak IBOutlet UITableView *tblView;
    __weak IBOutlet UILabel *lblMessage;

	NSMutableArray *arrBroadcast;
	int broadcastPageNo;
	int broadcastTotalNoOfPages;
	BOOL isLoading;
}
@end
