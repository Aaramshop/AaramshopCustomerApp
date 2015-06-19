//
//  HomeSecondCustomCell.m
//  AaramShop
//
//  Created by Approutes on 09/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeSecondCustomCell.h"

@implementation HomeSecondCustomCell
@synthesize indexPath,subCategory,delegate;
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
        lblName.font = [UIFont fontWithName:kRobotoRegular size:16.0f];
        lblName.textColor = [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0];
        [lblName setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:lblName];

        
        lblPrice = [[UILabel alloc] init];
        lblPrice.textColor = [UIColor whiteColor];
        lblPrice.numberOfLines = 0;
        lblPrice.font = [UIFont fontWithName:kRobotoRegular size:14.0f];
        lblPrice.textColor = [UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0];
        [lblPrice setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:lblPrice];


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

        int xPos = 5;
        imgV.frame = CGRectMake(xPos, 4, 60, 60);
        xPos+=imgV.frame.size.width+5;
        
        btnPlus.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-35, 14, 30, 40);
        lblCount.frame = CGRectMake(btnPlus.frame.origin.x-30, 24, 30, 20);
        btnMinus.frame = CGRectMake(lblCount.frame.origin.x-30, 14, 30, 40);
        lblName.frame = CGRectMake(xPos, 10, btnMinus.frame.origin.x-(xPos+10), 24);
        lblPrice.frame = CGRectMake(xPos, 34, 200, 20);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)btnMinusClick
{
    
}
-(void)btnPlusClick
{
    if ([subCategory.count intValue]>=0) {
        int Counter = [subCategory.count intValue];
        Counter++;
        subCategory.count = [NSString stringWithFormat:@"%d",Counter];
//        if (self.delegate && [self.delegate conformsToProtocol:@protocol(VenueViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(addedValueByCounter:atIndexPath:)])
//        {
//            [self.delegate addedValueByCounter:counter atIndexPath:self.indexPath];
//        }
//        

    }

}
-(void)updateCellWithSubCategory:(SubCategoryModel *)objSubCategory
{
    imgV.image = [UIImage imageNamed:objSubCategory.img];
    lblName.text= objSubCategory.strCategoryName;
    lblPrice.text = objSubCategory.price;
    lblCount.text = objSubCategory.count;
}

@end
