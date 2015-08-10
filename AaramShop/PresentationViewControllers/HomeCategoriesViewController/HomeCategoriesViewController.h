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
#import "GlobalSearchViewController.h"
#import "LocationEnterViewController.h"

@interface HomeCategoriesViewController : UIViewController<AaramShop_ConnectionManager_Delegate,CDRTranslucentSideBarDelegate,CustomNavigationDelegate,UIPickerViewDataSource,UIPickerViewDelegate,LocationEnterViewControllerDelegate>
{
    YSLContainerViewController *containerVC;

    IBOutlet UICollectionView *collectionMaster;
    IBOutlet UIView *viewOverlay;
    IBOutlet UIView *viewSubcategories;
    UIToolbar *keyBoardToolBar;
    NSMutableArray *arrCategories;
	UIPickerView *pickerViewSlots;
    NSInteger totalNoOfPages;
	NSMutableArray *arrAddress;
	NSDictionary *dictPickerValue;
	UIButton *backBtn;
	UIButton *btnPicker;
	UIButton *btnCart;
	UIButton *btnSearch;
	UIButton *btnBroadcast;
}

@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end




