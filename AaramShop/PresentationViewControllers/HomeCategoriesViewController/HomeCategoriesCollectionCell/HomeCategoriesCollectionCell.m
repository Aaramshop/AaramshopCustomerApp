//
//  HomeCategoriesCollectionCell.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 10/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoriesCollectionCell.h"

@implementation HomeCategoriesCollectionCell


//-(void)updateMasterCollectionCell:(HomeCategoriesModel *)homeCategoriesModel
-(void)updateMasterCollectionCell:(StoreModel *)storeModel
{
    activityIndicatorView.hidesWhenStopped = YES;
    
    [activityIndicatorView startAnimating];
    
    imgCategory.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
    [imgCategory sd_setImageWithURL:[NSURL URLWithString:storeModel.store_main_category_banner_1] placeholderImage:[UIImage imageNamed:@"homePageBannerImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (image) {
             [activityIndicatorView stopAnimating];
         }
     }];
    
    [imgDiscountOffer sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",storeModel.store_main_category_banner_2]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
    
}


@end
