//
//  ChatViewController.h
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 25/05/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MESegmentedControl.h"
#import "CartViewController.h"
@interface ChatViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,CDRTranslucentSideBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tViewChat;
@property (weak, nonatomic) IBOutlet MESegmentedControl *segChatSelection;
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, strong) NSMutableArray *arrCustomers;
- (IBAction)sideBarLeft:(id)sender;
- (IBAction)selectionChange:(id)sender;
@end
