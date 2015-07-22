//
//  SearchTableCell.h
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 02/07/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsModel.h"

@interface SearchTableCell : UITableViewCell
{
    UIImageView *imgView;
    UILabel *lblProductName;
    UILabel *lblProductPrice;
    NSString *strRupee;
}

//-(void)updateDetailsForCustomer:(Customer *)search;
-(void)updateDetailsFor:(ProductsModel *)product;

@end
