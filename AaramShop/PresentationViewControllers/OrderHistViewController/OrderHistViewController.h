//
//  OrderHistViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistViewController : UIViewController<CDRTranslucentSideBarDelegate>
{
    
    __weak IBOutlet UITableView *tblView;
}
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end
