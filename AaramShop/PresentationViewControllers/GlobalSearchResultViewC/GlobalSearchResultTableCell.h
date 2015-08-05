//
//  GlobalSearchResultTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 05/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsModel.h"
@interface GlobalSearchResultTableCell : UITableViewCell
{
	__weak IBOutlet UILabel *lblStoreName;
	__weak IBOutlet UILabel *lblProductName;
	__weak IBOutlet UIImageView *imgProduct;
	__weak IBOutlet UIButton *btnMinus;
	
	__weak IBOutlet UIButton *btnPlus;
	__weak IBOutlet UILabel *lblCount;
	__weak IBOutlet UIImageView *imgStore;
	__weak IBOutlet UILabel *lblLine;
	__weak IBOutlet UILabel *lblOfferPrice;
	__weak IBOutlet UILabel *lblPrice;
}
@property (nonatomic, assign) BOOL fromCart;
@property (nonatomic, strong) NSString *store_id;
@property(nonatomic,strong) ProductsModel *objProductsModelMain;
@property(nonatomic,strong) id<HomeSecondCustomCellDelegate> delegate;
@property(nonatomic,strong) NSIndexPath *indexPath;
-(void)updateCellWithSubCategory:(ProductsModel *)objProductsModel;
- (IBAction)btnMinus:(id)sender;
- (IBAction)btnPlus:(id)sender;
@end
