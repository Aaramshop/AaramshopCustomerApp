//
//  ShopListTableCell.m
//  AaramShop
//
//  Created by Pradeep Singh on 15/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListCell.h"

@implementation ShoppingListCell

- (void)awakeFromNib {
    // Initialization code
    
    btnShare.enabled = NO;
    
//    [btnShare setTitleColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)actionDelete:(id)sender
{
	
}

-(void)updateCell:(ShoppingListModel *)shoppingListModel
{
    
}


@end
