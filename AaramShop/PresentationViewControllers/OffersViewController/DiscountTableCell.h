//
//  DiscountTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 12/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMDiscountOffer.h"

@interface DiscountTableCell : UITableViewCell
{
	
	__weak IBOutlet UIImageView *brandImage;
	__weak IBOutlet UILabel *lblBrandName;
	__weak IBOutlet UILabel *lblDateTime;
	__weak IBOutlet UILabel *lblMrpPrice;
	__weak IBOutlet UILabel *lblOfferPrice;
	NSString *strRupee;
}
//- (void)updateCellWithData:(CMDiscountOffer *)discountOffer;
- (void)updateCellWithData:(NSDictionary *)inDataDic;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
