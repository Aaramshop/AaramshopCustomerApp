//
//  UserContactTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 02/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "UserContactTableCell.h"

@implementation UserContactTableCell
@synthesize lblEmail,lblChangePass;
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
        
        lblEmail = [[UILabel alloc]initWithFrame:CGRectZero];
		
		lblChangePass = [[UILabel alloc] initWithFrame:CGRectZero];
		lblChangePass.textAlignment = NSTextAlignmentRight;
		
		[self addSubview:lblChangePass];

        [self addSubview:lblEmail];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    float lblHeight = 21;
    float padding = 16;
    
    CGRect lblEmailRect           =   CGRectZero;
	CGRect lblChangePassRect           =   CGRectZero;
    CGRect selfRect                 =   self.frame;
    
    lblEmailRect.size.width     =   selfRect.size.width - padding*2;
    lblEmailRect.size.height    =   lblHeight;
    lblEmailRect.origin.x           =   padding;
    lblEmailRect.origin.y           =   (selfRect.size.height - lblEmailRect.size.height)/2;
    lblEmail.frame                  =   lblEmailRect;
	
	lblChangePassRect.size.width     =   selfRect.size.width - padding*2;
	lblChangePassRect.size.height    =   lblHeight;
	lblChangePassRect.origin.x           =   padding;
	lblChangePassRect.origin.y           =   (selfRect.size.height - lblEmailRect.size.height)/2;
	lblChangePass.frame                  =   lblChangePassRect;
}
-(void)updateCellWithData:(NSDictionary  *)inDataDic
{
    lblEmail.text = [inDataDic objectForKey:@"email"];
}
@end
