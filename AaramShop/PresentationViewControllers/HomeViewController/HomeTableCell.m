//
//  HomeTableCell.m
//  AaramShop
//
//  Created by Pradeep Singh on 14/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeTableCell.h"

@implementation HomeTableCell

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
        lblRestaurant = [[UILabel alloc]initWithFrame:CGRectZero];
        lblRestaurant.font = [UIFont fontWithName:kMyriadProRegular size:15];
        
        lblLocation = [[UILabel alloc]initWithFrame:CGRectZero];
        lblLocation.font = [UIFont fontWithName:kMyriadProRegular size:15];
        
        lblMini = [[UILabel alloc]initWithFrame:CGRectZero];
        lblMini.font = [UIFont fontWithName:kMyriadProRegular size:15];
        lblMini.text = @"Minimum Order Value: ";
        //
        imgProfilePic = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.size.width / 2;
        imgProfilePic.clipsToBounds=YES;
        
        imgUserChoice = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        imgLocation = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgLocation.image  = [UIImage imageNamed:@"locationIcon"];
        
        imgDot = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        [self addSubview:imgDot];
        [self addSubview:lblMini];
        [self addSubview: imgUserChoice];
        [self addSubview:lblRestaurant];
        [self addSubview:imgProfilePic];
        [self addSubview:imgLocation];
        
        
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    float imgProfilePicSize       =   60;
    float imgUserChoiceSize = 20;
    float lblHeight     =   18;
    float lblMiniWidth=150;
    float padding       =   8;
    
    CGRect imgProfilePicRect          =   CGRectZero;
    CGRect lblRestaurantRect          =   CGRectZero;
    CGRect lblLocationRect              =  CGRectZero;
    CGRect lblMiniRect                      = CGRectZero;
    CGRect imgUserChoiceRect     =   CGRectZero;
    CGRect imgLocationRect           =   CGRectZero;
    CGRect imgDotRect               =   CGRectZero;
    CGRect selfRect                         =   self.frame;
    
    imgProfilePicRect.size.width        =   imgProfilePicSize;
    imgProfilePicRect.size.height       =   imgProfilePicSize;
    imgProfilePicRect.origin.x            =   padding;
    imgProfilePicRect.origin.y            =     (selfRect.size.height - imgProfilePicSize)/2;
    imgProfilePic.frame                 =imgProfilePicRect;
    
    imgUserChoiceRect.size.width        =   imgUserChoiceSize;
    imgUserChoiceRect.size.height       =   imgUserChoiceSize;
    imgUserChoiceRect.origin.x            =   imgProfilePicRect.origin.x + imgProfilePicRect.size.width + padding;
    imgUserChoiceRect.origin.y            =    (selfRect.size.height - imgUserChoiceSize*3)/2;
    imgUserChoice.frame                 =imgUserChoiceRect;
    
    lblRestaurantRect.size.width        =   selfRect.size.width - imgUserChoiceSize - imgProfilePicRect.size.width - padding*3;
    lblRestaurantRect.size.height       =   lblHeight;
    lblRestaurantRect.origin.x           =      imgUserChoiceRect.origin.x + imgUserChoiceRect.size.width + padding;
    lblRestaurantRect.origin.y          =       imgUserChoiceRect.origin.y;
    lblRestaurant.frame             =lblRestaurantRect;
    
    imgDotRect.size.width        =   11;
    imgDotRect.size.height       =   11;
    imgDotRect.origin.x           =      selfRect.size.width - 19;
    imgDotRect.origin.y          =       imgUserChoiceRect.origin.y;
    imgDot.frame             =imgDotRect;
    
    lblMiniRect.size.width        =   lblMiniWidth;
    lblMiniRect.size.height       =   lblHeight;
    lblMiniRect.origin.x            =   imgProfilePicRect.origin.x + imgProfilePicRect.size.width + padding + 3;
    lblMiniRect.origin.y            =    imgUserChoiceRect.origin.y + imgUserChoiceRect.size.height + 3;
    lblMini.frame                       =lblMiniRect;
    
    imgLocationRect.size.width        =   imgUserChoiceSize;
    imgLocationRect.size.height       =   imgUserChoiceSize;
    imgLocationRect.origin.x            =   imgProfilePicRect.origin.x + imgProfilePicRect.size.width + padding;
    imgLocationRect.origin.y            =    lblMiniRect.origin.y + lblMiniRect.size.height;
    imgLocation.frame                    =imgLocationRect;
    
    
    
    
}
-(void)updateCellWithData:(NSDictionary  *)inDataDic
{
    imgProfilePic.image=[UIImage imageNamed:[inDataDic objectForKey:@"imgProfilePic"]];
    lblRestaurant.text = [inDataDic objectForKey:@"name"];
    imgUserChoice.image = [UIImage imageNamed:[inDataDic objectForKey:@"userChoice"]];
    imgDot.image = [UIImage imageNamed:[inDataDic objectForKey:@"paid"]];
}
@end
