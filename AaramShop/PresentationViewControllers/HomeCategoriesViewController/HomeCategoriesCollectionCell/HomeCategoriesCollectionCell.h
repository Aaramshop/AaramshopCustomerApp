//
//  HomeCategoriesCollectionCell.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 10/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HomeCategoriesModel.h"

#import "StoreModel.h"

@interface HomeCategoriesCollectionCell : UICollectionViewCell
{
    IBOutlet UIImageView *imgCategory;
    IBOutlet UIImageView *imgDiscountOffer;
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
}

@property (nonatomic,strong) NSIndexPath *indexPath;
//-(void)updateMasterCollectionCell:(HomeCategoriesModel *)homeCategoriesModel;

-(void)updateMasterCollectionCell:(StoreModel *)storeModel;

@end
