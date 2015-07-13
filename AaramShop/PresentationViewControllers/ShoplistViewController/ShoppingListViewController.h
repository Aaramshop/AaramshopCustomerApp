//
//  ShoplistViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListCell.h"

@interface ShoppingListViewController : UIViewController<CDRTranslucentSideBarDelegate>
{
    __weak IBOutlet UITableView *tblView;
    NSMutableArray *arrShoppingList;
}
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end
