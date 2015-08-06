//
//  ShoppingListShareViewController.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListShareViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
	IBOutlet UITableView *tblView;
    IBOutlet UILabel *lblMessage;
    
    NSMutableArray *arrShareList;
    
    UIRefreshControl *refreshStoreList;
    BOOL isLoading;

}

@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

@property (nonatomic, strong) NSString *strShoppingListId;

@end

