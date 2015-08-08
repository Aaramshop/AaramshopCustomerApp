//
//  GlobalSearchResultViewC.h
//  AaramShop
//
//  Created by Arbab Khan on 04/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsModel.h"
#import "GlobalSearchViewController.h"
#import "HomeSecondCustomCell.h"
#import "StoreModel.h"
#import "GlobalSearchResultTableCell.h"
#import "SubCategoryModel.h"
#import "CartViewController.h"
@interface GlobalSearchResultViewC : UIViewController<HomeSecondCustomCellDelegate,AaramShop_ConnectionManager_Delegate,GlobalSearchViewControllerDelegate>
{
	NSMutableArray *arrGlobalSearchResult;
	int pageno;
	int totalNoOfPages;
	BOOL isLoading;
	NSString *strTotalPrice;
	
	__weak IBOutlet UITableView *tblView;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	GlobalSearchViewController *globalSearchViewController;
	BOOL isSearching;
	NSString *strSelectedCategoryId;
	NSString *strSelectedSubCategoryId;
	NSString *strProductId;
	NSString *strStoreName;
	NSString *strStore_image;
	ProductsModel *cmProductModel;
	NSIndexPath *atIndexPath;
}
@property(nonatomic,strong) NSString *strStore_Id;
@property(nonatomic,strong) NSString *strStore_CategoryName;
@property(nonatomic,strong) NSString *strStoreImage;
- (IBAction)btnSearch:(id)sender;
@end
