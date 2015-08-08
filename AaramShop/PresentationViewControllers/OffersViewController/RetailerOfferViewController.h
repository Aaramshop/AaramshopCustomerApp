//
//  RetailerOfferViewController.h
//  AaramShop
//
//  Created by Neha Saxena on 28/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffersTableCell.h"
#import "CMOffers.h"
#import "ComboDetailViewController.h"
#import "MyCustomOfferTableCell.h"
#import "CartViewController.h"
@interface RetailerOfferViewController : UIViewController<AaramShop_ConnectionManager_Delegate,UITableViewDelegate,UITableViewDataSource,OffersTableCellDelegate>
{
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	
	__weak IBOutlet UITableView *tblView;
	NSMutableArray *arrOffers;
	int pageno;
	int totalNoOfPages;
	BOOL isLoading;
}

@end
