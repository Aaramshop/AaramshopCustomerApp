//
//  CartViewController.h
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartListDetailCell.h"
#import "OffersTableCell.h"
@interface CartViewController : UIViewController<ProductCellDelegate,OffersTableCellDelegate>
{
    IBOutlet UITableView *tblView;
	__weak IBOutlet UIImageView *imgViewEmptyCart;
	__weak IBOutlet UILabel *lblInfo1;
	__weak IBOutlet UILabel *lblInfo2;
}
@property	(nonatomic ,strong) NSMutableArray *arrProductList;
@property (nonatomic, strong)  NSMutableDictionary *dictProduct;

@end