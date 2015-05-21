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

@interface LocationEnterViewController ()
{
    AppDelegate *appDeleg;
    CustomMapAnnotationView *viewOfCustomAnnotation;
    NSString *strYourCurrentAddress;
    LocationAlertViewController *locationAlert;
}
- (void)coordinateChanged_:(NSNotification *)notification;
@end

@implementation LocationEnterViewController
@synthesize aaramShop_ConnectionManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDeleg = APP_DELEGATE;
    txtFLocation.delegate = self;
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;

    txtFLocation.tintColor = [UIColor blackColor];
    arrShopsData = [[NSMutableArray alloc]init];
    mapViewLocation.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
    [self createDataToGetAaramShops];
    [self getAddressFromLatitude:appDeleg.myCurrentLocation.coordinate.latitude andLongitude:appDeleg.myCurrentLocation.coordinate.longitude];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}
-(void)getAddressFromLatitude:(CLLocationDegrees)Latitude andLongitude:(CLLocationDegrees)LongitudeValue
{
    if ([Utils isInternetAvailable]) {
        NSString*urlStrings = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%.8f,%.8f&sensor=true&key=AIzaSyCTT48mLXvl2wBtzb9tzfZhafxaXyYrPiA",Latitude, LongitudeValue];
        
        NSURL *url=[NSURL URLWithString:[urlStrings stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSError* error;
        
        NSData* data = [NSData dataWithContentsOfURL:url];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"json=%@",json);
        NSString *str=[json objectForKey:@"status"];
        if ([str isEqualToString:@"OK"])
        {
            [self fetchedData:data];
        }
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
                NSArray *arr=[returnJsonValue objectAtIndex:0];
                NSString *stringTaggedLocationloc=[arr valueForKey:@"formatted_address"];
                
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
            }
            
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}
-(void)createDataToGetAaramShops
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:kOptionStore_listing forKey:kOption];
    [dict removeObjectForKey:kSessionToken];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
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
    
    [aaramShop_ConnectionManager getDataForFunction:@"" withInput:aDict withCurrentTask:TASK_ENTER_LOCATION andDelegate:self];
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
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:kUserId] forKey:kUserId];
    [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:kUserId] forKey:kUserId];
    [self plotPositions:arrShopsData];
    [self updateMapScreenFromLatitude:appDeleg.myCurrentLocation.coordinate.latitude andLongitude:appDeleg.myCurrentLocation.coordinate.longitude];
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
//
//    
//    CLLocationCoordinate2D theCoordinate;
//    theCoordinate.latitude = 27.810000;
//    theCoordinate.longitude = 82.477989;
//
}
-(void)updateMapScreenFromLatitude:(CLLocationDegrees)Latitude andLongitude:(CLLocationDegrees)LongitudeValue
{
    CLLocationCoordinate2D coordinateValue = CLLocationCoordinate2DMake(Latitude, LongitudeValue);
    Annotation *annotation = [[Annotation alloc]initWithName:@"You" Address:strYourCurrentAddress Coordinate:coordinateValue imageUrl:@"" showMyLocation:YES];
    [mapViewLocation addAnnotation:annotation];
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (id <MKAnnotation> annotation in mapViewLocation.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    
    region.center.latitude=(topLeftCoord.latitude+bottomRightCoord.latitude)/2;
    region.center.longitude=(bottomRightCoord.longitude+ topLeftCoord.longitude)/2;
    float LatDelta=(topLeftCoord.latitude-bottomRightCoord.latitude)*1.5;
    
    float LonDelta=(bottomRightCoord.longitude-topLeftCoord.longitude)*1.5;
    
    if (LatDelta>180)
        LatDelta=180;
    
    if (LonDelta>180)
        LonDelta=180;
    
    region.span.latitudeDelta = LatDelta;
    region.span.longitudeDelta = LonDelta;
    
    if(region.center.longitude == 0.00000000 && region.center.latitude==0)
        NSLog(@"Invalid region!");
    else
        [mapViewLocation setRegion:region animated:YES];

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
                     [self getAddressFromLatitude:annotation.coordinate.latitude andLongitude:annotation.coordinate.longitude];
                    annotation.Address = strYourCurrentAddress;
                 }
             }
         }

    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
    MKAnnotationView *draggablePinView = [mapViewLocation dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
    
    if ([annotation isKindOfClass:[Annotation class]]) {
        Annotation *objAnnotation = (Annotation *)annotation;
        if (objAnnotation.isMyLocation) {
            if (draggablePinView) {
                draggablePinView.annotation = annotation;
            }
            else
            {
                draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:mapViewLocation];
                draggablePinView.draggable = YES;
                
                if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
                    // draggablePinView is DDAnnotationView on iOS 3.
                } else {
                    draggablePinView.draggable = YES;
                    // draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
                }
            }
            
        }
        else
        {
            draggablePinView.enabled = YES;
            draggablePinView.canShowCallout = NO;
            draggablePinView.calloutOffset = CGPointMake(0, 0);
            draggablePinView.image = [UIImage imageNamed:@"mapPin.png"];
            draggablePinView.annotation = annotation;
            return draggablePinView;
            
        }
    }
    
    return draggablePinView;
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
                calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 7, -calloutViewFrame.size.height);
                
                viewOfCustomAnnotation.frame = calloutViewFrame;
                
                [viewOfCustomAnnotation.lblName setText:[(Annotation*)[view annotation] Name]];
                
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

- (IBAction)btnDoneClick:(UIButton *)sender {
    
//    LocationAlertViewController *locAlertVwController = (LocationAlertViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationAlertScreen"];
  //  [self presentViewController:locAlertVwController animated:YES completion:nil];
   // [self.view addSubview:locAlertVwController.view];
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    locationAlert =  [self.storyboard instantiateViewControllerWithIdentifier :@"LocationAlertScreen"];
//    
//    CGRect locationAlertViewRect = self.view.bounds;
//    locationAlert.view.frame = locationAlertViewRect;
//    [self.view addSubview:locationAlert.view];
}

- (IBAction)btnEditClick:(UIButton *)sender {
    txtFLocation.userInteractionEnabled = YES;
    [txtFLocation becomeFirstResponder];
}

#pragma mark - 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
