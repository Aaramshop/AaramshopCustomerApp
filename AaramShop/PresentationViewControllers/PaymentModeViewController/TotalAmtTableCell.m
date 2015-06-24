//
//  TotalAmtTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 24/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "TotalAmtTableCell.h"

@implementation TotalAmtTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateCellWithData:(NSDictionary *)inDataDic
{
    NSString *strRupeSymbol =@"";
    lblTotalAmt.text = @"Total Amount";
    lblPrice.text =[NSString stringWithFormat:@"%@ 8989",strRupeSymbol ];
}
@end
