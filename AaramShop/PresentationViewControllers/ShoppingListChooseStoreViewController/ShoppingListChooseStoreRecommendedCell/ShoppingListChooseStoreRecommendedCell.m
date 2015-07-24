//
//  ShoppingListChooseStoreRecommendedCell.m
//  AaramShop
//
//  Created by Approutes on 23/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListChooseStoreRecommendedCell.h"

@implementation ShoppingListChooseStoreRecommendedCell

@synthesize indexPath,isRecommendedStore;

- (void)awakeFromNib {
    // Initialization code
    
    imgStore.layer.cornerRadius = 5.0;
    imgStore.clipsToBounds=YES;
    
    imgHomeIcon.image = [UIImage imageNamed:@"homeScreenHomeIconRed"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



//*

-(void)updateCellWithData:(ShoppingListChooseStoreModel*)objStoreData
{
    CGSize size= [Utils getLabelSizeByText:objStoreData.store_category_name font:[UIFont fontWithName:kRobotoRegular size:14.0] andConstraintWith:[UIScreen mainScreen].bounds.size.width-110];
    
    if (size.height < 20) {
        size.height = 20;
    }
    
    ////
    if ([objStoreData.is_home_store isEqualToString:@"1"]) {
        imgHomeIcon.hidden = NO;
    }
    else
        imgHomeIcon.hidden = YES;
    
    
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
//    [btnDistance setTitle:[AppManager getDistance:objStoreData] forState:UIControlStateNormal]; //
    
    
    ////
    if ([objStoreData.home_delivery isEqualToString:@"1"]) {
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
    
}


@end
