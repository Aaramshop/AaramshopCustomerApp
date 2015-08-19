//
//  SearchViewController.h
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 02/07/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsModel.h"
#import "SearchTableCell.h"
#import "ShoppingListChooseStoreModel.h"

@protocol SearchViewControllerDelegate <NSObject>
@optional
-(void)removeSearchViewFromParentView;
-(void)openSearchedUserPrroductFor:(ProductsModel *)product;

@end


@interface SearchViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
    IBOutlet UISearchBar *searchBarMain;
    UIToolbar *toolbarbackground;
    IBOutlet UIView *viewSearchBarContainer;
    
    IBOutlet UITableView *tblViewSearch;
    
    NSMutableArray *arrSearchResult;
    
    NSString *globalURL;
    
    BOOL isKeyboardVisible;
    
    BOOL isLoading;
	
    NSInteger pageNumber;
    int totalNoOfPages;
    
    UIActivityIndicatorView *activityIndicatorView;
    BOOL boolActivityIndicator;
    
    ViewStatus viewStatus;
}
-(void)updateViewWhenAppears;
@property (nonatomic, retain) ShoppingListChooseStoreModel *store;
@property (weak, nonatomic) id <SearchViewControllerDelegate> delegate;

@end
