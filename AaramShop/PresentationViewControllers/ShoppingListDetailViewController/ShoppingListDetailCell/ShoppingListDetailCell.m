//
//  ShoppingListDetailCell.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListDetailCell.h"

@implementation ShoppingListDetailCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)actionRemoveProduct:(id)sender
{
    int counter = [[dicTempProduct objectForKey:@"quantity"] intValue];

    if (counter==0)
    {
        btnRemove.enabled = NO;
    }
    else
    {
        btnRemove.enabled = YES;
    }
    
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(ProductCellDelegate)] && [self.delegate respondsToSelector:@selector(removeProduct:)])
    {
        [self.delegate removeProduct:_indexPath];
    }
}

-(IBAction)actionAddProduct:(id)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(ProductCellDelegate)] && [self.delegate respondsToSelector:@selector(addProduct:)])
    {
        [self.delegate addProduct:_indexPath];
    }
}


-(void)updateCell:(NSDictionary *)dicProduct
{
    dicTempProduct = [[NSMutableDictionary alloc]initWithDictionary:dicProduct];
    
    imgProduct.image = [UIImage imageNamed:[dicTempProduct objectForKey:@"image"]];
    lblProductName.text = [dicTempProduct objectForKey:@"name"];
    
    if ([[dicTempProduct objectForKey:@"quantity"] integerValue]==0)
    {
        btnRemove.enabled = NO;
    }
    else
    {
        btnRemove.enabled = YES;
    }
    
    lblCounter.text = [dicTempProduct objectForKey:@"quantity"];
}



@end
