//
//  CurLocationTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 02/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurLocationTableCell : UITableViewCell
{
    UIImageView *imgPic;
    UIImageView *imgArrow;
    UILabel *lblName;
}
@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)updateCellWithData:(NSDictionary  *)inDataDic;
@end
