//
//  HomeCategoriesViewController.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 09/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCategoriesViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
    IBOutlet UICollectionView *collectionMaster;
    IBOutlet UIView *viewSubcategories;
}

@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

@end
