//
//  CartViewController.h
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListDetailCell.h"

@interface CartViewController : UIViewController<ProductCellDelegate>
{
    IBOutlet UITableView *tblView;
    
    NSMutableArray *arrProductList;
}
@end