//
//  PreferencesViewController.h
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPreferences.h"
#import "AddressModel.h"
#import "AddLocationViewController.h"
#import "HomeStoreViewController.h"
@interface PreferencesViewController : UIViewController<CustomNavigationDelegate,AaramShop_ConnectionManager_Delegate>
{
	
	__weak IBOutlet UITableView *tblView;
	CMPreferences *preferencesModel;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	NSMutableArray *arrLocation;
	NSString *strAddressCount;
	UIButton *doneBtn;
	UIButton *backBtn;
	AppDelegate *appDel;
}
@end
