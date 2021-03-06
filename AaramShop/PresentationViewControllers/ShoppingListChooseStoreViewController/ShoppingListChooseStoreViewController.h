//
//  ShoppingListChooseStoreViewController.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListChooseStoreModel.h"

typedef void (^ChooseStoreCompletion) (ShoppingListChooseStoreModel *);

@interface ShoppingListChooseStoreViewController : UIViewController<AaramShop_ConnectionManager_Delegate,UITableViewDataSource,UITableViewDelegate>
{
	__weak IBOutlet UITableView *tblStores;
    
    NSMutableArray *arrAllStores;
    
    UITableView *tblRecommendedStore;
    NSMutableArray *arrRecommendedStores;
    
    UIButton *btnExpandCollapse;
    
    BOOL isTableExpanded;
    
    UIRefreshControl *refreshStoreList;
    BOOL isLoading;
    
//    ShoppingListChooseStoreModel *shoppingListChooseStoreModel;

    ShoppingListChooseStoreModel *selectedStoreModel;


}

@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

@property(nonatomic,strong) NSString *strShoppingListId;

@property (nonatomic, copy) ChooseStoreCompletion refreshShoppingList;


@end