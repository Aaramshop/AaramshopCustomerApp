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
}
@end

@implementation AddNewLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
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
- (void)gotAddress
{
}





- (IBAction)backBtnAction:(id)sender {
	[self.view removeFromSuperview];
}

- (IBAction)btnSearch:(id)sender {
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
