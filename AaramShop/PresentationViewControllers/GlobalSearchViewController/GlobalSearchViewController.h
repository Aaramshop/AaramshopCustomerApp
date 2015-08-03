//
//  GlobalSearchViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 01/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobalSearchViewController : UIViewController
{
	
	__weak IBOutlet UITableView *tblView;
	BOOL isSearching;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchCustomer;
@end
