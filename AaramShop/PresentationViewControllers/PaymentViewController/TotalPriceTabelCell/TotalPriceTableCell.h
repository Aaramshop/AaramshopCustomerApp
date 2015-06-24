//
//  TotalPriceTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 22/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalPriceTableCell : UITableViewCell
{
    
    __weak IBOutlet UILabel *lblTotal;
    __weak IBOutlet UILabel *lblSubTotal;
    __weak IBOutlet UILabel *lblDeliveryCharges;
    __weak IBOutlet UILabel *lblDiscount;
}
@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)updateCellWithData:(NSDictionary  *)inDataDic;
@end
