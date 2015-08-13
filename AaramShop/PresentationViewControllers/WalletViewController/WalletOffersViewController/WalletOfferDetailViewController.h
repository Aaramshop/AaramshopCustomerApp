//
//  WalletOfferDetailViewController.h
//  AaramShop
//
//  Created by Neha Saxena on 12/08/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsModel.h"
#import "StoreModel.h"
#import "GlobalSearchResultTableCell.h"

@interface WalletOfferDetailViewController : UIViewController<AaramShop_ConnectionManager_Delegate,HomeSecondCustomCellDelegate, UITableViewDataSource,UITableViewDelegate>
{
	int pageno;
	int totalNoOfPages;
	BOOL isLoading;
	NSMutableArray *arrGlobalSearchResult;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	__weak IBOutlet UITableView *tblView;
	NSIndexPath *atIndexPath;
}
@property (nonatomic, retain) NSString	*	strProductId;
@end
