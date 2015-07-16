//
//  ShoppingListDetailViewController.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListDetailCell.h"

@interface ShoppingListDetailViewController : UIViewController<ProductCellDelegate>
{
	IBOutlet UITableView *tblView;
    NSMutableArray *arrProductList;
    
    BOOL isStoreSelected;
}
@end
