//
//  ShoppingListDetailCell.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsModel.h"

@protocol RetailerShoppingListCellDelegate <NSObject>

-(void)addProduct:(NSIndexPath *)indexPath;
-(void)removeProduct:(NSIndexPath *)indexPath;

@end

@interface RetailerShoppingListDetailCell : UITableViewCell
{
    __weak IBOutlet UIImageView *imgProduct;
    __weak IBOutlet UILabel *lblProductName;
    __weak IBOutlet UILabel	*lblPrice;
    __weak IBOutlet UIButton *btnRemove;
    __weak IBOutlet UILabel *lblCounter;
    __weak IBOutlet UIButton *btnAdd;
    
    ProductsModel *tempProductModel;
}

@property (nonatomic,weak) id <RetailerShoppingListCellDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;

-(void)updateCell:(ProductsModel *)productsModel;

@end