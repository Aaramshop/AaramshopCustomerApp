//
//  AddNewLocationViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 18/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AddNewLocationViewController.h"
#import "DXAnnotationView.h"
#import "DXAnnotationSettings.h"
@interface DXAnnotation : NSObject <MKAnnotation>
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
@interface AddNewLocationViewController ()
{
	UIView *calloutView;
 CustomMapAnnotationView *viewOfCustomAnnotation;
	AppDelegate *appDeleg;
	NSString *strYourCurrentAddress;
	AaramShop_ConnectionManager *aaramShop_ConnectionManager;
	CLLocationCoordinate2D cordinatesLocation;
	double longitude;
	double latitude;
	DXAnnotationView *annotationView;
	DXAnnotation *annotation1;
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
	[self updateMapScreenFromLatitude:appDeleg.myCurrentLocation.coordinate.latitude andLongitude:appDeleg.myCurrentLocation.coordinate.longitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateMapScreenFromLatitude:(CLLocationDegrees)Latitude andLongitude:(CLLocationDegrees)LongitudeValue
{
	//	[mapViewLocation removeAnnotations:mapViewLocation.annotations];
	MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
	region.center.latitude = Latitude;
	region.center.longitude = LongitudeValue;
	region.span.latitudeDelta = 0.0187f;
	region.span.longitudeDelta = 0.0137f;
	[mapViewLocation removeAnnotations:mapViewLocation.annotations];
	if(!annotation1)
	{
		annotation1= [DXAnnotation new];
	}
	annotation1.coordinate = CLLocationCoordinate2DMake(Latitude, LongitudeValue);
	[mapViewLocation addAnnotation:annotation1];
	[mapViewLocation setRegion:region];
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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
	//    [self createDataToGetAaramShops];
	cordinatesLocation = CLLocationCoordinate2DMake(appDeleg.myCurrentLocation.coordinate.latitude, appDeleg.myCurrentLocation.coordinate.longitude);
	[self getAddressFromLatitude:appDeleg.myCurrentLocation.coordinate.latitude andLongitude:appDeleg.myCurrentLocation.coordinate.longitude];
	
	//    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
	//    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
	
}
- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}
-(void)backBtn
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)hideKeyboard
{
	//    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//	[txtAddress resignFirstResponder];
	[txtLocality resignFirstResponder];
	[txtPinCode resignFirstResponder];
	[txtCity resignFirstResponder];
	[txtState resignFirstResponder];
}
#pragma mark - Get Address From Map
-(void)getAddressFromLatitude:(CLLocationDegrees)Latitude andLongitude:(CLLocationDegrees)LongitudeValue
{
	if ([Utils isInternetAvailable]) {
		longitude = LongitudeValue;
		latitude = Latitude;
		[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
		NSString*urlStrings = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%.8f,%.8f&sensor=false",Latitude, LongitudeValue];
		
		NSURL *url=[NSURL URLWithString:[urlStrings stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		
		NSOperationQueue *queue = [[NSOperationQueue alloc]init];
		[NSURLConnection sendAsynchronousRequest:request
										   queue:queue
							   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
								   if (error) {
									   [AppManager stopStatusbarActivityIndicator];
									   NSLog(@"error:%@", error.localizedDescription);
								   }
								   else
								   {
									   data = [NSData dataWithContentsOfURL:url];
									   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
									   NSLog(@"json=%@",json);
									   NSString *str=[json objectForKey:@"status"];
									   if ([str isEqualToString:@"OK"])
									   {
										   [self fetchedData:data];
									   }
									   else
										   [AppManager stopStatusbarActivityIndicator];
								   }
								   
							   }];
	}
	
}
- (void)fetchedData:(NSData *)responseData
{
	@try
	{
		if(responseData.length>0)
		{
			// NSLog(@"responseData-----::::;;;;;;;;;%@",responseData);
			
			NSError* error;
			NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
			
			NSMutableArray *returnJsonValue=[json valueForKey:@"results"];
			NSLog(@"%@",returnJsonValue);
			
			if(returnJsonValue.count>0)
			{
				[[NSOperationQueue mainQueue] addOperationWithBlock:^{
					
					NSDictionary *dict=[returnJsonValue objectAtIndex:0];
					NSArray * arr1 = [dict valueForKey:@"address_components"];
					NSString *shortAdministrativearea1= @"";
					for(int i=0;i<[arr1 count];i++)
					{
						if([[[[arr1 objectAtIndex:i] objectForKey:@"types"]objectAtIndex:0]isEqualToString:@"postal_code"])
						{
							txtPinCode.text = [[arr1 objectAtIndex:i] objectForKey:@"long_name"];
						}
						if([[[[arr1 objectAtIndex:i] objectForKey:@"types"]objectAtIndex:0]isEqualToString:@"administrative_area_level_1"])
						{
							txtState.text = [[arr1 objectAtIndex:i] objectForKey:@"long_name"];
							shortAdministrativearea1 =[[arr1 objectAtIndex:i] objectForKey:@"short_name"];
						}
						if([[[[arr1 objectAtIndex:i] objectForKey:@"types"]objectAtIndex:0]isEqualToString:@"administrative_area_level_2"])
						{
							txtCity.text = [[arr1 objectAtIndex:i] objectForKey:@"long_name"];
						}
						if([[[[arr1 objectAtIndex:i] objectForKey:@"types"]objectAtIndex:0]isEqualToString:@"locality"])
						{
							txtLocality.text = [[arr1 objectAtIndex:i] objectForKey:@"long_name"];
						}
					}
					
					NSMutableArray *arrayFormattedAddress = [NSMutableArray arrayWithArray:[[dict objectForKey:@"formatted_address"] componentsSeparatedByString:@","]];
					if([arrayFormattedAddress containsObject:[NSString stringWithFormat:@" %@ %@",txtState.text,txtPinCode.text]])
					{
						[arrayFormattedAddress removeObject:[NSString stringWithFormat:@" %@ %@",txtState.text,txtPinCode.text]];
					}
					if([arrayFormattedAddress containsObject:[NSString stringWithFormat:@" %@ %@",shortAdministrativearea1,txtPinCode.text]])
					{
						[arrayFormattedAddress removeObject:[NSString stringWithFormat:@" %@ %@",shortAdministrativearea1,txtPinCode.text]];
					}
					
					if([arrayFormattedAddress containsObject:[NSString stringWithFormat:@" %@",txtCity.text]])
					{
						[arrayFormattedAddress removeObject:[NSString stringWithFormat:@" %@",txtCity.text]];
					}
					if([arrayFormattedAddress containsObject:[NSString stringWithFormat:@" %@",txtLocality.text]])
					{
						[arrayFormattedAddress removeObject:[NSString stringWithFormat:@" %@",txtLocality.text]];
					}
					[arrayFormattedAddress removeObject:[arrayFormattedAddress lastObject]];
					NSString *addressString = [[NSArray arrayWithArray:arrayFormattedAddress] componentsJoinedByString:@","];
					
					strYourCurrentAddress = addressString;
					
//					txtAddress.text = strYourCurrentAddress;
					
					[self updateMapScreenFromLatitude:cordinatesLocation.latitude  andLongitude:cordinatesLocation.longitude];
					
				}];
			}
			
			//            if(returnJsonValue.count>0)
			//            {
			//                NSArray *arr=[returnJsonValue objectAtIndex:0];
			//                NSString *stringTaggedLocationloc=[arr valueForKey:@"formatted_address"];
			//        //        NSArray * arr1 = [arr valueForKey:@"address_components"];
			//                NSArray *items = [stringTaggedLocationloc componentsSeparatedByString:@","];
			//
			//                txtLocality.text = [items objectAtIndex:2];
			//                txtCity.text = [items objectAtIndex:3];
			//                txtState.text = [items objectAtIndex:4];
			//            }
			
			//    [self updateMapScreenFromLatitude:appDeleg.myCurrentLocation.coordinate.latitude andLongitude:appDeleg.myCurrentLocation.coordinate.longitude];
			
		}
	}
	@catch (NSException *exception)
	{
		NSLog(@"%@",exception);
	}
	[AppManager stopStatusbarActivityIndicator];
	
}
#pragma mark DDAnnotationCoordinateDidChangeNotification

- (void)coordinateChanged_:(NSNotification *)notification {
	
	//    Annotation *annotation = notification.object;
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (newState == MKAnnotationViewDragStateEnding) {
		if([annotationView.annotation isKindOfClass:[DXAnnotation class]])
		{
			annotationView.dragState = MKAnnotationViewDragStateNone;
		}
		for (DXAnnotation *annotation in mapViewLocation.annotations)
		{
			if ([annotation isKindOfClass:[DXAnnotation class]]) {
				cordinatesLocation.latitude = annotation.coordinate.latitude;
				cordinatesLocation.longitude = annotation.coordinate.longitude;
				[self getAddressFromLatitude:annotation.coordinate.latitude andLongitude:annotation.coordinate.longitude];
				//                    annotation.Address = strYourCurrentAddress;
			}
		}
		
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
			viewForAnnotation:(id<MKAnnotation>)annotation {
	
	if ([annotation isKindOfClass:[DXAnnotation class]]) {
		
		UIView *pinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locationPinIcon"]];
		
		
		
		UILabel *lbl = (UILabel *)[calloutView viewWithTag:101];
		lbl.text = [[NSUserDefaults standardUserDefaults] valueForKey:kStore_name];
		
		UILabel *lblAddress = (UILabel *)[calloutView viewWithTag:102];
		lblAddress.text = strYourCurrentAddress;
		UIImageView *imgView = (UIImageView *)[calloutView viewWithTag:100];
		[imgView.layer setCornerRadius:imgView.frame.size.width/2];
		[imgView setClipsToBounds:YES];
		[imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:kImage_url_100],[[NSUserDefaults standardUserDefaults]valueForKey:kStore_image]]] placeholderImage:[UIImage imageNamed:@"defaultProfilePic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			//<#code#>
		}];
		
		
		annotationView = (DXAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([DXAnnotationView class])];
		[annotationView setCalloutView:calloutView];
		annotationView.draggable = YES;
		
		DXAnnotationSettings *settings =[[DXAnnotationSettings alloc]init];
		[settings setShouldRoundifyCallout:NO];
		[settings setShouldAddCalloutBorder:NO];
		[settings setShouldGroupAccessibilityChildren:NO];
		if (!annotationView) {
			annotationView = [[DXAnnotationView alloc] initWithAnnotation:annotation
														  reuseIdentifier:NSStringFromClass([DXAnnotationView class])
																  pinView:pinView
															  calloutView:calloutView
																 settings:settings];
		}
		else
		{
			
		}
		
		return annotationView;
	}
	return nil;
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
	[mapView selectAnnotation:[[mapView annotations] lastObject] animated:YES];
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	if ([view isKindOfClass:[DXAnnotationView class]]) {
		[((DXAnnotationView *)view)hideCalloutView];
		view.layer.zPosition = -1;
	}
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if ([view isKindOfClass:[DXAnnotationView class]]) {
		[((DXAnnotationView *)view)showCalloutView];
		view.layer.zPosition = 0;
	}
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


@end
