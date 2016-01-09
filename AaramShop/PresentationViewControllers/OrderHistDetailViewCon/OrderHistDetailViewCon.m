//
//  OrderHistDetailViewCon.m
//  AaramShop
//
//  Created by Arbab Khan on 13/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OrderHistDetailViewCon.h"
#import "OrderedProductsDetailViewController.h"

@interface OrderHistDetailViewCon ()

@end

@implementation OrderHistDetailViewCon

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self setUpNavigationBar];
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate = self;
    
    [self updateBtnFrames];
//    self.automaticallyAdjustsScrollViewInsets = NO;
	


    
	
	strRupee =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kCurrencySymbol]];
	
	lblCustomerName.text = _orderHist.store_name;
	imgCustomer.layer.cornerRadius = imgCustomer.frame.size.width/2;
	imgCustomer.layer.masksToBounds=YES;
	
	[imgCustomer sd_setImageWithURL:[NSURL URLWithString:_orderHist.store_image] placeholderImage:[UIImage imageNamed:@"defaultProfilePic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		
	}];
	lblOrder_time.text = _orderHist.order_time;
	lblOrderDate.text = _orderHist.order_date;
	lblTimeSlot.text = _orderHist.delivery_slot;
	lblPaymentMode.text = _orderHist.payment_mode;
	lblOrderAmt.text = [NSString stringWithFormat:@"%@ %@",strRupee,_orderHist.total_cart_value];
	if ([_orderHist.packed_timing isEqualToString:@""]) {
		[packedBtn setSelected:NO];
		
	}
	else
	{
		[packedBtn setSelected:YES];
		orderStatusButton = eSelectedType1;
		lblPackedTime.text = _orderHist.packed_timing;
		
	}
	if ([_orderHist.dispached_timing isEqualToString:@""])
	{
		[dispatchedBtn setSelected:NO];
	}
	else
	{
		[dispatchedBtn setSelected:YES];
		orderStatusButton = eSelectedType2;
		lblDispachedTime.text = _orderHist.dispached_timing;
	}
	if ([_orderHist.delivered_timing isEqualToString:@""])
	{
		[imgReceived setHidden:YES];
		[lblReceived setHidden:YES];
		[btnCompleted setHidden:YES];
	}
	else
	{
		[imgReceived setHidden:NO];
		[lblReceived setHidden:NO];
		[btnCompleted setHidden:NO];
		lblReceived.text = [NSString stringWithFormat:@"%@",_orderHist.delivered_timing];
		
	}

    
    if ([_orderHist.deliveryboy_name length]>0)
    {
        lblDeliveryBoyName.text = _orderHist.deliveryboy_name;
        btnCallDeliveryBoy.hidden = NO;
    }
    else
    {
        lblDeliveryBoyName.text = @"Pending";
        btnCallDeliveryBoy.hidden = YES;
    }
    

    
    lblUdhaar_value.text = [NSString stringWithFormat:@"%@ %@",strRupee,_orderHist.udhaar_value];
    lblTotalUdhaar.text = [NSString stringWithFormat:@"%@ %@",strRupee,_orderHist.total_udhaar];


	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"OrderHistoryDetail"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
//	[self updateBtnFrames];
	if([[UIScreen mainScreen] bounds].size.height==480)
	{
//		//		scrollview.translatesAutoresizingMaskIntoConstraints = YES;
//		//		scrollview.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
		[scrollview setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 600)];
//
	}
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

- (IBAction)btnReceived:(id)sender {
	if ([lblDispachedTime.text length]!=0) {
		[sender setEnabled:NO];
		[imgReceived setHidden:NO];
		[btnCompleted setHidden:NO];
		[lblReceived setHidden:NO];
		NSDate *dateCurrent = [NSDate date];
		lblReceived.text = [NSString stringWithFormat:@"%@",[Utils stringFromDateForExactTime:dateCurrent]];
		_orderHist.delivered_timing = [self getTimeStamp];
		[self sendCurrentTime];
	}
}

- (IBAction)btnCallMerchant:(id)sender
{
	strCust_Mobile = _orderHist.store_mobile;
	NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",strCust_Mobile]];
	
	if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
		[[UIApplication sharedApplication] openURL:phoneUrl];
	} else
	{
		[Utils showAlertView:kAlertTitle message:kAlertCallFacilityNotAvailable delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
	}
}
- (IBAction)btnChatWithMerchant:(id)sender
{
	AppDelegate *deleg = APP_DELEGATE;
	SMChatViewController *chatView = nil;
	chatView = [deleg createChatViewByChatUserNameIfNeeded:_orderHist.store_chatUserName];
	chatView.chatWithUser = [NSString stringWithFormat:@"%@@%@",_orderHist.store_chatUserName,STRChatServerURL];
	chatView.friendNameId = _orderHist.store_id;
	chatView.imageString = _orderHist.store_image;
	chatView.userName = _orderHist.store_name;
	chatView.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:chatView animated:YES];
}

-(void)sendCurrentTime
{
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	[dict setObject:_orderHist.order_id forKey:kOrder_id];
	[dict setObject:_orderHist.delivered_timing forKey:kDatetime];
	[self callWebServiceToSendOrderStatus:dict];
}
- (void)callWebServiceToSendOrderStatus:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
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



- (NSString *) getTimeStamp
{
	return [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970] ];
}




- (IBAction)btnSeeMoreDetails:(id)sender {

    OrderedProductsDetailViewController *orderedProducts =[self.storyboard instantiateViewControllerWithIdentifier:@"OrderedProductsDetail"];
    orderedProducts.orderHist =self.orderHist;
    [self.navigationController pushViewController:orderedProducts animated:YES];
    
}



- (IBAction)btnCallDeliveryBoy:(id)sender
{
//	[self btnSeeMoreDetails:sender];
    strDeliveryboy_mobile = _orderHist.deliveryboy_mobile;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",strDeliveryboy_mobile]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        [Utils showAlertView:kAlertTitle message:kAlertCallFacilityNotAvailable delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
}

- (void)updateBtnFrames
{
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = packedBtn.imageView.image.size;
    packedBtn.titleEdgeInsets = UIEdgeInsetsMake(
                                                    0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [packedBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: packedBtn.titleLabel.font}];
    packedBtn.imageEdgeInsets = UIEdgeInsetsMake(
                                                    - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
//    [packedBtn setFrame: CGRectMake( 25 ,0 , (screenWitdth-60)/2, 80)];
    
    
    
    
    
    CGSize imageSizeDist = dispatchedBtn.imageView.image.size;
    dispatchedBtn.titleEdgeInsets = UIEdgeInsetsMake(
                                                 0.0, - imageSizeDist.width, - (imageSizeDist.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSizeDist = [dispatchedBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: dispatchedBtn.titleLabel.font}];
    dispatchedBtn.imageEdgeInsets = UIEdgeInsetsMake(
                                                 - (titleSizeDist.height + spacing), 0.0, 0.0, - titleSizeDist.width);
    
    
    
    
    
    
    
    
    CGSize imageSizeRec = receivedBtn.imageView.image.size;
    receivedBtn.titleEdgeInsets = UIEdgeInsetsMake(
                                                 0.0, - imageSizeRec.width, - (imageSizeRec.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSizeRec = [receivedBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: receivedBtn.titleLabel.font}];
    receivedBtn.imageEdgeInsets = UIEdgeInsetsMake(
                                                 - (titleSizeRec.height + spacing), 0.0, 0.0, - titleSizeRec.width);
    
    
    
}

@end
