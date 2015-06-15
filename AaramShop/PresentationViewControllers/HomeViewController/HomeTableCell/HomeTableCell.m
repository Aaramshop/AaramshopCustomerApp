//
//  HomeTableCell.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeTableCell.h"

@implementation HomeTableCell
@synthesize objSubCategoryModel,indexPath,delegateHomeCell,selectedCategory;
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
        
        lblCategoryName = [[UILabel alloc]initWithFrame:CGRectZero];
        lblCategoryName.font = [UIFont fontWithName:kRobotoRegular size:14.0];
        lblCategoryName.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];

        
        lblRestaurantName = [[UILabel alloc]initWithFrame:CGRectZero];
        lblRestaurantName.font = [UIFont fontWithName:kRobotoRegular size:13.0];
        lblRestaurantName.textColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
        
        lblDistance = [[UILabel alloc]initWithFrame:CGRectZero];
        lblDistance.font = [UIFont fontWithName:kRobotoRegular size:12.0];
        lblDistance.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];
        
        lblDeliveryType = [[UILabel alloc]initWithFrame:CGRectZero];
        lblDeliveryType.font = [UIFont fontWithName:kRobotoRegular size:12.0];
        lblDeliveryType.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];
        
        lblPriceValue = [[UILabel alloc]initWithFrame:CGRectZero];
        lblPriceValue.font = [UIFont fontWithName:kRobotoRegular size:12.0];
        lblPriceValue.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];

        imgvCategoryIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgvCategoryIcon.layer.cornerRadius =2.0;
        imgvCategoryIcon.clipsToBounds=YES;
        
        imgVCategoryTypeIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        imgVLocationIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        imgVDeliveryIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        imgVPriceIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        imgVStatusTypeIcon = [[UIImageView alloc]initWithFrame:CGRectZero];

        btnFavouriteType = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFavouriteType addTarget:self action:@selector(btnFavouriteTypeClick) forControlEvents:UIControlEventTouchUpInside];
        
        imgVHomeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        imgVHomeIcon.image = [UIImage imageNamed:@"homeScreenHomeIconRed"];

        imgvCategoryIcon.frame = CGRectMake(10, 15, 50, 50);
        imgVCategoryTypeIcon.frame = CGRectMake(70, 15, 20, 20);
        imgVStatusTypeIcon.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-35, 20, 25, 25);
        lblCategoryName.frame = CGRectMake(imgVCategoryTypeIcon.frame.origin.x+imgVCategoryTypeIcon.frame.size.width+10, 14, imgVStatusTypeIcon.frame.origin.x, 20);
        btnFavouriteType.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-35, 45, 25, 25);
        lblRestaurantName.frame = CGRectMake(70, lblCategoryName.frame.origin.y+lblCategoryName.frame.size.height, 200, 25);
        
        imgVLocationIcon.frame = CGRectMake(70, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height, 15, 15);
        lblDistance.frame = CGRectMake(imgVLocationIcon.frame.origin.x+imgVLocationIcon.frame.size.width+5, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height-3, 40, 20);
        
        imgVDeliveryIcon.frame = CGRectMake(lblDistance.frame.origin.x+lblDistance.frame.size.width+5, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height, 15, 15);
        lblDeliveryType.frame = CGRectMake(imgVDeliveryIcon.frame.origin.x+imgVDeliveryIcon.frame.size.width+5, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height-3, 50, 20);

        
        imgVPriceIcon.frame = CGRectMake(lblDeliveryType.frame.origin.x+lblDeliveryType.frame.size.width+5, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height, 15, 15);
        lblPriceValue.frame = CGRectMake(imgVPriceIcon.frame.origin.x+imgVPriceIcon.frame.size.width+5, lblRestaurantName.frame.origin.y+lblRestaurantName.frame.size.height-3, 50, 20);

       // [self.contentView addSubview:imgVHomeIcon];
        [self.contentView addSubview:lblCategoryName];
        [self.contentView addSubview:lblDeliveryType];
        [self.contentView addSubview: lblDistance];
        [self.contentView addSubview:lblPriceValue];
        [self.contentView addSubview:lblRestaurantName];
        
        [self.contentView addSubview:imgvCategoryIcon];
        [self.contentView addSubview:imgVCategoryTypeIcon];
        [self.contentView addSubview:imgVLocationIcon];
        [self.contentView addSubview:imgVDeliveryIcon];
        [self.contentView addSubview:imgVPriceIcon];
        [self.contentView addSubview:imgVStatusTypeIcon];
        
        [self.contentView addSubview:btnFavouriteType];
    }
    return self;
}

-(void)updateCellWithData:(SubCategoryModel  *)objSubCategoryData
{
    imgVLocationIcon.image = [UIImage imageNamed:@"locationIcon.png"];
    imgvCategoryIcon.image = [UIImage imageNamed:@"homeDetailsDefaultImgae.png"];
    imgVDeliveryIcon.image = [UIImage imageNamed:@""];
    imgVPriceIcon.image = [UIImage imageNamed:@"homeRupeesIcon.png"];
    imgVCategoryTypeIcon.image = [UIImage imageNamed:@"homeChocklateIcon.png"];
    
    lblCategoryName.text =objSubCategoryData.strCategoryName;
    lblDeliveryType.text = @"Delivers";
    lblDistance.text = objSubCategoryData.distance;
    lblPriceValue.text =objSubCategoryData.price;
    lblRestaurantName.text =objSubCategoryData.restaurantName;
    if (objSubCategoryData.isAddedToFavourite) {
        [btnFavouriteType setImage:[UIImage imageNamed:@"homeStarIconActive.png"] forState:UIControlStateNormal];
    }
    else
        [btnFavouriteType setImage:[UIImage imageNamed:@"homeStarIconInactive.png"] forState:UIControlStateNormal];
    
    if ([objSubCategoryData.status isEqualToString:@"1"]) {
        imgVStatusTypeIcon.image = [UIImage imageNamed:@"homeLockIconOpen.png"];
    }
    else
        imgVStatusTypeIcon.image = [UIImage imageNamed:@"homeLockIconClose.png"];
}
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self hideUtilityButtonsAnimated:YES];
}
-(void)btnFavouriteTypeClick
{
    objSubCategoryModel.isAddedToFavourite = !objSubCategoryModel.isAddedToFavourite;
    if (self.delegateHomeCell && [self.delegateHomeCell conformsToProtocol:@protocol(HomeTableCellDelegate)] && [self.delegateHomeCell respondsToSelector:@selector(refreshBtnFavouriteStatus:)])
    {
        [self.delegateHomeCell refreshBtnFavouriteStatus:indexPath];
    }

}

@end
