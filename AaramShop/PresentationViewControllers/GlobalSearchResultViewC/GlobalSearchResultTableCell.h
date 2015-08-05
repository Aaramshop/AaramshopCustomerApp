//
//  GlobalSearchResultTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 05/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobalSearchResultTableCell : UITableViewCell
{
	__weak IBOutlet UILabel *lblStoreName;
	__weak IBOutlet UILabel *lblProductName;
	__weak IBOutlet UIImageView *imgProduct;
	
	__weak IBOutlet UIImageView *imgStore;
	__weak IBOutlet UILabel *lblProductPrice;
}
@end
