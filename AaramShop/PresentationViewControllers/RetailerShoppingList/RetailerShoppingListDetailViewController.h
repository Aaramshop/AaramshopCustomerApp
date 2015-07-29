//
//  RetailerShoppingListDetailViewController.h
//  AaramShop
//
//  Created by Neha Saxena on 24/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListModel.h"
#import "RetailerShoppingListDetailCell.h"


@interface RetailerShoppingListDetailViewController : UIViewController<AaramShop_ConnectionManager_Delegate,UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tblView;
    
    NSMutableArray *arrProductList;
    
    UIRefreshControl *refreshShoppingList;
    BOOL isLoading;
    
}

@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

@property(nonatomic,strong) NSString *strShoppingListName;
@property(nonatomic,strong) NSString *strShoppingListID;

@end