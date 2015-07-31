//
//  ShopListTableCell.h
//  AaramShop
//
//  Created by Pradeep Singh on 15/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListModel.h"

@protocol ShoppingListCellDelegate <NSObject>

-(void)deleteShoppingList:(NSInteger)index;
@end

@interface ShoppingListCell : UITableViewCell
{
	__weak IBOutlet UILabel *lblTitle;
	__weak IBOutlet UILabel *lblQuantity;
    __weak IBOutlet UIButton *btnTime;
	__weak IBOutlet UIButton *btnShare;
//    __weak IBOutlet UILabel *lblShare;
}

@property(nonatomic,weak) id <ShoppingListCellDelegate>delegate;
@property(nonatomic,strong) NSIndexPath *indexPath;

-(void)updateCell:(ShoppingListModel *)shoppingListModel;

@end
