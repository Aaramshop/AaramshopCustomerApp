//
//  OffersViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscountTableCell.h"
#import "CouponTableCell.h"

@interface OffersViewController : UIViewController<CDRTranslucentSideBarDelegate,AaramShop_ConnectionManager_Delegate>
{
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;

	__weak IBOutlet UITableView *tblView;
	NSMutableArray *arrDiscount;
	NSMutableArray *arrCoupon;
	
	int pageno;
	int totalNoOfPages;
	BOOL isLoading;
}



@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end
