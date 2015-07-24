//
//  MoneyTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMWalletMoney.h"
@interface MoneyTableCell : UITableViewCell
{
	__weak IBOutlet UILabel *lblDate;
	
	__weak IBOutlet UILabel *lblAmount;
	__weak IBOutlet UILabel *lblBrandName;
}
-(void)updateCellWithData:(CMWalletMoney *)walletMoneyModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
