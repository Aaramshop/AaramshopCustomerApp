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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        lblCategoryName.font = [UIFont fontWithName:kRobotoRegular size:14.0];
        lblCategoryName.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
        lblCategoryName.backgroundColor = [UIColor clearColor];
        lblCategoryName.numberOfLines=0;
        
        
        lblStoreName.font = [UIFont fontWithName:kRobotoRegular size:13.0];
        lblStoreName.textColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
        
//        lblDistance = [[UILabel alloc]initWithFrame:CGRectZero];
//        lblDistance.font = [UIFont fontWithName:kRobotoRegular size:12.0];
//        lblDistance.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];
//        
//        lblDeliveryType = [[UILabel alloc]initWithFrame:CGRectZero];
//        lblDeliveryType.font = [UIFont fontWithName:kRobotoRegular size:12.0];
//        lblDeliveryType.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];
//        
//        lblPriceValue = [[UILabel alloc]initWithFrame:CGRectZero];
//        lblPriceValue.font = [UIFont fontWithName:kRobotoRegular size:12.0];
//        lblPriceValue.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];
        
        
        
        imgStore.layer.cornerRadius = imgStore.frame.size.height/2;
        imgStore.clipsToBounds=YES;
        

        
//        imgVLocationIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
//        
//        imgVDeliveryIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
//        
//        imgVPriceIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
//        
//        imgVStatusTypeIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        
//        imgIsFavourite = [[UIImageView alloc]initWithFrame:CGRectZero];
        

        imgHomeIcon.image = [UIImage imageNamed:@"homeScreenHomeIconRed"];
        
        
        
//        [self.contentView addSubview:lblCategoryName];
//        [self.contentView addSubview:lblDeliveryType];
//        [self.contentView addSubview: lblDistance];
//        [self.contentView addSubview:lblPriceValue];
//        [self.contentView addSubview:lblRestaurantName];
//        
//        [self.contentView addSubview:imgHomeIcon];
//        [self.contentView addSubview:imgStore];
//        [self.contentView addSubview:imgCategoryTypeIcon];
//        [self.contentView addSubview:imgVLocationIcon];
//        [self.contentView addSubview:imgVDeliveryIcon];
//        [self.contentView addSubview:imgVPriceIcon];
//        [self.contentView addSubview:imgVStatusTypeIcon];
//        [self.contentView addSubview:imgVIsFavourite];
    }
    return self;
}

-(void)updateCellWithData:(StoreModel*)objStoreData
{
    CGSize size= [Utils getLabelSizeByText:objStoreData.store_category_name font:[UIFont fontWithName:kRobotoRegular size:14.0] andConstraintWith:[UIScreen mainScreen].bounds.size.width-110];
    
    if (size.height < 20) {
        size.height = 20;
    }
    
    
    imgStore.frame = CGRectMake(10, 15, 50, 50);
    imgCategoryTypeIcon.frame = CGRectMake(70, 15, 20, 20);
//    imgVStatusTypeIcon.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-35, 20, 25, 25);
    lblCategoryName.frame = CGRectMake(imgCategoryTypeIcon.frame.origin.x+imgCategoryTypeIcon.frame.size.width+10, 14, [UIScreen mainScreen].bounds.size.width-150, size.height);
//    imgVIsFavourite.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-35, 45, 25, 25);
    lblStoreName.frame = CGRectMake(70, lblCategoryName.frame.origin.y+lblCategoryName.frame.size.height, [UIScreen mainScreen].bounds.size.width-110, 25);
    
//    imgVLocationIcon.frame = CGRectMake(70, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height, 15, 15);
//    lblDistance.frame = CGRectMake(imgVLocationIcon.frame.origin.x+imgVLocationIcon.frame.size.width+5, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height-3, 60, 20);
    
//    imgVDeliveryIcon.frame = CGRectMake(lblDistance.frame.origin.x+lblDistance.frame.size.width+5, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height, 15, 15);
//    lblDeliveryType.frame = CGRectMake(imgVDeliveryIcon.frame.origin.x+imgVDeliveryIcon.frame.size.width+5, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height-3, 50, 20);
    
    
//    imgVPriceIcon.frame = CGRectMake(lblDeliveryType.frame.origin.x+lblDeliveryType.frame.size.width+5, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height, 15, 15);
    
    
    
//    lblPriceValue.frame = CGRectMake(imgVPriceIcon.frame.origin.x+imgVPriceIcon.frame.size.width+5, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height-3, 50, 20);
    
    
//    imgVLocationIcon.image = [UIImage imageNamed:@"locationIconHome"];
//    imgVDeliveryIcon.image = [UIImage imageNamed:@"homeStoreDetailsDeleversIcon"];
//    imgVPriceIcon.image = [UIImage imageNamed:@"homeRupeesIcon.png"];
    
    lblCategoryName.text =objStoreData.store_category_name;
//    lblDeliveryType.text = @"Delivers";
//    lblDistance.text = [AppManager getDistance:objStoreData];
    
    lblStoreName.text =objStoreData.store_name;
    
    if (isRecommendedStore) {
        imgStore.layer.cornerRadius = 2.0;
    }
    else
    {
        imgStore.layer.cornerRadius = imgStore.frame.size.width / 2;
        imgStore.clipsToBounds = YES;
        
    }
    
    
    NSString *strStoreImage = [NSString stringWithFormat:@"%@",objStoreData.store_image];
    NSURL *urlStoreImage = [NSURL URLWithString:[strStoreImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    
    [imgStore sd_setImageWithURL:urlStoreImage placeholderImage:[UIImage imageNamed:@"homeDetailsDefaultImgae.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];
    
    if ([objStoreData.is_home_store isEqualToString:@"1"]) {
        imgHomeIcon.hidden = NO;
    }
    else
        imgHomeIcon.hidden = YES;
    
    if ([objStoreData.home_delivey isEqualToString:@"1"]) {
//        [imgVDeliveryIcon setHidden:NO];
//        [lblDeliveryType setHidden:NO];
    }
    else
    {
//        [imgVDeliveryIcon setHidden:YES];
//        [lblDeliveryType setHidden:YES];
    }
    
    if ([objStoreData.total_orders isEqualToString:@"0"]) {
//        [imgVPriceIcon setHidden:YES];
//        [lblPriceValue setHidden:YES];
    }
    else
    {
//        [imgVPriceIcon setHidden:NO];
//        [lblPriceValue setHidden:NO];
//        lblPriceValue.text = [NSString stringWithFormat:@"%@ Times",objStoreData.total_orders];
    }
    
    
    
    NSString *strStoreCategoryIcon = [NSString stringWithFormat:@"%@",objStoreData.store_category_icon];
    NSURL *urlStoreCategoryIcon = [NSURL URLWithString:[strStoreCategoryIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    [imgCategoryTypeIcon sd_setImageWithURL:urlStoreCategoryIcon placeholderImage:[UIImage imageNamed:@"homeChocklateIcon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];
    if ([objStoreData.is_favorite isEqualToString:@"1"]) {
        imgIsFavourite.image = [UIImage imageNamed:@"homeStarIconActive.png"];
    }
    else
        imgIsFavourite.image = [UIImage imageNamed:@"homeStarIconInactive.png"];
    
    if ([objStoreData.is_open isEqualToString:@"1"]) {
//        imgStatusTypeIcon.image = [UIImage imageNamed:@"homeLockIconOpen.png"];
    }
    else{
//        imgVStatusTypeIcon.image = [UIImage imageNamed:@"homeLockIconClose.png"];
        
    }
}


-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self hideUtilityButtonsAnimated:YES];
}

@end
