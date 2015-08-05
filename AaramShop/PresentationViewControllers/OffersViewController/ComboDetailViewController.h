//
//  ComboDetailViewController.h
//  AaramShop_Merchant
//
//  Created by Neha Saxena on 22/07/2015.
//  Copyright (c) 2015 Arbab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMOffers.h"
#import "CartProductModel.h"
@interface ComboDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AaramShop_ConnectionManager_Delegate>
{
	__weak IBOutlet UILabel *lblOfferName;
	__weak IBOutlet UILabel *lblValidTill;
	__weak IBOutlet UILabel *lblActualPrice;
	__weak IBOutlet UILabel *lblOfferPrice;
	__weak IBOutlet UIImageView *imgViewOffer;
}
@property (nonatomic, strong) IBOutlet UITableView *tblView;
@property (nonatomic, strong) CMOffers *offersModel;
@property (nonatomic, strong) CartProductModel *cartProductModel;
@property (nonatomic, strong) NSMutableArray *arrProducts;
@end
