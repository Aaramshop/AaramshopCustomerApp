//
//  ShoppingListDetailViewController.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListDetailViewController : UIViewController
{
	IBOutlet UITableView *tblView;
    NSMutableArray *arrProductList;
    
    BOOL isStoreSelected;
}
@end
