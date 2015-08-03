//
//  OffersViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersTableCell.h"
#import "CMOffers.h"
#import "CouponModel.h"
#import "MyCustomOfferTableCell.h"
#import "ComboDetailViewController.h"
@interface OffersViewController : UIViewController<CDRTranslucentSideBarDelegate,AaramShop_ConnectionManager_Delegate,UITableViewDelegate,UITableViewDataSource,OffersTableCellDelegate>
{
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;

	__weak IBOutlet UITableView *tblView;
	NSMutableArray *arrOffers;
	NSMutableArray *arrCoupon;
	
	int pageno;
	int couponPageNo;
	int couponTotalNoOfPages;
	int totalNoOfPages;
	BOOL isLoading;
}

- (IBAction)selectionChanged:(id)sender;

@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end
