//
//  HomeCategoriesViewController.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 09/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCategoriesCollectionCell.h"
#import "YSLContainerViewController.h"


@interface HomeCategoriesViewController : UIViewController<AaramShop_ConnectionManager_Delegate,CDRTranslucentSideBarDelegate,CustomNavigationDelegate>//,SWTableViewCellDelegate>
{
    YSLContainerViewController *containerVC;

    IBOutlet UICollectionView *collectionMaster;
    IBOutlet UIView *viewOverlay;
    IBOutlet UIView *viewSubcategories;
    
    NSMutableArray *arrCategories;
    
}

@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

@end
