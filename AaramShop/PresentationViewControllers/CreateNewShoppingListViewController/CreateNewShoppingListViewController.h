//
//  CreateNewShoppingListViewController.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListDetailCell.h"
#import "SearchViewController.h"


@interface CreateNewShoppingListViewController : UIViewController<ProductCellDelegate,AaramShop_ConnectionManager_Delegate,SearchViewControllerDelegate>
{
    IBOutlet UITextField *txtShoppingListName;
	IBOutlet UITableView *tblView;
    
    SearchViewController *searchViewController;
    AppDelegate *appDel;

}

@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

@property(nonatomic,strong) NSMutableArray *arrProductList;




@end
