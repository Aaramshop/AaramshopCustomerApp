//
//  OrderHistDetailViewCon.m
//  AaramShop
//
//  Created by Arbab Khan on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OrderHistDetailViewCon.h"

@interface OrderHistDetailViewCon ()

@end

@implementation OrderHistDetailViewCon

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setUpNavigationBar];
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate = self;
	
	strRupee = @"\u20B9";
	
//	lblCustomerName.text = _orderHist.customer_name;
	imgCustomer.layer.cornerRadius = imgCustomer.frame.size.width/2;
	imgCustomer.layer.masksToBounds=YES;
	
//	[imgCustomer sd_setImageWithURL:[NSURL URLWithString:_orderHist.customer_image] placeholderImage:[UIImage imageNamed:@"defaultProfilePic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
	
//	}];
//	lblOrder_time.text = _orderHist.order_time;
//	lblOrderDate.text = _orderHist.order_date;
//	lblTimeSlot.text = _orderHist.order_timeslot;
//	lblPaymentMode.text = _orderHist.payment_mode;
//	lblDeliveryBoyName.text = _orderHist.deliveryboy_name;
//	lblOrderAmt.text = [NSString stringWithFormat:@"%@ %@",strRupee,_orderHist.total_cart_value];
//	lblUdhaar_value.text = [NSString stringWithFormat:@"%@ %@",strRupee,_orderHist.udhaar_value];
//	lblTotalUdhaar.text = [NSString stringWithFormat:@"%@ %@",strRupee,_orderHist.total_udhaar];
//	if ([_orderHist.packed_timing isEqualToString:@"05:30 AM"] || [_orderHist.packed_timing isEqualToString:@"0"]) {
//		[packedBtn setSelected:NO];
//	}
//	else
//	{
//		[packedBtn setSelected:YES];
//		orderStatusButton = eSelectedType1;
//		lblPackedTime.text = _orderHist.packed_timing;
//	}
//	if ([_orderHist.dispatched_timing isEqualToString:@"05:30 AM"] || [_orderHist.dispatched_timing isEqualToString:@"0"])
//	{
//		[dispatchedBtn setSelected:NO];
//	}
//	else
//	{
//		[dispatchedBtn setSelected:YES];
//		orderStatusButton = eSelectedType2;
//		lblDispachedTime.text = _orderHist.dispatched_timing;
//		//		lblPackedTime.text = _orderHist.packed_timing;
//		
//		//        lblDispachedTime.text = [Utils stringFromDateForExactTime:[NSDate dateWithTimeIntervalSince1970:[_orderHist.dispatched_timing doubleValue]]];
//		
//	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
-(void)setUpNavigationBar
{
	
	CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 190, 44);
	UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
	_headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
	_headerTitleSubtitleView.autoresizesSubviews = NO;
	
	CGRect titleFrame = CGRectMake(0,0, 190, 44);
	UILabel* titleView = [[UILabel alloc] initWithFrame:titleFrame];
	titleView.backgroundColor = [UIColor clearColor];
	titleView.font = [UIFont fontWithName:kRobotoRegular size:15];
	titleView.textAlignment = NSTextAlignmentCenter;
	titleView.textColor = [UIColor whiteColor];
	titleView.text = @"Order Detail";
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
	[self.navigationController popViewControllerAnimated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)btnReceived:(id)sender {
}

- (IBAction)btnCallCustomer:(id)sender
{
//	strCust_Mobile = _orderHist.customer_mobile;
	NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",strCust_Mobile]];
	
	if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
		[[UIApplication sharedApplication] openURL:phoneUrl];
	} else
	{
		[Utils showAlertView:kAlertTitle message:kAlertCallFacilityNotAvailable delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
	}
}
- (IBAction)btnChatWithCustomer:(id)sender
{
	
}

-(void)sendCurrentTime
{
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kStore_id] forKey:kStore_id];
//	[dict setObject:_orderHist.order_id forKey:kOrder_id];
	
//	if ([strOrderStatus isEqualToString:@"1"]) {
//		
//		[dict setObject:_orderHist.packed_timing forKey:kDatetime];
//		[dict setObject:strOrderStatus forKey:kOrder_status];
//		
//	}
//	else if([strOrderStatus isEqualToString:@"2"])
//	{
//		[dict setObject:strOrderStatus forKey:kOrder_status];
//		[dict setObject:_orderHist.dispatched_timing forKey:kDatetime];
//	}
	
	[self callWebServiceToSendOrderStatus:dict];
	
}
- (void)callWebServiceToSendOrderStatus:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		//        [Utils stopActivityIndicatorInView:self.view];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		//        [submitBtn setEnabled:YES];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLSentOrderStatus withInput:aDict withCurrentTask:TASK_TO_SEND_ORDER_STATUS andDelegate:self];
}
- (void)responseReceived:(id)responseObject
{
	//    [Utils stopActivityIndicatorInView:self.view];
	//    [submitBtn setEnabled:YES];
	[AppManager stopStatusbarActivityIndicator];
	if(aaramShop_ConnectionManager.currentTask == TASK_TO_SEND_ORDER_STATUS)
	{
		if([[responseObject objectForKey:kstatus] intValue] == 1)
		{
			
			
		}
		
	}
}
- (void)didFailWithError:(NSError *)error
{
	//    [Utils stopActivityIndicatorInView:self.view];
	//    [submitBtn setEnabled:YES];
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}

#pragma mark - custom method for button state
-(void)setSideBtnState:(enBtnSelectedType)inSelectedState
{
	switch (inSelectedState)
	{
		case eSelectedTypeNone:
		{
			[packedBtn setSelected: NO];
			[dispatchedBtn setSelected:NO];
		}
			break;
			
		case eSelectedType1:
		{
			
			[packedBtn setSelected: YES];
			[dispatchedBtn setSelected:NO];
		}
			break;
		case eSelectedType2:
		{
			[packedBtn setSelected: YES];
			[dispatchedBtn setSelected:YES];
		}
			break;
		default:
			break;
	}
}

- (NSString *) getTimeStamp
{
	return [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970] ];
}

@end
