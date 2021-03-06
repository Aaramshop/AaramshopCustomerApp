//
//  PointsTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMWalletPoints.h"
@interface PointsTableCell : UITableViewCell
{
	__weak IBOutlet UILabel *lblName;	
	__weak IBOutlet UILabel *lblPoints;
}
-(void)updateCellWithData:(CMWalletPoints *)walletPointModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
