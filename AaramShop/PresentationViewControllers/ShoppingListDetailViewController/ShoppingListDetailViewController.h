//
//  ShoppingListDetailViewController.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListDetailNewCell.h"
#import "ShoppingListDetailCell.h"

@interface ShoppingListDetailViewController : UIViewController<AaramShop_ConnectionManager_Delegate,ProductCellDelegate>
{
	__weak IBOutlet UITableView *tblView;
    __weak IBOutlet UIButton *btnChooseStore;

    NSMutableArray *arrProductList;
        
    UIRefreshControl *refreshShoppingList;
    BOOL isLoading;

}

@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

@property(nonatomic,strong) NSString *strShoppingListName;
@property(nonatomic,strong) NSString *strShoppingListID;


@end
