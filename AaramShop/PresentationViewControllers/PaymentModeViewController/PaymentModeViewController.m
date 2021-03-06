//
//  PaymentModeViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 24/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PaymentModeViewController.h"
#import "ProductsModel.h"
#import "AddressModel.h"
#import "MoEngage.h"
#import "OrderHistDetailViewCon.h"
#define kTagForFeedBack 100
#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]


@interface PaymentModeViewController ()
{
	CMPaymentMode *cmPaymentMode;
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
    NSString *actual_total_discount;
    NSString *actual_subTotal;
    NSString *coupon_value;
    NSMutableArray *arr_overall_value_offers;
	NSString *timeStampString;
}
@end

@implementation PaymentModeViewController
@synthesize feedBack;
@synthesize strStore_Id;
@synthesize btnBack;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;
    [self setUpNavigationBar];
    [tblView reloadData];
    arrAddressData = [[NSMutableArray alloc] init];
    arrDeliverySlot = [[NSMutableArray alloc]init];
    arrLastMinPick = [[NSMutableArray alloc]init];
    _dict=self.cmPayment.pamentDataDic;
	[[UIApplication sharedApplication] setStatusBarHidden:YES];

    webView.hidden=YES;
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"PaymentMode"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
     webView.delegate = self;
	btnBack.hidden=YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
	cmPaymentMode = [[CMPaymentMode alloc]init];
    [self getPaymentModes];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [Utils stopActivityIndicatorInView:self.view];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
	[Utils stopActivityIndicatorInView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setUpNavigationBar
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
    titleView.text = @"Accepted Payment Mode";
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
        return arrPaymentMode.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    else
        return CGFLOAT_MIN;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 48)];
//    //UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(16, (secView.frame.size.height - 21)/2, [[UIScreen mainScreen] bounds].size.width - 32, 21)];
//   // lblName.text = @"Choose Payment mode";
//    
//  //  [secView addSubview:lblName];
//    return secView;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    switch (indexPath.section) {
        case 0:
        {
        
            static NSString *cellIdentifier = @"AmountCell";
            TotalAmtTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            _dict=_cmPayment.pamentDataDic;

            if (cell == nil) {
                cell = [[TotalAmtTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.indexPath = indexPath;
            [cell updateCellWithData:_dict];
            
            tableCell = cell;
        }
            break;
            case 1:
        {
            static NSString *cellIdentifier = @"PaymentCell";
            PaymentModeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [[PaymentModeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		  }
	    cell.indexPath = indexPath;

	    
	CMPaymentMode *cmPaymentloc = [arrPaymentMode objectAtIndex:indexPath.row];
	    if ([cmPaymentloc.mode_id integerValue]!=[cmPaymentMode.mode_id integerValue]) {
		    cell.accessoryType=UITableViewCellAccessoryNone;
	    }
	    else
		   {
		    cell.accessoryType=UITableViewCellAccessoryCheckmark;
		   }
	    [cell updatePaymentModeCell:cmPaymentloc];
	    
	    tableCell = cell;
  

        }
            break;
            
        default:
            break;
    }
    return tableCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	cmPaymentMode=[arrPaymentMode objectAtIndex:indexPath.row];
	cmPaymentMode.isChecked=!cmPaymentMode.isChecked;
	
	
	
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	_indexPath=indexPath;

	[tblView reloadData];
    }


#pragma mark - Web service Methods
- (void)getPaymentModes
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	NSString *storeId = [_dict objectForKey:kStore_id];
[dict setObject:storeId forKey:kStore_id];
  //  [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kStore_id] forKey:kStore_id];
       //[dict setObject:strStore_Id. forKey:kStore_id];
    
    [self performSelector:@selector(callWebServiceToGetPaymentMode:) withObject:dict afterDelay:0.1];
}
-(void)callWebServiceToGetPaymentMode:(NSMutableDictionary *)aDic
{
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kPaymentModeByStoreId withInput:aDic withCurrentTask:TASK_USER_PAYMENTMODE andDelegate:self ];
}
- (void)responseReceived:(id)responseObject
{

    [Utils stopActivityIndicatorInView:self.view];
    
    [AppManager stopStatusbarActivityIndicator];
//    if(aaramShop_ConnectionManager.currentTask == TASK_USER_PAYMENTMODE)
//    {
//        if([[responseObject objectForKey:kstatus] intValue] == 1)
//        {
//            [self parseData:[responseObject objectForKey:kPayment_modes]];
//            [Utils showAlertViewWithTag:kTagForFeedBack title:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//            
//            
//            [AppManager removeCartBasedOnStoreId:self.strStore_Id];
//            
//            gAppManager.intCount = 0;
//            [AppManager saveCountOfProductsInCart:gAppManager.intCount];
//        }
//    }
switch (aaramShop_ConnectionManager.currentTask) {
case TASK_CHECKOUT:
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            [Utils showAlertViewWithTag:kTagForFeedBack title:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            
            
            [AppManager removeCartBasedOnStoreId:self.strStore_Id];
            
            gAppManager.intCount = 0;
            [AppManager saveCountOfProductsInCart:gAppManager.intCount];
            [Utils stopActivityIndicatorInView:self.view];

        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
           break;
    }
        case TASK_USER_PAYMENTMODE:
    {
                if([[responseObject objectForKey:kstatus] intValue] == 1)
                {
                    [self parseData:[responseObject objectForKey:kPayment_modes]];
                    
                }
    }
    break;
 case TASK_JIOMONEY_ORDERCOMPLETE:
    {
	if([[responseObject objectForKey:kstatus] intValue] == 1|| [[responseObject objectForKey:kstatus] intValue] ==0)
	    {
		if ([[responseObject objectForKey:@"order_payment_status"] isEqual:@"1"]) {
			[AppManager removeCartBasedOnStoreId:self.strStore_Id];
      //  [Utils showAlertViewWithTag:kTagForFeedBack title:kAlertTitle message:nil  delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
			[self openFeedbackScreen];
			gAppManager.intCount = 0;
			[AppManager saveCountOfProductsInCart:gAppManager.intCount];
//			OrderHistDetailViewCon *orderHistory = (OrderHistDetailViewCon *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"orderHistViewController"];
//			
//			
//			[self.navigationController pushViewController:orderHistory animated:YES];
	//		[Utils stopActivityIndicatorInView:self.view];

		}else{
//			webView.hidden=YES;
//			btnBack.hidden=YES;
//			btnBack.userInteractionEnabled=NO;
//
			
          [[self navigationController] setNavigationBarHidden:NO animated:NO];
			//This for loop iterates through all the view controllers in navigation stack.
			for (UIViewController *controller in [self.navigationController viewControllers])
			    {
    if ([controller isKindOfClass:[CartViewController class]])
    {
	[self.navigationController popToViewController:controller animated:YES];
	break;
    }
	 }

	 }
		

		
	
		[Utils stopActivityIndicatorInView:self.view];
	    }
    }
default:
//    [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    break;
}

}
- (void)didFailWithError:(NSError *)error
{
    //    [Utils stopActivityIndicatorInView:self.view];
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
#pragma mark - Parsing Data
- (void)parseData:(id)data
{
    if (!arrPaymentMode) {
        arrPaymentMode = [[NSMutableArray alloc] init];
    }
    [arrPaymentMode removeAllObjects];
    if([data count]>0)
    {
        
        for(int i =0 ; i < [data count] ; i++)
        {
            NSDictionary *dict = [data objectAtIndex:i];
            CMPaymentMode *mode = [[CMPaymentMode alloc] init];
            mode.mode_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kPaymentMode_Id]];
            mode.name = [NSString stringWithFormat:@"%@",[dict objectForKey:kPaymentMode_Name]];
            [arrPaymentMode addObject:mode];
        }
        [tblView reloadData];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(CMPayment*)cmPayment
{
    if(_cmPayment==nil)
    {
        _cmPayment= [[CMPayment alloc]init];
    }
    return _cmPayment;
}

- (IBAction)btnFinalPay:(id)sender {
	strStore_Id=[_dict objectForKey:@"store_id"];
	
	if (_indexPath==nil) {
		[Utils showAlertView:kAlertTitle message:@"Please select Anyone Payment Mode" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
	 return;
	 
 }
	else	if ([arrPaymentMode count]>0 && [cmPaymentMode.name isEqualToString:@"JioMoney"]) {
  
		webView.hidden=NO;
	//	btnBack.hidden=NO;
		_btnFinalPay.userInteractionEnabled = NO;
	//	btnBack.userInteractionEnabled=YES;
		
		timeStampString=TimeStamp;
		[[self navigationController] setNavigationBarHidden:YES animated:YES];
		
		[Utils startActivityIndicatorInView:self.view withMessage:nil];
		float totalAmt =[ [_dict objectForKey:@"total_amount"]floatValue];
		NSString *total = [NSString stringWithFormat:@"%.2f",totalAmt];
		NSString *deviceType=[_dict objectForKey:@"deviceType"];
		NSString *deviceId = [_dict objectForKey:@"deviceId"];
		NSString *userId = [_dict objectForKey:@"userId"];
		NSString *userAddId = [_dict objectForKey:@"user_address_id"];
		NSString *storeId = [_dict objectForKey:@"store_id"];
		NSString *productId = [_dict objectForKey:@"product_ids"];
		NSString *offerType = [_dict objectForKey:@"offer_types"];
		NSString *productprice = [_dict objectForKey:@"product_prices"];
		NSString *productQty = [_dict objectForKey:@"product_qtys"];
		NSString *delDate = [_dict objectForKey:@"delivery_date"];
		NSString *delSlot = [_dict objectForKey:@"delivery_slot"];
		NSString *totalDisc = [_dict objectForKey:@"total_discount"];
		NSString *couponCode = [_dict objectForKey:@"coupon_code"];
		NSString *paymentModeId = [_dict objectForKey:@"payment_mode_id"];
		
		NSString* delSlotReplaceSpace=[delSlot stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
		if (couponCode == nil ) {
			couponCode=@"";
		}
		NSString *urlString =[NSString stringWithFormat:@"https://www.aaramshop.com/jio/jio_payment?unique=%@&deviceId=%@&deviceType=%@&userId=%@&user_address_id=%@&store_id=%@&product_ids=%@&offer_types=%@&product_prices=%@&product_qtys=%@&delivery_date=%@&delivery_slot=%@&total_amount=%@&total_discount=%@&coupon_code=%@&payment_mode_id=%@",timeStampString,deviceId,deviceType,userId,userAddId,storeId,productId,offerType,productprice,productQty,delDate,delSlotReplaceSpace,total,totalDisc,couponCode,paymentModeId];
		
		
		NSURL* url=[NSURL URLWithString:urlString];
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
		[webView loadRequest:urlRequest];
		
	 [NSTimer scheduledTimerWithTimeInterval: 3.0 target: self
												selector: @selector(callAfterSixtySecond) userInfo: nil repeats: YES];
	}else{
		[Utils startActivityIndicatorInView:self.view withMessage:nil];
		
		[self dataDictionary];
		
	}
	
}
-(void)callAfterSixtySecond
{
	NSURL *myURL = [[NSURL alloc]init];
	myURL = webView.request.URL.absoluteURL;
	NSString*urlString=[NSString stringWithFormat:@"%@",myURL];

	if ([urlString isEqualToString:@"https://www.aaramshop.com/jio/jio_response"]) {
		btnBack.hidden=NO;
		btnBack.userInteractionEnabled=YES;
	}
	

}

-(void)dataDictionary
{
 //   _dict=self.cmPayment.pamentDataDic;

 [self performSelector:@selector(callWebServiceForCheckout:) withObject:_dict afterDelay:0.1];
   // [self callWebServiceForCheckout:_dict];
}

-(void)callWebServiceForCheckout:(NSMutableDictionary *)aDict
{
   // aDict= [Utils setPredefindValueForWebservice];

    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [Utils stopActivityIndicatorInView:self.view];
    //    btnPay.enabled = NO;
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kcheckoutURL withInput:aDict withCurrentTask:TASK_CHECKOUT andDelegate:self ];
    
}


- (void)showPopupWithMessage:(NSString *)message
{
    tblView.userInteractionEnabled = NO;
//    [viewOverallValueStatus setHidden:NO];
  //  lblOverallValueStatus.text = message;
}
#pragma mark - Feedback screen

-(void)openFeedbackScreen
{
    [tblView setUserInteractionEnabled:NO];
    feedBack = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
  
    feedBack.strStore_Id =[_dict objectForKey:kStore_id];
    feedBack.strStore_name = [_dict objectForKey:kStore_name];
    feedBack.strStore_image = [_dict objectForKey:kStore_image];
    
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
- (IBAction)btnBack:(id)sender {
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	if (![Utils isInternetAvailable])
	    {
		[Utils stopActivityIndicatorInView:self.view];
		//    btnPay.enabled = NO;
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	    }
_btnFinalPay.userInteractionEnabled = NO;
	
	NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceId];
	//NSString *deviceType = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceType];
	NSMutableDictionary *orderDic = [[NSMutableDictionary alloc] init];
	[orderDic setObject:deviceId forKey:kDeviceId];
	[orderDic setObject:@"1" forKey:kDeviceType];
	[orderDic setObject:timeStampString forKey:@"unique"];

	

	[aaramShop_ConnectionManager getDataForFunction:kURLJioOrderStatus withInput:orderDic withCurrentTask:TASK_JIOMONEY_ORDERCOMPLETE andDelegate:self ];
}
@end
