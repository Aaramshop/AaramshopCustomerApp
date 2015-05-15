//
//  PalsFriendTableViewCell.m
//  SocialParty
//
//  Created by Shakir Approutes on 30/05/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import "ShareLocationViewController.h"
#import "CAnnotation.h"
#define txtField_txtField_MAXLENGTH 50
#define kKeyboardHeightPortrait 135

@interface ShareLocationViewController ()
{
    AppDelegate *appDel;
}

@end

@implementation ShareLocationViewController

@synthesize ActivityIncator;
@synthesize GeoCoder;
@synthesize CurrAddress;
@synthesize CurrAnnotation;
@synthesize selected;
@synthesize nearbyVenues;
@synthesize searchedNearbyVenues;
@synthesize currentlyContainVenues;
@synthesize isSearching;
@synthesize locationManager;
@synthesize delegate;
@synthesize searchBar;
@synthesize currentLocation;
@synthesize coordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    if ([UIScreen mainScreen].bounds.size.height>480)
//    {
//        self = [super initWithNibName: @"ShareLocationViewController_iPhone5" bundle:nibBundleOrNil];
//
//    }
//    else
//    {
//        self = [super initWithNibName:@"ShareLocationViewController" bundle:nibBundleOrNil];
//
//    }
    self = [super initWithNibName: @"ShareLocationViewController_iPhone5" bundle:nibBundleOrNil];
    


    if (self)
    {
        // Custom initialization
        self.isSearching = NO;
        self.nearbyVenues =[[NSMutableArray alloc] init];
        self.currentlyContainVenues = [[NSMutableArray alloc] init];
        self.searchedNearbyVenues = [[NSMutableArray alloc] init];
        self.GeoCoder = [[CLGeocoder alloc] init];
        convertedCurrLocation = [[FSVenue alloc]init];
        searchNotFoundVenue = [[FSVenue alloc]init];
        searchNotFoundVenue.name  = @"Location not found";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tblLocation.scrollsToTop = YES;
    
    [mMapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
    // Do any additional setup after loading the view from its nib.
       [self.ActivityIncator setHidesWhenStopped: YES];
    mMapView.delegate = self;
    [tblLocation addSubview: self.ActivityIncator];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
   
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
     [self.locationManager startUpdatingLocation];
}
#pragma mark - Methods used by foursquare
- (void)getVenuesForLocation:(CLLocation *)location {
    
    [Foursquare2 venueSearchNearByLatitude:@(location.coordinate.latitude)
                                 longitude:@(location.coordinate.longitude)
                                     query:nil
                                     limit:nil
                                    intent:intentCheckin
                                    radius:@(500)
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          NSDictionary *dic = result;
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          FSConverter *converter = [[FSConverter alloc]init];
                                        [self.nearbyVenues removeAllObjects];
                                          NSArray *fsConverter = [converter convertToObjects:venues];
                                          
                                          [self.nearbyVenues insertObject:convertedCurrLocation atIndex:0];

                                          if (fsConverter && fsConverter.count > 0)
                                          {
                                              [self.nearbyVenues addObjectsFromArray: fsConverter];
                                              if (self.isSearching == NO)
                                              {
                                                  [self updateDataSource: self.nearbyVenues];
                                              }
                                          }
                                          
                                      }
                                  }];
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    currentLocation=newLocation;
    [self showActivityindicator:NO];
    [self convertCurrentLocationInVanue: newLocation];
    [self getVenuesForLocation:newLocation];
    [self currentAddressUsingGeoCoder: newLocation];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    [Utils showAlertView:kAlertTitle message:@"Turn On Location Services to Allow \"UmmApp\" to Determine Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [self showActivityindicator:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)convertCurrentLocationInVanue:(CLLocation *)inCurLocation
{
    convertedCurrLocation.name = @"";
    convertedCurrLocation.venueId = @"CurrId";
    
    convertedCurrLocation.location.address = @"";
    convertedCurrLocation.location.distance =[NSNumber numberWithInt:0];
    [convertedCurrLocation.location setCoordinate:CLLocationCoordinate2DMake(inCurLocation.coordinate.latitude,inCurLocation.coordinate.longitude)];

}
-(void)createAnnotations:(CLLocation *)inCurrLocation
{
    
    if(self.CurrAnnotation)
        [mMapView removeAnnotation: self.CurrAnnotation];
    
    // annotation for Golden Gate Bridge
    CAnnotation *aAnnotation = [[CAnnotation alloc] initwithCoordinate: self.currentLocation.coordinate];
    aAnnotation.mainAddress = self.CurrAddress;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 1.0/50.0;
    span.longitudeDelta = 1.0/50.0;
    region.span = span;
    region.center = inCurrLocation.coordinate;
    
    [mMapView setRegion:region animated:TRUE];
    [mMapView regionThatFits:region];

    
    [mMapView addAnnotation : aAnnotation];
    [mMapView selectAnnotation:[[mMapView annotations] lastObject] animated:YES];

    self.CurrAnnotation = aAnnotation;
}

-(void)currentAddressUsingGeoCoder:(CLLocation *)inLocation
{
    [self.GeoCoder reverseGeocodeLocation: inLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
        MKPlacemark * aPlaceMark = [placemarks objectAtIndex:0];
        NSString *locatedaddress = [[aPlaceMark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        
        if ([locatedaddress length] > 0 )
        {
            self.CurrAddress = [NSString stringWithFormat:@"%@",locatedaddress];
           
            //update converted location
            convertedCurrLocation.name = aPlaceMark.name;
            convertedCurrLocation.location.address =  [locatedaddress stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",aPlaceMark.name] withString:@""];
            [tblLocation reloadData];
            
            mMapView.showsUserLocation = NO;
            [self createAnnotations:inLocation];
        }
    }];
}



#pragma Annotation Delegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    for (id<MKAnnotation> aCurrentAnnotation in mMapView.annotations) {
        if ([aCurrentAnnotation isEqual:self.CurrAnnotation]) {
            [mMapView selectAnnotation:aCurrentAnnotation animated:FALSE];
        }
    }
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    for (id<MKAnnotation> aCurrentAnnotation in mMapView.annotations) {
        if ([aCurrentAnnotation isEqual:self.CurrAnnotation]) {
            [mMapView selectAnnotation:aCurrentAnnotation animated:FALSE];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    // handle our three custom annotations
    //
    if ([annotation isKindOfClass:[CAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString *CAnnotationIdentifier = @"CAnnotationIdentifier";
        
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [mMapView dequeueReusableAnnotationViewWithIdentifier:CAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:CAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            [customPinView setSelected: YES ];
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}


#pragma mark - UIButton Methods
-(IBAction)btnCancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];   
}

-(IBAction)btnRefreshOrCancelClicked:(id)sender
{
    [self showActivityindicator:YES];
    
    [self performSelector:@selector(updateLocation) withObject:nil afterDelay:0.7];
    
}


-(void)updateLocation{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        if ([CLLocationManager locationServicesEnabled])
        {
            [self.locationManager startUpdatingLocation];
        }
    }
    else
    {
         [self showActivityindicator:NO];
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The location services seems to be disabled from the settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        alert= nil;
    }
}

#pragma mark - Show Activity Indicator
-(void)showActivityindicator:(BOOL)show{
    
    if (show) {
        [self.view endEditing:YES];
        UIActivityIndicatorView *activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicatorView setFrame:CGRectMake(0, 0, 30, 30)];
        [activityIndicatorView startAnimating];
        [activityIndicatorView setCenter:btnRefresh.center];
        activityIndicatorView.tag=110011;
        [self.view addSubview:activityIndicatorView];
        [btnRefresh setHidden:YES];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
    }else{
        UIActivityIndicatorView *activityIndicatorView=(UIActivityIndicatorView *)[self.view viewWithTag:110011];
        [activityIndicatorView removeFromSuperview];
        [btnRefresh setHidden:NO];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    
}


#pragma mark - UITableView Delegates & DataSource Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentlyContainVenues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    UILabel *lblLocationName;
    UILabel *lblLocationAddress;
    if (cell == nil)
    {
        NSArray* nib;
        
        nib  = [[NSBundle mainBundle] loadNibNamed:@"CellPostLocation" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        lblLocationName = (UILabel*)[cell.contentView viewWithTag:1];
        lblLocationAddress = (UILabel*)[cell.contentView viewWithTag:2];
        
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(224/255.0) green:(224/255.0) blue:(224/255.0) alpha:1];
        cell.selectedBackgroundView = selectionColor;
    }
    FSVenue *venue = self.currentlyContainVenues[indexPath.row];
    switch (indexPath.row) {
        case 0:
            if (isSearching && currentlyContainVenues.count == 0)//when location not found
            {
                lblLocationName.text = venue.name;
                lblLocationAddress.text= @"";

            }
            else//non searching mode, first object is current location as venue.
            {
                lblLocationName.text = venue.name;
                lblLocationAddress.text= venue.location.address;
            }
            break;
            
        default:
            lblLocationName.text = [self.currentlyContainVenues[indexPath.row] name];
            
            if (venue.location.address) {
                lblLocationAddress.text = [NSString stringWithFormat:@"%@m, %@",
                                           venue.location.distance,
                                           venue.location.address];
            } else {
                lblLocationAddress.text = [NSString stringWithFormat:@"%@m",
                                           venue.location.distance];
            }
            break;
    }
    
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isSearching && currentlyContainVenues.count ==0 )
    {
        return;
    }
    selectedVenue=[[FSVenue alloc]init];
    selectedVenue=(FSVenue*)[self.currentlyContainVenues objectAtIndex:indexPath.row];
    if ([delegate respondsToSelector:@selector(shareSelectedLocation:)])
    {
        [delegate shareSelectedLocation:selectedVenue];
        [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    }
    

}
-(void)adjustViewsBySearchingBool:(BOOL)inBool
{
    CGRect tableRect = tblLocation.frame;
    CGRect searchBarRect = self.searchBar.frame;
    self.isSearching = inBool;
    if (inBool)
    {
        btnBack.hidden = YES;
        btnRefresh.hidden = YES;
        mMapView.hidden = YES;
        
        tableRect.origin.y = searchBarRect.origin.y + searchBarRect.size.height;
        tableRect.size.height = tableRect.size.height + searchBarRect.size.height - kKeyboardHeightPortrait;
        
        searchBarRect.origin.x  = 5.0;
        searchBarRect.size.width = 320-searchBarRect.origin.x *2;// searchBarRect.size.width +( btnBack.frame.size.width + btnRefresh.frame.size.width);

    }
    else
    {
        btnBack.hidden = NO;
        btnRefresh.hidden = NO;
        mMapView.hidden = NO;
        
        tableRect.origin.y = mMapView.frame.origin.y + mMapView.frame.size.height;
        tableRect.size.height = tableRect.size.height - searchBarRect.size.height + kKeyboardHeightPortrait;
        
        searchBarRect.origin.x  = btnBack.frame.origin.x + btnBack.frame.size.width;
searchBarRect.size.width = 320 -( btnBack.frame.origin.x + btnBack.frame.size.width +(320- btnRefresh.frame.origin.x));

    }
    [tblLocation setFrame: tableRect];
    [self.searchBar setFrame: searchBarRect];
    
    CGRect activityRect = CGRectZero;
//    CGPoint centerPoint = tblLocation.center;
    activityRect.size.width = activityRect.size.height = 30;

    activityRect.origin.x = (tableRect.size.width-activityRect.size.width)/2.0;
    activityRect.origin.y = (tableRect.size.height- activityRect.size.height)/2.0;
    [self.ActivityIncator setFrame: activityRect];

    
}

-(void)updateDataSource:(NSMutableArray *)inDataSource
{
    //removed previous searched items
    [self.currentlyContainVenues removeAllObjects];
    if (inDataSource && inDataSource.count > 0)
    {
        [self.currentlyContainVenues addObjectsFromArray: inDataSource];
    }
    [tblLocation reloadData];

}
#pragma mark - TextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  
}

-(void)textFieldDidEndEditing:(UITextField*)textfield
{
       [txtSearch resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES; // We do not want UITextField to insert line-breaks.
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text length] > txtField_txtField_MAXLENGTH) {
        textField.text = [textField.text substringToIndex:txtField_txtField_MAXLENGTH-1];
        return NO;
    }
    return YES;
}

#pragma mark --
#pragma mark UISearchBar method

// End search
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1
{
    [self adjustViewsBySearchingBool: YES];
	searchBar1.showsCancelButton = YES;
	searchBar1.autocorrectionType = UITextAutocorrectionTypeNo;
    [self updateDataSource: nil];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1

{
    [self adjustViewsBySearchingBool: NO];
    [self updateDataSource: self.nearbyVenues];
}

- (void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText
{
    if ([searchBar1.text length] == 0)
    {
        [self.searchedNearbyVenues removeAllObjects];
        [self.searchedNearbyVenues addObject: searchNotFoundVenue];
        [self updateDataSource: nil];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar1 setShowsCancelButton:YES];
    for (UIView *subview in searchBar1.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            int64_t delayInSeconds = .001;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                UIButton * cancelButton = (UIButton *)subview;
                [cancelButton setHidden:NO];
                [cancelButton setEnabled:YES];
                
            });
        }
    }
    //[searchBar1 resignFirstResponder];
    
    if (searchBar1.text.length>0)
    {
        self.ActivityIncator.hidden = NO;
        [self.ActivityIncator startAnimating];
        [self performSelector:@selector(searchManuallyAsychroByQueryText:) withObject: searchBar1.text afterDelay: 0.1];
    }
    
    
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
        return YES;
}



// Cancel search
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar1 setShowsCancelButton:NO];
	searchBar1.text = @"";
    [searchBar1 resignFirstResponder];
	
}
#pragma mark - Searcl Location Delegate
-(void)LocationSearchedResult:(FSVenue*)venue{
    if ([delegate respondsToSelector:@selector(shareSelectedLocation:)]) [delegate shareSelectedLocation:venue];
}


-(void)searchManuallyAsychroByQueryText:(NSString *)inQuery
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSDictionary *result=[self searchForPlaceOnFourSquareByqueryText:inQuery];
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSArray *venues = [result valueForKeyPath:@"response.venues"];
            FSConverter *converter = [[FSConverter alloc]init];
            NSArray *fsConverter =[converter convertToObjects:venues];
            [self.searchedNearbyVenues removeAllObjects];
            
            if (fsConverter && fsConverter.count > 0 && self.isSearching)
            {
                [self.searchedNearbyVenues addObjectsFromArray: fsConverter];
                
            }
            else if ((!fsConverter || fsConverter.count == 0 ) && self.isSearching)
            {
                [self.searchedNearbyVenues addObject:searchNotFoundVenue];
            }
            
            [self updateDataSource: self.searchedNearbyVenues];
            [self.ActivityIncator stopAnimating];

        });
    });
    // Do any additional setup after loading the view from its nib.
}

-(NSDictionary*)searchForPlaceOnFourSquareByqueryText:(NSString *)inQuery
{
    
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateInString=[formatter stringFromDate:date];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&query=%@&client_id=%@&client_secret=%@&v=%@",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,[inQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],kFourSquareClientId,kFourSquareSecretId,dateInString]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
//    NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSDictionary *result = [s JSONValue];
    if(responseData==nil)
        return nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    
    if (![result isKindOfClass:[NSDictionary class]])
        result = nil;
    
    return result;
}

@end
