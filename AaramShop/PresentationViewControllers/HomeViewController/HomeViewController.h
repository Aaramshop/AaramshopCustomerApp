//
//  HomeViewController.h
//  AaramShop
//
//  Created by Pradeep Singh on 12/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTableCell.h"
@interface HomeViewController : UIViewController<CDRTranslucentSideBarDelegate,CustomNavigationDelegate,UIScrollViewDelegate>

{
    NSMutableArray *dataSource;
    __weak IBOutlet UITableView *tblView;
}
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end
