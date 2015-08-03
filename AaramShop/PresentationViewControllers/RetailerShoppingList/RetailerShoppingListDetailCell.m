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
    lblPrice.numberOfLines = 0;
    [lblPrice sizeToFit];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)actionRemoveProduct:(id)sender
{
//    int counter = [tempProductModel.quantity intValue];
    
    int counter = [tempProductModel.strCount intValue];


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
    
    
    
    //// offer - begin ///    
    
    NSString *strRupee = @"\u20B9";
    NSString *strActualPrice = [NSString stringWithFormat:@"%@ %@",strRupee,tempProductModel.product_price];

    
    
    if([tempProductModel.offer_type integerValue]==1)
    {
        lblOfferPrice.hidden = NO;
        
        NSDictionary* actPriceAttributes = @{
                                             NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle],
                                             NSForegroundColorAttributeName : [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0]
                                             };
        
        NSAttributedString* actPriceAttrString = [[NSAttributedString alloc] initWithString:strActualPrice attributes:actPriceAttributes];
        
        
        lblPrice.attributedText = actPriceAttrString;
        lblOfferPrice.text = [NSString stringWithFormat:@"%@ %@",strRupee,tempProductModel.offer_price];

    }
    else
    {
        lblOfferPrice.hidden = YES;
        lblPrice.text = strActualPrice;
    }
    //// offer - end ///

    
    
//    if ([tempProductModel.quantity integerValue]==0)
    if ([tempProductModel.strCount integerValue]==0)
    {
        btnRemove.enabled = NO;
    }
    else
    {
        btnRemove.enabled = YES;
    }
    
//    if ([tempProductModel.quantity integerValue]<20)
    if ([tempProductModel.strCount integerValue]<20)
    {
        btnAdd.enabled = YES;
    }
    else
    {
        btnAdd.enabled = NO;
    }
    
    
//    lblCounter.text = tempProductModel.quantity;
    lblCounter.text = tempProductModel.strCount;

}



@end
