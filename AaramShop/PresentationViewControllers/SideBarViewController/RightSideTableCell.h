//
//  RightSideTableCell.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightSideTableCell : UITableViewCell
{
    UIButton *btnCategory;
    UILabel *lblName;
}

@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)updateCellWithData:(NSDictionary  *)inDataDic;
@end
