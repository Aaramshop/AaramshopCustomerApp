//
//  ShoppingListDetailNewCell.h
//  AaramShop
//
//  Created by Approutes on 18/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsModel.h"

@interface ShoppingListDetailNewCell : UITableViewCell
{
    __weak IBOutlet UIImageView *imgProduct;
    __weak IBOutlet UILabel *lblProductName;
    __weak IBOutlet UILabel *lblTotalProducts;
    __weak IBOutlet UILabel *lblProductPerUnitPrice;
    __weak IBOutlet UILabel *lblOfferPrice;
}

@property (nonatomic,strong) NSIndexPath *indexPath;

-(void)updateCell:(ProductsModel *)productsModel;



@end
