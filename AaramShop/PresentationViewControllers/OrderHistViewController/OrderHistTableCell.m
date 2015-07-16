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
	appDeleg = APP_DELEGATE;
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
	
	
	[imgUser sd_setImageWithURL:[NSURL URLWithString:cmOrderHist.store_image] placeholderImage:[UIImage imageNamed:@"defaultProfilePic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		
	}];
	
	lblUsername.text = cmOrderHist.store_name;
	
	
	NSString *strCity = cmOrderHist.store_city;
	if ([strCity length]>12)
	{
		strCity = [cmOrderHist.store_city substringWithRange:NSMakeRange(0, 12)];
	}
	
	
	NSString *strDistance = @"";
	
	NSString *customerLongitude = [NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude];
	NSString * customerLatitude = [NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude];
	
	NSString * merchantLongitude = cmOrderHist.store_longitude;
	NSString * merchantLatitude = cmOrderHist.store_latitude;
	
	if ([customerLatitude length]>0 && [customerLongitude length]>0 && [merchantLatitude length]>0 && [merchantLongitude length]>0)
	{
		strDistance = [Utils milesFromLatitude:[merchantLatitude doubleValue] fromLongitude:[merchantLongitude doubleValue] ToLatitude:[customerLatitude doubleValue] andToLongitude:[customerLongitude doubleValue]];
	}
	
	lblLocation.text = [NSString stringWithFormat:@"%@ (%dKm)",strCity,[strDistance intValue]];
	
	
	
	NSString *strNoOfItems = cmOrderHist.quantity;
	NSString *strTotalPrice = cmOrderHist.total_cart_value;
	
	NSString *labelString = [NSString stringWithFormat:@"%@ Items worth : %@", strNoOfItems, strTotalPrice];
	
	NSMutableAttributedString *labelAttributedString = [[NSMutableAttributedString alloc] initWithString:labelString];
	[labelAttributedString addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0] range: NSMakeRange(0, (labelString.length - strTotalPrice.length))];
	[labelAttributedString addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0] range: NSMakeRange((labelString.length - strTotalPrice.length), strTotalPrice.length)];
	
	
	lblPrice.attributedText = labelAttributedString;
	
	
	NSCalendarUnit unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit;
	NSCalendar *sysCalendar = [NSCalendar currentCalendar];
	NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:[NSDate date]  toDate:[NSDate dateWithTimeIntervalSince1970:[cmOrderHist.delivery_time doubleValue]]  options:0];
	NSLog(@"Break down: %li min : %li hours : %li days ", (long)[breakdownInfo minute], (long)[breakdownInfo hour], (long)[breakdownInfo day]);
	if([breakdownInfo day] >0)
	{
		lblRemainingTime.text = [NSString stringWithFormat:@"%li day(s) remaining",(long)[breakdownInfo day]];
	}
	else if([breakdownInfo hour] >0)
	{
		lblRemainingTime.text = [NSString stringWithFormat:@"%li hours(s) remaining",(long)[breakdownInfo hour]];
	}
	else if([breakdownInfo minute] >0)
	{
		lblRemainingTime.text = [NSString stringWithFormat:@"%li minute(s) remaining",(long)[breakdownInfo minute]];
	}
	else
	{
		lblRemainingTime.text = @"Order overdue";
	}
	
	
	
	NSString *strOrderTime = [Utils convertedDate:[NSDate dateWithTimeIntervalSince1970:[cmOrderHist.order_time doubleValue]]];
	[btnTime setTitle:[strOrderTime stringByReplacingOccurrencesOfString:@"/" withString:@"-"] forState:UIControlStateNormal];
}



-(IBAction)actionDoCall:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(doCallToMerchant:)])
    {
        [self.delegate doCallToMerchant:_indexPath];
    }
	
}


-(IBAction)actionDoChat:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(doChatToMerchant:)])
    {
        [self.delegate doChatToMerchant:_indexPath];
    }
    
}

@end
