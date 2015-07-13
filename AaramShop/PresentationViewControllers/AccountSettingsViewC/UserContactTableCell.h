//
//  UserContactTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 02/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserContactTableCell : UITableViewCell

@property (nonatomic, strong) PWTextField *txtEmail;
@property (nonatomic, strong) UILabel *lblChangePass;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
