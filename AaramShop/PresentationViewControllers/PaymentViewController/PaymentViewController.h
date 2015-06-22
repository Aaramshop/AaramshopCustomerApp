//
//  PaymentViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 22/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
    
    __weak IBOutlet UITableView *tblView;
    NSMutableArray *datasource;
}
@end
