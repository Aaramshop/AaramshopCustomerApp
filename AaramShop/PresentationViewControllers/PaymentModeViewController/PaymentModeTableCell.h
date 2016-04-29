//
//  PaymentModeTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 24/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPaymentMode.h"
@interface PaymentModeTableCell : UITableViewCell
{
    
    __weak IBOutlet UILabel *lblName;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;

@property (nonatomic, strong) NSIndexPath *indexPath;

-(void)updatePaymentModeCell:(CMPaymentMode *)PaymentMode;
@end
