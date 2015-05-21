//
//  RightSideTableCell.m
//  AaramShop
//
//  Created by Pradeep Singh on 21/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "RightSideTableCell.h"

@implementation RightSideTableCell

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
       
        btnCategory=[[UIButton alloc]initWithFrame:CGRectZero];
        
        lblName=[[UILabel alloc]initWithFrame:CGRectZero];
        lblName.font=[UIFont fontWithName:@"Roboto-Regular" size:13.0f];
        lblName.textColor=[UIColor colorWithRed:89/255.0f green:89/255.0f blue:89/255.0f alpha:1.0f];
        lblName.textAlignment=NSTextAlignmentCenter;
        
        
        
        
        
        
        
        
        
        
//        self.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
        
        
       
        [self addSubview:btnCategory];
        [self addSubview:lblName];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // adjust frame here if needed.
    float imgSize = 70.0f;
    float lblHeight = 20;
    
    CGRect btnCategoryRect          =   CGRectZero;
    CGRect lblNameRect                  =   CGRectZero;
    CGRect selfRect                     =self.frame;
    
    btnCategoryRect.size.width      =   imgSize;
    btnCategoryRect.size.height      =   imgSize;
    btnCategoryRect.origin.x            =   (selfRect.size.width - imgSize)/2;
    btnCategoryRect.origin.y            =   (selfRect.size.height - imgSize - lblHeight)/2;
    btnCategory.frame                   =   btnCategoryRect;
    
    
    
    lblNameRect.size.width      =   selfRect.size.width;
    lblNameRect.size.height      =   lblHeight;
    lblNameRect.origin.x            =   0;
    lblNameRect.origin.y            =   btnCategoryRect.origin.y  + btnCategoryRect.size.width + 4;
    lblName.frame                   =   lblNameRect;
    
    
    
    
    
}
-(void)updateCellWithData:(NSDictionary  *)inDataDic
{
    [btnCategory setImage:[UIImage imageNamed:[inDataDic objectForKey:@"image"] ] forState:UIControlStateNormal];
    lblName.text = [inDataDic objectForKey:@"name"];
}
@end
