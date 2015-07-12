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
	
    UIImageView *imgArrow;
	
}
@property (nonatomic, strong) UILabel *lblUpper;
@property (nonatomic, strong) UILabel *lblLower;
@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)updateCellWithData:(NSDictionary  *)inDataDic;
@end
