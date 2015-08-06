//
//  HomeStoreDetailViewController.h
//  AaramShop
//
//  Created by Approutes on 08/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"
#import "PreferencesViewController.h"
@interface HomeStoreDetailViewController : UIViewController<CustomNavigationDelegate,AaramShop_ConnectionManager_Delegate>
{
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UILabel *lblStoreCategoryName;
    __weak IBOutlet UILabel *lblStoreName;
    __weak IBOutlet UILabel *lblStoreDistance;
    __weak IBOutlet UILabel *lblStoreAddress;
    __weak IBOutlet UILabel *lblDelivery;
    __weak IBOutlet UIImageView *imgDelivery;
    __weak IBOutlet UIImageView *imgVOfferImage;
    __weak IBOutlet UIImageView *imgVStoreCategoryImage;
    __weak IBOutlet UIImageView *imgVStoreImage;
    
    __weak IBOutlet UIView *viewRating;
    
    __weak IBOutlet UIImageView *imgRating1;
    __weak IBOutlet UIImageView *imgRating2;
    __weak IBOutlet UIImageView *imgRating3;
    __weak IBOutlet UIImageView *imgRating4;
    __weak IBOutlet UIImageView *imgRating5;
    
	__weak IBOutlet UIButton *confirmBtn;
}
@property(nonatomic,strong) StoreModel *objStoreModel;
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;
- (IBAction)btnReenterHomeStoreIdClick:(UIButton *)sender;
- (IBAction)btnStartShoppingClick:(UIButton *)sender;
@end
