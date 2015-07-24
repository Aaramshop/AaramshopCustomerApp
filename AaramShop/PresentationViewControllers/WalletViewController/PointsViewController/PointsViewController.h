//
//  PointsViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointsTableCell.h"
#import "CMWalletPoints.h"
@protocol PointsVCDelegate <NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView onTableView:(UITableView *)tableView;
@end
typedef enum
{
	eAaramPoints = 0,
	eBonusPoints,
	eBrandPoints,
	eSelectedPointsTypeNone
}enSectionType;

@interface PointsViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
	enSectionType selectedPointsType;
	NSMutableArray *arrTemp;
	NSMutableDictionary *dicAllPoints;
	NSString *strAaramPoints;
	NSString *strBonusPoints;
	NSString *strBrandPoints;
	UILabel *lblPointsName;
	__weak IBOutlet UILabel *lblPoint;
	
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	__weak IBOutlet UITableView *tblView;
	int pageno;
	int totalNoOfPages;
	BOOL isLoading;
	
}
@property (weak, nonatomic) id <PointsVCDelegate> delegate;
@end
