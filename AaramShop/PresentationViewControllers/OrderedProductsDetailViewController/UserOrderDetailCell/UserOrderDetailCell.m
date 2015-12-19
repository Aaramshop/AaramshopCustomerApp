//
//  UserOrderDetailCell.m
//  AaramShop_Merchant
//
//  Created by chetan shishodia on 05/06/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import "UserOrderDetailCell.h"
#import "OrderDetailModel.h"

@implementation UserOrderDetailCell

- (void)awakeFromNib {
    // Initialization code
    
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    lblName.adjustsFontSizeToFitWidth = YES;
    
    [lblQuantity sizeToFit];
    [lblUnitPrice sizeToFit];
    
    CGRect rect = self.frame;
    rect.size.height = 44;
    self.frame = rect;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateOrderDetailCell:(NSMutableArray *)arrOrderDetail
{
    OrderDetailModel *orderDetailModel = [arrOrderDetail objectAtIndex:_indexPath.row];
    
    lblOfferPrice.hidden = YES;
    
    if ([orderDetailModel.offer_type integerValue] == 0)
    {
        [imgOrder sd_setImageWithURL:[NSURL URLWithString:orderDetailModel.image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        //
        
        //
        
        NSString *strNoOfOrders = orderDetailModel.quantity;
        NSString *strOrderName = orderDetailModel.name;
        
        NSString *labelString = [NSString stringWithFormat:@"%@ %@",strNoOfOrders,strOrderName];
        
        NSMutableAttributedString *labelAttributedString = [[NSMutableAttributedString alloc] initWithString:labelString];
        [labelAttributedString addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:182.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] range: NSMakeRange(0, (labelString.length - strOrderName.length))];
        
        [labelAttributedString addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1.0] range: NSMakeRange((labelString.length - strOrderName.length), strOrderName.length)];
        
        
        lblName.attributedText = labelAttributedString;
        
        //
        
        //
        NSString *strRupee =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol]];
        
        NSInteger totalPrice = [orderDetailModel.price integerValue]*[orderDetailModel.quantity integerValue];
        lblTotalPrice.text = [NSString stringWithFormat:@"%@ %ld",strRupee,(long)totalPrice];
        
        //
        
        
        //
//        NSString *strQuantity = [[orderDetailModel.name componentsSeparatedByString:@" "] lastObject];
        lblQuantity.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];
//        lblQuantity.text = orderDetailModel.price; // not used ..
        lblQuantity.text = @"";
        
        lblUnitPrice.text = orderDetailModel.price;
        
    }
    else if ([orderDetailModel.offer_type integerValue] == 1)
    {
        lblOfferPrice.hidden = NO;

        [imgOrder sd_setImageWithURL:[NSURL URLWithString:orderDetailModel.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        //
        
        
        //
        NSString *strNoOfOrders = orderDetailModel.quantity;
        NSString *strOrderName = orderDetailModel.offerTitle;
        
        NSString *labelString = [NSString stringWithFormat:@"%@ %@",strNoOfOrders,strOrderName];
        
        NSMutableAttributedString *labelAttributedString = [[NSMutableAttributedString alloc] initWithString:labelString];
        [labelAttributedString addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:182.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] range: NSMakeRange(0, (labelString.length - strOrderName.length))];
        
        [labelAttributedString addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1.0] range: NSMakeRange((labelString.length - strOrderName.length), strOrderName.length)];
        
        
        lblName.attributedText = labelAttributedString;
        
        //
        
        //
        NSString *strRupee =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol]];
        
        NSInteger totalPrice = [orderDetailModel.offer_price integerValue]*[orderDetailModel.quantity integerValue];
        lblTotalPrice.text = [NSString stringWithFormat:@"%@ %ld",strRupee,(long)totalPrice];
        
        //

        
        //
//        NSString *strQuantity = [[orderDetailModel.name componentsSeparatedByString:@" "] lastObject];
        lblQuantity.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];
        //        lblQuantity.text = orderDetailModel.price; // not used ..
        lblQuantity.text = @"";
        
        
        //
        NSDictionary* actPriceAttributes = @{
                                             NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle],
                                             NSForegroundColorAttributeName : [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0]
                                             };
        
        
        NSString *strPrice = [NSString stringWithFormat:@"%@%@",strRupee,orderDetailModel.price];
        
        NSAttributedString* actPriceAttrString = [[NSAttributedString alloc] initWithString:strPrice attributes:actPriceAttributes];
        
        
        lblUnitPrice.attributedText = actPriceAttrString;
        lblOfferPrice.text = [NSString stringWithFormat:@"%@ %@",strRupee,orderDetailModel.offer_price];
        //
        
    }
    else if ([orderDetailModel.offer_type integerValue] == 4)
    {
        lblOfferPrice.hidden = NO;
        
        [imgOrder sd_setImageWithURL:[NSURL URLWithString:orderDetailModel.offerImage] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        //
        NSString *strNoOfOrders = orderDetailModel.quantity;
        NSString *strOrderName = orderDetailModel.offerTitle;
        
        NSString *labelString = [NSString stringWithFormat:@"%@ %@",strNoOfOrders,strOrderName];
        
        NSMutableAttributedString *labelAttributedString = [[NSMutableAttributedString alloc] initWithString:labelString];
        [labelAttributedString addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:182.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] range: NSMakeRange(0, (labelString.length - strOrderName.length))];
        
        [labelAttributedString addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1.0] range: NSMakeRange((labelString.length - strOrderName.length), strOrderName.length)];
        
        
        lblName.attributedText = labelAttributedString;
        
        //
        
        //
        NSString *strRupee =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol]];
        
        NSInteger totalPrice = [orderDetailModel.combo_offer_price integerValue]*[orderDetailModel.quantity integerValue];
        lblTotalPrice.text = [NSString stringWithFormat:@"%@ %ld",strRupee,totalPrice];
        
        //
        
        
        //
//        NSString *strQuantity = [[orderDetailModel.name componentsSeparatedByString:@" "] lastObject];
        lblQuantity.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];
        //        lblQuantity.text = orderDetailModel.price; // not used ..
        lblQuantity.text = @"";
        
        
        //
        NSDictionary* actPriceAttributes = @{
                                             NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle],
                                             NSForegroundColorAttributeName : [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0]
                                             };
        
        
        NSString *strPrice = [NSString stringWithFormat:@"%@%@",strRupee,orderDetailModel.combo_mrp];
        
        NSAttributedString* actPriceAttrString = [[NSAttributedString alloc] initWithString:strPrice attributes:actPriceAttributes];
        
        
        lblUnitPrice.attributedText = actPriceAttrString;
        lblOfferPrice.text = [NSString stringWithFormat:@"%@ %@",strRupee,orderDetailModel.combo_offer_price];
        //
        

    }
    
    
    if ([orderDetailModel.isReported integerValue]==1)
    {
        [btnReport setSelected:YES];
    }
    else
    {
        [btnReport setSelected:NO];
    }
    if([orderDetailModel.isAvailable integerValue]==1)
    {
        [self.contentView setAlpha:1.0];
        [self setUserInteractionEnabled:YES];
    }
    else
    {
        [self.contentView setAlpha:0.5];
        [btnReport setSelected:YES];
        [self setUserInteractionEnabled:NO];
    }
    
}



-(IBAction)actionReportOrders:(id)sender
{
    if ([self.orderDetailDelegate respondsToSelector:@selector(reportOrderClicked:)])
    {
        [self.orderDetailDelegate reportOrderClicked:_indexPath];
    }
}


@end
