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

#import "StoreModel.h"


@interface HomeCategoryListCell : SWTableViewCell<UIGestureRecognizerDelegate>
{
   
    __weak IBOutlet UIImageView *imgHomeIcon;
    __weak IBOutlet UIImageView *imgStore;
    __weak IBOutlet UIImageView *imgCategoryTypeIcon;

    __weak IBOutlet UILabel *lblCategoryName;

    __weak IBOutlet UIImageView *imgStoreStatusIcon;

    __weak IBOutlet UILabel *lblStoreName;

    
    
    __weak IBOutlet UIView *viewRating;
    __weak IBOutlet UIImageView *imgRating1;
    __weak IBOutlet UIImageView *imgRating2;
    __weak IBOutlet UIImageView *imgRating3;
    __weak IBOutlet UIImageView *imgRating4;
    __weak IBOutlet UIImageView *imgRating5;
    
    
    __weak IBOutlet UIButton *btnDistance;
    __weak IBOutlet UIButton *btnDeliveryType;
    __weak IBOutlet UIButton *btnTotalOrders;
    
    
    __weak IBOutlet UIImageView *imgIsFavourite;
    
}

@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic,assign) BOOL isRecommendedStore;
@property(nonatomic) NSInteger selectedCategory;
//@property(nonatomic,strong) StoreModel *objStoreModel;

-(void)updateCellWithData:(StoreModel  *)objStoreData;
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;


@end