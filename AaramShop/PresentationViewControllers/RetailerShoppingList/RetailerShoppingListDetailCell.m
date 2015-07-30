//
//  RetailerShoppingListDetailCelll.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "RetailerShoppingListDetailCell.h"

@implementation RetailerShoppingListDetailCell

- (void)awakeFromNib {
    // Initialization code
    
    [lblProductName setAdjustsFontSizeToFitWidth:YES];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)actionRemoveProduct:(id)sender
{
    int counter = [tempProductModel.quantity intValue];

    if (counter==0)
    {
        btnRemove.enabled = NO;
    }
    else
    {
        btnRemove.enabled = YES;
    }
    
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(RetailerShoppingListCellDelegate)] && [self.delegate respondsToSelector:@selector(removeProduct:)])
    {
        [self.delegate removeProduct:_indexPath];
    }
}


-(IBAction)actionAddProduct:(id)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(RetailerShoppingListCellDelegate)] && [self.delegate respondsToSelector:@selector(addProduct:)])
    {
        [self.delegate addProduct:_indexPath];
    }
}


-(void)updateCell:(ProductsModel *)productsModel
{
    tempProductModel = productsModel;
    

    [imgProduct sd_setImageWithURL:[NSURL URLWithString:tempProductModel.product_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
    
    lblProductName.text = tempProductModel.product_name;
    
    if ([tempProductModel.quantity integerValue]==0)
    {
        btnRemove.enabled = NO;
    }
    else
    {
        btnRemove.enabled = YES;
    }
    
    if ([tempProductModel.quantity integerValue]<20)
    {
        btnAdd.enabled = YES;
    }
    else
    {
        btnAdd.enabled = NO;
    }
    
    
    lblCounter.text = tempProductModel.quantity;
}



@end
