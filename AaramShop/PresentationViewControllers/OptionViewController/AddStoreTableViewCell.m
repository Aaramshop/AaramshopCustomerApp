//
//  AddStoreTableViewCell.m
//  AaramShop
//
//  Created by Riteshk Gupta on 03/04/17.
//  Copyright © 2017 Approutes. All rights reserved.
//

#import "AddStoreTableViewCell.h"

@implementation AddStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteStoreBtn:(UIButton *)sender {
}


- (IBAction)deleteStore:(id)sender {
    
    {
        if (self.adelegate && [self.adelegate conformsToProtocol:@protocol(DeleteStoreListCell)] && [self.adelegate respondsToSelector:@selector(deleteStoreList:)])
        {
            [self.adelegate deleteStoreList:_indexPath1.row];
            
        }
 }

	}

@end
