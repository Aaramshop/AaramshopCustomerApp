//
//  OrderHistViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHistTableCell.h"
#import "CMOrderHist.h"
#import "OrderHistDetailViewCon.h"
#import "CartViewController.h"
//========================================
@protocol OrderHistVCDelegate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView onTableView:(UITableView *)tableView;

@end
@interface OrderHistViewController : UIViewController<CDRTranslucentSideBarDelegate,AaramShop_ConnectionManager_Delegate,CallAndChatDelegate>
{
    
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UILabel *lblMessage;

    NSMutableArray *arrOrderHist;
    UIRefreshControl *refreshOrderList;
	int pageno;
	int totalNoOfPages;
	NSString *strPacked;
	NSString *strDispached;
	NSString *strCompleted;
}
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, weak) id <OrderHistVCDelegate> delegate;


@end
