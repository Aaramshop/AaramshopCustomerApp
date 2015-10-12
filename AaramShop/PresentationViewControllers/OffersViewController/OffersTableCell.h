//
//  OffersTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 14/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMOffers.h"


@interface OffersTableCell : UITableViewCell
{
	
	__weak IBOutlet UIImageView *imgBrandLogo;
	__weak IBOutlet UILabel *lblOfferPrice;
	__weak IBOutlet UILabel *lblValidTill;
	__weak IBOutlet UILabel *lblPrice;
	__weak IBOutlet UILabel *lblbrandName;
	__weak IBOutlet UILabel *lblLine;
	__weak IBOutlet UILabel *lblCounter;

	__weak IBOutlet UILabel *lblViewDetails;
    
    __weak IBOutlet UILabel *lblStoreName;
    
}
@property (nonatomic, strong)	IBOutlet UIButton *btnRemove;
@property (nonatomic, strong)	IBOutlet UIButton *btnAdd;
@property (nonatomic, strong) CMOffers *offers;
@property(nonatomic,strong) id<OffersTableCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)updateCellWithData: (CMOffers *)offers;
- (IBAction)btnRemoveClicked:(id)sender;
- (IBAction)btnAddClicked:(id)sender;
@end
