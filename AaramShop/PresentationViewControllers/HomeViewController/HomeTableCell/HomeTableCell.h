//
//  HomeTableCell.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "SWCellScrollView.h"
#import "SubCategoryModel.h"
#import <QuartzCore/QuartzCore.h>
@protocol HomeTableCellDelegate <NSObject>

-(void)refreshBtnFavouriteStatus:(NSIndexPath *)indexPath;
@end


@interface HomeTableCell :  SWTableViewCell<UIGestureRecognizerDelegate>
{
    UILabel *lblCategoryName, *lblRestaurantName,*lblDistance,*lblDeliveryType,*lblPriceValue;
    UIImageView *imgvCategoryIcon,*imgVCategoryTypeIcon,*imgVLocationIcon,*imgVDeliveryIcon,*imgVPriceIcon,*imgVStatusTypeIcon,*imgVHomeIcon;
    UIButton *btnFavouriteType;
}
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic) NSInteger selectedCategory;
@property(nonatomic,strong) SubCategoryModel *objSubCategoryModel;
@property(nonatomic,strong) id<HomeTableCellDelegate> delegateHomeCell;
-(void)updateCellWithData:(SubCategoryModel  *)objSubCategoryData;
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
@end
