//
//  SearchStoresViewController.h
//  AaramShop
//
//  Created by Approutes on 24/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ProductsModel.h"
#import "SearchTableCell.h"


@protocol SearchViewControllerDelegate <NSObject>
@optional
-(void)removeSearchViewFromParentView;
-(void)openSearchedUserPrroductFor:(ProductsModel *)product;

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
}
-(void)updateViewWhenAppears;

@property (weak, nonatomic) id <SearchViewControllerDelegate> delegate;

@end
