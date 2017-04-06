//
//  LocationTableCell.m
//  AaramShop
//
//  Created by Arbab Khan on 31/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "LocationTableCell.h"
#import "AddLocationViewController.h"

@implementation LocationTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateCellWithData: (AddressModel *)addressModel
{
	lblTitle.text = addressModel.title;
	lblAddress.text = [NSString stringWithFormat:@"%@, %@, %@, %@",addressModel.address,addressModel.state,addressModel.city,addressModel.pincode];
}
//- (IBAction)deleteButton:(UIButton *)sender {
- (IBAction)deleteButton:(id)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(LocationListCellDelegate)] && [self.delegate respondsToSelector:@selector(deleteLocationList:)])
    {
        [self.delegate deleteLocationList:_indexPath.row];
        
    }
   

    


//-(void)updateCell:(AddressModel *)locationListModel
//{
//    //_lblTitle.text = locationListModel.shoppingListName;
//    
//    if ([locationListModel.title length]>0) {
//       lblTitle.text=[NSString stringWithFormat:@"%@ Titles",locationListModel.title];
//    }
//    else{
//        lblTitle.text=[NSString stringWithFormat:@"%@ Title",locationListModel.title];
//    }
//    if ([locationListModel.address length]>0) {
//      lblAddress.text = [NSString stringWithFormat:@"%@, %@, %@, %@",locationListModel.address,locationListModel.state,locationListModel.city,locationListModel.pincode];
//    }
//    else{
//       lblAddress.text = [NSString stringWithFormat:@"%@, %@, %@, %@",locationListModel.address,locationListModel.state,locationListModel.city,locationListModel.pincode];
//    }

    
    
    //lblAddress.text=locationListModel.address;
    
    
    
//    if ([shoppingListModel.totalItems integerValue]>1)
//    {
//        lblQuantity.text = [NSString stringWithFormat:@"%@ Items",shoppingListModel.totalItems];
//    }
//    else
//    {
//        lblQuantity.text = [NSString stringWithFormat:@"%@ Item",shoppingListModel.totalItems];
//    }
    
    //
    //    ////
    //
    //    NSString *strTime = @"";
    //
    //    if ([shoppingListModel.reminder_start_date integerValue]>0)
    //    {
    //        [btnTime setImage:[UIImage imageNamed:@"clockIconRed"] forState:UIControlStateNormal];
    //        [btnTime setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    //
    //        strTime = [self convertTimeStampToDate:shoppingListModel.reminder_start_date];
    //
    //        //        strTime = [Utils convertedDate:[NSDate dateWithTimeIntervalSince1970:[shoppingListModel.reminder_start_date doubleValue]]];
    //    }
    //    else
    //    {
    //        //        strTime = [Utils convertedDate:[NSDate dateWithTimeIntervalSince1970:[shoppingListModel.creationDate doubleValue]]];
    //
    //        strTime = [self convertTimeStampToDate:shoppingListModel.creationDate];
    //
    //    }
    //
    //    strTime = [[[strTime stringByReplacingOccurrencesOfString:@"/" withString:@"-"] componentsSeparatedByString:@" "] firstObject];
    //
    //    if ([strTime hasSuffix:@","])
    //    {
    //        strTime = [strTime substringToIndex:[strTime length]-1];
    //    }
    //
    //
    //    [btnTime setTitle:strTime forState:UIControlStateNormal];
    //
    //
    //    btnShare.hidden = NO;
    //    lblShare.hidden = NO;
    //
    //
    //    if ([shoppingListModel.sharedBy count]>0)
    //    {
    //        SharedUserModel *sharedUserModel = [shoppingListModel.sharedBy objectAtIndex:0];
    //
    //        NSString *strText1 = sharedUserModel.full_name;
    //        NSString *strText2 = @" is sharing with you";
    //
    //        NSString *strFullString = [NSString stringWithFormat:@"%@%@",strText1,strText2];
    //
    //        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strFullString];
    //
    //
    //        [attrString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:12.0],NSFontAttributeName,[UIColor colorWithRed:254.0/255.0 green:56.0/255.0 blue:45.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(0 , strText1.length)];
    //
    //        [attrString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:12.0],NSFontAttributeName,[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(strText1.length, strFullString.length-(3+strText1.length))];
    //
    //        [attrString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:12.0],NSFontAttributeName,[UIColor colorWithRed:254.0/255.0 green:56.0/255.0 blue:45.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(strFullString.length-3 , 3)];
    //
    //
    //        lblShare.attributedText = attrString;
    //
    //    }
    //    else if ([shoppingListModel.sharedWith count]>0)
    //    {
    //
    //        NSString *strText1 = @"Shared by you with ";
    //
    //        NSString *strText2 = [NSString stringWithFormat:@"%ld people",[shoppingListModel.sharedWith count]];
    //
    //        NSString *strFullString = [NSString stringWithFormat:@"%@%@",strText1,strText2];
    //
    //        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strFullString];
    //
    //        [attrString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:12.0],NSFontAttributeName,[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, strText1.length)];
    //
    //        [attrString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:12.0],NSFontAttributeName,[UIColor colorWithRed:254.0/255.0 green:56.0/255.0 blue:45.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(strText1.length, strText2.length)];
    //        
    //        
    //        lblShare.attributedText = attrString;
    //        
    //        
    //    }
    //    else
    //    {
    //        btnShare.hidden = YES;
    //        lblShare.hidden = YES;
    //        
    //    }
    //}
    
}
@end
