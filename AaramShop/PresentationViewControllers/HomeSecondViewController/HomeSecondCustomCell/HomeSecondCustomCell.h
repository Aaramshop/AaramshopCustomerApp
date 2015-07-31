//
//  HomeSecondCustomCell.h
//  AaramShop
//
//  Created by Approutes on 09/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsModel.h"

@protocol HomeSecondCustomCellDelegate <NSObject>

-(void)addedValueByPrice:(NSString*)strPrice atIndexPath:(NSIndexPath *)inIndexPath;
-(void)minusValueByPrice:(NSString*)strPrice atIndexPath:(NSIndexPath *)inIndexPath;
-(void)updateTableAtIndexPath:(NSIndexPath *)inIndexPath;
@end

@interface HomeSecondCustomCell : UITableViewCell
{
    UIImageView *imgV;
    UILabel *lblPrice, *lblName, *lblCount,*lblLine,*lblOfferPrice;
    UIButton *btnPlus, *btnMinus;
}
@property (nonatomic, strong) NSString *store_id;
@property(nonatomic,strong) ProductsModel *objProductsModelMain;
@property(nonatomic,strong) id<HomeSecondCustomCellDelegate> delegate;
@property(nonatomic,strong) NSIndexPath *indexPath;
-(void)updateCellWithSubCategory:(ProductsModel *)objProductsModel;
@end
