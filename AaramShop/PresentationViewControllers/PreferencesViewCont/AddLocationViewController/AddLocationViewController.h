//
//  AddLocationViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTableCell.h"
#import "AddressModel.h"
#import "LocationAlertViewController.h"
@interface AddLocationViewController : UIViewController<LocationAlertViewControllerDelegate,LocationListCellDelegate,AaramShop_ConnectionManager_Delegate>
{
	
	__weak IBOutlet UITableView *tblView;
	NSMutableArray *datasource;
	LocationAlertViewController *locationAlert;
}
//- (IBAction)deleteCell:(id)sender;

- (IBAction)btnAddLoc:(id)sender;
@end
