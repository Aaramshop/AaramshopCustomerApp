//
//  OrderHistTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 23/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OrderHistTableCell.h"

@implementation OrderHistTableCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    imgUser.layer.cornerRadius = imgUser.frame.size.width/2;
    imgUser.clipsToBounds = YES;
    btnTime.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateOrderHistCell:(NSMutableArray *)arrayOrderHist
{
    CMOrderHist *cmOrderHist = [arrayOrderHist objectAtIndex:_indexPath.row];
    
//    [imgUser sd_setImageWithURL:[NSURL URLWithString:cmOrderHist.user_image] placeholderImage:[UIImage imageNamed:@"defaultProfilePic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
	
//    }];
	
//    lblUsername.text = cmOrderHist.name;

//    lblLocation.text = [NSString stringWithFormat:@"%@ (25Km)",cmOrderHist.user_city]; // add distance with location..
    //    pendingOrderModel.longitude
    //    pendingOrderModel.latitude
    
    
    
    
    
    NSString *strNoOfItems = cmOrderHist.quantity;
    NSString *strTotalPrice = cmOrderHist.order_amount;
    
    NSString *labelString = [NSString stringWithFormat:@"%@ Items worth : %@", strNoOfItems, strTotalPrice];
    
    NSMutableAttributedString *labelAttributedString = [[NSMutableAttributedString alloc] initWithString:labelString];
    [labelAttributedString addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0] range: NSMakeRange(0, (labelString.length - strTotalPrice.length))];
    [labelAttributedString addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0] range: NSMakeRange((labelString.length - strTotalPrice.length), strTotalPrice.length)];
    
    
    lblPrice.attributedText = labelAttributedString;
    
    
    double remainingTime = [cmOrderHist.delivery_time doubleValue] - [cmOrderHist.order_time doubleValue];
    NSDate *dateRemaining = [NSDate dateWithTimeIntervalSince1970:remainingTime];
    
     lblRemainingTime.text = [NSString stringWithFormat:@"%@ min remaining",[Utils getFinalStringFromDate:dateRemaining]];
    
    NSDate *dateDelivery = [NSDate dateWithTimeIntervalSince1970:[cmOrderHist.delivery_time doubleValue]];
    [btnTime setTitle:[Utils getFinalStringFromDate:dateDelivery] forState:UIControlStateNormal];
}



-(IBAction)actionDoCall:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(doCallToUser:)])
    {
        [self.delegate doCallToUser:_indexPath];
    }
    
}


-(IBAction)actionDoChat:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(doChatToUser:)])
    {
        [self.delegate doChatToUser:_indexPath];
    }
    
}

@end
