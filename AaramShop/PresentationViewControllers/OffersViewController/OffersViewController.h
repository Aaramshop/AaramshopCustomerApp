//
//  OffersViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersTableCell.h"
#import "CMOffers.h"

@interface OffersViewController : UIViewController<CDRTranslucentSideBarDelegate,AaramShop_ConnectionManager_Delegate,UITableViewDelegate,UITableViewDataSource>
{
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;

	__weak IBOutlet UITableView *tblView;
	NSMutableArray *arrOffers;
	NSMutableArray *arrBroadcast;
	
	int pageno;
	int broadcastPageNo;
	int broadcastTotalNoOfPages;
	int totalNoOfPages;
	BOOL isLoading;
}

- (IBAction)selectionChanged:(id)sender;

@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end
