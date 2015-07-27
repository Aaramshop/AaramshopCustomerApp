//
//  SearchStoresViewController.h
//  AaramShop
//
//  Created by Approutes on 24/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "ProductsModel.h"
#import "SearchTableCell.h"
#import "StoreModel.h"

@protocol SearchStoresViewControllerDelegate <NSObject>
@optional
-(void)removeSearchViewFromParentView;
-(void)openSearchedStores:(StoreModel *)store;

@end


@interface SearchStoresViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
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
    
    AppDelegate *appDel;

}
-(void)updateViewWhenAppears;

@property (weak, nonatomic) id <SearchStoresViewControllerDelegate> delegate;

@end
