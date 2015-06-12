//
//  HomeStoreViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStorePopUpViewController.h"

@interface HomeStoreViewController : UIViewController<HomeStorePopUpViewControllerDelegate>
{
    
    __weak IBOutlet UITextField *txtStoreId;
    __weak IBOutlet UILabel *lblHd;
    
    __weak IBOutlet UIButton *btnWhatsHomeStore;    
}
- (IBAction)btnStart:(id)sender;
- (IBAction)btnWhatsHomeStoreClick:(UIButton *)sender;

@end
