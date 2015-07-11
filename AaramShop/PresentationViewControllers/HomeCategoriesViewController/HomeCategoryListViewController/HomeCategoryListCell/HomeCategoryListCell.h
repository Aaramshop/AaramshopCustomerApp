//
//  HomeCategoryListCell.h
//  AaramShop
//
//  Created by Shakir@AppRoutes on 11/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWTableViewCell.h"
#import "SWCellScrollView.h"
#import <QuartzCore/QuartzCore.h>
//#import "HomeCategoriesModel.h"
#import "HomeStoreModel.h"

@interface HomeCategoryListCell : SWTableViewCell<UIGestureRecognizerDelegate>
{
    UILabel *lblCategoryName, *lblRestaurantName,*lblDistance,*lblDeliveryType,*lblPriceValue;
    UIImageView *imgvCategoryIcon,*imgVCategoryTypeIcon,*imgVLocationIcon,*imgVDeliveryIcon,*imgVPriceIcon,*imgVStatusTypeIcon,*imgVHomeIcon,*imgVIsFavourite;
}
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic,assign) BOOL isRecommendedStore;
@property(nonatomic) NSInteger selectedCategory;
//@property(nonatomic,strong) HomeCategoriesModel *objStoreModel;
//-(void)updateCellWithData:(HomeCategoriesModel  *)objStoreData;
@property(nonatomic,strong) HomeStoreModel *objStoreModel;
-(void)updateCellWithData:(HomeStoreModel  *)objStoreData;

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;

@end