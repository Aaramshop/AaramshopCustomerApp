//
//  ShopListTableCell.m
//  AaramShop
//
//  Created by Pradeep Singh on 15/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListCell.h"

@implementation ShoppingListCell

- (void)awakeFromNib {
    // Initialization code
    
    
//    [btnShare setTitleColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)actionDelete:(id)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(ShoppingListCellDelegate)] && [self.delegate respondsToSelector:@selector(deleteShoppingList:)])
    {
        [self.delegate deleteShoppingList:_indexPath.row];
    }

}




-(void)updateCell:(ShoppingListModel *)shoppingListModel
{
    lblTitle.text = shoppingListModel.shoppingListName;
    
    if ([shoppingListModel.totalItems integerValue]>1)
    {
        lblQuantity.text = [NSString stringWithFormat:@"%@ Items",shoppingListModel.totalItems];
    }
    else
    {
        lblQuantity.text = [NSString stringWithFormat:@"%@ Item",shoppingListModel.totalItems];
    }
    
    
    ////
    
    NSString *strTime = @"";
    
    if ([shoppingListModel.reminderDate length]>0)
    {
        [btnTime setImage:[UIImage imageNamed:@"clockIconRed"] forState:UIControlStateNormal];
        [btnTime setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        
        strTime = [Utils convertedDate:[NSDate dateWithTimeIntervalSince1970:[shoppingListModel.reminderDate doubleValue]]];
    }
    else
    {
        strTime = [Utils convertedDate:[NSDate dateWithTimeIntervalSince1970:[shoppingListModel.creationDate doubleValue]]];
    }
    
    strTime = [[[strTime stringByReplacingOccurrencesOfString:@"/" withString:@"-"] componentsSeparatedByString:@" "] firstObject];

    // firstly remove ',' from last index of string, after uncommenting the above code. Ex - 'Yesterday,'.
    // Right now, it's - 'Yesterday, 12:00 AM'
   
    
    if ([strTime hasSuffix:@","])
    {
        strTime = [strTime substringToIndex:[strTime length]-1];
    }
    
    
    [btnTime setTitle:strTime forState:UIControlStateNormal];
    
    
    ////
    
    
    // work remainig for share info..
    
    
}

/*
 @property(nonatomic,strong) NSString * sharedBy; // temp // user model here
 @property(nonatomic,strong) NSString * sharedWith; // temp // user model here
 @property(nonatomic,strong) NSString * total_people;
 */


@end
