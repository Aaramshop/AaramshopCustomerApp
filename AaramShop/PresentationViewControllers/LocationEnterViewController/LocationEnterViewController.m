//
//  LocationEnterViewController.m
//  AaramShop
//
//  Created by Approutes on 08/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "LocationEnterViewController.h"
#import "DDAnnotationView.h"
#import "ShopDataModel.h"
#import "AaramShop_ConnectionManager.h"
#import "HomeStoreViewController.h"
#import "AddressModel.h"
#import "AddNewLocationViewController.h"
@interface LocationEnterViewController ()
{
    AppDelegate *appDeleg;
    CustomMapAnnotationView *viewOfCustomAnnotation;
    NSString *strYourCurrentAddress;
    LocationAlertViewController *locationAlert;
    CLLocationCoordinate2D cordinatesLocation;
    AddressModel *addressModel;
}
- (void)coordinateChanged_:(NSNotification *)notification;
@end

@implementation LocationEnterViewController
@synthesize aaramShop_ConnectionManager,locationManager;
- (void)viewDidLoad {
    [super viewDidLoad];
	btnCancel.hidden=YES;
	[self findCurrentLocation];
    if (self.addAddressCompletion)
    {
		btnCancel.hidden=NO;
        self.navigationController.navigationBarHidden = YES;
    }
    
    appDeleg = APP_DELEGATE;
    txtFLocation.delegate = self;
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;

    addressModel = [[AddressModel alloc]init];
    
    txtFLocation.tintColor = [UIColor blackColor];
    arrShopsData = [[NSMutableArray alloc]init];
    mapViewLocation.delegate = self;
    
//    [mapViewLocation setShowsUserLocation:YES];
    
    
        [gAppManager performSelector:@selector(fetchAddressBookWithContactModel) withObject:nil];
    
        [gAppManager performSelector:@selector(createDefaultValuesForDictionay) withObject:nil];

}
-(void)findCurrentLocation
{
	
	locationManager = [[CLLocationManager alloc] init];
	geocoder = [[CLGeocoder alloc] init];
	
	if ([CLLocationManager locationServicesEnabled])
	{
		locationManager.delegate = self;
		if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
			[locationManager requestWhenInUseAuthorization];
		}
		[locationManager startUpdatingLocation];
		
	}
}
- (void)viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}
-(void)getAddressFromLatitude:(CLLocationDegrees)Latitude andLongitude:(CLLocationDegrees)LongitudeValue
{
    if ([Utils isInternetAvailable]) {
		
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
                                       if (data!=nil) {
                                           NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                           NSLog(@"json=%@",json);
                                           NSString *str=[json objectForKey:@"status"];
                                           if ([str isEqualToString:@"OK"])
                                           {
                                               [self fetchedData:data];
                                           }
                                           else
										   {
                                               [AppManager stopStatusbarActivityIndicator];
										   }
										   
                                           
   
                                       }
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
            NSLog(@"responseData-----::::;;;;;;;;;%@",responseData);
            
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
                            addressModel.pincode = [[arr1 objectAtIndex:i] objectForKey:@"long_name"];
                        }
                        if([[[[arr1 objectAtIndex:i] objectForKey:@"types"]objectAtIndex:0]isEqualToString:@"administrative_area_level_1"])
                        {
                            addressModel.state = [[arr1 objectAtIndex:i] objectForKey:@"long_name"];
                            shortAdministrativearea1 =[[arr1 objectAtIndex:i] objectForKey:@"short_name"];
                        }
                        if([[[[arr1 objectAtIndex:i] objectForKey:@"types"]objectAtIndex:0]isEqualToString:@"administrative_area_level_2"])
                        {
                            addressModel.city = [[arr1 objectAtIndex:i] objectForKey:@"long_name"];
                        }
                        if([[[[arr1 objectAtIndex:i] objectForKey:@"types"]objectAtIndex:0]isEqualToString:@"locality"])
                        {
                            addressModel.locality = [[arr1 objectAtIndex:i] objectForKey:@"long_name"];
                        }
                    }
                    
                    NSMutableArray *arrayFormattedAddress = [NSMutableArray arrayWithArray:[[dict objectForKey:@"formatted_address"] componentsSeparatedByString:@","]];
                    if([arrayFormattedAddress containsObject:[NSString stringWithFormat:@" %@ %@",addressModel.state,addressModel.pincode]])
                    {
                        [arrayFormattedAddress removeObject:[NSString stringWithFormat:@" %@ %@",addressModel.state,addressModel.pincode]];
                    }
                    if([arrayFormattedAddress containsObject:[NSString stringWithFormat:@" %@ %@",shortAdministrativearea1,addressModel.pincode]])
                    {
                        [arrayFormattedAddress removeObject:[NSString stringWithFormat:@" %@ %@",shortAdministrativearea1,addressModel.pincode]];
                    }
                    
                    if([arrayFormattedAddress containsObject:[NSString stringWithFormat:@" %@",addressModel.city]])
                    {
                        [arrayFormattedAddress removeObject:[NSString stringWithFormat:@" %@",addressModel.city]];
                    }
                    if([arrayFormattedAddress containsObject:[NSString stringWithFormat:@" %@",addressModel.locality]])
                    {
                        [arrayFormattedAddress removeObject:[NSString stringWithFormat:@" %@",addressModel.locality]];
                    }
                    [arrayFormattedAddress removeObject:[arrayFormattedAddress lastObject]];
                    NSString *strAddressString = [[NSArray arrayWithArray:arrayFormattedAddress] componentsJoinedByString:@","];
                    
                    addressModel.address = strAddressString;
              
                    NSDictionary *dictAdd=[returnJsonValue objectAtIndex:0];
                    NSString *stringTaggedLocationloc=[dictAdd valueForKey:@"formatted_address"];
                    
                    NSArray *items = [stringTaggedLocationloc componentsSeparatedByString:@","];
                    
                    NSMutableString *strAddress = [[NSMutableString alloc]init];
                    for (int p = 0; p < [items count]; p++)
                    {
                        [strAddress appendString:[items objectAtIndex:p]];
                    }
                    if (strAddress.length>0) {
                        strYourCurrentAddress = strAddress;
                        txtFLocation.text = strYourCurrentAddress;
                        
                    }
                [self updateMapScreenFromLatitude:cordinatesLocation.latitude  andLongitude:cordinatesLocation.longitude];
                    
                }];
            }
            
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}


-(void)createDataToGetAaramShopsWithLocation:(CLLocation *)location
{

    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:kLongitude];
    
    
    
    //sector chi V greater noida
//    [dict setObject:@"28.4309684" forKey:kLatitude];
//    [dict setObject:@"77.5060438" forKey:kLongitude];
    
    // sec 132 noida
//    [dict setObject:@"28.5160458" forKey:kLatitude]; // temp
//    [dict setObject:@"77.3735504" forKey:kLongitude]; // temp
//
//    [dict setObject:@"26" forKey:kUserId];
    
    
    
    [dict setObject:@"5" forKey:kRadius];
    [self callWebserviceToGetAaramShops:dict];
}
-(void)callWebserviceToGetAaramShops:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];

    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kStoreListURL withInput:aDict withCurrentTask:TASK_ENTER_LOCATION andDelegate:self];
}
-(void) didFailWithError:(NSError *)error
{
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_ENTER_LOCATION) {
        [self parseResponseForAaramShops:responseObject];
    }
}

-(void)parseResponseForAaramShops:(id)responseObject
{
    NSArray *arrData = [responseObject objectForKey:kData];
    for (id obj in arrData) {
        
        ShopDataModel *objShopData = [[ShopDataModel alloc]init];
        objShopData.city_name = [NSString stringWithFormat:@"%@",[obj objectForKey:kCity_name]];
        objShopData.delivers = [NSString stringWithFormat:@"%@",[obj objectForKey:kDelivers]];
        objShopData.locality_name = [NSString stringWithFormat:@"%@",[obj objectForKey:kLocality_name]];
        objShopData.minimum_order = [NSString stringWithFormat:@"%@",[obj objectForKey:kMinimum_order]];
        objShopData.state_name = [NSString stringWithFormat:@"%@",[obj objectForKey:kState_name]];
        objShopData.store_address = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_address]];
        objShopData.store_category = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_category]];
        objShopData.store_closing_days = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_closing_days]];
        objShopData.store_code = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_code]];
        objShopData.store_distance = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_distance]];
        objShopData.store_email = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_email]];
        objShopData.store_id = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_id]];
        objShopData.store_image = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_image]];
        objShopData.store_latitude = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_latitude]];
        objShopData.store_longitude = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_longitude]];
        objShopData.store_mobile = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_mobile]];
        objShopData.store_person = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_person]];
        objShopData.store_phone = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_phone]];
        objShopData.store_pincode = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_pincode]];
        objShopData.store_terms = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_terms]];
        objShopData.store_working_from = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_working_from]];
        objShopData.store_working_status = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_working_status]];
        objShopData.store_working_to = [NSString stringWithFormat:@"%@",[obj objectForKey:kStore_working_to]];

        [arrShopsData addObject:objShopData];
    }
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[responseObject objectForKey:kUserId]] forKey:kUserId];
    
    if ([arrShopsData count]>0)
    {
        [self plotPositions:arrShopsData];
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    
}

#pragma mark - plotThePins

#pragma mark -

- (void)plotPositions:(NSArray *)arrData
{
    for (int z=0; z<arrData.count; z++)
    {
        ShopDataModel *objshopData = [arrData objectAtIndex:z];
        NSString *strName=[NSString stringWithFormat:@"%@",objshopData.store_name];
        NSString *strAddress=[NSString stringWithFormat:@"%@", objshopData.store_address];
        
        CLLocationCoordinate2D placeCoord;
        
        placeCoord.latitude=[objshopData.store_latitude doubleValue];
        placeCoord.longitude=[objshopData.store_longitude doubleValue];
        
        NSString *strLat = objshopData.store_latitude ;
        NSString *strLng = objshopData.store_longitude ;

        if (strLat.length!=0 && strLng.length!=0)
        {
            Annotation *pinPoint = [[Annotation alloc]initWithName:strName Address:strAddress Coordinate:placeCoord imageUrl:@"" showMyLocation:NO];
            
            if ([pinPoint observationInfo]==nil)
            {
                [mapViewLocation addAnnotation: pinPoint];
            }
            else
            {
                [pinPoint removeObserver:pinPoint forKeyPath:@"Anotations"];
            }
            
            pinPoint = nil;
        }
    }
    [self setRegionOfMap];

}
-(void)updateMapScreenFromLatitude:(CLLocationDegrees)Latitude andLongitude:(CLLocationDegrees)LongitudeValue
{
    for (id<MKAnnotation> annotation in mapViewLocation.annotations)
    {
        if ([annotation isKindOfClass:[Annotation class]]) {
            Annotation *obj = (Annotation *)annotation;
            if (obj.isMyLocation) {
                MKAnnotationView* aView = [mapViewLocation viewForAnnotation: obj];
                
              for (UIView *subview in aView.subviews )
              {
                  [subview removeFromSuperview];
              }

                [mapViewLocation removeAnnotation:annotation];
                break;
            }
        }
    }
    
    CLLocationCoordinate2D coordinateValue = CLLocationCoordinate2DMake(Latitude, LongitudeValue);
    
    NSString *strFullname = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kFullname] != nil)
    {
        strFullname = [[NSUserDefaults standardUserDefaults] valueForKey:kFullname];
    }
    
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = Latitude;
    region.center.longitude = LongitudeValue;
    region.span.latitudeDelta = 0.0287f;
    region.span.longitudeDelta = 0.0287f;
    [mapViewLocation setRegion:region];

    
    Annotation *annotation = [[Annotation alloc]initWithName:[NSString stringWithFormat:@"%@",strFullname] Address:strYourCurrentAddress Coordinate:coordinateValue imageUrl:@"" showMyLocation:YES];
    [mapViewLocation addAnnotation:annotation];
    

//    [self setRegionOfMap];

}
-(void)setRegionOfMap
{
//    CLLocationCoordinate2D topLeftCoord;
//    topLeftCoord.latitude = -90;
//    topLeftCoord.longitude = 180;
//    
//    CLLocationCoordinate2D bottomRightCoord;
//    bottomRightCoord.latitude = 90;
//    bottomRightCoord.longitude = -180;
//    
//    for (id <MKAnnotation> annotation in mapViewLocation.annotations)
//    {
//        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
//        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
//        
//        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
//        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
//    }
//    
//    MKCoordinateRegion region;
//    
//    region.center.latitude=(topLeftCoord.latitude+bottomRightCoord.latitude)/2;
//    region.center.longitude=(bottomRightCoord.longitude+ topLeftCoord.longitude)/2;
//    float LatDelta=(topLeftCoord.latitude-bottomRightCoord.latitude)*1.5;
//    
//    float LonDelta=(bottomRightCoord.longitude-topLeftCoord.longitude)*1.5;
//    
//    if (LatDelta>180)
//        LatDelta=180;
//    
//    if (LonDelta>180)
//        LonDelta=180;
//    
//    region.span.latitudeDelta = LatDelta;
//    region.span.longitudeDelta = LonDelta;
    
//    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
//    region.center.latitude = Latitude;
//    region.center.longitude = LongitudeValue;
//    region.span.latitudeDelta = 0.0187f;
//    region.span.longitudeDelta = 0.0137f;
//    [mapViewLocation setRegion:region];
//
//
//    if(region.center.longitude == 0.00000000 && region.center.latitude==0)
//        NSLog(@"Invalid region!");
//    else
//        [mapViewLocation setRegion:region animated:YES];
    
    
    
//    [mapViewLocation setCenterCoordinate:mapViewLocation.userLocation.location.coordinate animated:YES];
//    [mapViewLocation setRegion:region animated:YES];
    
    
    
//    region.span.longitudeDelta  = 0.005;
//    region.span.latitudeDelta  = 0.005;
//    
//    [mapViewLocation setRegion:region animated:YES];

    
//    CLLocationCoordinate2D noLocation;
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
//    MKCoordinateRegion adjustedRegion = [mapViewLocation regionThatFits:viewRegion];
//    [mapViewLocation setRegion:adjustedRegion animated:YES];
//    mapViewLocation.showsUserLocation = YES;

}
#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification

- (void)coordinateChanged_:(NSNotification *)notification {
    
    Annotation *annotation = notification.object;
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (oldState == MKAnnotationViewDragStateDragging) {
         for (Annotation *annotation in mapViewLocation.annotations)
         {
             if ([annotation isKindOfClass:[Annotation class]]) {
                 Annotation *obj = (Annotation *)annotation;
                 if (obj.isMyLocation) {
                     cordinatesLocation.latitude = annotation.coordinate.latitude;
                     cordinatesLocation.longitude = annotation.coordinate.longitude;
                     [self getAddressFromLatitude:cordinatesLocation.latitude andLongitude:cordinatesLocation.longitude];
                     
//                     [mapViewLocation selectAnnotation:obj animated:YES];
                     
                 }
             }
         }

    }
}

//-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{
//    MKAnnotationView *note= [mapView viewForAnnotation:mapView.userLocation];
//    note.hidden = YES;
//}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
    MKAnnotationView *draggablePinView = [mapViewLocation dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
    
    
    if ([annotation isKindOfClass:[Annotation class]]) {
        Annotation *objAnnotation = (Annotation *)annotation;
        if ( objAnnotation.isMyLocation) {
            if([draggablePinView isKindOfClass:[DDAnnotationView class]])
            {
//                if (draggablePinView) {
                    draggablePinView.annotation = annotation;

//                }
            }
            else
            {
                draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:mapViewLocation];
                
                
                draggablePinView.draggable = YES;
                
                
                
            }
//            else
//            {
            
//                if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
//                    // draggablePinView is DDAnnotationView on iOS 3.
//                } else {
//                    draggablePinView.draggable = YES;
//                    // draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
//                }
//            }
            
        }
        else
        {
            
            MKPinAnnotationView *annotationPinView =
            (MKPinAnnotationView *) [mapViewLocation dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
            

            
            if(!annotationPinView)
            {
                annotationPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier];

            }
            annotationPinView.image = [UIImage imageNamed:@"mapPin"];
            annotationPinView.canShowCallout = NO;
            annotationPinView.enabled = NO;
            return annotationPinView;
            
//            draggablePinView.enabled = YES;
//            draggablePinView.canShowCallout = NO;
//            draggablePinView.calloutOffset = CGPointMake(0, 0);
//            draggablePinView.image = [UIImage imageNamed:@"mapPin.png"];
//            draggablePinView.annotation = annotation;
//            return draggablePinView;
            
        }
    }
    
    return draggablePinView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (id<MKAnnotation> currentAnnotation in mapView.annotations) {
        Annotation *objAnnotation = (Annotation *)currentAnnotation;
        if(objAnnotation.isMyLocation)
        {
            [mapView selectAnnotation:currentAnnotation animated:FALSE];
        }
    }
}
#pragma mark-

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if(![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        if ([view.annotation isKindOfClass:[Annotation class]]) {
            Annotation *objAnnotation = (Annotation *)view.annotation;
            if (objAnnotation.isMyLocation) {
                viewOfCustomAnnotation = (CustomMapAnnotationView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomMapAnnotationView" owner:self options:nil]objectAtIndex:0];
                viewOfCustomAnnotation.backgroundColor = [UIColor clearColor];
                CGRect calloutViewFrame = viewOfCustomAnnotation.frame;
                calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 90, -calloutViewFrame.size.height-4);
                
//                calloutViewFrame.origin = CGPointMake(self.view.frame.size.width-calloutViewFrame.size.width/2 + 7, -calloutViewFrame.size.height);

                
                
                
                
                
                viewOfCustomAnnotation.frame = calloutViewFrame;
                
                
                NSString *strFullname = @"";
                
                if ([[NSUserDefaults standardUserDefaults] valueForKey:kFullname] != nil)
                {
                    strFullname = [[NSUserDefaults standardUserDefaults] valueForKey:kFullname];
                }
                
                
                
                [viewOfCustomAnnotation.lblName setText:[NSString stringWithFormat:@"%@",strFullname]];
                viewOfCustomAnnotation.imgProfile.layer.cornerRadius =  viewOfCustomAnnotation.imgProfile.frame.size.width / 2;
                viewOfCustomAnnotation.imgProfile.clipsToBounds = YES;

                if ([[[NSUserDefaults standardUserDefaults]valueForKey:kProfileImage] length]>0)
                {
                    [viewOfCustomAnnotation.activityIndicatorVw startAnimating];
                    
                    if ([UIScreen mainScreen].bounds.size.height == 480) {
                        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImage_url_100],[[NSUserDefaults standardUserDefaults] valueForKey:kProfileImage]];

                        [viewOfCustomAnnotation.imgProfile sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"defaultProfilePic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (image) {
                            }
                            [viewOfCustomAnnotation.activityIndicatorVw stopAnimating];
                        }];
                    }
                    else if ([UIScreen mainScreen].bounds.size.height == 568) {
                        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImage_url_320],[[NSUserDefaults standardUserDefaults] valueForKey:kProfileImage]];
                        [viewOfCustomAnnotation.imgProfile sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"defaultProfilePic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (image) {
                            }
                            [viewOfCustomAnnotation.activityIndicatorVw stopAnimating];
                        }];
                    }
                    else if ([UIScreen mainScreen].bounds.size.height == 667) {
                        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImage_url_640],[[NSUserDefaults standardUserDefaults] valueForKey:kProfileImage]];

                        [viewOfCustomAnnotation.imgProfile sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"defaultProfilePic.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (image) {
                            }
                            [viewOfCustomAnnotation.activityIndicatorVw stopAnimating];
                        }];
                    }

                }
                else
                {
                    viewOfCustomAnnotation.imgProfile.image = gAppManager.imgProfile !=nil?gAppManager.imgProfile : [UIImage imageNamed:@"defaultProfilePic.png"] ;
                }

                [viewOfCustomAnnotation.lblAddress setText:[(Annotation*)[view annotation] Address]];
                [viewOfCustomAnnotation.lblAddress setNumberOfLines:2];
                
                viewOfCustomAnnotation.userInteractionEnabled=YES;
                [view addSubview:viewOfCustomAnnotation];
                
            }
        }
    }
}



-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - UITextField Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch isKindOfClass:[UITextField class]]) {
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
#pragma mark - Button Actions

- (IBAction)btnCancelClicked:(id)sender {
	self.addAddressCompletion();
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDoneClick:(UIButton *)sender {
    
    [txtFLocation resignFirstResponder];
    [self addLocationScreen:addressModel];
}

- (IBAction)btnEditClick:(UIButton *)sender {
//    txtFLocation.userInteractionEnabled = NO;
//    [txtFLocation resignFirstResponder];
//    AddressModel *addressModelTemp ;
//    addressModelTemp.address = @"";
//    addressModelTemp.state = @"";
//    addressModelTemp.city = @"";
//    addressModelTemp.locality = @"";
//    addressModelTemp.pincode = @"";

//    [self addLocationScreen:addressModel];
	//=================Tempory Code Begins===================
	AddNewLocationViewController *addNewLocationView = (AddNewLocationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AddNewLocationView"];
	addNewLocationView.delegate = self;
	[appDeleg.window addSubview:addNewLocationView.view];

	//=================Tempory Code End===================
}
-(void)gotAddress:(double)lat longitude:(double)longitude
{
	[self updateMapScreenFromLatitude:lat andLongitude:longitude];
}
-(void)addLocationScreen:(AddressModel *)addModel
{
    locationAlert =  [self.storyboard instantiateViewControllerWithIdentifier :@"LocationAlertScreen"];
    locationAlert.delegate = self;
    locationAlert.objAddressModel = addModel;
    locationAlert.cordinatesLocation = cordinatesLocation;
    CGRect locationAlertViewRect = [UIScreen mainScreen].bounds;
    locationAlert.view.frame = locationAlertViewRect;
    [appDeleg.window addSubview:locationAlert.view];

}
-(void)saveAddress
{
    if (self.addAddressCompletion)
    {
        self.addAddressCompletion();
		if(self.delegate && [self.delegate respondsToSelector:@selector(saveAddressInLocationEnter)])
		{
			[self.delegate saveAddressInLocationEnter];
		}
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        HomeStoreViewController *homeStoreVwController = (HomeStoreViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeStoreScreen"];
        [self.navigationController pushViewController:homeStoreVwController animated:YES];
    }
}
#pragma mark - 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager* )manager didFailWithError:(NSError *)error
{
	
}


- (void)locationManager:(CLLocationManager* )manager didUpdateLocations:(NSArray* )locations
{
	[locationManager stopUpdatingLocation];

	CLLocation* newLocation = [locations lastObject];
	
	[self getUpdatedLocation:newLocation];
}


-(void)getUpdatedLocation:(CLLocation *)newLocation
{
	if(cordinatesLocation.latitude==0)
	{
		[self createDataToGetAaramShopsWithLocation:newLocation];
		
		cordinatesLocation = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
		
		[self getAddressFromLatitude:cordinatesLocation.latitude andLongitude:cordinatesLocation.longitude];
	}

}


@end
