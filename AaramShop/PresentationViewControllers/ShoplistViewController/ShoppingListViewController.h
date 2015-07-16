//
//  ShoplistViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListCell.h"

@interface ShoppingListViewController : UIViewController<CDRTranslucentSideBarDelegate,AaramShop_ConnectionManager_Delegate,ShoppingListDelegate>
{
    __weak IBOutlet UITableView *tblView;
    NSMutableArray *arrShoppingList;
    
    UIRefreshControl *refreshShoppingList;
    BOOL isLoading;

}

@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;


@end
