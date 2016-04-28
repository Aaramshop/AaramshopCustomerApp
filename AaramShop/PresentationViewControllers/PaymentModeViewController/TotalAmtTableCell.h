//
//  TotalAmtTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 24/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPayment.h"
@interface TotalAmtTableCell : UITableViewCell
{
    
    __weak IBOutlet UILabel *lblPrice;
    __weak IBOutlet UILabel *lblTotalAmt;
}
@property (nonatomic, strong) NSIndexPath *indexPath;

-(void)updateCellWithData:(NSDictionary *)inDataDic;

@end
