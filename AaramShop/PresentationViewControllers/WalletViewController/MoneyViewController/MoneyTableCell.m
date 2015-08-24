//
//  MoneyTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "MoneyTableCell.h"

@implementation MoneyTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateCellWithData:(CMWalletMoney *)walletMoneyModel
{
	lblBrandName.text = walletMoneyModel.store_name;
	lblDate.text = walletMoneyModel.order_date;
	lblAmount.text = [NSString stringWithFormat:@"\u20B9 %@",[walletMoneyModel.due_amount stringByReplacingOccurrencesOfString:@"-" withString:@""] ];
}
@end
