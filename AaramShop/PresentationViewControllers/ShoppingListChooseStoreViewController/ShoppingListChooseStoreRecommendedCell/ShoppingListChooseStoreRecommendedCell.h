//
//  ShoppingListChooseStoreRecommendedCell.h
//  AaramShop
//
//  Created by Approutes on 23/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingListChooseStoreModel.h"

@interface ShoppingListChooseStoreRecommendedCell : UITableViewCell
{
    
    __weak IBOutlet UIImageView *imgStore;
    __weak IBOutlet UILabel *lblStoreName;
    __weak IBOutlet UILabel *lblTotalAmount;
    
    
    __weak IBOutlet UIView *viewRating;
    __weak IBOutlet UIImageView *imgRating1;
    __weak IBOutlet UIImageView *imgRating2;
    __weak IBOutlet UIImageView *imgRating3;
    __weak IBOutlet UIImageView *imgRating4;
    __weak IBOutlet UIImageView *imgRating5;
    
    
    __weak IBOutlet UILabel *lblAvailableProducts;
    
    
    __weak IBOutlet UIButton *btnDistance;
    __weak IBOutlet UIButton *btnDeliveryType;
    __weak IBOutlet UIButton *btnTotalOrders;
    
    
    __weak IBOutlet UIImageView *imgStoreStatusIcon;
    
}

@property(nonatomic, strong) NSIndexPath *indexPath;

-(void)updateCellWithData:(ShoppingListChooseStoreModel  *)objStoreData;


@end
