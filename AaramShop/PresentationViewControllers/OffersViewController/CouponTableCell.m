//
//  CouponTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 12/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "CouponTableCell.h"

@implementation CouponTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//-(void)updateCellWithData:(CMCouponOffer *)couponOffer {
//	
//}
- (void)updateCellWithData:(NSDictionary *)inDataDic
{
	lblBrandName.text = [inDataDic objectForKey:@"name"];
	lblCouponCode.text = [inDataDic objectForKey:@"offer"];
	lblDateTime.text = [inDataDic objectForKey:@"date"];
}

@end
