//
//  SearchTableCell.m
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 02/07/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import "SearchTableCell.h"

@implementation SearchTableCell

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
        // Initialization code
        
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[self setBackgroundColor:[UIColor whiteColor]];
		
		strRupee =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol]];
		imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
		imgView.layer.cornerRadius = imgView.bounds.size.width/2;
		imgView.layer.masksToBounds = YES;
		imgView.contentMode = UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:imgView];
		
		
		lblProductName = [[UILabel alloc] initWithFrame:CGRectZero ];
		
		[lblProductName setTextColor:[UIColor blackColor]];
		lblProductName.font = [UIFont fontWithName:kRobotoRegular size:15.0f];
		lblProductName.numberOfLines = 2;
		lblProductName.lineBreakMode = NSLineBreakByWordWrapping;
		
		[self.contentView addSubview:lblProductName];
		
		lblProductPrice = [[UILabel alloc] initWithFrame:CGRectZero];
		[lblProductPrice setTextColor:[UIColor blackColor]];
		lblProductPrice.textAlignment = NSTextAlignmentRight;
		[lblProductPrice setFont:[UIFont fontWithName:kRobotoRegular size:10.0]];
		[self.contentView addSubview:lblProductPrice];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    float imgSize = 44;
    float lblNameHeight = 42;
    float lblPriceHeight = 21;
    float padding = 8;
    
    CGRect lblProductNameRect = CGRectZero;
    CGRect lblProductPriceRect = CGRectZero;
    CGRect imgViewRect = CGRectZero;
    CGRect selfRect = self.frame;
    
    imgViewRect.size.width              =   imgSize;
    imgViewRect.size.height             =   imgSize;
    imgViewRect.origin.x                  =     padding;
    imgViewRect.origin.y                  =     (selfRect.size.height - imgViewRect.size.height)/2;
    imgView.frame                       =   imgViewRect;
	
    
    lblProductNameRect.size.width              =   selfRect.size.width - padding*3 - imgSize - 64;
    lblProductNameRect.size.height             =   lblNameHeight;
    lblProductNameRect.origin.x                  =    imgViewRect.origin.x + imgViewRect.size.width +  (padding)/2;
    lblProductNameRect.origin.y                  =     (selfRect.size.height - lblProductNameRect.size.height)/2;
    lblProductName.frame                       =   lblProductNameRect;
    
    lblProductPriceRect.size.width              =   64;
    lblProductPriceRect.size.height             =   lblPriceHeight;
    lblProductPriceRect.origin.x                  =     lblProductNameRect.origin.x + lblProductNameRect.size.width + (padding)/2;
    lblProductPriceRect.origin.y                  =     (selfRect.size.height - lblProductPriceRect.size.height)/2;
    lblProductPrice.frame                       =   lblProductPriceRect;
    
}

//-(void)updateDetailsForCustomer:(Customer *)search
//{
//    [imgView sd_setImageWithURL:[NSURL URLWithString:search.customer_image_small] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
//    
//    lblProductName.text = search.customer_name;
//    lblProductPrice.text = @"";
//}

-(void)updateDetailsFor:(ProductsModel *)product
{
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:product.product_image] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
    lblProductName.text = product.product_name;
    lblProductPrice.text = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol],product.product_price];
}
@end
