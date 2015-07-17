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

@interface ShoppingListAddMoreViewController : UIViewController<ProductCellDelegate,AaramShop_ConnectionManager_Delegate,SearchViewControllerDelegate>
{
	IBOutlet UITableView *tblView;
    
    NSMutableArray *arrProductList;
    
    SearchViewController *searchViewController;
    AppDelegate *appDel;

}

@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;


@end
