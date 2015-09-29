//
//  LocationAlertViewController.m
//  AaramShop
//
//  Created by Approutes on 16/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "LocationAlertViewController.h"
#import "LocationEnterViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface LocationAlertViewController ()
{
    LocationEnterViewController *locationEnter;
    AppDelegate *appDeleg;
}
@end

@implementation LocationAlertViewController
@synthesize delegate,scrollView,objAddressModel,aaramShop_ConnectionManager,cordinatesLocation;
//@synthesize searchedNearbyVenues,isSearching,currentLocation,locationManager;





- (void)viewDidLoad {
    [super viewDidLoad];
    
    subView.layer.cornerRadius = 5;
    subView.layer.masksToBounds = YES;
    
    appDeleg = APP_DELEGATE;
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;

    scrollView=[[AKKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, 0.01f)];
    
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [scrollView setContentSize:CGSizeMake(320, ([UIScreen mainScreen].bounds.size.height-100))];
    btnHome.selected = YES;
    btnOffice.selected = NO;
    btnOthers.selected = NO;
    [txtTitle setHidden:YES];
    [self bindData];

	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:@"SaveLocation"];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
    // added on 18 Sep 2015 ..... begins
//    self.searchedNearbyVenues = [[NSMutableArray alloc] init];
//    self.isSearching = NO;
    // added on 18 Sep 2015 ..... ends
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    self.locationManager = [[CLLocationManager alloc]init];
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.delegate = self;
//    
//    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [self.locationManager requestAlwaysAuthorization];
//    }
//    [self.locationManager startUpdatingLocation];

}



//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation {
//    [self.locationManager stopUpdatingLocation];
//    currentLocation=newLocation;
//}

//- (void)locationManager:(CLLocationManager *)manager
//       didFailWithError:(NSError *)error{
//    
//    [Utils showAlertView:kAlertTitle message:@"Turn On Location Services to Allow \"AaramShop\" to Determine Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//}



-(void)bindData
{
    txtAddress.text = objAddressModel.address;
    txtState.text = objAddressModel.state;
    txtCity.text = objAddressModel.city;
    txtLocality.text = objAddressModel.locality;
    txtPinCode.text = objAddressModel.pincode;
}
-(void)saveAddressIntoDataBase
{
    [self.view removeFromSuperview];
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(LocationAlertViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(saveAddress)])
    {
        [self.delegate saveAddress];
    }
}

#pragma mark - UIButton Actions

- (IBAction)btnCancel:(id)sender
{
        [self.view removeFromSuperview];
}

- (IBAction)btnSave:(id)sender
{
    subView.userInteractionEnabled = NO;
    
    txtAddress.text = [txtAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    txtState.text = [txtState.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    txtCity.text = [txtCity.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    txtLocality.text = [txtLocality.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    txtPinCode.text = [txtPinCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([txtAddress.text length] == 0) {
        
        [Utils showAlertView:kAlertTitle message:@"Enter address" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        subView.userInteractionEnabled = YES;


        return;
    }
    
    else if ([txtState.text length] == 0) {
        
        [Utils showAlertView:kAlertTitle message:@"Enter state" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        subView.userInteractionEnabled = YES;

        return;
    }
    
    else if ([txtCity.text length] == 0) {
        
        [Utils showAlertView:kAlertTitle message:@"Enter city" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        subView.userInteractionEnabled = YES;

        return;
    }
    
    else if ([txtLocality.text length] == 0) {
        
        [Utils showAlertView:kAlertTitle message:@"Enter locality" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        subView.userInteractionEnabled = YES;

        return;
    }
    
    else if ([txtPinCode.text length] == 0) {
        
        [Utils showAlertView:kAlertTitle message:@"Enter pincode" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        subView.userInteractionEnabled = YES;

        return;
    }
    
    
    else if (btnOthers.selected) {
        txtTitle.text = [txtTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([txtTitle.text length] == 0) {
            
            [Utils showAlertView:kAlertTitle message:@"Enter title" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            subView.userInteractionEnabled = YES;

            
            return;
        }
        else
        {
            [self createDataForAddressUpdate];
        }
    }
    else
    {
        [self createDataForAddressUpdate];
    }
}
-(void)createDataForAddressUpdate
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:txtAddress.text forKey:kAddress];
    [dict setObject:txtState.text forKey:kState];
    [dict setObject:txtCity.text forKey:kCity];
    [dict setObject:txtLocality.text forKey:kLocality];
    [dict setObject:txtPinCode.text forKey:kPincode];
    
    if (btnHome.selected) {
        [dict setObject:@"Home" forKey:kTitle];
    }
    else if (btnOffice.selected) {
        [dict setObject:@"Office" forKey:kTitle];
    }
    else if (btnOthers.selected) {
        [dict setObject:txtTitle.text forKey:kTitle];
    }

    [dict setObject:[NSString stringWithFormat:@"%f",cordinatesLocation.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",cordinatesLocation.longitude] forKey:kLongitude];
    [self callWebServiceForAddressUpdate:dict];
}
-(void)callWebServiceForAddressUpdate:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        subView.userInteractionEnabled = YES;

        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kUpdateAddressURL withInput:aDict withCurrentTask:TASK_UPDATE_ADDRESS andDelegate:self ];
}

-(void) didFailWithError:(NSError *)error
{
    subView.userInteractionEnabled = YES;

    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_UPDATE_ADDRESS) {
        
        subView.userInteractionEnabled = YES;

        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
			[[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:kUser_address] forKey:kUser_address];
			[[NSUserDefaults standardUserDefaults] synchronize];
            [self saveAddressIntoDataBase];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
}


- (IBAction)btnActionClicked:(UIButton *)sender {
    
    if (sender.tag == 100) {
        if (btnHome.selected) {
            btnHome.selected = YES;
        }
        else
            sender.selected = !sender.selected;
    }
    else if (sender.tag == 101) {
        if (btnOffice.selected) {
            btnOffice.selected = YES;
        }
        else
            sender.selected = !sender.selected;
    }

   else if (sender.tag == 102) {
      
       if (btnOthers.selected) {
           btnOthers.selected = YES;
       }
       else
           sender.selected = !sender.selected;
    }

    switch (sender.tag) {
        case 100:
        {
            btnOffice.selected = NO;
            btnOthers.selected = NO;
            [txtTitle setHidden:YES];
        }
            break;
        case 101:
        {
            btnHome.selected = NO;
            btnOthers.selected = NO;
            [txtTitle setHidden:YES];
        }
            break;

        case 102:
        {
            btnOffice.selected = NO;
            btnHome.selected = NO;
            [txtTitle setHidden:NO];
        }
            break;

        default:
            break;
    }
}




#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Auto Suggestion - 

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == txtAddress) {
        [txtState becomeFirstResponder];
    }
    else if (textField == txtState) {
        [txtCity becomeFirstResponder];
    }
    else if (textField == txtCity) {
        [txtLocality becomeFirstResponder];
    }
    else if (textField == txtLocality) {
        [txtPinCode becomeFirstResponder];
    }
    else if (textField == txtPinCode) {
        if (btnOthers.selected) {
            [txtTitle becomeFirstResponder];
        }
        else
            [txtPinCode resignFirstResponder];
    }
    else
    {
        [txtTitle resignFirstResponder];
    }
    return YES;
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
    
    
    if ([txtLocality.text length]==0)
    {
        txtLocality.text = aStringInfo;
    }
    else
    {
        NSRange rangeOfString = [txtLocality.text rangeOfString:searchString options:NSBackwardsSearch|NSCaseInsensitiveSearch];
        
        if (rangeOfString.location == NSNotFound)
            return;
        else
            txtLocality.text =[txtLocality.text stringByReplacingCharactersInRange:NSMakeRange(rangeOfString.location, [txtLocality.text length] - rangeOfString.location ) withString:[NSString stringWithFormat:@"%@, ",aStringInfo]];
    }
    
}

//-(void)userSelectedInfo:(NSDictionary*)aDictInfo ForSearchString:(NSString*)searchString forDictionaryKey:(NSString *)strKey{
//    
//    [postAutoSuggestionView.tableView removeFromSuperview];
//    
//    
//    if ([txtLocality.text length]==0)
//    {
//        txtLocality.text = [NSString stringWithFormat:@"%@, ",[aDictInfo valueForKey:strKey]];
//    }
//    else
//    {
//        NSRange rangeOfString = [txtLocality.text rangeOfString:searchString options:NSBackwardsSearch|NSCaseInsensitiveSearch];
//        
//        if (rangeOfString.location == NSNotFound)
//            return;
//        else
//            txtLocality.text =[txtLocality.text stringByReplacingCharactersInRange:NSMakeRange(rangeOfString.location, [txtLocality.text length] - rangeOfString.location ) withString:[NSString stringWithFormat:@"%@, ",[aDictInfo valueForKey:strKey]]];
//    }
//    
//}



/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////



//#pragma mark - Four Square API
//
//-(void)searchManuallyAsychroByQueryText:(NSString *)inQuery
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        NSDictionary *result=[self searchForPlaceOnFourSquareByqueryText:inQuery];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSArray *venues = [result valueForKeyPath:@"response.venues"];
//            FSConverter *converter = [[FSConverter alloc]init];
//            NSArray *fsConverter =[converter convertToObjects:venues];
//            [self.searchedNearbyVenues removeAllObjects];
//            
//            if (fsConverter && fsConverter.count > 0 /* && self.isSearching */)
//            {
//                [self.searchedNearbyVenues addObjectsFromArray: fsConverter];
//                
//            }
//            else if ((!fsConverter || fsConverter.count == 0 ) /* && self.isSearching */)
//            {
//                //                [self.searchedNearbyVenues addObject:searchNotFoundVenue];
//            }
//            
//            [self updateDataSource: self.searchedNearbyVenues];
//            //            [self.ActivityIncator stopAnimating];
//            
//        });
//    });
//    // Do any additional setup after loading the view from its nib.
//}


//-(NSDictionary*)searchForPlaceOnFourSquareByqueryText:(NSString *)inQuery
//{
//    
//    NSDate *date=[NSDate date];
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyyMMdd"];
//    NSString *dateInString=[formatter stringFromDate:date];
//    
//    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&query=%@&client_id=%@&client_secret=%@&v=%@",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,[inQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],kFourSquareClientId,kFourSquareSecretId,dateInString]];
//    
//    
//    
////    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&query=%@&client_id=%@&client_secret=%@&v=%@",28.53159939018553,77.38593645393848,[inQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],kFourSquareClientId,kFourSquareSecretId,dateInString]];
//
//    
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
//    
//    NSURLResponse *response;
//    NSError *err;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
//    
//    //    NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    //    NSDictionary *result = [s JSONValue];
//    if(responseData==nil)
//        return nil;
//    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
//    
//    
//    if (![result isKindOfClass:[NSDictionary class]])
//        result = nil;
//    
//    return result;
//}


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



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// GOOGLE PLACES API //////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-(void) queryGooglePlaces: (NSString *) googleType {

    
//    googleType = @"Naraina";
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&radius=2000&key=%@",googleType,kGOOGLE_API_KEY];


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
