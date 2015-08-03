//
//  LocationTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 31/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface LocationTableCell : UITableViewCell
{
	
	__weak IBOutlet UILabel *lblTitle;
	__weak IBOutlet UILabel *lblAddress;
}
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)updateCellWithData: (AddressModel *)addressModel;
@end
