//
//  PreferenceTableCell.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PreferenceTableCell.h"

@implementation PreferenceTableCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        imgPic = [[UIImageView alloc]initWithFrame:CGRectZero];
        swtBtn = [[UISwitch alloc]initWithFrame:CGRectZero];
        [swtBtn addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
        lblName = [[UILabel alloc]initWithFrame:CGRectZero];
        
        [self addSubview:imgPic];
        [self addSubview:swtBtn];
        [self addSubview:lblName];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    float imgSize = 20;
    float lblHeight = 21;
    float btnSwitchSize = 31;
    float padding = 8;
    
    CGRect imgPicRect           =   CGRectZero;
    CGRect swtBtnRect           =   CGRectZero;
    CGRect lblNameRect          =   CGRectZero;
    CGRect selfRect                 =   self.frame;
    
    imgPicRect.size.width           =   imgSize;
    imgPicRect.size.height          =   imgSize;
    imgPicRect.origin.x             =   padding*2;
    imgPicRect.origin.y             =   (selfRect.size.height - imgSize)/2;
    imgPic.frame                    =   imgPicRect;
    
    lblNameRect.size.width           =   selfRect.size.width - btnSwitchSize - imgPicRect.size.width - padding*8;
    lblNameRect.size.height          =   lblHeight;
    lblNameRect.origin.x             =   imgPicRect.origin.x + imgPicRect.size.width + padding;
    lblNameRect.origin.y             =   (selfRect.size.height - lblHeight)/2;
    lblName.frame                    =   lblNameRect;
    
    swtBtnRect.size.width           =   btnSwitchSize;
    swtBtnRect.size.height          =   btnSwitchSize;
    swtBtnRect.origin.x             =   lblNameRect.origin.x + lblNameRect.size.width + padding;
    swtBtnRect.origin.y             =   (selfRect.size.height - btnSwitchSize)/2;
    swtBtn.frame                    =   swtBtnRect;
}
- (void)handleSwitchEvent:(id)sender
{
    if([sender isOn])
    {
        NSLog(@"Switch is ON");
        [self sendSwitchValue:@"ON"];
    }
    else
    {
        NSLog(@"Switch is OFF");
        [self sendSwitchValue:@"OFF"];
    }
    
}
-(void)sendSwitchValue:(NSString *)switchBtnText
{
    if (self.delegateSwitchValue && [self.delegateSwitchValue conformsToProtocol:@protocol(delegateSwitchValue)] && [self.delegateSwitchValue respondsToSelector:@selector(getSwitchValue:indexPath:)])
    {
        [_delegateSwitchValue getSwitchValue:switchBtnText indexPath:_indexPath];
    }
}
-(void)updateCellWithData:(NSDictionary  *)inDataDic
{
    lblName.text=[inDataDic objectForKey:@"name"];
    imgPic.image=[UIImage imageNamed:[inDataDic objectForKey:@"images"]];
}
@end
