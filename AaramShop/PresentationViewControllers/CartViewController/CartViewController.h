//
//  CartViewController.h
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListDetailCell.h"
#import "ShoppingListChooseStoreModel.h"

@interface CartViewController : UIViewController<ProductCellDelegate>
{
    IBOutlet UITableView *tblView;
}

@property	(nonatomic, strong) ShoppingListChooseStoreModel *selectedStore;
@property	(nonatomic ,strong) NSMutableArray *arrProductList;
@property (nonatomic, strong)  NSMutableDictionary *dictProduct;

@end