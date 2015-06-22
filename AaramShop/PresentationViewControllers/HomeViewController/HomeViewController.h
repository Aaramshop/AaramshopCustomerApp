//
//  HomeViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTableCell.h"
#import "SWTableViewCell.h"
#import "CategoryViewController.h"
#import "StoreModel.h"

@interface HomeViewController : UIViewController<CDRTranslucentSideBarDelegate,CustomNavigationDelegate,UIScrollViewDelegate,SWTableViewCellDelegate,CategoryViewControllerDelegate,HomeTableCellDelegate,AaramShop_ConnectionManager_Delegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *tblVwCategory;
    UITableView *tblStores;
    UIScrollView *mainScrollView;
    NSMutableArray *arrSubCategory;
    NSMutableArray *arrCategory;
    NSMutableArray *arrRecommendedStores;
    
    NSMutableArray *arrSubCategoryMyStores;
    NSMutableArray *arrRecommendedStoresMyStores;

    
    CategoryViewController *objCategoryVwController;
}
@property (nonatomic) NSInteger mainCategoryIndex;
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end
