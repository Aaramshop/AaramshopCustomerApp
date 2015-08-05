//
//  GlobalSearchResultTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 05/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "GlobalSearchResultTableCell.h"

@implementation GlobalSearchResultTableCell

- (void)awakeFromNib {
    // Initialization code
	imgProduct.layer.cornerRadius = imgProduct.frame.size.width/2;
	imgProduct.layer.masksToBounds = YES;
	imgStore.layer.cornerRadius = imgProduct.frame.size.width/2;
	imgStore.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
