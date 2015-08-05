//
//  GlobalSearchViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 01/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMGlobalSearch.h"
#import "GlobalSearchTableCell.h"
#import "StoreModel.h"
@interface GlobalSearchViewController : UIViewController
{
	
	IBOutlet UISearchBar *searchBarMain;
	UIToolbar *toolbarbackground;
	IBOutlet UIView *viewSearchBarContainer;
	NSMutableDictionary *dicSearchResult;
	IBOutlet UITableView *tblViewSearch;
	
	NSMutableArray *arrSearchResult;
	NSMutableArray *allSections;
	
	NSString *globalURL;
	
	BOOL isKeyboardVisible;
	
	BOOL isLoading;
	
	NSInteger pageNumber;
	int totalNoOfPages;
	
	UIActivityIndicatorView *activityIndicatorView;
	BOOL boolActivityIndicator;
	AppDelegate *appDel;
	ViewStatus viewStatus;
	NSString *searchType;

}
-(void)updateViewWhenAppears;
@property (weak, nonatomic) id <GlobalSearchViewControllerDelegate> delegate;
@end
