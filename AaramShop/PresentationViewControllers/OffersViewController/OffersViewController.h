//
//  OffersViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscountTableCell.h"
#import "CouponTableCell.h"

typedef enum
{
	eSelectedTypeNone = 0,
	eSelectedDiscount,
	eSelectedCoupon
}enSelectedOfferBtn;

@protocol OffersViewControllerDelegate <NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView onTableView:(UITableView *)tableView;
@end

@interface OffersViewController : UIViewController<CDRTranslucentSideBarDelegate,AaramShop_ConnectionManager_Delegate>
{
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;

	enSelectedOfferBtn selectedOffer;
	__weak IBOutlet UIButton *couponBtn;
	
	__weak IBOutlet UIButton *discountBtn;
	__weak IBOutlet UITableView *tblView;
	NSMutableArray *arrDiscount;
	NSMutableArray *arrCoupon;
	
	int pageno;
	int totalNoOfPages;
	BOOL isLoading;
}

- (IBAction)btnDiscount:(id)sender;
- (IBAction)btnCoupon:(id)sender;
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (weak, nonatomic) id <OffersViewControllerDelegate> delegate;

@end
