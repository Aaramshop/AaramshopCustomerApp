//
//  PointsTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PointsTableCell.h"

@implementation PointsTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateCellWithData:(CMWalletPoints *)walletPointModel
{
	if ([walletPointModel.product_name isEqualToString:@"(null)"] && ![walletPointModel.store_name isEqualToString:@"(null)"]) {
		lblName.text = walletPointModel.store_name;
		lblPoints.text = walletPointModel.point;
	}
	else if ([walletPointModel.store_name isEqualToString:@"(null)"])
	{
		lblName.text = walletPointModel.order_code;
		lblPoints.text = walletPointModel.point;
	}
	else
	{
		lblName.text = walletPointModel.brand_name;
		lblPoints.text = walletPointModel.point;
	}
}
@end
