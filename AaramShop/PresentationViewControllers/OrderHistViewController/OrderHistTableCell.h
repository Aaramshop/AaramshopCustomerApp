//
//  OrderHistTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 23/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMOrderHist.h"
@protocol CallAndChatDelegate <NSObject>

-(void)doCallToMerchant:(NSIndexPath *)indexPath;
-(void)doChatToMerchant:(NSIndexPath *)indexPath;

@end
@interface OrderHistTableCell : UITableViewCell
{
    IBOutlet UIImageView *imgUser;
    IBOutlet UILabel *lblUsername;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblPrice;
    IBOutlet UILabel *lblRemainingTime;
    IBOutlet UIButton *btnTime;
	AppDelegate *appDeleg;
}
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <CallAndChatDelegate> delegate;
-(void)updateOrderHistCell:(NSMutableArray *)arrayPendingOrder;

@end
