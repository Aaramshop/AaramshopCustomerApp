//
//  ShoplistViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListCell.h"
#import "CartViewController.h"
@interface ShoppingListViewController : UIViewController<CDRTranslucentSideBarDelegate,AaramShop_ConnectionManager_Delegate,ShoppingListCellDelegate>
{
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UILabel *lblMessage;

    NSMutableArray *arrShoppingList;
    
    UIRefreshControl *refreshShoppingList;
    BOOL isLoading;
    
    NSInteger deletedShoppingListIndex;

}

@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;


@end
