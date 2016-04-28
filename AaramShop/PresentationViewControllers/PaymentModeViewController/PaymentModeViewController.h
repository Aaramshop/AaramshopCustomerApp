//
//  PaymentModeViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 24/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPaymentMode.h"
#import "TotalAmtTableCell.h"
#import "PaymentModeTableCell.h"

#import "TotalPriceTableCell.h"
#import "PickLastTableCell.h"
#import "HomeSecondCustomCell.h"
#import "LocationEnterViewController.h"
#import "FeedbackViewController.h"
#import "CMPayment.h"


@interface PaymentModeViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
    
    __weak IBOutlet UITableView *tblView;
    NSMutableArray *arrPaymentMode;
    NSMutableArray *arrAddressData;
    NSMutableArray *arrDeliverySlot;
    NSMutableArray *arrLastMinPick;

    __weak IBOutlet UIWebView *webView;
}

@property(nonatomic,retain)CMPayment* cmPayment;

@property (weak, nonatomic) IBOutlet UIButton *btnFinalPay;
@property(nonatomic,strong) NSString *strStore_Id;
@property(nonatomic,strong) NSString *strStore_name;
@property(nonatomic,strong) NSString *strStore_image;
@property(nonatomic,strong) NSString *strTotalPrice;
@property(nonatomic,strong) NSString *strActualTotalPrice;
@property(nonatomic,strong) NSMutableArray *arrSelectedProducts;

@property (nonatomic, assign) BOOL fromCart;
@property(nonatomic,strong) FeedbackViewController *feedBack;

-(void)callWebServiceForCheckout:(NSMutableDictionary *)aDict;

@property(nonatomic,strong)NSMutableDictionary* dict;
@end
