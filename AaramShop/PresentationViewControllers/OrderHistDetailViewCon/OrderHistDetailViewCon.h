//
//  OrderHistDetailViewCon.h
//  AaramShop
//
//  Created by Arbab Khan on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMOrderHist.h"
typedef enum
{
	eSelectedTypeNone=0,
	eSelectedType1,
	eSelectedType2
	
}enBtnSelectedType;
@interface OrderHistDetailViewCon : UIViewController<AaramShop_ConnectionManager_Delegate>
{
	
	__weak IBOutlet UILabel *lblOrderDate;
	__weak IBOutlet UIImageView *imgCustomer;
	
	__weak IBOutlet UILabel *lblCustomerName;
	
	__weak IBOutlet UILabel *lblTimeSlot;
	__weak IBOutlet UILabel *lblDeliveryBoyName;
	
	__weak IBOutlet UILabel *lblOrder_time;

	__weak IBOutlet UILabel *lblOrderAmt;
	
	enBtnSelectedType orderStatusButton;
	__weak IBOutlet UIButton *dispatchedBtn;
	__weak IBOutlet UIButton *packedBtn;
	__weak IBOutlet UILabel *lblPackedTime;
	
	__weak IBOutlet UIButton *btnCompleted;
	__weak IBOutlet UIImageView *imgReceived;
	__weak IBOutlet UILabel *lblReceived;
	__weak IBOutlet UIButton *receivedBtn;
	__weak IBOutlet UILabel *lblDispachedTime;
	NSString *strCust_Mobile;
	NSString *strDeliveryboy_mobile;
	NSString *strOrderStatus;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	NSString *strRupee;
	__weak IBOutlet UILabel *lblPaymentMode;
    
    
    __weak IBOutlet UIScrollView *scrollview;
    __weak IBOutlet UILabel *lblTotalUdhaar;
    __weak IBOutlet UILabel *lblUdhaar_value;
    __weak IBOutlet UIButton *btnCallDeliveryBoy;

    
}

@property (nonatomic, strong) CMOrderHist *orderHist;

- (IBAction)btnReceived:(id)sender;

- (IBAction)btnSeeMoreDetails:(id)sender;
- (IBAction)btnCallMerchant:(id)sender;
- (IBAction)btnChatWithMerchant:(id)sender;


@end
