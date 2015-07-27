//
//  ShoppingListDetailNewCell.m
//  AaramShop
//
//  Created by Approutes on 18/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListDetailNewCell.h"

@implementation ShoppingListDetailNewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCell:(ProductsModel *)productsModel
{
    [imgProduct sd_setImageWithURL:[NSURL URLWithString:productsModel.product_image] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
    
    lblProductName.text = productsModel.product_name;
    
    if ([productsModel.quantity integerValue]>1)
    {
        lblTotalProducts.text = [NSString stringWithFormat:@"%@ Items",productsModel.quantity];
    }
    else
    {
        lblTotalProducts.text = [NSString stringWithFormat:@"%@ Item",productsModel.quantity];
    }
    

    NSString *strRupee = @"\u20B9";
    NSString *strAmount = productsModel.product_price;

    lblProductPerUnitPrice.text = [NSString stringWithFormat:@"%@ %@",strRupee,strAmount];
    
    
    //lblOfferPrice
}

@end
