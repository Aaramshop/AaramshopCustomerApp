//
//  WalletViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 16/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "WalletViewController.h"

@interface WalletViewController ()
{
	MoneyViewController *moneyVC;
}
@end

@implementation WalletViewController
@synthesize pointsBtn,offersBtn,moneyBtn,subView,btnBack;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate = self;
	[self setNavigationBar];
	[self setupAllViews];
	[pointsBtn setSelected:![pointsBtn isSelected]];
	[self setSideBtnState: eSelectedPoints];
	selectedWallet = eSelectedPoints;
	
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self createDataToGetWallet];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)callWebService
{
	[self createDataToGetWallet];
}
- (void)createDataToGetWallet
{
	[self userInteraction:NO];
	//    [Utils startActivityIndicatorInView:self.view withMessage:nil];
	[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
	NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
	//    [dict setObject:@"6951" forKey:kAaramshopId];
	[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
	
	[self performSelector:@selector(callWebServiceToGetWallet:) withObject:dict afterDelay:0.1];
}
- (void)callWebServiceToGetWallet:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[self userInteraction:YES];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetWallet withInput:aDict withCurrentTask:TASK_GET_WALLET andDelegate:self ];
}
- (void)responseReceived:(id)responseObject
{
	[self userInteraction:YES];
	[AppManager stopStatusbarActivityIndicator];
	switch (aaramShop_ConnectionManager.currentTask) {
		case TASK_GET_WALLET:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				
				[pointsBtn setTitle:[[[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"points"]] componentsSeparatedByString:@"."] firstObject] forState:UIControlStateNormal];
				[moneyBtn setTitle:[[[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"money"]] componentsSeparatedByString:@"."] firstObject] forState:UIControlStateNormal];
				[offersBtn setTitle:[[[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"offers"]] componentsSeparatedByString:@"."] firstObject] forState:UIControlStateNormal];
				[subView setHidden:NO];
			}
		}
			break;
		
		default:
			break;
	}
	
}
- (void)didFailWithError:(NSError *)error
{
	[self userInteraction:YES];
	//    [Utils stopActivityIndicatorInView:self.view];
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}
- (void)userInteraction:(BOOL)enable
{
	[offersBtn setUserInteractionEnabled:enable];
	[pointsBtn setUserInteractionEnabled:enable];
	[moneyBtn setUserInteractionEnabled:enable];
	[subView setUserInteractionEnabled:enable];
	[btnBack setUserInteractionEnabled:enable];
}
-(void)setNavigationBar
{
	self.navigationController.navigationBarHidden = NO;
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
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
	titleView.text = @"Wallet";
	titleView.adjustsFontSizeToFitWidth = YES;
	[_headerTitleSubtitleView addSubview:titleView];
	self.navigationItem.titleView = _headerTitleSubtitleView;
	
	
	btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
	btnBack.bounds = CGRectMake( 0, 0, 30, 30 );
	[btnBack setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
	[btnBack addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *batBtnBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
	
	
	NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:batBtnBack, nil];
	self.navigationItem.leftBarButtonItems = arrBtnsLeft;
}
- (void)backButtonClicked
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)setupAllViews
{
	//Calling WalletOffersViewController
	walletOfferVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"WalletOfferViewScene"];
//	walletOfferVC.delegate  = self;
	CGRect walletOfferRect = subView.bounds;
	walletOfferVC.view.frame = walletOfferRect;
	[walletOfferVC.view setHidden:YES];
	[subView addSubview:walletOfferVC.view];
	
	
	//Calling MoneyViewController
	moneyVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"MoneyViewScene"];
//	moneyVC.delegate = self;
	CGRect moneyViewRect = subView.bounds;
	moneyVC.view.frame = moneyViewRect;
	[moneyVC.view setHidden:YES];
	[subView addSubview:moneyVC.view];
	
	
	//Calling PointsViewController
	pointsVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"PointsViewScene"];
//	pointsVC.delegate = self;
	CGRect pointsViewRect = subView.bounds;
	pointsVC.view.frame = pointsViewRect;
	[subView addSubview:pointsVC.view];
	
	
}

- (IBAction)btnOffers:(id)sender {
	[offersBtn setSelected:![offersBtn isSelected]];
	[self setSideBtnState: eSelectedWalletOffer];
	selectedWallet = eSelectedWalletOffer;
	
}

- (IBAction)btnMoney:(id)sender {
	[moneyBtn setSelected:![moneyBtn isSelected]];
	[self setSideBtnState: eSelectedAaramMoney];
	selectedWallet = eSelectedAaramMoney;
}

- (IBAction)btnPoints:(id)sender {
	[pointsBtn setSelected:![pointsBtn isSelected]];
	[self setSideBtnState: eSelectedPoints];
	selectedWallet = eSelectedPoints;
}

#pragma mark - custom method for button state
-(void)setSideBtnState:(enWalletSelectedType)inSelectedState
{
	switch (inSelectedState)
	{
		case eSelectedPoints:
		{
			[pointsBtn setSelected: YES];
			[moneyBtn setSelected:NO];
			[offersBtn setSelected:NO];
			[pointsVC.view setHidden:NO];
			[moneyVC.view setHidden:YES];
			[walletOfferVC.view setHidden:YES];
		}
			break;
			
		case eSelectedAaramMoney:
		{
			[pointsBtn setSelected: NO];
			[moneyBtn setSelected:YES];
			[offersBtn setSelected:NO];
			[pointsVC.view setHidden:YES];
			[moneyVC.view setHidden:NO];
			[walletOfferVC.view setHidden:YES];
		}
			break;
		case eSelectedWalletOffer:
		{
			[pointsBtn setSelected: NO];
			[moneyBtn setSelected:NO];
			[offersBtn setSelected:YES];
			[pointsVC.view setHidden:YES];
			[moneyVC.view setHidden:YES];
			[walletOfferVC.view setHidden:NO];
		}
			break;
		default:
			break;
	}
}

@end
