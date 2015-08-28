//
//  PaymentViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 22/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PaymentViewController.h"
#import "ProductsModel.h"
#import "AddressModel.h"


#define kBtnDone   33454
#define kBtnCancel 33455
#define kTagForFeedBack 100


static NSString *strCollectionItems = @"collectionItems";

@interface PaymentViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    AppDelegate *appDel;
    BOOL isPickerOpen;
    NSString *strDeliveryDate;
    NSString *strSelectSlot;
    NSMutableArray *arrSelectedLastMinPick;
    NSString *strSelectAddress;
    NSString *strSelectedUserAddress_Id;
	NSString *total_discount;
	NSString *coupon_code;
	NSString *delivery_charges;
	NSString *subTotal;
	NSString *min_order_value;
	UITextField *tfCouponCode;
	NSInteger isCouponValid;
}
@end

@implementation PaymentViewController
@synthesize strStore_Id,strTotalPrice,arrSelectedProducts,ePickerType;
@synthesize feedBack;

 - (void)initializeObjects
{
	coupon_code = @"";
	isCouponValid = -1;
	total_discount = @"0";
	delivery_charges = @"0";
	appDel = APP_DELEGATE;
	isPickerOpen = NO;
	ePickerType = enPickerSlots;
	strDeliveryDate = @"Immediate";
	strSelectSlot = @"Select Slot";
	strSelectAddress = @"Select Address";
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;
	arrAddressData = [[NSMutableArray alloc] init];
	arrLastMinPick = [[NSMutableArray alloc]init];
	arrDeliverySlot = [[NSMutableArray alloc]init];
	arrSelectedLastMinPick = [[NSMutableArray alloc]init];
	tblView.sectionFooterHeight= 0.0;
	tblView.sectionHeaderHeight = 0.0;
	self.automaticallyAdjustsScrollViewInsets = NO;
	NSInteger discount = 0;
	NSInteger sub_total = 0;
	for (CartProductModel *productModel in arrSelectedProducts) {
		if([productModel.strOffer_type integerValue]==1 || [productModel.strOffer_type integerValue]==4 )
		{
			discount += ([productModel.product_price integerValue]-[productModel.offer_price integerValue])*[productModel.strCount integerValue];
		}
		if([productModel.strOffer_type integerValue] == 6)
		{
			sub_total +=[productModel.offer_price integerValue]*[productModel.strCount integerValue];
		}
		sub_total += [productModel.product_price integerValue]*[productModel.strCount integerValue];

	}
	subTotal = [NSString stringWithFormat:@"%ld",(long)sub_total];
	total_discount = [NSString stringWithFormat:@"%ld",(long)discount];
	strTotalPrice = [NSString stringWithFormat:@"%ld",(long)([subTotal integerValue]-[total_discount integerValue])];
}
- (void)getTotalAmount
{
	
}
- (void)getTotalDiscount
{
	
}
- (void)viewDidLoad {
    [super viewDidLoad];
	[self initializeObjects];
    [self setNavigationBar];
    [self createDataToGetPaymentPageData];
    [self designDatePicker];
    [self designToolBar];
    [self designPickerViewSlots];
}
-(void)designDatePicker
{
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+216, [UIScreen mainScreen].bounds.size.width, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setMinimumDate:[NSDate date]];
    [self.view addSubview:datePicker];
}
-(void)designPickerViewSlots
{
    pickerViewSlots = [[UIPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+216, [UIScreen mainScreen].bounds.size.width, 216)];
    pickerViewSlots.delegate = self;
    pickerViewSlots.dataSource = self;
    pickerViewSlots.backgroundColor=[UIColor whiteColor];
    pickerViewSlots.clipsToBounds=YES;
    pickerViewSlots.showsSelectionIndicator = YES;
    [self.view addSubview:pickerViewSlots];
}
- (NSDictionary *)getProductIdandProductQty
{
	
	NSString *productIds				= @"";
	NSString *product_sku_ids	= @"";
	NSString *offer_types				= @"";
	NSString *productqtys			= @"";
	NSString *product_prices		=	@"";

	
	NSPredicate *predicate =[NSPredicate predicateWithFormat:@"NOT (SELF.strOffer_type CONTAINS %@)",@"0"] ;
	NSArray *array = [arrSelectedProducts filteredArrayUsingPredicate:predicate];
	if([array count]>0)
	{
		NSArray *arrIDs = [array valueForKey:@"offer_id"];
		productIds = [arrIDs componentsJoinedByString:@","];
		
		arrIDs = [array valueForKey:@"strCount"];
		productqtys =[arrIDs componentsJoinedByString:@","];
		
		arrIDs = [array valueForKey:@"product_sku_id"];
		product_sku_ids = [arrIDs componentsJoinedByString:@","];
		
		arrIDs = [array valueForKey:@"offer_price"];
		product_prices = [arrIDs componentsJoinedByString:@","];

		arrIDs = [array valueForKey:@"strOffer_type"];
		offer_types = [arrIDs componentsJoinedByString:@","];
}
	predicate = [NSPredicate predicateWithFormat:@"SELF.strOffer_type == %@",@"0"];
	array = [arrSelectedProducts filteredArrayUsingPredicate:predicate];
	if([array count]>0)
	{
		NSMutableArray *arrIDs = [NSMutableArray arrayWithArray:[array valueForKey:@"product_id"]];
		[arrIDs addObjectsFromArray:[productIds componentsSeparatedByString:@","]];
		productIds = [arrIDs componentsJoinedByString:@","];
		
		arrIDs = [NSMutableArray arrayWithArray:[array valueForKey:@"strCount"]];
		[arrIDs addObjectsFromArray:[productqtys componentsSeparatedByString:@","]];
		productqtys =[arrIDs componentsJoinedByString:@","];
		
		arrIDs = [NSMutableArray arrayWithArray:[array valueForKey:@"product_sku_id"]];
		[arrIDs addObjectsFromArray:[product_sku_ids componentsSeparatedByString:@","]];
		product_sku_ids =[arrIDs componentsJoinedByString:@","];

		arrIDs = [NSMutableArray arrayWithArray:[array valueForKey:@"product_price"]];
		[arrIDs addObjectsFromArray:[product_prices componentsSeparatedByString:@","]];
		product_prices =[arrIDs componentsJoinedByString:@","];

		arrIDs = [NSMutableArray arrayWithArray:[array valueForKey:@"strOffer_type"]];
		[arrIDs addObjectsFromArray:[offer_types componentsSeparatedByString:@","]];
		offer_types =[arrIDs componentsJoinedByString:@","];

	}
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:productIds,@"product_ids",productqtys,@"product_qtys",product_sku_ids,@"product_sku_ids",product_prices,@"product_prices",offer_types,@"offer_types", nil];
	return dict;
}
-(void)createDataForCheckout
{
	NSDictionary *getProductListDetails = [self getProductIdandProductQty];
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:strStore_Id forKey:kStore_id];
    [dict setObject:strSelectedUserAddress_Id forKey:kUser_address_id];
    
	[dict setObject:[getProductListDetails objectForKey:@"product_ids"] forKey:@"product_ids"];
    
	[dict setObject:[getProductListDetails objectForKey:@"product_sku_ids"] forKey:@"product_sku_ids"];
    
	[dict setObject:[getProductListDetails objectForKey:@"product_prices"] forKey:@"product_prices"];
	
	[dict setObject:[getProductListDetails objectForKey:@"product_qtys"] forKey:@"product_qtys"];
	
	[dict setObject:[getProductListDetails objectForKey:@"offer_types"] forKey:@"offer_types"];
	[dict setObject:@"1" forKey:@"payment_mode_id"];
    
//    UITableViewCell *cell = (UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];

//    UIButton *btnSlot = (UIButton *)[cell.contentView viewWithTag:302];
	
    if ([strDeliveryDate isEqualToString:@"Immediate" ]) {
        strDeliveryDate = [appDel getDateAndFromString:nil andDate:[NSDate date] needSting:YES dateFormat:DATE_FORMATTER_yyyy_mm_dd];
    }
    [dict setObject:strDeliveryDate forKey:@"delivery_date"];
    [dict setObject:strSelectSlot forKey:@"delivery_slot"];
    [dict setObject:strTotalPrice forKey:@"total_amount"];
    [dict setObject:total_discount forKey:@"total_discount"];
    [dict setObject:@"0" forKey:@"ip_address"];
	if(isCouponValid == 1)
	{
		[dict setObject:coupon_code forKey:@"coupon_code"];
	}
	[Utils stopActivityIndicatorInView:self.view];
	[Utils startActivityIndicatorInView:self.view withMessage:nil];
    [self performSelector:@selector(callWebServiceForCheckout:) withObject:dict afterDelay:0.1];
}
- (void)callWebServiceToCheckCouponValidation
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	if (![Utils isInternetAvailable])
	{
		btnPay.enabled = NO;
		[Utils stopActivityIndicatorInView:self.view];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	NSMutableDictionary *aDict = [Utils setPredefindValueForWebservice];
	[aDict setObject:coupon_code forKey:@"coupon_code"];
	[aDict setObject:strTotalPrice forKey:@"total_amount"];
	NSString *productIds = @"";
	NSString *productqtys = @"";
	NSPredicate *predicate =[NSPredicate predicateWithFormat:@"NOT (SELF.strOffer_type CONTAINS %@)",@"0"] ;
	NSArray *array = [arrSelectedProducts filteredArrayUsingPredicate:predicate];
	if([array count]>0)
	{
		NSArray *arrIDs = [array valueForKey:@"offer_id"];
		productIds = [arrIDs componentsJoinedByString:@","];
		arrIDs = [array valueForKey:@"strCount"];
		productqtys =[arrIDs componentsJoinedByString:@","];
	}
	predicate = [NSPredicate predicateWithFormat:@"SELF.strOffer_type == %@",@"0"];
	array = [arrSelectedProducts filteredArrayUsingPredicate:predicate];
	if([array count]>0)
	{
		NSMutableArray *arrIDs = [NSMutableArray arrayWithArray:[array valueForKey:@"product_id"]];
		[arrIDs addObjectsFromArray:[productIds componentsSeparatedByString:@","]];
		productIds = [arrIDs componentsJoinedByString:@","];
		
		arrIDs = [NSMutableArray arrayWithArray:[array valueForKey:@"strCount"]];
		[arrIDs addObjectsFromArray:[productqtys componentsSeparatedByString:@","]];
		productqtys =[arrIDs componentsJoinedByString:@","];
	}
	[aDict setObject:productIds forKey:@"product_ids"];
	[aDict setObject:productqtys forKey:@"product_qtys"];
	[aaramShop_ConnectionManager getDataForFunction:kURLValidateCoupons withInput:aDict withCurrentTask:TASK_VALIDATE_COUPON andDelegate:self ];
}

- (void)callWebServiceToGetMinOrderValue
{
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	if (![Utils isInternetAvailable])
	{
		btnPay.enabled = NO;
		[Utils stopActivityIndicatorInView:self.view];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	NSMutableDictionary *aDict = [Utils setPredefindValueForWebservice];
	[aDict setObject:strSelectedUserAddress_Id forKey:@"user_address_id"];
	[aDict setObject:self.strStore_Id forKey:kStore_id];
	[aaramShop_ConnectionManager getDataForFunction:kURLGetMinimumOrderValue withInput:aDict withCurrentTask:TASK_GET_MINIMUM_ORDER_VALUE andDelegate:self ];

}
-(void)callWebServiceForCheckout:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
		[Utils stopActivityIndicatorInView:self.view];
        btnPay.enabled = NO;
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kcheckoutURL withInput:aDict withCurrentTask:TASK_CHECKOUT andDelegate:self ];
    
}

-(void)createDataToGetDeliverySlots
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kUserId];
//    NSString *strDate = [appDel getDateAndFromString:nil andDate:datePicker.date needSting:YES dateFormat:DATE_FORMATTER_yyyy_mm_dd];
    [dict setObject:strDeliveryDate forKey:kDate];
    [self callWebServiceToGetDeliverySlots:dict];
}
-(void)callWebServiceToGetDeliverySlots:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
		[Utils stopActivityIndicatorInView:self.view];
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:KGetDeliverySlotURL withInput:aDict withCurrentTask:TASK_GET_DELIVERY_SLOTS andDelegate:self ];

}
-(void)createDataToGetPaymentPageData
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:strStore_Id forKey:kStore_id];
    [dict setObject:[NSString stringWithFormat:@"%f",appDel.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDel.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
	[dict setObject:self.strTotalPrice forKey:kTotal_amount];
	[Utils stopActivityIndicatorInView:self.view];
	[Utils startActivityIndicatorInView:self.view withMessage:nil];
	[self performSelector:@selector(callWebServiceToGetPaymentPageData:) withObject:dict afterDelay:0.1];
}
-(void)callWebServiceToGetPaymentPageData: (NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kGetPaymentPageDataURL withInput:aDict withCurrentTask:TASK_GET_PAYMENT_PAGE_DATA andDelegate:self ];
}
- (void)responseReceived:(id)responseObject
{
	[Utils stopActivityIndicatorInView:self.view];

    [AppManager stopStatusbarActivityIndicator];
    if(aaramShop_ConnectionManager.currentTask == TASK_GET_PAYMENT_PAGE_DATA)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
			delivery_charges =[NSString stringWithFormat:@"%d", [[responseObject objectForKey:kDelivery_charges]intValue]];
			strTotalPrice = [NSString stringWithFormat:@"%ld",(long)(([subTotal integerValue]-[total_discount integerValue])+[delivery_charges integerValue])];
            [self parsePaymentPageData:[responseObject objectForKey:@"payment_page_info"]];
        }
		else
		{
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}

    }
    else if(aaramShop_ConnectionManager.currentTask == TASK_GET_DELIVERY_SLOTS)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            NSLog(@"VALUE = %@",responseObject);
            [self parseGetDeliverySlots:responseObject];
        }
		else
		{
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}

    }
    else if(aaramShop_ConnectionManager.currentTask == TASK_CHECKOUT)
    {
        btnPay.enabled = YES;
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            [Utils showAlertViewWithTag:kTagForFeedBack title:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            
            
			[AppManager removeCartBasedOnStoreId:self.strStore_Id];

			gAppManager.intCount = 0;
			[AppManager saveCountOfProductsInCart:gAppManager.intCount];

        }
		else
		{
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}
    }
	else if (aaramShop_ConnectionManager.currentTask == TASK_GET_MINIMUM_ORDER_VALUE)
	{
		if([[responseObject objectForKey:kstatus]intValue]==1)
		{
			min_order_value =[responseObject objectForKey:@"minimum_order_value" ];
			if([strTotalPrice integerValue] < [[responseObject objectForKey:@"minimum_order_value" ] integerValue])
			{
				[self showPopupWithMessage:[NSString stringWithFormat:@"Minimum order value for this store is ₹%@. Please add more products.",[responseObject objectForKey:@"minimum_order_value" ]]];
			}
		}
		else
		{
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}

	}
	else if(aaramShop_ConnectionManager.currentTask == TASK_VALIDATE_COUPON)
	{
		if([[responseObject objectForKey:kstatus]intValue]==1)
		{
			isCouponValid = [[responseObject objectForKey:@"isValid"] integerValue];
			if(isCouponValid==0)
			{
				coupon_code = @"";
				tfCouponCode.text = @"";
				isCouponValid = -1;
				[tblView reloadData];
			}
			else
			{
				NSString *coupon_value = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"coupon_value"] ];
				total_discount = [NSString stringWithFormat:@"%ld",(long)([total_discount integerValue]+[coupon_value integerValue])];
				strTotalPrice = [NSString stringWithFormat:@"%ld",(long)(([subTotal integerValue]-[total_discount integerValue])+[delivery_charges integerValue])];

				NSRange range = NSMakeRange(0, 1);
				NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
				[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];

				NSLog(@"%@",responseObject);
			}
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}
	}
	else
	{
		[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
	}


}
-(void)parseGetDeliverySlots:(NSDictionary *)responseObject
{
    NSArray *arrDeliverySlotTemp = [responseObject objectForKey:@"delivery_slot"];
    [arrDeliverySlot removeAllObjects];
    for (NSDictionary *dictDeliverySlots in arrDeliverySlotTemp) {
        NSMutableDictionary *dictSlots = [[NSMutableDictionary alloc]init];
        [dictSlots setObject:[dictDeliverySlots objectForKey:@"slot"] forKey:@"slot"];
        [arrDeliverySlot addObject:dictSlots];
    }
	if([arrDeliverySlot count]>0)
	{
		strSelectSlot = [[arrDeliverySlot objectAtIndex:0] objectForKey:@"slot"];
	}
	else
	{
		strSelectSlot = @"Select slot";
	}
    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didFailWithError:(NSError *)error
{
	[Utils stopActivityIndicatorInView:self.view];
    btnPay.enabled = YES;
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
#pragma mark - Parsing Data
- (void)parsePaymentPageData:(NSDictionary *)data
{
    NSArray *arrDeliverySlotTemp = [data objectForKey:@"delivery_slot"];
    NSArray *arrLastMinPickTemp = [data objectForKey:@"last_minute_pick"];
    NSArray *arrAddressTemp = [data objectForKey:@"address"];
	NSString *popup_message = [data objectForKey:kPopup_message];
	[arrAddressData removeAllObjects];
	
	AddressModel *objAddressModel = [[AddressModel alloc]init];
	objAddressModel.user_address_id = @"0";
	objAddressModel.title = @"Add new address";
	objAddressModel.state = @"";
	objAddressModel.city = @"";
	objAddressModel.pincode = @"";
	objAddressModel.locality = @"";
	objAddressModel.address = @"";
	
	[arrAddressData addObject:objAddressModel];

    for (NSDictionary *dictAddress in arrAddressTemp) {

        AddressModel *objAddressModel = [[AddressModel alloc]init];
        objAddressModel.user_address_id = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kUser_address_id]];
        objAddressModel.title = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kUser_address_title]];
        objAddressModel.state = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kState]];
        objAddressModel.city = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kCity]];
        objAddressModel.pincode = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kPincode]];
        objAddressModel.locality = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kLocality]];
        objAddressModel.address = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kAddress]];
		

        [arrAddressData addObject:objAddressModel];
    }
	strDeliveryDate = [data objectForKey:@"delivery_date"];
    for (NSDictionary *dictDeliverySlots in arrDeliverySlotTemp) {
        NSMutableDictionary *dictSlots = [[NSMutableDictionary alloc]init];
        [dictSlots setObject:[dictDeliverySlots objectForKey:@"slot"] forKey:@"slot"];
        [arrDeliverySlot addObject:dictSlots];
    }
	if([arrDeliverySlot count]>0)
	{
		strSelectSlot = [[arrDeliverySlot objectAtIndex:0] objectForKey:@"slot"];
	}
    for (NSDictionary *dictProducts in arrLastMinPickTemp) {
        
        ProductsModel *objProducts = [[ProductsModel alloc]init];
        objProducts.product_id			= [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_id]];
        objProducts.product_image	= [NSString stringWithFormat:@"%@",[[dictProducts objectForKey:kProduct_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        objProducts.product_name		= [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_name]];
        objProducts.product_price		= [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_price]];
        objProducts.product_sku_id	= [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_sku_id]];
		objProducts.offer_price			=	[NSString stringWithFormat:@"%@",[dictProducts objectForKey:kOffer_price]];
		objProducts.offer_type			=	[NSString stringWithFormat:@"%d",[[dictProducts objectForKey:@"offer_type"] intValue]];
		objProducts.offer_id				=	[NSString stringWithFormat:@"%@",[dictProducts objectForKey:kOffer_id]];
		NSString *strId = @"0";
		if([objProducts.offer_type  integerValue]>0)
		{
			strId =	objProducts.offer_id;
		}
		else
		{
			strId = objProducts.product_id;
		}

		if(self.fromCart)
		{
			objProducts.strCount			=	[AppManager getCountOfProduct:strId withOfferType:objProducts.offer_type forStore_id:self.strStore_Id];
		}
		else
		{
			objProducts.strCount			= [self getCountOfProduct:strId withOfferType:objProducts.offer_type forStoreId:self.strStore_Id];
		}

        objProducts.isSelected = NO;
        [arrLastMinPick addObject:objProducts];
    }
	if([popup_message length]>0)
	{
		[self showPopupWithMessage:popup_message];
	}
    [tblView reloadData];
}
- (NSString *)getCountOfProduct:(NSString *)productOrOfferId withOfferType:(NSString *)offerType forStoreId:(NSString *)store_id
{
//	NSMutableArray *arrCartProduct	= [NSMutableArray arrayWithArray:[AppManager getCartProductsByStoreId:store_id]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF. cartProductId == %@ and SELF.strOffer_type == %@",productOrOfferId,offerType];
	NSArray *array	=	[arrSelectedProducts filteredArrayUsingPredicate:predicate];
	if([array count]>0)
	{
		return [[array objectAtIndex:0] strCount];
	}
	return @"0";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
-(void)setNavigationBar
{
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 150, 44);
    UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
    CGRect titleFrame = CGRectMake(0,0, 150, 44);
    UILabel* titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:kRobotoRegular size:15];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"Payment";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    UIImage *imgBack = [UIImage imageNamed:@"backBtn"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake( -10, 0, 30, 30);
    
    [backBtn setImage:imgBack forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
}
-(void)backBtn
{
    [self showOptionPatch:NO];
    [self showPickerView:NO];
    [pickerViewSlots removeFromSuperview];
    [datePicker removeFromSuperview];

	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return 130;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 78;
            break;
        case 3:
            return 87;
            break;
        case 4:
		{
			CGFloat rowHeight = 0.0;
				ProductsModel *objProductsModel = nil;
				objProductsModel = [arrLastMinPick objectAtIndex:indexPath.row];
				CGSize size= [Utils getLabelSizeByText:objProductsModel.product_name font:[UIFont fontWithName:kRobotoRegular size:14.0f] andConstraintWith:[UIScreen mainScreen].bounds.size.width-175];
				if (size.height<24) {
					rowHeight = 68.0;
				}
				else
					rowHeight = 44+size.height;
			
				return rowHeight;
		}
			break;
			
        default:
            return 0;
            break;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if(section ==4)
	{
		UIView *sectionView		=	[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
		UILabel *lblTitle				=	[[UILabel alloc]initWithFrame:CGRectMake(0, 10, [[UIScreen mainScreen] bounds].size.width, 34)];
		lblTitle.textColor			=	[UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0];
		lblTitle.font						=	[UIFont fontWithName:kRobotoBold size:14.0];
		lblTitle.text						=	@"  Last Minute Pick";
		lblTitle.backgroundColor	=	[UIColor whiteColor];
		lblTitle.textAlignment	=	NSTextAlignmentLeft;
		[sectionView addSubview:lblTitle];
		return sectionView;
	}
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
			return CGFLOAT_MIN;
			break;
        case 1:
			return CGFLOAT_MIN;
			break;
        case 2:
			return CGFLOAT_MIN;
			break;
        case 3:
			return CGFLOAT_MIN;
			break;
        case 4:
			return 44;
			break;
        default:
            return CGFLOAT_MIN;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section==4)
	{
		return arrLastMinPick.count;
	}
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellIdentifier = @"TotalPriceCell";
            
            TotalPriceTableCell *cell = [self createCellTotalPrice:cellIdentifier];
            cell.indexPath = indexPath;
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:strTotalPrice,kTotalPrice,subTotal,kSubTotalPrice,delivery_charges,kDeliveryCharges,total_discount,kDiscount, nil];
            tableCell = cell;
            [cell updateCellWithData:dict];
        }
            break;
        case 1:
        {
            
            static NSString *cellIdentifier = @"ApplyBtnCell";
            
            tableCell = [self createCell:cellIdentifier];
			tfCouponCode = (UITextField *)[tableCell.contentView viewWithTag:100];
			tfCouponCode.delegate = self;
            
            UIButton *applyCoupon = (UIButton *)[tableCell.contentView viewWithTag:101];
            [applyCoupon addTarget:self action:@selector(applyCouponClick) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case 2:
        {
            static NSString *cellIdentifier = @"DateTimeSlotCell";
            
            tableCell = [self createCell:cellIdentifier];
            
            UIButton *btnImmdediate = (UIButton *)[tableCell.contentView viewWithTag:301];
            
            UIButton *btnSlot = (UIButton *)[tableCell.contentView viewWithTag:302];
            
            [btnImmdediate setTitle:strDeliveryDate forState:UIControlStateNormal];
            
            [btnSlot setTitle:strSelectSlot forState:UIControlStateNormal];
            
            [btnSlot addTarget:self action:@selector(btnSlotClick) forControlEvents:UIControlEventTouchUpInside];
            
            [btnImmdediate addTarget:self action:@selector(btnImmdediateClick) forControlEvents:UIControlEventTouchUpInside];

        }
            break;
            
        case 3:
        {
            static NSString *cellIdentifier = @"AddressCell";
            
            tableCell = [self createCell:cellIdentifier];
            
            UIButton *btnTitle = (UIButton *)[tableCell.contentView viewWithTag:401];
            [btnTitle setTitle:strSelectAddress forState:UIControlStateNormal];
            [btnTitle addTarget:self action:@selector(btnSelectAddressClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 4:
        {
			static NSString *cellIdentifier = @"Cell";
			

			HomeSecondCustomCell *cell = (HomeSecondCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if (cell == nil) {
				cell = [[HomeSecondCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
				cell.delegate=self;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			ProductsModel *objProductsModel = nil;
			objProductsModel = [arrLastMinPick objectAtIndex:indexPath.row];
			cell.indexPath=indexPath;
			cell.store_id	=	self.strStore_Id;
			cell.fromCart	=	self.fromCart;
			cell.objProductsModelMain = objProductsModel;
			[cell updateCellWithSubCategory:objProductsModel];
			return cell;

			
//            static NSString *cellIdentifier = @"PickCollectionCell";
//            
//            UITableViewCell *cell = (UITableViewCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//
//            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
//            
//            UILabel *lblLastPick = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 21)];
//            lblLastPick.textColor = [UIColor blackColor];
//            lblLastPick.font = [UIFont fontWithName:kRobotoRegular size:13.0];
//            lblLastPick.text = @"Last minute pick";
//            [cell.contentView addSubview:lblLastPick];
//            
//            UICollectionViewFlowLayout *flowLayout1= [[UICollectionViewFlowLayout alloc] init];
//            flowLayout1.minimumLineSpacing = 0.0;
//            flowLayout1.minimumInteritemSpacing = 0.0f;
//            [flowLayout1  setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//            
//            UICollectionView *collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 22, [UIScreen mainScreen].bounds.size.width-20, 85) collectionViewLayout:flowLayout1];
//            collectionV.allowsSelection=YES;
//            collectionV.alwaysBounceHorizontal = YES;
//            [collectionV setDataSource:self];
//            [collectionV setDelegate:self];
//            
//            [collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:strCollectionItems];
//            collectionV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//            
//            collectionV.backgroundColor = [UIColor clearColor];
//            collectionV.pagingEnabled = YES;
//            [collectionV reloadData];
//            [cell.contentView addSubview:collectionV];
//            tableCell = cell;
//            
        }
            break;
        default:
            break;
    }
    return tableCell;
}
-(UITableViewCell*)createCell:(NSString*)cellIdentifier{
    UITableViewCell *cell = (UITableViewCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}
-(TotalPriceTableCell*)createCellTotalPrice:(NSString*)cellIdentifier{
    TotalPriceTableCell *cell = (TotalPriceTableCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TotalPriceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}
-(PickLastTableCell*)createCellPick:(NSString*)cellIdentifier{
    PickLastTableCell *cell = (PickLastTableCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PickLastTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - add or remove last minute pick

- (CartProductModel *)getCartProductFromOffer:(ProductsModel *)product
{
	CartProductModel *cart = [[CartProductModel alloc]init];
	cart.strOffer_type			= [NSString stringWithFormat:@"%d",[product.offer_type intValue]];
	cart.offer_price				=	product.offer_price;
	cart.offerTitle					=	product.product_name;
	cart.offer_id					=	product.offer_id;
	if([product.offer_type integerValue] >0)
	{
		cart.cartProductId		=	product.offer_id;
	}
	else
	{
		cart.cartProductId		=	product.product_id;
	}
	cart.strCount					=	product.strCount;
	cart.product_id				=	product.product_id;
	cart.product_sku_id		=	product.product_sku_id;
	cart.cartProductImage	= product.product_image;
	cart.product_name			=	product.product_name;
	cart.product_price			=	product.product_price;
	return cart;
}
- (void)modifyCartForShoppingListByData:(ProductsModel *)productModel
{
	NSString *strId = @"0";
	if([productModel.offer_type integerValue]>0)
	{
		strId = productModel.offer_id;
	}
	else
		strId = productModel.product_id;
	
	NSPredicate *predicate	= [NSPredicate predicateWithFormat:@"SELF.cartProductId == %@ and SELF.strOffer_type ==%@",strId,productModel.offer_type];
	NSArray *arrProduct		=	[arrSelectedProducts filteredArrayUsingPredicate:predicate];
	if([arrProduct count]>0)
	{
		NSInteger index = [arrSelectedProducts indexOfObject:[arrProduct objectAtIndex:0]];
		if ([productModel.strCount intValue]==0) {
			[arrSelectedProducts removeObject:[arrProduct objectAtIndex:0]];
		}
		else
		{
			[arrSelectedProducts replaceObjectAtIndex:index withObject:[self getCartProductFromOffer:productModel]];
		}
	}
	else
	{
		[arrSelectedProducts addObject:[self getCartProductFromOffer:productModel]];
	}
}
-(void)addedValueByPrice:(NSString *)strPrice atIndexPath:(NSIndexPath *)inIndexPath
{
	ProductsModel *objProductsModel = nil;
	objProductsModel = [arrLastMinPick objectAtIndex:inIndexPath.row];
	
	NSInteger discount = [total_discount integerValue];
	NSInteger sub_total = [subTotal integerValue];
	if([objProductsModel.offer_type intValue]>0)
	{
		discount += ([objProductsModel.product_price integerValue]-[objProductsModel.offer_price integerValue]);
		if([objProductsModel.offer_type intValue]== 6)
		{
			sub_total+=[objProductsModel.offer_price intValue];
		}
	}
	sub_total+=[objProductsModel.product_price intValue];
	
	subTotal = [NSString stringWithFormat:@"%ld",(long)sub_total];
	total_discount = [NSString stringWithFormat:@"%ld",(long)discount];
	strTotalPrice = [NSString stringWithFormat:@"%ld",(long)(([subTotal integerValue]-[total_discount integerValue])+[delivery_charges integerValue])];

	if(self.fromCart)
	{
		[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:objProductsModel] forStore:[NSDictionary dictionaryWithObjectsAndKeys:strStore_Id,kStore_id,self.strStore_name,kStore_name,self.strStore_image,kStore_image, nil] add:YES fromCart:NO];
		
		arrSelectedProducts		=	(NSMutableArray *)[AppManager getCartProductsByStoreId:strStore_Id];
		gAppManager.intCount++;
		[AppManager saveCountOfProductsInCart:gAppManager.intCount];

	}
	else
	{
		[self modifyCartForShoppingListByData:objProductsModel];
	}
	NSRange range = NSMakeRange(inIndexPath.section, 1);
	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
	range = NSMakeRange(0, 1);
	sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];

	//    [tblVwCategory reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	
}
-(void)minusValueByPrice:(NSString *)strPrice atIndexPath:(NSIndexPath *)inIndexPath
{
	ProductsModel *objProductsModel = nil;
	objProductsModel = [arrLastMinPick objectAtIndex:inIndexPath.row];
	
	NSInteger discount = [total_discount integerValue];
	NSInteger sub_total = [subTotal integerValue];
	if([objProductsModel.offer_type intValue]>0)
	{
		discount -= ([objProductsModel.product_price integerValue]-[objProductsModel.offer_price integerValue]);
		if([objProductsModel.offer_type intValue]== 6)
		{
			sub_total-=[objProductsModel.offer_price intValue];
		}
	}
	sub_total-=[objProductsModel.product_price intValue];
	
	subTotal = [NSString stringWithFormat:@"%ld",(long)sub_total];
	total_discount = [NSString stringWithFormat:@"%ld",(long)discount];
	strTotalPrice = [NSString stringWithFormat:@"%ld",(long)(([subTotal integerValue]-[total_discount integerValue])+[delivery_charges integerValue])];

	if(self.fromCart)
	{
		[AppManager AddOrRemoveFromCart:[self getCartProductFromOffer:objProductsModel] forStore:[NSDictionary dictionaryWithObjectsAndKeys:strStore_Id,kStore_id,self.strStore_name,kStore_name,self.strStore_image,kStore_image, nil] add:NO fromCart:NO];
		
		arrSelectedProducts = (NSMutableArray *)[AppManager getCartProductsByStoreId:strStore_Id];
		gAppManager.intCount--;
		[AppManager saveCountOfProductsInCart:gAppManager.intCount];

	}
	else
	{
		[self modifyCartForShoppingListByData:objProductsModel];
	}
	
	NSRange range = NSMakeRange(inIndexPath.section, 1);
	NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
	range = NSMakeRange(0, 1);
	sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
	[tblView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];

	
	
	//    [tblVwCategory reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
	[tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	
	
}

-(void)btnSelectAddressClick
{
    if ([arrAddressData count]==0)
    {
        [Utils showAlertView:kAlertTitle message:@"No address available." delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    isPickerOpen = YES;

    ePickerType = enPickerAddress;
    [self showDatePickerView:NO];
    [self showOptionPatch:YES];
    [self showPickerView:YES];
    [pickerViewSlots reloadAllComponents];
}
#pragma mark - UIPickerView Delegate

#pragma mark-


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsNum = 0;
    if (ePickerType == enPickerAddress) {
        rowsNum = arrAddressData.count;
    }
    else
        rowsNum = arrDeliverySlot.count;
    return rowsNum;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strTitle =@"";
    if (ePickerType == enPickerAddress) {
        
        AddressModel *objAddressModel = [arrAddressData objectAtIndex:row];
        strTitle =  objAddressModel.title;
    }
    else
    {
        NSDictionary *dict = [arrDeliverySlot objectAtIndex:row];
        strTitle = [dict objectForKey:@"slot"];
    }
    return strTitle;
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    [self setSlot];
}
-(void)setSlot
{
    if (ePickerType == enPickerAddress) {
        AddressModel *objaddressModel = [arrAddressData objectAtIndex:[pickerViewSlots selectedRowInComponent:0]];
		if([objaddressModel.user_address_id integerValue]==0)
		{
//			locationAlert =  [self.storyboard instantiateViewControllerWithIdentifier :@"LocationAlertScreen"];
//			locationAlert.delegate = self;
//			CGRect locationAlertViewRect = [UIScreen mainScreen].bounds;
//			locationAlert.view.frame = locationAlertViewRect;
//			[[UIApplication sharedApplication].keyWindow addSubview:locationAlert.view];
			LocationEnterViewController *locationScreen = (LocationEnterViewController*) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationEnterScreen"];
			locationScreen.delegate							= self;
			locationScreen.addAddressCompletion	= ^(void)
			{
				self.navigationController.navigationBarHidden = NO;
			};
			
			[self.navigationController pushViewController:locationScreen animated:YES];
		}
		else
		{
			UITableViewCell *cell = (UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
			
			UIButton *btnTitle = (UIButton *)[cell.contentView viewWithTag:401];

			strSelectAddress = objaddressModel.address;
			[btnTitle setTitle:strSelectAddress forState:UIControlStateNormal];
			strSelectedUserAddress_Id = objaddressModel.user_address_id;
			[Utils stopActivityIndicatorInView:self.view];
			[Utils startActivityIndicatorInView:self.view withMessage:nil];
			[self performSelector:@selector(callWebServiceToGetMinOrderValue) withObject:nil afterDelay:0.2];
		}
    }
    else
    {
        NSDictionary *dict = [arrDeliverySlot objectAtIndex:[pickerViewSlots selectedRowInComponent:0]];
        UITableViewCell *cell = (UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        UIButton *btnSlot = (UIButton *)[cell.contentView viewWithTag:302];
        strSelectSlot = [dict objectForKey:@"slot"];
        [btnSlot setTitle:strSelectSlot forState:UIControlStateNormal];
    }
}

#pragma mark -- Location alert Delegate Method

-(void)saveAddressInLocationEnter
{
	[self createDataToGetPaymentPageData];
}
#pragma mark - CollectionView Delegates & DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrLastMinPick.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeCell=CGSizeZero;
    sizeCell=CGSizeMake(([UIScreen mainScreen].bounds.size.width)/3-2, 85);
    return sizeCell;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell ;
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:strCollectionItems forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    
    ProductsModel *objProductModel =[arrLastMinPick objectAtIndex:indexPath.row];
    
    UIImageView *imgProfilePic = [[UIImageView alloc]initWithFrame:CGRectMake( ((([UIScreen mainScreen].bounds.size.width)/3-2)-56)/2, 3, 56, 56)];
    imgProfilePic.backgroundColor = [UIColor clearColor];
    
    
    UILabel *lblPrice				=	[[UILabel alloc]initWithFrame:CGRectMake(1, 58, 50, 21)];
    lblPrice.textColor				=	[UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0];
    lblPrice.textAlignment		=	NSTextAlignmentCenter;
    lblPrice.font						=	[UIFont fontWithName:kRobotoRegular size:11.0];
    lblPrice.text						=	[NSString stringWithFormat:@"₹%@",objProductModel.product_price];
	
	UILabel *lblLine					=	[[UILabel alloc]initWithFrame:CGRectMake(5, 67.5, 42, 1)];
	lblLine.backgroundColor	=	[UIColor blackColor];
	lblLine.textAlignment			=	NSTextAlignmentCenter;

	
	UILabel *lblOfferPrice			=	[[UILabel alloc]initWithFrame:CGRectMake(52, 58, 50, 21)];
	lblOfferPrice.textColor			=	[UIColor redColor];
	lblOfferPrice.textAlignment	=	NSTextAlignmentCenter;
	lblOfferPrice.font					=	[UIFont fontWithName:kRobotoRegular size:11.0];
	lblOfferPrice.text					=	[NSString stringWithFormat:@"₹%@",objProductModel.offer_price];

	
    [imgProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objProductModel.product_image]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];
    
    
    [cell.contentView addSubview:imgProfilePic];
    [cell.contentView addSubview:lblPrice];
	[cell.contentView addSubview:lblLine];
	[cell.contentView addSubview:lblOfferPrice];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ProductsModel *objProduct = [arrLastMinPick objectAtIndex:indexPath.row];
    objProduct.isSelected = !objProduct.isSelected;
    
    if (objProduct.isSelected) {
        objProduct.strCount = [NSString stringWithFormat:@"1"];
        int selectedPrice =  1 * [objProduct.product_price intValue];
        
        int priceValue = [strTotalPrice intValue];
        priceValue+=selectedPrice;
        strTotalPrice = [NSString stringWithFormat:@"%d",priceValue];

        [arrSelectedLastMinPick addObject:objProduct];
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (objProduct.isSelected == NO)
    {
        int selectedPrice =  1 * [objProduct.product_price intValue];

        int priceValue = [strTotalPrice intValue];
        priceValue-=selectedPrice;
        strTotalPrice = [NSString stringWithFormat:@"%d",priceValue];
        [arrSelectedLastMinPick removeObject:objProduct];
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}



#pragma mark - Button Actions

-(void)applyCouponClick
{
	[tfCouponCode resignFirstResponder];
    if([coupon_code length]>0)
	{
		[Utils stopActivityIndicatorInView:self.view];
		[Utils startActivityIndicatorInView:self.view withMessage:nil];
		[self performSelector:@selector(callWebServiceToCheckCouponValidation) withObject:nil afterDelay:0.1];
	}
	else
	{
		[Utils showAlertView:kAlertTitle message:@"Please enter coupon code" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
	}
}
-(void)btnImmdediateClick
{
    [self showOptionPatch:YES];
    [self showDatePickerView:YES];
}
-(void)btnSlotClick
{
//    if ([arrAddressData count]==0)
//    {
//        [Utils showAlertView:kAlertTitle message:@"No address available." delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//        return;
//    }
    
    isPickerOpen = YES;
    ePickerType = enPickerSlots;
    [self showPickerView:YES];
    [self showOptionPatch:YES];
    [pickerViewSlots reloadAllComponents];
}
- (IBAction)btnPayClick:(UIButton *)sender {
    
    btnPay.enabled = NO;
    if ([strSelectSlot isEqualToString:@"Select Slot"]) {
        btnPay.enabled = YES;

        [Utils showAlertView:kAlertTitle message:@"Please select Slot" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else if([strSelectAddress isEqualToString:@"Select Address"])
    {
        btnPay.enabled = YES;

        [Utils showAlertView:kAlertTitle message:@"Please select Address For Delivery" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];

    }
	else if ([strTotalPrice integerValue]<[min_order_value integerValue])
	{
		btnPay.enabled = YES;

		[Utils showAlertView:kAlertTitle message:[NSString stringWithFormat:@"Minimum order value for this store is ₹%@. Please add more products.",min_order_value] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
	}
	else if([coupon_code length]>0 && isCouponValid == -1)
	{
		[Utils showAlertView:kAlertTitle message:@"Please check coupon validity" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
	}
    else
	{
		[Utils stopActivityIndicatorInView:self.view];
		[Utils startActivityIndicatorInView:self.view withMessage:nil];
		[self performSelector:@selector(createDataForCheckout) withObject:nil afterDelay:0.1 ];
	}
}

-(void)designToolBar
{
    if (keyBoardToolBar==nil)
    {
        keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 630 , [UIScreen mainScreen].bounds.size.width, 44)];
        keyBoardToolBar.backgroundColor = [UIColor clearColor];
        
        UIBarButtonItem *tempDistance = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarBtnClicked:)];
        btnDone.tintColor = [UIColor blueColor];
        btnDone.tag = kBtnDone;
        
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarBtnClicked:)];
        btnCancel.tintColor = [UIColor blueColor];
        btnCancel.tag = kBtnCancel;

        keyBoardToolBar.items = [NSArray arrayWithObjects:btnCancel,tempDistance,btnDone, nil];
    }
    else
    {
        [keyBoardToolBar removeFromSuperview];
    }
    
    [self.view addSubview:keyBoardToolBar];
    [self.view bringSubviewToFront:keyBoardToolBar];
}

-(void)toolBarBtnClicked:(UIBarButtonItem*)sender
{
    switch (sender.tag) {
        case kBtnCancel:
            [self showOptionPatch:NO];
            [self showDatePickerView:NO];
            [self showPickerView:NO];

            break;
        case kBtnDone:
        {
            UITableViewCell *cell = (UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            UIButton *btnImmdediate = (UIButton *)[cell.contentView viewWithTag:301];
			if(!isPickerOpen)
			{
				strDeliveryDate = [appDel getDateAndFromString:nil andDate:datePicker.date needSting:YES dateFormat:DATE_FORMATTER_yyyy_mm_dd];
				[btnImmdediate setTitle:strDeliveryDate forState:UIControlStateNormal];
			}
            [self showOptionPatch:NO];
            [self showDatePickerView:NO];

            if (isPickerOpen) {
				[self showPickerView:NO];
                [self setSlot];
				
            }
            else
            {
                if (![datePicker.date isEqualToDate:[NSDate date]]) {
					[Utils stopActivityIndicatorInView:self.view];
					[Utils startActivityIndicatorInView:self.view withMessage:nil];
                    [self performSelector:@selector(createDataToGetDeliverySlots) withObject:nil afterDelay:0.1];
                }

            }
        }
            break;
    
        default:
            break;
    }
}
-(void)showOptionPatch:(BOOL)isShow
{
    if(isShow)
    {
		[tfCouponCode resignFirstResponder];
        [UIView animateWithDuration:0.29 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
         {
             keyBoardToolBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-216-44,[UIScreen mainScreen].bounds.size.width, 44 );
			 [self.view bringSubviewToFront:keyBoardToolBar];
             
         }completion:nil];
        
    }
    else{
        [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
         {
             keyBoardToolBar.frame = CGRectMake(0, 1000, [UIScreen mainScreen].bounds.size.width, 40);
         }
         
                         completion:nil];
    }
}
#pragma mark Show and Hide Picker View

-(void)showDatePickerView:(BOOL)isShow
{
    if(isShow)
    {
		[tfCouponCode resignFirstResponder];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            datePicker.frame = CGRectMake(0,[[UIScreen mainScreen]bounds].size.height-216, [[UIScreen mainScreen]bounds].size.width, 216);
        } completion:nil];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             datePicker.frame = CGRectMake(0, [[UIScreen mainScreen]bounds].size.height+216, [[UIScreen mainScreen]bounds].size.width,216);
                         }
                         completion:nil];
    }
}


-(void)showPickerView:(BOOL)isShow
{
    if(isShow)
    {
		[tfCouponCode resignFirstResponder];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            pickerViewSlots.frame = CGRectMake(0,[[UIScreen mainScreen]bounds].size.height-216, [[UIScreen mainScreen]bounds].size.width, 216);
        } completion:nil];
        
    }
    else
    {
        isPickerOpen = NO;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             pickerViewSlots.frame = CGRectMake(0, [[UIScreen mainScreen]bounds].size.height+216, [[UIScreen mainScreen]bounds].size.width,216);
                         }
                         completion:nil];
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showPopupWithMessage:(NSString *)message
{
	tblView.userInteractionEnabled = NO;
	viewOverallValueStatus.hidden = NO;
	lblOverallValueStatus.text = message;
}
- (IBAction)btnCrossClicked:(id)sender {
	tblView.userInteractionEnabled = YES;
	viewOverallValueStatus.hidden = YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self showOptionPatch:NO];
	[self showDatePickerView:NO];
	[self showPickerView:NO];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[tfCouponCode resignFirstResponder];
	return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	coupon_code = textField.text;
	return YES;
}



#pragma mark - Feedback screen

-(void)openFeedbackScreen
{
	[tblView setUserInteractionEnabled:NO];
    feedBack = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
    
    feedBack.strStore_Id = strStore_Id;
    feedBack.strStore_name = _strStore_name;
    feedBack.strStore_image = _strStore_image;
    
    CGRect customFeedbackViewRect = [[UIScreen mainScreen] bounds];

    feedBack.view.frame = customFeedbackViewRect;
	
    __weak typeof(self) weakSelf = self;
    __weak UITableView *tempTableView = tblView;
    __weak AppDelegate *tempAppDel = appDel;
    
    feedBack.feedbackCompletion = ^(void)
    {
		tempTableView.userInteractionEnabled=YES;
		if([weakSelf.tabBarController isEqual:tempAppDel.tabBarControllerRetailer])
		{
			if(weakSelf.fromCart)
			{
				[tempAppDel removeTabBarRetailer];
			}
			else
			{
				[weakSelf.navigationController popToRootViewControllerAnimated:YES];
			}
		}
		else
		{
			[weakSelf.navigationController popToRootViewControllerAnimated:YES];
		}
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:feedBack.view];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kTagForFeedBack)
    {
        [self performSelector:@selector(openFeedbackScreen) withObject:nil afterDelay:0.5];

    }
}


@end
