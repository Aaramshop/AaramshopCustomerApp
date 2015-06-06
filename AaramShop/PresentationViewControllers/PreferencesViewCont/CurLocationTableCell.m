//
//  CurLocationTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 02/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "CurLocationTableCell.h"

@implementation CurLocationTableCell

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
        
        imgPic = [[UIImageView alloc]initWithFrame:CGRectZero];
        lblName = [[UILabel alloc]initWithFrame:CGRectZero];
        imgArrow = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgArrow.image = [UIImage imageNamed:@"btnArrow"];
        
        [self addSubview:imgPic];
        [self addSubview:lblName];
        [self addSubview:imgArrow];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    float imgSize = 20;
    float lblHeight = 21;
    float imgArrowWidth = 13;
    float imgArrowHeight = 21;
    float padding = 8;
    
    CGRect imgPicRect           =   CGRectZero;
    CGRect imgArrowRect           =   CGRectZero;
    CGRect lblNameRect          =   CGRectZero;
    CGRect selfRect                 =   self.frame;
    
    imgPicRect.size.width           =   imgSize;
    imgPicRect.size.height          =   imgSize;
    imgPicRect.origin.x             =   padding*2;
    imgPicRect.origin.y             =   (selfRect.size.height - imgSize)/2;
    imgPic.frame                    =   imgPicRect;
    
    lblNameRect.size.width           =   selfRect.size.width - imgArrowWidth - imgPicRect.size.width - padding*8;
    lblNameRect.size.height          =   lblHeight;
    lblNameRect.origin.x             =   imgPicRect.origin.x + imgPicRect.size.width + padding;
    lblNameRect.origin.y             =   (selfRect.size.height - lblHeight)/2;
    lblName.frame                    =   lblNameRect;
    
    imgArrowRect.size.width           =   imgArrowWidth;
    imgArrowRect.size.height          =   imgArrowHeight;
    imgArrowRect.origin.x             =   lblNameRect.origin.x + lblNameRect.size.width + padding;
    imgArrowRect.origin.y             =   (selfRect.size.height - imgArrowHeight)/2;
    imgArrow.frame                    =   imgArrowRect;
}
-(void)updateCellWithData:(NSDictionary  *)inDataDic
{
    lblName.text=[inDataDic objectForKey:@"name"];
    imgPic.image=[UIImage imageNamed:[inDataDic objectForKey:@"images"]];
}
@end
