//
//  HomeStoreViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStorePopUpViewController.h"

#import "SearchStoresViewController.h"


@interface HomeStoreViewController : UIViewController<AaramShop_ConnectionManager_Delegate,SearchStoresViewControllerDelegate>
{
    
    __weak IBOutlet UITableView *tblSuggestedStores;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextField *txtStoreId;
    __weak IBOutlet UIImageView *imgVOffer;
    __weak IBOutlet UILabel *lblHd;
    __weak IBOutlet UIButton *btnWhatsHomeStore;
    __weak IBOutlet UIButton *btnStartShopping;
    NSMutableArray *arrSuggestedStores;
    
    SearchStoresViewController *searchStoresViewController;
    AppDelegate *appDel;
    
}
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

- (IBAction)btnStart:(id)sender;
- (IBAction)btnWhatsHomeStoreClick:(UIButton *)sender;

@end
