//
//  PreferenceTableCell.h
//  AaramShop
//
//  Created by Pradeep Singh on 14/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol delegateSwitchValue <NSObject>
@optional
-(void)getSwitchValue:(NSString *)switchBtnText indexPath:(NSIndexPath*)indexPath;
@end
@interface PreferenceTableCell : UITableViewCell
{
    UILabel *lblName;
    UIImageView *imgPic;
    UISwitch *swtBtn;
    NSString *onText;
    NSString *offText;
}

@property (weak,nonatomic) id <delegateSwitchValue> delegateSwitchValue;
@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)updateCellWithData:(NSDictionary  *)inDataDic;
@end
