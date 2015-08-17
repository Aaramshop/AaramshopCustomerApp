//
//  ShoppingListAddMoreViewController.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListDetailCell.h"
#import "SearchViewController.h"
#import "ShoppingListChooseStoreModel.h"

@interface ShoppingListAddMoreViewController : UIViewController<ProductCellDelegate,AaramShop_ConnectionManager_Delegate,SearchViewControllerDelegate>
{
	IBOutlet UITableView *tblView;
    
    SearchViewController *searchViewController;
    AppDelegate *appDel;

}

@property (nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;
@property (nonatomic,strong) NSMutableArray *arrProductList;
@property (nonatomic,strong) NSString *strShoppingListId;
@property (nonatomic, strong) ShoppingListChooseStoreModel *store;

@end
