//
//  PaymentModeViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 24/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPaymentMode.h"
#import "TotalAmtTableCell.h"
#import "PaymentModeTableCell.h"
@interface PaymentModeViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
    
    __weak IBOutlet UITableView *tblView;
    NSMutableArray *arrPaymentMode;
}
@end
