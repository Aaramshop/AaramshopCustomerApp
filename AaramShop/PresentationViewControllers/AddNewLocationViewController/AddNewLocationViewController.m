//
//  AddNewLocationViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 18/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AddNewLocationViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


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
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"SearchAddress"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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





//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Auto Suggestion -

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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == txtLocality)
    {
        NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"New String = %@",newStr);
        
        
        newStr = [newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([newStr length]>0)
        {
            //            [self searchManuallyAsychroByQueryText:newStr];
            [self queryGooglePlaces:newStr];
        }
        else
        {
            [postAutoSuggestionView.tableView removeFromSuperview];
        }
    }
    
    
    return YES;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtLocality)
    {
        textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (!postAutoSuggestionView) {
            postAutoSuggestionView=[[PostAutoSuggestionTableViewController alloc]initWithNibName:@"PostAutoSuggestionTableViewController" bundle:nil];
            postAutoSuggestionView.delegate=self;
            [postAutoSuggestionView.tableView setFrame:CGRectMake(15, 80, 290, 120)];
            
            [postAutoSuggestionView.tableView setHidden:YES];
            [self.view addSubview:postAutoSuggestionView.tableView];
        }
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField == txtLocality)
    {
        textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [postAutoSuggestionView.tableView removeFromSuperview];
        
    }
    
}






#pragma Auto Suggested Delegate

-(void)userSelectedInfo:(NSString*)aStringInfo ForSearchString:(NSString*)searchString{
    
    [postAutoSuggestionView.tableView removeFromSuperview];
    
    NSArray *arrInfo = [aStringInfo componentsSeparatedByString:@","];
    
    NSString *strLocality = [[arrInfo objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    
    
//    if ([txtLocality.text length]==0)
//    {
        txtLocality.text = strLocality;
//    }
//    else
//    {
//        NSRange rangeOfString = [txtLocality.text rangeOfString:searchString options:NSBackwardsSearch|NSCaseInsensitiveSearch];
//        
//        if (rangeOfString.location == NSNotFound)
//            return;
//        else
//            txtLocality.text =[txtLocality.text stringByReplacingCharactersInRange:NSMakeRange(rangeOfString.location, [txtLocality.text length] - rangeOfString.location ) withString:[NSString stringWithFormat:@"%@, ",strLocality]];
//    }
    
}







//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// GOOGLE PLACES API //////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-(void)updateDataSource:(NSArray *)inDataSource
{
    [postAutoSuggestionView.tableView setHidden:NO];
    
    if (inDataSource && inDataSource.count > 0)
    {
        
        [self.view addSubview:postAutoSuggestionView.tableView];
        [postAutoSuggestionView.tableView setHidden:NO];
        
        //        [postAutoSuggestionView reloadTableViewWithData:inDataSource forSearchString:txtLocality.text forDictionaryKey:@"name"];
        
        [postAutoSuggestionView reloadTableViewWithData:inDataSource forSearchString:txtLocality.text];
        
    }
    else
    {
        [postAutoSuggestionView.tableView removeFromSuperview];
    }
    
}


-(void) queryGooglePlaces: (NSString *) googleType {
    
    
    //    googleType = @"Naraina";
    
//    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&radius=2000&key=%@",googleType,kGOOGLE_API_KEY];
    
    // updated on 13 Oct 2015 ... begin
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&key=%@",googleType,kGOOGLE_API_KEY];
    // ...end
    

    
    
    //https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Naraina&types=establishment&radius=2000&key=AIzaSyAzMfO-tlOmsM47CG35YF-yHmleevA0LpM
    
    // AIzaSyAzMfO-tlOmsM47CG35YF-yHmleevA0LpM
    
    NSURL *googleRequestURL=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        if (data)
        {
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        }
    });
}




-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    //    NSArray* places = [json objectForKey:@"results"];
    
    if (json)
    {
        NSArray* places = [json valueForKeyPath:@"predictions.description"];
        [self updateDataSource: places];
        NSLog(@"Google Data: %@", places);
        
    }
    
}











@end
