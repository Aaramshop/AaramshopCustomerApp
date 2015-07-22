//
//  ShoppingListChooseStoreViewController.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListChooseStoreViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
	__weak IBOutlet UITableView *tblView;
    
    NSMutableArray *arrStoreList;
    
    UIRefreshControl *refreshStoreList;
    BOOL isLoading;

}

@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

@end