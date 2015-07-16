//
//  ShoppingListShareCell.m
//  AaramShop
//
//  Created by Approutes on 15/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListShareCell.h"

@implementation ShoppingListShareCell

- (void)awakeFromNib {
    // Initialization code
    
    imgUser.layer.cornerRadius = imgUser.frame.size.height/2;
    imgUser.clipsToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateCell
{
    imgUser.image = [UIImage imageNamed:@"shoppingListDefaultImage"];
    lblUserName.text = @"Username";
}

@end
