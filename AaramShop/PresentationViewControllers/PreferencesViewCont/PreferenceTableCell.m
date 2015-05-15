//
//  PreferenceTableCell.m
//  AaramShop
//
//  Created by Pradeep Singh on 14/05/15.
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
        
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
-(void)updateCellWithData:(NSDictionary  *)inDataDic
{
    lbl.text=[inDataDic objectForKey:@"Key"];
    imgPic.image=[UIImage imageNamed:[inDataDic objectForKey:@"Value"]];
}
@end
