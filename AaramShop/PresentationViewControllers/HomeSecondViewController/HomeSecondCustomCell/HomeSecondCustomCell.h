//
//  HomeSecondCustomCell.h
//  AaramShop
//
//  Created by Approutes on 09/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsModel.h"



@interface HomeSecondCustomCell : UITableViewCell
{
    UIImageView *imgV;
    UILabel *lblPrice, *lblName, *lblCount,*lblLine,*lblOfferPrice;
    UIButton *btnPlus, *btnMinus;
}
@property (nonatomic, assign) BOOL fromCart;
@property (nonatomic, strong) NSString *store_id;
@property(nonatomic,strong) ProductsModel *objProductsModelMain;
@property(nonatomic,strong) id<HomeSecondCustomCellDelegate> delegate;
@property(nonatomic,strong) NSIndexPath *indexPath;
-(void)updateCellWithSubCategory:(ProductsModel *)objProductsModel;
@end
