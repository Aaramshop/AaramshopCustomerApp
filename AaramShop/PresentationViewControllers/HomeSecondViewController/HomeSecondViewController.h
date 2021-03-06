//
//  HomeSecondViewController.h
//  AaramShop
//
//  Created by Approutes on 08/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "RightCollectionViewController.h"
#import "HomeSecondCustomCell.h"


@interface HomeSecondViewController : UIViewController<V8HorizontalPickerViewDelegate,V8HorizontalPickerViewDataSource,CDRTranslucentSideBarDelegate,CustomNavigationDelegate,UIScrollViewDelegate,UISearchBarDelegate,AaramShop_ConnectionManager_Delegate,RightControllerDelegate,UITableViewDataSource,UITableViewDelegate,HomeSecondCustomCellDelegate>
{    
    
    RightCollectionViewController *rightCollectionVwContrllr;
    NSMutableArray *arrGetStoreProductCategories;
    NSMutableArray *arrGetStoreProducts;
    NSMutableArray *arrSearchGetStoreProducts;
    NSMutableArray *arrGetStoreProductSubCategory;
	__weak IBOutlet UISearchBar *searchBarr;
	
	__weak IBOutlet UIView *subView;
	__weak IBOutlet UIScrollView *scrollViewMain;
	__weak IBOutlet UITableView *tblVwCategory;
    BOOL isViewActive;

    UIRefreshControl *refreshShoppingList;
    BOOL isLoading;
    
    UISearchBar *searchBarProducts;
    
}
@property (nonatomic) NSInteger mainCategoryIndexPicker;
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;
@property(nonatomic,strong) NSString *strStore_Id;
@property(nonatomic,strong) NSString *strStore_CategoryName;
@property(nonatomic,strong) NSString *strStoreImage;

@end
