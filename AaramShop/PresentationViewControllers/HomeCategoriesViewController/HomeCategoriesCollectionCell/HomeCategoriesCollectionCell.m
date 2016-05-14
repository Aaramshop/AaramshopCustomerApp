//
//  HomeCategoriesCollectionCell.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 10/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoriesCollectionCell.h"

@implementation HomeCategoriesCollectionCell

-(void)updateMasterCollectionCell:(StoreModel *)storeModel
{
    activityIndicatorView.hidesWhenStopped = YES;
    
//    [activityIndicatorView startAnimating];
	
    [imgCategory sd_setImageWithURL:[NSURL URLWithString:storeModel.store_main_category_banner_1] placeholderImage:[UIImage imageNamed:@"homeDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
//         if (image) {
//             [activityIndicatorView stopAnimating];
//         }
     }];
    
    [imgDiscountOffer sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",storeModel.store_main_category_banner_2]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
    
}


@end
