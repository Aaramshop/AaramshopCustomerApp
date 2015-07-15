//
//  ShoppingListDetailCell.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductCellDelegate <NSObject>

-(void)addProduct:(NSIndexPath *)indexPath;
-(void)removeProduct:(NSIndexPath *)indexPath;

@end

@interface ShoppingListDetailCell : UITableViewCell
{
    __weak IBOutlet UIImageView *imgProduct;
    __weak IBOutlet UILabel *lblProductName;
    __weak IBOutlet UIButton *btnRemove;
    __weak IBOutlet UILabel *lblCounter;
    __weak IBOutlet UIButton *btnAdd;
    
    NSMutableDictionary *dicTempProduct;
}

@property (nonatomic,weak) id <ProductCellDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;

-(void)updateCell:(NSDictionary *)dicProduct;

@end
