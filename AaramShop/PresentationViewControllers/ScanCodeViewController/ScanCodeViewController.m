//
//  ScanCodeViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 31/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ScanCodeViewController.h"

@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,AaramShop_ConnectionManager_Delegate>
{
	AVCaptureSession *_session;
	AVCaptureDevice *_device;
	AVCaptureDeviceInput *_input;
	AVCaptureMetadataOutput *_output;
	AVCaptureVideoPreviewLayer *_prevLayer;
	NSString *detectedStr;
	UIView *_highlightView;
	UILabel *_label;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	CMWalletOffer *walletOfferModel;
	WalletOffersViewController *walletOfferVC;
}
@end

@implementation ScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate = self;
	count = 0;
	isQrCode = NO;
	_highlightView = [[UIView alloc] init];
	_highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
	_highlightView.layer.borderColor = [UIColor greenColor].CGColor;
	_highlightView.layer.borderWidth = 3;
	[self.view addSubview:_highlightView];
	
	_label = [[UILabel alloc] init];
	_label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
	_label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	_label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
	_label.textColor = [UIColor whiteColor];
	_label.textAlignment = NSTextAlignmentCenter;
	_label.text = @"(none)";
//	[self.view addSubview:_label];
	
	_session = [[AVCaptureSession alloc] init];
	_device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	NSError *error = nil;
	
	_input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
	if (_input) {
		[_session addInput:_input];
	} else {
		NSLog(@"Error: %@", error);
	}
	
	_output = [[AVCaptureMetadataOutput alloc] init];
	[_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
	[_session addOutput:_output];
	
	_output.metadataObjectTypes = [_output availableMetadataObjectTypes];
	
	_prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
	_prevLayer.frame = self.view.bounds;
	_prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[self.view.layer addSublayer:_prevLayer];
	
	[_session startRunning];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button addTarget:self
			   action:@selector(hideSuperView)
	 forControlEvents:UIControlEventTouchUpInside];
//	[button setTitle:@"Show View" forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:@"cancelIconCircle"] forState:UIControlStateNormal];
	button.frame = CGRectMake(10, 32, 65, 30);
	[self.view addSubview:button];
	
	[self.view bringSubviewToFront:_highlightView];
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"QRCodeScaner"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
- (void)hideSuperView
{
	if (self.delegate && [self.delegate conformsToProtocol:@protocol(ScanCodeVCDelegate)] && [self.delegate respondsToSelector:@selector(removeSuperview)])
	{
		[self.delegate removeSuperview];
	}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
	CGRect highlightViewRect = CGRectZero;
	AVMetadataMachineReadableCodeObject *barCodeObject;
	NSString *detectionString = nil;
	NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
							  AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
							  AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
	
	for (AVMetadataObject *metadata in metadataObjects) {
		for (NSString *type in barCodeTypes) {
			if ([type isEqualToString:@"org.iso.QRCode"]) {
				isQrCode = YES;
			}
			if ([metadata.type isEqualToString:type])
			{
				barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
				highlightViewRect = barCodeObject.bounds;
				detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
				break;
			}
		}
		
		if (detectionString != nil)
		{
			[self createDataToSendCode:detectionString];
			break;
			
		}
		else
		{
			
		}
	}
	_highlightView.frame = highlightViewRect;
	
}
- (void)createDataToSendCode: (NSString *)detectedString
{
	if (count == 0) {
		[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
		NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
		[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
		if (isQrCode == NO) {
			[dict setObject:detectedString forKey:@"barcode"];
		}
		else
			[dict setObject:detectedString forKey:@"qrcode"];
		[self performSelector:@selector(callWebServiceToSendCode:) withObject:dict afterDelay:0.1];
		count ++;
	}
	
}

- (void)callWebServiceToSendCode:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		count = 0;
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLGetWalletOffers withInput:aDict withCurrentTask:TASK_TO_GET_WALLET_OFFER andDelegate:self];
}
- (void)responseReceived:(id)responseObject
{
	[AppManager stopStatusbarActivityIndicator];
	switch (aaramShop_ConnectionManager.currentTask) {
		case TASK_TO_GET_WALLET_OFFER:
		{
			if([[responseObject objectForKey:kstatus] intValue] == 1)
			{
				if (self.delegate && [self.delegate conformsToProtocol:@protocol(ScanCodeVCDelegate)] && [self.delegate respondsToSelector:@selector(removeSuperview)])
				{
					[self.delegate removeSuperview];
				}

//				[self parseData:[responseObject objectForKey:@"result"]];
			}
			else
			{
				[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
				[self hideSuperView];
			}
		}
			break;
			
		default:
			break;
	}
	
}
- (void)didFailWithError:(NSError *)error
{
	count = 0;
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
}
- (void)parseData:(id)dict
{
	walletOfferModel = [[CMWalletOffer alloc] init];
	walletOfferModel.offerType                        = [NSString stringWithFormat:@"%@",[dict objectForKey:kOfferType]];
	walletOfferModel.product_id                      = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_id]];
	walletOfferModel.product_sku_id               = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_sku_id]];
	walletOfferModel.product_image                = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_image]];
	walletOfferModel.product_actual_price       = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_actual_price]];
	walletOfferModel.offer_price                      = [NSString stringWithFormat:@"%@",[dict objectForKey:kOffer_price]];
	walletOfferModel.product_name                 = [NSString stringWithFormat:@"%@",[dict objectForKey:kProduct_name]];
	walletOfferModel.offerTitle                         = [NSString stringWithFormat:@"%@",[dict objectForKey:kOfferTitle]];
	walletOfferModel.offer_id                           = [NSString stringWithFormat:@"%@",[dict objectForKey:kOffer_id]];
	walletOfferModel.free_item                        = [NSString stringWithFormat:@"%@",[dict objectForKey:kFree_item]];
	walletOfferModel.combo_mrp                    = [NSString stringWithFormat:@"%@",[dict objectForKey:kCombo_mrp]];
	walletOfferModel.combo_offer_price          = [NSString stringWithFormat:@"%@",[dict objectForKey:kCombo_offer_price]];
	walletOfferModel.offerDetail                      = [NSString stringWithFormat:@"%@",[dict objectForKey:kOfferDetail]];
	walletOfferModel.offerDescription             = [NSString stringWithFormat:@"%@",[dict objectForKey:kOfferDescription]];
	walletOfferModel.offerImage                      = [NSString stringWithFormat:@"%@",[dict objectForKey:kOfferImage]];
	walletOfferModel.start_date                      = [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kStart_date] doubleValue]]];
	walletOfferModel.end_date                      = [Utils stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kEnd_date] doubleValue]]];
	
	if (self.delegate && [self.delegate conformsToProtocol:@protocol(ScanCodeVCDelegate)] && [self.delegate respondsToSelector:@selector(removeSuperviewWithModel:)])
	{
		
		[self.delegate removeSuperviewWithModel:walletOfferModel];
		
	}
}

@end
