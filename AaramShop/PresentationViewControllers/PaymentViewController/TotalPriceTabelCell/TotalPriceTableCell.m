//
//  TotalPriceTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 22/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "TotalPriceTableCell.h"

@implementation TotalPriceTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateCellWithData:(NSDictionary *)inDataDic
{
    lblDeliveryCharges.text = [inDataDic objectForKey:kDeliveryCharges];
    lblDiscount.text = [inDataDic objectForKey:kDiscount];
    lblSubTotal.text = [inDataDic objectForKey:kSubTotalPrice];
    lblTotal.text = [inDataDic objectForKey:kTotalPrice];
}

@end
