//
//  CouponTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 12/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCouponOffer.h"
@interface CouponTableCell : UITableViewCell
{
	
	__weak IBOutlet UIImageView *brandImage;
	__weak IBOutlet UILabel *lblBrandName;
	__weak IBOutlet UILabel *lblDateTime;
	__weak IBOutlet UILabel *lblCouponCode;
	NSString *strRupee;
}
//-(void)updateCellWithData:(CMCouponOffer *)couponOffer;
- (void)updateCellWithData:(NSDictionary *)inDataDic;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
