//
//  HomeCollectionCell.h
//  AaramShop
//
//  Created by Approutes on 08/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
@interface HomeCollectionCell : UICollectionViewCell{
    UIImageView *imgVCategory;
    UILabel *lblCategoryName;
}
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;
-(void)updateCategoryCellWithCategoryData:(CategoryModel *)objCategoryModelTemp;
@end
