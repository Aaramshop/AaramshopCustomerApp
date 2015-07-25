//
//  RetailerShoppingListViewController.h
//  AaramShop
//
//  Created by Neha Saxena on 24/07/2015.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RetailerShoppingListVCDelegate <NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView onTableView:(UITableView *)tableView;
@end

@interface RetailerShoppingListViewController : UIViewController <AaramShop_ConnectionManager_Delegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSMutableArray *arrShoppingList;
@property (weak, nonatomic) id <RetailerShoppingListVCDelegate> delegate;

@end
