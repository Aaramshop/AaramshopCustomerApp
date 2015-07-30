//
//  ShoppingListShareCell.h
//  AaramShop
//
//  Created by Approutes on 15/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedUserModel.h"

@interface ShoppingListShareCell : UITableViewCell
{
    __weak IBOutlet UIImageView *imgUser;
    __weak IBOutlet UILabel *lblUserName;
}

//@property (nonatomic,strong) SharedUserModel *sharedUserModel;
//@property (nonatomic,strong) NSIndexPath *indexPath;

-(void)updateCell:(SharedUserModel *)sharedUserModel;


@end
