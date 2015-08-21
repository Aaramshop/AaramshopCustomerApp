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
	AppDelegate *appDeleg;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	CLLocationCoordinate2D searchLocation;
}
@end

@implementation AddNewLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
//	address;
//	state;
//	city;
//	locality;
//	pincode;
//	title;
//	user_address_id;
	if([self.addModel.address length]>0)
	{
		txtAddress.text	=	self.addModel.address;
		txtLocality.text	=	self.addModel.locality;
		txtPinCode.text	=	self.addModel.pincode;
		txtCity.text	=	self.addModel.city;
		txtState.text	=	self.addModel.state;
	}
	else
	{
		txtAddress.text	=	@"";
		txtLocality.text	=	@"";
		txtPinCode.text	=	@"";
		txtCity.text	=	@"";
		txtState.text	=	@"";
	}
	searchLocation = CLLocationCoordinate2DMake(0, 0);
	appDeleg = APP_DELEGATE;
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
	aaramShop_ConnectionManager.delegate = self;
	subView.layer.cornerRadius = 5.0f;
	subView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)hideKeyboard
{
	[txtAddress resignFirstResponder];
	[txtLocality resignFirstResponder];
	[txtPinCode resignFirstResponder];
	[txtCity resignFirstResponder];
	[txtState resignFirstResponder];
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
		[self btnSearch:searchBtn];
		
	}
	return YES; // We do not want UITextField to insert line-breaks.
}
- (IBAction)backBtnAction:(id)sender {
	[self.view removeFromSuperview];
}

- (IBAction)btnSearch:(id)sender {
	[self hideKeyboard];
	if([txtAddress.text length]==0 ||[txtCity.text length]==0 ||[txtLocality.text length]==0 ||[txtState.text length]==0)
	{
		[Utils showAlertView:kAlertTitle message:@"Please fill all fields" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[self.scrollView setUserInteractionEnabled:NO];
	[self performSelector:@selector(searchLocation) withObject:nil afterDelay:0.1];
	[self performSelector:@selector(saveAddress) withObject:nil afterDelay:0.2];
}
- (void)saveAddress
{
	NSLog(@"%f %f",searchLocation.latitude, searchLocation.longitude);
	if(searchLocation.latitude==0)
	{
		[self performSelector:@selector(saveAddress) withObject:nil afterDelay:0.2];
	}
	else
	{
		[self.view removeFromSuperview];

		if(self.delegate && [self.delegate respondsToSelector:@selector(gotAddress:withModel:)])
		{
			[self.delegate gotAddress:searchLocation withModel:self.addModel];
		}
		searchLocation	=	CLLocationCoordinate2DMake(0, 0);
	}
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
							   [self.scrollView setUserInteractionEnabled:YES];

							   if (error) {
								   [AppManager stopStatusbarActivityIndicator];
								   [Utils showAlertView:kAlertTitle message:@"Address not found." delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
							   }
							   else
							   {
								   data = [NSData dataWithContentsOfURL:url];
								   if (data!=nil) {
									   
									   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
									   NSLog(@"json=%@",json);
//									   CLLocationCoordinate2D ordinate = CLLocationCoordinate2DMake(0, 0);
									   self.addModel.address = txtAddress.text;
									   self.addModel.state		=	txtState.text;
									   self.addModel.city		=	txtCity.text;
									   self.addModel.locality	=	txtLocality.text;
									   self.addModel.pincode	=	txtPinCode.text;
									   
									   if ([[json valueForKey:@"status"] isEqualToString:@"OK"]) {
										   NSDictionary *location = [[[[json valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"];
										   searchLocation = CLLocationCoordinate2DMake([[location valueForKey:@"lat"] floatValue], [[location valueForKey:@"lng"] floatValue]);
										   NSLog(@"%f %f",searchLocation.latitude, searchLocation.longitude);

									   }
								   }
							   }
							   
						   }];
}
@end
