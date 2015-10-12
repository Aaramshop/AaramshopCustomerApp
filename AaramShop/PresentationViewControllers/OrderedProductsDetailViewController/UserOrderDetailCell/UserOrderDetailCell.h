//
//  UserOrderDetailCell.h
//  AaramShop_Merchant
//
//  Created by chetan shishodia on 05/06/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol orderDetailDelegate <NSObject>

-(void)reportOrderClicked:(NSIndexPath*)indexPath;
@end

@interface UserOrderDetailCell : UITableViewCell
{
    IBOutlet UIImageView *imgOrder;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblTotalPrice;
    IBOutlet UILabel *lblQuantity;
    IBOutlet UIButton *btnReport;
    IBOutlet UILabel *lblUnitPrice;
    IBOutlet UILabel *lblOfferPrice;
    
}
@property (nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic,weak)id <orderDetailDelegate> orderDetailDelegate;


-(void)updateOrderDetailCell:(NSMutableArray *)arrOrderDetail;
@end
