//
//  HomeTableCell.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "SWCellScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "StoreModel.h"

@interface HomeTableCell :  SWTableViewCell<UIGestureRecognizerDelegate>
{
    UILabel *lblCategoryName, *lblRestaurantName,*lblDistance,*lblDeliveryType,*lblPriceValue;
    UIImageView *imgvCategoryIcon,*imgVCategoryTypeIcon,*imgVLocationIcon,*imgVDeliveryIcon,*imgVPriceIcon,*imgVStatusTypeIcon,*imgVHomeIcon,*imgVIsFavourite;
}
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic,assign) BOOL isRecommendedStore;
@property(nonatomic) NSInteger selectedCategory;
@property(nonatomic,strong) StoreModel *objStoreModel;
-(void)updateCellWithData:(StoreModel  *)objStoreData;
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
@end
