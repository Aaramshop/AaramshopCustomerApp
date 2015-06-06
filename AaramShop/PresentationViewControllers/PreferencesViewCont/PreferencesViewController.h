//
//  PreferencesViewController.h
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferenceTableCell.h"
#import "CurLocationTableCell.h"

@interface PreferencesViewController : UIViewController<CustomNavigationDelegate,delegateSwitchValue>
{
    
    __weak IBOutlet UITableView *tblView;
}
@end
