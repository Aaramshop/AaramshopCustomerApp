//
//  LocationTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 31/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "LocationTableCell.h"

@implementation LocationTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateCellWithData: (AddressModel *)addressModel
{
	lblTitle.text = addressModel.title;
	lblAddress.text = [NSString stringWithFormat:@"%@, %@, %@, %@",addressModel.address,addressModel.state,addressModel.city,addressModel.pincode];
}
@end
