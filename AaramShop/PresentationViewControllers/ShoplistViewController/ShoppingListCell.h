//
//  ShopListTableCell.h
//  AaramShop
//
//  Created by Pradeep Singh on 15/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListModel.h"

@protocol ShoppingListDelegate <NSObject>

-(void)deleteShoppingList:(NSIndexPath *)indexPath;
@end

@interface ShoppingListCell : UITableViewCell
{
	__weak IBOutlet UILabel *lblTitle;
	__weak IBOutlet UILabel *lblQuantity;
	__weak IBOutlet UILabel *lblTime;
	__weak IBOutlet UIButton *btnShare;
}

@property(nonatomic,weak) id <ShoppingListDelegate>delegate;
@property(nonatomic,strong) NSIndexPath *indexPath;

-(void)updateCell:(ShoppingListModel *)shoppingListModel;

@end
