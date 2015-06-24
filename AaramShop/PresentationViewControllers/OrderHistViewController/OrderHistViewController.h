//
//  OrderHistViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHistTableCell.h"
#import "CMOrderHist.h"
@interface OrderHistViewController : UIViewController<CDRTranslucentSideBarDelegate,AaramShop_ConnectionManager_Delegate,CallAndChatDelegate>
{
    
    __weak IBOutlet UITableView *tblView;
    NSMutableArray *arrOrderHist;
    UIRefreshControl *refreshCustomerList;
}
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end
