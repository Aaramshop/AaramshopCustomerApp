//
//  HomeSecondCustomCell.m
//  AaramShop
//
//  Created by Approutes on 09/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeSecondCustomCell.h"

@implementation HomeSecondCustomCell
@synthesize indexPath,delegate,objProductsModelMain;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        imgV = [[UIImageView alloc]init];
        [self addSubview:imgV];
        
        lblName = [[UILabel alloc] init];
        lblName.textColor = [UIColor whiteColor];
        lblName.numberOfLines = 0;
        lblName.font = [UIFont fontWithName:kRobotoRegular size:14.0f];
        lblName.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
        [lblName setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:lblName];

        
        lblPrice = [[UILabel alloc] init];
        lblPrice.textColor = [UIColor whiteColor];
        lblPrice.numberOfLines = 0;
        lblPrice.font = [UIFont fontWithName:kRobotoRegular size:14.0f];
        lblPrice.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];
        [lblPrice setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lblPrice];
		
		lblLine =[[UILabel alloc] init];
		lblLine.text = @"";
		lblLine.backgroundColor = [UIColor blackColor];
		[self addSubview:lblLine];
		
		lblOfferPrice = [[UILabel alloc]init];
		lblOfferPrice.textColor = [UIColor redColor];
		lblOfferPrice.numberOfLines = 0;
		lblOfferPrice.font = [UIFont fontWithName:kRobotoRegular size:14.0f];
		[lblOfferPrice setTextAlignment:NSTextAlignmentLeft];
		[self addSubview:lblOfferPrice];
		
        btnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMinus addTarget:self action:@selector(btnMinusClick) forControlEvents:UIControlEventTouchUpInside];
        [btnMinus setImage:[UIImage imageNamed:@"minusIconCircle.png"] forState:UIControlStateNormal];
        
        [self addSubview:btnMinus];

        lblCount = [[UILabel alloc] init];
        lblCount.textColor = [UIColor whiteColor];
        lblCount.numberOfLines = 0;
        lblCount.font = [UIFont fontWithName:kRobotoRegular size:18.0f];
        lblCount.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];
        [lblCount setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lblCount];


        btnPlus = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPlus addTarget:self action:@selector(btnPlusClick) forControlEvents:UIControlEventTouchUpInside];
        [btnPlus setImage:[UIImage imageNamed:@"addIconCircle.png"] forState:UIControlStateNormal];
        
        [self addSubview:btnPlus];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)btnMinusClick
{
    if ([objProductsModelMain.strCount intValue]>=0) {
        int Counter = [objProductsModelMain.strCount intValue];
        Counter--;
        objProductsModelMain.strCount = [NSString stringWithFormat:@"%d",Counter];
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(HomeSecondCustomCellDelegate)] && [self.delegate respondsToSelector:@selector(minusValueByPrice:atIndexPath:)])
        {
            int TotalPrice =  1 * [objProductsModelMain.product_price intValue];

            [self.delegate minusValueByPrice:[NSString stringWithFormat:@"%d",TotalPrice] atIndexPath:indexPath];
        }
    }
}
-(void)btnPlusClick
{
    if ([objProductsModelMain.strCount intValue]>=0) {
        int Counter = [objProductsModelMain.strCount intValue];
        Counter++;
        objProductsModelMain.strCount = [NSString stringWithFormat:@"%d",Counter];
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(HomeSecondCustomCellDelegate)] && [self.delegate respondsToSelector:@selector(addedValueByPrice:atIndexPath:)])
        {
            int TotalPrice =  1 * [objProductsModelMain.product_price intValue];
            
            [self.delegate addedValueByPrice:[NSString stringWithFormat:@"%d",TotalPrice] atIndexPath:indexPath];
        }
    }

}
-(void)updateCellWithSubCategory:(ProductsModel *)objProductsModel
{
    CGSize size= [Utils getLabelSizeByText:objProductsModel.product_name font:[UIFont fontWithName:kRobotoRegular size:14.0f] andConstraintWith:[UIScreen mainScreen].bounds.size.width-175];

    if (size.height<24) {
        size.height = 24;
    }
    int xPos = 5;
    imgV.frame = CGRectMake(xPos, 4, 60, 60);
    xPos+=imgV.frame.size.width+5;
    
    btnPlus.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-35, 14, 30, 40);
    lblCount.frame = CGRectMake(btnPlus.frame.origin.x-30, 24, 30, 20);
    btnMinus.frame = CGRectMake(lblCount.frame.origin.x-30, 14, 30, 40);
    lblName.frame = CGRectMake(xPos, 10, [UIScreen mainScreen].bounds.size.width-175, size.height);
    lblPrice.frame = CGRectMake(xPos, size.height+10, 58, 20);
	
	//////////////////////////////////////////////////////////////////for offer kind of products//////////////////////////////////////////////////////////////////
	lblLine.frame		=	CGRectMake(lblPrice.frame.origin.x, lblPrice.frame.origin.y+9, 58, 2);
	lblOfferPrice.frame		=	CGRectMake(lblPrice.frame.origin.x+lblPrice.frame.size.width+8, lblPrice.frame.origin.y, 58, 20);
	lblLine.hidden = YES;
	lblOfferPrice.hidden = YES;
	NSString *strCount = @"0";
	if([objProductsModel.offer_type integerValue]>0)
	{
		lblLine.hidden = NO;
		lblOfferPrice.hidden = NO;
		lblOfferPrice.text = [NSString stringWithFormat:@"₹%@",objProductsModel.offer_price];
		strCount = [AppManager getCountOfProduct:objProductsModel.offer_id withOfferType:objProductsModel.offer_type forStore_id:self.store_id];
	}
	else
	{
		strCount = [AppManager getCountOfProduct:objProductsModel.product_id withOfferType:objProductsModel.offer_type forStore_id:self.store_id];
	}
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if ([strCount intValue]<=0) {
        btnMinus.enabled=NO;
    }
    else
        btnMinus.enabled = YES;
	if([strCount intValue]==20)
	{
		 btnPlus.enabled=NO;
	}
	else
	{
		btnPlus.enabled = YES;
	}
	
    [imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objProductsModel.product_image]] placeholderImage:[UIImage imageNamed:@"homeDetailsDefaultImgae.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];
    lblName.text= objProductsModel.product_name;
    lblPrice.text = [NSString stringWithFormat:@"₹%@",objProductsModel.product_price];
	lblCount.text = strCount;

}

@end
