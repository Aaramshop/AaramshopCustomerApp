//
//  UserOrderDetailOfferCell.h
//  AaramShop_Merchant
//
//  Created by Approutes on 17/08/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol orderDetailOfferDelegate <NSObject>

-(void)reportOrderClicked:(NSIndexPath*)indexPath;
@end


@interface UserOrderDetailOfferCell : UITableViewCell
{
    IBOutlet UIImageView *imgOrder;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblDescription;
    IBOutlet UILabel *lblTotalPrice;
    IBOutlet UILabel *lblQuantity;
    IBOutlet UIButton *btnReport;
    IBOutlet UILabel *lblUnitPrice;
    IBOutlet UILabel *lblOfferPrice;
    
}
@property (nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic,weak)id <orderDetailOfferDelegate> orderDetailOfferDelegate;


-(void)updateOrderDetailOfferCell:(NSMutableArray *)arrOrderDetail;

@end


