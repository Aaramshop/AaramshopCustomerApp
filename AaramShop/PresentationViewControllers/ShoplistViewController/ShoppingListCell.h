//
//  ShopListTableCell.h
//  AaramShop
//
//  Created by Pradeep Singh on 15/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListCell : UITableViewCell
{
	__weak IBOutlet UILabel *lblTitle;
	__weak IBOutlet UILabel *lblQuantity;
	__weak IBOutlet UILabel *lblTime;
	__weak IBOutlet UIButton *btnShare;
}
@end
