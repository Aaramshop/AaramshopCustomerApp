//
//  HomeCollectionCell.m
//  AaramShop
//
//  Created by Approutes on 08/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeCollectionCell.h"

@implementation HomeCollectionCell
@synthesize selectedIndexPath;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        imgVCategory =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 233)];
        
        lblCategoryName = [[UILabel alloc] initWithFrame:CGRectMake(55, 193, self.frame.size.width-165, 40)];
        lblCategoryName.textColor = [UIColor whiteColor];
        
        [self addSubview:imgVCategory];
//        [self addSubview:lblCategoryName];
    }
    return self;
}
-(void)updateCategoryCellWithCategoryData:(StoreModel *)objStoreModelTemp
{
    [imgVCategory sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objStoreModelTemp.store_image]] placeholderImage:[UIImage imageNamed:@"homeDetailsDefaultImgae.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];

    lblCategoryName.text = objStoreModelTemp.store_category_name;
}
@end
