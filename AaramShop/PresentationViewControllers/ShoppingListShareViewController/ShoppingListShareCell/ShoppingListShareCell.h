//
//  ShoppingListShareCell.h
//  AaramShop
//
//  Created by Approutes on 15/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListShareCell : UITableViewCell
{
    __weak IBOutlet UIImageView *imgUser;
    __weak IBOutlet UILabel *lblUserName;
}

-(void)updateCell;


@end
