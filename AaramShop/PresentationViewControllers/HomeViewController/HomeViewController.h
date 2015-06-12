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
@interface HomeViewController : UIViewController<CDRTranslucentSideBarDelegate,CustomNavigationDelegate,UIScrollViewDelegate,SWTableViewCellDelegate,CategoryViewControllerDelegate,HomeTableCellDelegate>
{
    NSMutableArray *arrSubCategory;
    __weak IBOutlet UITableView *tblVwCategory;
    NSMutableArray *arrCategory;
    CategoryViewController *objCategoryVwController;
}
@property (nonatomic) NSInteger mainCategoryIndex;
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;

@end
