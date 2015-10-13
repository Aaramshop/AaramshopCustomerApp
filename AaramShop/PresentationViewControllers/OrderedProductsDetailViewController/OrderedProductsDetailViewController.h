//
//  OrderedProductsDetailViewController.h
//  AaramShop
//
//  Created by Approutes on 17/09/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMOrderHist.h"
#import "UserOrderDetailCell.h"
#import "UserOrderDetailOfferCell.h"

@interface OrderedProductsDetailViewController : UIViewController<AaramShop_ConnectionManager_Delegate,orderDetailDelegate,orderDetailOfferDelegate,UIActionSheetDelegate>
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    
    NSMutableArray *arrOrderDetail;
    __weak IBOutlet UITableView *tblView;
    
    NSMutableArray *arrProductsUpdatedPrice;
    
}
@property (nonatomic, strong) CMOrderHist *orderHist;


@end
