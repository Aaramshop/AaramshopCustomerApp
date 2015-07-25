//
//  HomeCategoryListCell.m
//  AaramShop
//
//  Created by Shakir@AppRoutes on 11/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCategoryListCell.h"

@implementation HomeCategoryListCell
@synthesize indexPath,selectedCategory,isRecommendedStore;

- (void)awakeFromNib {
    // Initialization code
    
    imgStore.layer.cornerRadius = imgStore.frame.size.width/2.0;
    imgStore.clipsToBounds=YES;
    
    imgHomeIcon.image = [UIImage imageNamed:@"homeScreenHomeIconRed"];
    
    UIImage *imgStarIcon = [UIImage imageNamed:@"starIconInactive"];
    imgRating1.image = imgStarIcon;
    imgRating2.image = imgStarIcon;
    imgRating3.image = imgStarIcon;
    imgRating4.image = imgStarIcon;
    imgRating5.image = imgStarIcon;

    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)updateCellWithData:(StoreModel*)objStoreData
{   
    ////
    if ([objStoreData.is_home_store isEqualToString:@"1"]) {
        imgHomeIcon.hidden = NO;
    }
    else
        imgHomeIcon.hidden = YES;
    
    
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
    lblCategoryName.text =objStoreData.store_category_name;

    
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
    if ([objStoreData.store_rating integerValue]>0)
    {
        //        viewRating.hidden = NO;
        
        UIImage *imgStarIcon = [UIImage imageNamed:@"homeStarRedIcon"];
        
        switch ([objStoreData.store_rating integerValue])
        {
            case 1:
            {
                imgRating1.image = imgStarIcon;
                
            }
                break;
            case 2:
            {
                imgRating1.image = imgStarIcon;
                imgRating2.image = imgStarIcon;
                
            }
                break;
            case 3:
            {
                imgRating1.image = imgStarIcon;
                imgRating2.image = imgStarIcon;
                imgRating3.image = imgStarIcon;
                
            }
                break;
            case 4:
            {
                imgRating1.image = imgStarIcon;
                imgRating2.image = imgStarIcon;
                imgRating3.image = imgStarIcon;
                imgRating4.image = imgStarIcon;
                
            }
                break;
            case 5:
            {
                imgRating1.image = imgStarIcon;
                imgRating2.image = imgStarIcon;
                imgRating3.image = imgStarIcon;
                imgRating4.image = imgStarIcon;
                imgRating5.image = imgStarIcon;
                
            }
                break;
                
            default:
                break;
        }
    }    ////
    
    
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
