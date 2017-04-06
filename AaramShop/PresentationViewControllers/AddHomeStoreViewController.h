//
//  AddHomeStoreViewController.h
//  AaramShop
//
//  Created by Riteshk Gupta on 03/04/17.
//  Copyright © 2017 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StoreModel.h"
#import "AddHomeStoreViewController.h"
#import "AddStoreTableViewCell.h"

@interface AddHomeStoreViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AaramShop_ConnectionManager_Delegate,DeleteStoreListCell>
{
	AppDelegate *appDel;

}
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *homeStoreLbl;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
- (IBAction)backBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *addHomeStoreLbl;
- (IBAction)addHomeStoreBtn:(UIButton *)sender;

@end
