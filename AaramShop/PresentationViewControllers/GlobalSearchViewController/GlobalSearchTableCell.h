//
//  GlobalSearchTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 04/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMGlobalSearch.h"
@interface GlobalSearchTableCell : UITableViewCell
{
	UIImageView *imgView;
	UILabel *lblName;
	UILabel *lblProductPrice;
	NSString *strRupee;
	NSString *strSearchType;
	NSString *strStoreId;
	UIImageView *imgArrow;
}
-(void)updateCellWithData:(CMGlobalSearch *)globalSearchModel;
@end
