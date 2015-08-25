//
//  HomeCategoryListViewController.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 11/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCategoryListCell.h"
#import "SWTableViewCell.h"
#import "HomeSecondViewController.h"

#import "RecommendedStoreCell.h"

#import "StoreModel.h"

@interface HomeCategoryListViewController : UIViewController<SWTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate,AaramShop_ConnectionManager_Delegate>
{
    __weak IBOutlet UITableView *tblStores;
	__weak IBOutlet UILabel *lblMessage;
    
    NSMutableArray *arrAllStores;
    
    UITableView *tblRecommendedStore;
    NSMutableArray *arrRecommendedStores;
    
    UIButton *btnExpandCollapse;
    
    BOOL isTableExpanded;
    
    UIRefreshControl *refreshStoreList;
    BOOL isLoading;
	AppDelegate *appDel;
    StoreModel *tempStoreModel;

}

@property(nonatomic,strong) StoreModel *storeModel;
@property(nonatomic) NSInteger totalNoOfPages;

//@property(nonatomic) BOOL isFirstPage;

@end
