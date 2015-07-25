//
//  ShoppingListChooseStoreGeneralCell.m
//  AaramShop
//
//  Created by Approutes on 23/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListChooseStoreGeneralCell.h"

@implementation ShoppingListChooseStoreGeneralCell

@synthesize indexPath;

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

    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)updateCellWithData:(ShoppingListChooseStoreModel*)objStoreData
{    
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
    lblStoreName.text =objStoreData.store_name;

    
    ////
    NSString *strRupee = @"\u20B9";
    lblTotalAmount.text = [NSString stringWithFormat:@"%@ %@",strRupee, objStoreData.total_product_price];
    
    
    ////
    // rating images ...
    
//    viewRating.hidden = YES;
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
    }
    
    ////
    
    
    ////
    
    NSString *strAvailableProducts = @"";
    
    if ([objStoreData.available_products integerValue]==0)
    {
        strAvailableProducts = @"No product available";
    }
    else if ([objStoreData.available_products integerValue] == [objStoreData.total_products integerValue])
    {
        strAvailableProducts = @"All products available";
    }
    else
    {
        strAvailableProducts = [NSString stringWithFormat:@"%@ available, %@ remaining",objStoreData.available_products, objStoreData.remaining_products];
    }
    
    lblAvailableProducts.text = strAvailableProducts;
    
    
    
    
    ////
    
    StoreModel * objStore = [[StoreModel alloc]init];
    
    objStore.store_latitude = objStoreData.store_latitude;
    objStore.store_longitude = objStoreData.store_longitude;
    
    [btnDistance setTitle:[AppManager getDistance:objStore] forState:UIControlStateNormal];
    
    
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
    
    
    
    ////
    if ([objStoreData.is_open isEqualToString:@"1"]) {
        imgStoreStatusIcon.image = [UIImage imageNamed:@"homeLockIconOpen.png"];
    }
    else{
        imgStoreStatusIcon.image = [UIImage imageNamed:@"homeLockIconClose.png"];
        
    }

    
}


@end
