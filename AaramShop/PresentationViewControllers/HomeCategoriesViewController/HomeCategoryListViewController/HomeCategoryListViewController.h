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

@interface HomeCategoryListViewController : UIViewController<SWTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tblStores;
    
    NSMutableArray *arrAllStores;
    
    UITableView *tblRecommendedStore;
    NSMutableArray *arrRecommendedStores;
    
    UIButton *btnExpandCollapse;
    
    BOOL isTableExpanded;
}

@property(nonatomic,strong) StoreModel *storeModel;


//@property(nonatomic,strong) HomeCategoriesModel *homeCategoriesModel;
//@property(nonatomic,strong) NSMutableArray *arrHomeStore;
//@property(nonatomic,strong) NSMutableArray *arrRecommendedStore;
//@property(nonatomic,strong) NSMutableArray *arrShoppingStore;

@end
