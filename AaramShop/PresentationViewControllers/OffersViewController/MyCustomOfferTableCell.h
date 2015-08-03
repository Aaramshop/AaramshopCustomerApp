//
//  MyCustomOfferTableCell.h
//  AaramShop_Merchant
//
//  Created by Arbab Khan on 15/06/15.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMOffers.h"

@interface MyCustomOfferTableCell : UITableViewCell
{
    __weak IBOutlet UIImageView *imgBrandLogo;
	__weak IBOutlet UILabel *lblOfferPrice;
    __weak IBOutlet UILabel *lblValidTill;
    __weak IBOutlet UILabel *lblPrice;
    __weak IBOutlet UILabel *lblbrandName;
	__weak IBOutlet UILabel *lblDescription;
	__weak IBOutlet UILabel *lblLine;
	__weak IBOutlet UILabel *lblCounter;
	__weak IBOutlet UIButton *btnRemove;
	__weak IBOutlet UIButton *btnAdd;
}
@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)updateCellWithData:(CMOffers *)offers;
- (IBAction)btnRemoveClicked:(id)sender;
- (IBAction)btnAddClicked:(id)sender;
@property (nonatomic, strong) CMOffers *offers;
@property(nonatomic,strong) id<OffersTableCellDelegate> delegate;

@end
