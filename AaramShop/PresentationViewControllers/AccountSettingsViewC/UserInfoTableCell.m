//
//  UserInfoTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 02/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "UserInfoTableCell.h"

@implementation UserInfoTableCell

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
        
        lblLower = [[UILabel alloc]initWithFrame:CGRectZero];
        lblUpper = [[UILabel alloc]initWithFrame:CGRectZero];
        
        imgArrow = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgArrow.image = [UIImage imageNamed:@"btnArrow"];
        
        [self addSubview:lblUpper];
        [self addSubview:lblLower];
        [self addSubview:imgArrow];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    float lblHeight = 21;
    float imgArrowWidth = 13;
    float imgArrowHeight = 21;
    float padding = 8;
    
    CGRect lblUpperRect           =   CGRectZero;
    CGRect imgArrowRect           =   CGRectZero;
    CGRect lblLowerRect          =   CGRectZero;
    CGRect selfRect                 =   self.frame;
    
    lblUpperRect.size.width           =   selfRect.size.width - imgArrowWidth - padding*3;
    lblUpperRect.size.height          =   lblHeight;
    lblUpperRect.origin.x             =   padding;
    lblUpperRect.origin.y             =   (selfRect.size.height - lblHeight*2)/2;
    lblUpper.frame                    =   lblUpperRect;
    
    lblLowerRect.size.width           =   selfRect.size.width - imgArrowWidth - padding*3;
    lblLowerRect.size.height          =   lblHeight;
    lblLowerRect.origin.x             =   padding;
    lblLowerRect.origin.y             =   lblUpperRect.origin.y + lblUpperRect.size.height + 2;
    lblLower.frame                    =   lblLowerRect;
    
    imgArrowRect.size.width           =   imgArrowWidth;
    imgArrowRect.size.height          =   imgArrowHeight;
    imgArrowRect.origin.x             =   lblUpperRect.origin.x + lblUpperRect.size.width + padding;
    imgArrowRect.origin.y             =   (selfRect.size.height - imgArrowHeight)/2;
    imgArrow.frame                    =   imgArrowRect;
}
-(void)updateCellWithData:(NSDictionary  *)inDataDic
{
    lblLower.text = [inDataDic objectForKey:@"lastname"];
    lblUpper.text = [inDataDic objectForKey:@"firstname"];
}
@end
