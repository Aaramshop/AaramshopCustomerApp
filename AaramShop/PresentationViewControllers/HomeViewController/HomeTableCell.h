//
//  HomeTableCell.h
//  AaramShop
//
//  Created by Pradeep Singh on 14/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableCell : UITableViewCell
{
    UILabel *lblRestaurant;
    UILabel *lblMini;
    UILabel *lblLocation;
    UIImageView * imgUserChoice;
    UIImageView *imgLocation;
    UIImageView *imgDot;
    UIImageView * rightArrow;
    UIImageView *imgProfilePic;

}


@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)updateCellWithData:(NSDictionary  *)inDataDic;
@end
