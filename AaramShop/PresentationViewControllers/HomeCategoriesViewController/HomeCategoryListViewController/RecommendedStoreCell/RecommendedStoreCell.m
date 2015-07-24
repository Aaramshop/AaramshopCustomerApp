//
//  RecommendedStoreCell.m
//  AaramShop
//
//  Created by Approutes on 20/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "RecommendedStoreCell.h"

@implementation RecommendedStoreCell
@synthesize indexPath,selectedCategory,isRecommendedStore;

- (void)awakeFromNib {
    // Initialization code
    
    imgStore.layer.cornerRadius = 5.0;
    imgStore.clipsToBounds=YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



//*

-(void)updateCellWithData:(StoreModel*)objStoreData
{
    ////
    NSString *strStoreCategoryIcon = [NSString stringWithFormat:@"%@",objStoreData.store_category_icon];
    NSURL *urlStoreCategoryIcon = [NSURL URLWithString:[strStoreCategoryIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [imgCategoryTypeIcon sd_setImageWithURL:urlStoreCategoryIcon placeholderImage:[UIImage imageNamed:@"homeChocklateIcon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];
    
    
    ////
    NSString *strStoreImage = [NSString stringWithFormat:@"%@",objStoreData.store_image];
    NSURL *urlStoreImage = [NSURL URLWithString:[strStoreImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [imgStore sd_setImageWithURL:urlStoreImage placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];
    
    ////
    
    
    ////
    if ([objStoreData.is_open isEqualToString:@"1"]) {
        imgStoreStatusIcon.image = [UIImage imageNamed:@"homeLockIconOpen.png"];
    }
    else{
        imgStoreStatusIcon.image = [UIImage imageNamed:@"homeLockIconClose.png"];
        
    }
    
    
    ////
    lblStoreName.text =objStoreData.store_name;
    
    
    ////
    // rating images ...
    viewRating.hidden = YES; // temp
    ////
    
    
    ////
    [btnDistance setTitle:[AppManager getDistance:objStoreData] forState:UIControlStateNormal];
    
    
    ////
    if ([objStoreData.home_delivey isEqualToString:@"1"]) {
        [btnDeliveryType setHidden:NO];
    }
    else
    {
        [btnDeliveryType setHidden:YES];
    }
    
    
    ////
    if ([objStoreData.total_orders isEqualToString:@"0"]) {
        
        [btnTotalOrders setHidden:YES];
    }
    else
    {
        [btnTotalOrders setHidden:NO];
        
        [btnTotalOrders setTitle:[NSString stringWithFormat:@"%@ Times",objStoreData.total_orders] forState:UIControlStateNormal];
    }
    
    
    ////
    if ([objStoreData.is_favorite isEqualToString:@"1"]) {
        imgIsFavourite.image = [UIImage imageNamed:@"homeStarIconActive.png"];
    }
    else
        imgIsFavourite.image = [UIImage imageNamed:@"homeStarIconInactive.png"];
    
    
}


-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self hideUtilityButtonsAnimated:YES];
}

@end


//*