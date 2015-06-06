//
//  UserInfoTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 02/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableCell : UITableViewCell
{
    UILabel *lblUpper;
    UIImageView *imgArrow;
    UILabel *lblLower;
}
@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)updateCellWithData:(NSDictionary  *)inDataDic;
@end
