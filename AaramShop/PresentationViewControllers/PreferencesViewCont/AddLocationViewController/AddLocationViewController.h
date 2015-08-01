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
@interface AddLocationViewController : UIViewController<LocationAlertViewControllerDelegate>
{
	
	__weak IBOutlet UITableView *tblView;
	NSMutableArray *datasource;
	LocationAlertViewController *locationAlert;
}
- (IBAction)btnAddLoc:(id)sender;
@end
