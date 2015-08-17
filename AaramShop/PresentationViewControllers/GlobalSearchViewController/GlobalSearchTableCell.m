//
//  GlobalSearchTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 04/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "GlobalSearchTableCell.h"

@implementation GlobalSearchTableCell

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
		
		strRupee = @"\u20B9";
		imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
		imgView.layer.cornerRadius = imgView.bounds.size.width/2;
		imgView.layer.masksToBounds = YES;
		imgView.contentMode = UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:imgView];
		
		
		lblName = [[UILabel alloc] initWithFrame:CGRectZero ];
		
		[lblName setTextColor:[UIColor blackColor]];
		lblName.font = [UIFont fontWithName:kRobotoRegular size:15.0f];
		lblName.numberOfLines = 2;
		lblName.lineBreakMode = NSLineBreakByWordWrapping;
		
		[self.contentView addSubview:lblName];
		
		lblProductPrice = [[UILabel alloc] initWithFrame:CGRectZero];
		[lblProductPrice setTextColor:[UIColor blackColor]];
		lblProductPrice.textAlignment = NSTextAlignmentRight;
		[lblProductPrice setFont:[UIFont fontWithName:kRobotoRegular size:10.0]];
		[self.contentView addSubview:lblProductPrice];
		
		imgArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
		imgArrow.image = [UIImage imageNamed:@"sideArrowGrey"];
		[self.contentView addSubview:imgArrow];
  
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
	
	CGRect lblNameRect = CGRectZero;
	CGRect lblProductPriceRect = CGRectZero;
	CGRect imgViewRect = CGRectZero;
	CGRect imgArrowRect = CGRectZero;
	CGRect selfRect = self.frame;
	
	imgViewRect.size.width              =   imgSize;
	imgViewRect.size.height             =   imgSize;
	imgViewRect.origin.x                  =     padding;
	imgViewRect.origin.y                  =     (selfRect.size.height - imgViewRect.size.height)/2;
	imgView.frame                       =   imgViewRect;
	
	lblNameRect.size.width              =   selfRect.size.width - padding*3 - imgSize - 64;
	lblNameRect.size.height             =   lblNameHeight;
	lblNameRect.origin.x                  =    imgViewRect.origin.x + imgViewRect.size.width +  (padding)/2;
	lblNameRect.origin.y                  =     (selfRect.size.height - lblNameRect.size.height)/2;
	lblName.frame                       =   lblNameRect;
	imgArrowRect.size.width              =   13;
	imgArrowRect.size.height             =   13;
	imgArrowRect.origin.x                  =     selfRect.size.width - padding - 13;
	imgArrowRect.origin.y                  =     (selfRect.size.height - imgArrowRect.size.height)/2;
	imgArrow.frame                       =   imgArrowRect;
	
	lblProductPriceRect.size.width              =   64;
	lblProductPriceRect.size.height             =   lblPriceHeight;
	lblProductPriceRect.origin.x                  =     lblNameRect.origin.x + lblNameRect.size.width + (padding)/2;
	lblProductPriceRect.origin.y                  =     (selfRect.size.height - lblProductPriceRect.size.height)/2;
	lblProductPrice.frame                       =   lblProductPriceRect;
	
//	if ([strSearchType intValue] == 1) {
//		
//	}
//	else if ([strSearchType intValue]==2)
//	{
//		
//	}
//	else
//	{
//		if (strStoreId == nil) {
//			lblProductPriceRect.size.width              =   64;
//			lblProductPriceRect.size.height             =   lblPriceHeight;
//			lblProductPriceRect.origin.x                  =     lblNameRect.origin.x + lblNameRect.size.width + (padding)/2;
//			lblProductPriceRect.origin.y                  =     (selfRect.size.height - lblProductPriceRect.size.height)/2;
//			lblProductPrice.frame                       =   lblProductPriceRect;
//		}
//		else
//		{
//			imgArrowRect.size.width              =   13;
//			imgArrowRect.size.height             =   13;
//			imgArrowRect.origin.x                  =     selfRect.size.width - padding - 13;
//			imgArrowRect.origin.y                  =     (selfRect.size.height - imgArrowRect.size.height)/2;
//			imgArrow.frame                       =   imgArrowRect;
//		}
//	}
}
-(void)updateCellWithData:(CMGlobalSearch *)globalSearchModel
{
	strSearchType = globalSearchModel.search_type;
	strStoreId = globalSearchModel.store_id;
	if ([globalSearchModel.search_type intValue] == 1) {
		[imgArrow setHidden:NO];
		[lblProductPrice setHidden:YES];
		[imgView sd_setImageWithURL:[NSURL URLWithString:globalSearchModel.store_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
		lblName.text = globalSearchModel.store_name;
		
	}
	else if([globalSearchModel.search_type intValue]==2)
	{
		[imgArrow setHidden:YES];
		[lblProductPrice setHidden:NO];
		[imgView sd_setImageWithURL:[NSURL URLWithString:globalSearchModel.product_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
		lblName.text = globalSearchModel.product_name;
		lblProductPrice.text = [NSString stringWithFormat:@"%@ %@",strRupee,globalSearchModel.product_price];
	}
	else
	{
		if (globalSearchModel.store_id == nil) {
			[imgArrow setHidden:YES];
			[lblProductPrice setHidden:NO];
			[imgView sd_setImageWithURL:[NSURL URLWithString:globalSearchModel.product_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
			lblName.text = globalSearchModel.product_name;
			
			lblProductPrice.text = [NSString stringWithFormat:@"%@ %@",strRupee,globalSearchModel.product_price];
		}
		else
		{
		
		[imgView sd_setImageWithURL:[NSURL URLWithString:globalSearchModel.store_image] placeholderImage:[UIImage imageNamed:@"chooseCategoryDefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
		lblName.text = globalSearchModel.store_name;
			[imgArrow setHidden:NO];
			[lblProductPrice setHidden:YES];
		}
	}
}
@end
