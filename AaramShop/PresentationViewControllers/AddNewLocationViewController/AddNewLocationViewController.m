//
//  AddNewLocationViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 18/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AddNewLocationViewController.h"

@interface AddNewLocationViewController ()
{
	UIView *calloutView;
	AppDelegate *appDeleg;
	NSString *strYourCurrentAddress;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
}
@end

@implementation AddNewLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	[self setUpNavigationBar];
	appDeleg = APP_DELEGATE;
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate = self;
	[self.scrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 600)];
	UITapGestureRecognizer *gst = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
	gst.cancelsTouchesInView = NO;
	gst.delegate = self;
	[self.view addGestureRecognizer:gst];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setUpNavigationBar
{
	self.navigationItem.hidesBackButton = YES;
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
	titleView.text = @"Add New Location";
	titleView.adjustsFontSizeToFitWidth = YES;
	[_headerTitleSubtitleView addSubview:titleView];
	self.navigationItem.titleView = _headerTitleSubtitleView;
	
	UIImage *imgInfo = [UIImage imageNamed:@"accountDetailsQuestionmarkIcon"];
	UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	infoBtn.bounds = CGRectMake( -10, 0, 30, 30);
	
	[infoBtn setImage:imgInfo forState:UIControlStateNormal];
	[infoBtn addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barInfoBtn = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
	
	NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barInfoBtn, nil];
	self.navigationItem.rightBarButtonItems = arrBtnsRight;
	
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
}
-(void)backBtn
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)hideKeyboard
{
	[txtLocality resignFirstResponder];
	[txtPinCode resignFirstResponder];
	[txtCity resignFirstResponder];
	[txtState resignFirstResponder];
}

-(BOOL)prefersStatusBarHidden
{
	return YES;
}
#pragma mark - UITextfield Delegates
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
	NSInteger nextTag = textField.tag + 1;
	// Try to find next responder
	UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
	if (nextResponder) {
		// Found next responder, so set it.
		[nextResponder becomeFirstResponder];
		
		
	} else {
		// Not found, so remove keyboard.
		
		[textField resignFirstResponder];
		[self btnContinue:continueBtn];
		
	}
	return YES; // We do not want UITextField to insert line-breaks.
}
- (void)gotAddress
{
}
- (IBAction)btnBackClicked:(id)sender {
	[self.view removeFromSuperview];
}
- (IBAction)btnContinue:(id)sender
{
	[Utils startActivityIndicatorInView:self.view withMessage:@"Searching..."];
}
- (void)searchLocation
{
	NSString *urlStrings = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@,%@,%@,%@&sensor=true",txtAddress.text,txtLocality.text,txtCity.text,txtState.text];
	
	NSURL *url=[NSURL URLWithString:[urlStrings stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	NSOperationQueue *queue = [[NSOperationQueue alloc]init];
	[NSURLConnection sendAsynchronousRequest:request
									   queue:queue
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
							   [Utils stopActivityIndicatorInView:self.view];
							   if (error) {
								   [AppManager stopStatusbarActivityIndicator];
								   NSLog(@"error:%@", error.localizedDescription);
							   }
							   else
							   {
								   data = [NSData dataWithContentsOfURL:url];
								   if (data!=nil) {
									   
									   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
									   NSLog(@"json=%@",json);
									   CLLocationCoordinate2D ordinate = CLLocationCoordinate2DMake(0, 0);

									   if ([[json valueForKey:@"status"] isEqualToString:@"OK"]) {
										   NSDictionary *location = [[[[json valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"];
										   ordinate = CLLocationCoordinate2DMake([[location valueForKey:@"lat"] floatValue], [[location valueForKey:@"lng"] floatValue]);
										   if(self.delegate && [self.delegate respondsToSelector:@selector(gotAddress:longitude:)])
										   {
											   [self.delegate gotAddress:ordinate.latitude longitude:ordinate.longitude];
											   [self.view removeFromSuperview];
										   }

									   }

									   NSString *str=[json objectForKey:@"status"];
									   if ([str isEqualToString:@"OK"])
									   {
									   }
									   else
									   {
										   [AppManager stopStatusbarActivityIndicator];
									   }
									   
									   
									   
								   }
							   }
							   
						   }];
}
@end
