//
//  PreferenceTableCell.h
//  AaramShop
//
//  Created by Pradeep Singh on 14/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferenceTableCell : UITableViewCell
{
    UILabel *lbl;
    UIImageView * rightArrow;
    UIImageView *imgPic;
    UISwitch *swtBtn;
}


@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)updateCellWithData:(NSDictionary  *)inDataDic;
@end
