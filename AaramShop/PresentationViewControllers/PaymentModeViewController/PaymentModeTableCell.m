//
//  PaymentModeTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 24/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PaymentModeTableCell.h"

@implementation PaymentModeTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updatePaymentModeCell:(CMPaymentMode *)PaymentMode
{
   
    lblName.text = PaymentMode.name;
}

@end
