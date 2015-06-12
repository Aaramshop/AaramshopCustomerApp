//
//  ShoplistViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoplistViewController : UIViewController<CDRTranslucentSideBarDelegate>
{
    
    __weak IBOutlet UITableView *tblView;
    NSMutableArray *arrShoppingList;
}
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end
