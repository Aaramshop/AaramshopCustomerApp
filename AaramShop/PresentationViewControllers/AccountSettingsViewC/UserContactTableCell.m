//
//  UserContactTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 02/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "UserContactTableCell.h"

@implementation UserContactTableCell
@synthesize txtEmail,lblChangePass;
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
        
        txtEmail = [[PWTextField alloc]initWithFrame:CGRectZero];
		txtEmail.font = [UIFont fontWithName:kRobotoMedium size:14.0f];
		txtEmail.textColor = [UIColor colorWithRed:92/255.0f green:92/255.0f blue:92/255.0f alpha:1.0f];
		
		
		lblChangePass = [[UILabel alloc] initWithFrame:CGRectZero];
		lblChangePass.textAlignment = NSTextAlignmentRight;
		lblChangePass.font = [UIFont fontWithName:kRobotoRegular size:12.0f];
		lblChangePass.textColor = [UIColor colorWithRed:206/255.0f green:44/255.0f blue:23/255.0f alpha:1.0f];

		[self addSubview:lblChangePass];

        [self addSubview:txtEmail];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    float lblHeight = 30;
    float padding = 8;
    
    CGRect lblEmailRect           =   CGRectZero;
	CGRect lblChangePassRect           =   CGRectZero;
    CGRect selfRect                 =   self.frame;
    
    lblEmailRect.size.width     =   selfRect.size.width - padding*2;
    lblEmailRect.size.height    =   lblHeight;
    lblEmailRect.origin.x           =   padding;
    lblEmailRect.origin.y           =   (selfRect.size.height - lblEmailRect.size.height)/2;
    txtEmail.frame                  =   lblEmailRect;
	
	lblChangePassRect.size.width     =   selfRect.size.width - padding*2;
	lblChangePassRect.size.height    =   lblHeight;
	lblChangePassRect.origin.x           =   padding;
	lblChangePassRect.origin.y           =   (selfRect.size.height - lblEmailRect.size.height)/2;
	lblChangePass.frame                  =   lblChangePassRect;
}

@end
