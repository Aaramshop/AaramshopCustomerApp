//
//  MapViewController.m
 
//
//  Created by Shakir Approutes on 23/10/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "MapViewController.h"
#import "SHFileUtil.h"
#import "UIImage+Extension.h"
@interface MapViewController ()

@end

@implementation MapViewController
@synthesize  SelectedLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"MapViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        GeoCoder = [[CLGeocoder alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc]init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    [mMapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
    // Do any additional setup after loading the view from its nib.
    mMapView.delegate = self;
    mMapView.showsUserLocation = NO;
    
    segment.selectedSegmentIndex = 0;
    segment.tintColor=kAddPalsBlueColor;
    [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateSelected];
    
    [mActivityIndicator startAnimating];
  
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [locationManager stopUpdatingLocation];
    currLocation=newLocation;
    [self currentAddressUsingGeoCoder: newLocation];
    //    [self setupMapForLocatoion:newLocation];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
}

-(void)adjustViewOnGetingCurrentLocation
{
    lblState.text = mPlaceMark.name;
    lblCountry.text = mPlaceMark.country;
    
    lblCountry.hidden = NO;
    lblState.hidden = NO;
    [mActivityIndicator stopAnimating];
}

-(void)currentAddressUsingGeoCoder:(CLLocation *)inLocation
{
    CLLocation *aSelectedLoc =[[CLLocation alloc] initWithLatitude: self.SelectedLocation.Coordinates.latitude longitude:self.SelectedLocation.Coordinates.longitude];
    
    [GeoCoder reverseGeocodeLocation: aSelectedLoc completionHandler:^(NSArray *placemarks, NSError *error)
     {
         MKPlacemark * aPlaceMark = [placemarks objectAtIndex:0];
         mPlaceMark =[placemarks objectAtIndex:0];
         NSString *locatedaddress = [[aPlaceMark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];

         if ([locatedaddress length] > 0 )//&& mIsTimeShowed)
         {
             CurrAddress = [NSString stringWithFormat:@"%@",locatedaddress];
             [self createAnnotations:inLocation];
             [self adjustViewOnGetingCurrentLocation];
         }
     }];
}


-(void)createAnnotations:(CLLocation *)inCurrLocation
{
    
    if(currAnnotation)
        [mMapView removeAnnotation: currAnnotation];
    
    // annotation for Golden Gate Bridge
    CAnnotation *aAnnotation = [[CAnnotation alloc] initwithCoordinate: self.SelectedLocation.Coordinates];
    
    CLLocation  * aSelectedLocation = [[CLLocation alloc] initWithLatitude: self.SelectedLocation.Coordinates.latitude longitude:self.SelectedLocation.Coordinates.longitude];
    
    long distance = [inCurrLocation distanceFromLocation: aSelectedLocation];
    aAnnotation.mainAddress = [NSString stringWithFormat:@"%@ , %li m Away",SelectedLocation.UserName,distance] ;

    MKCoordinateRegion region;
    MKCoordinateSpan span;
//    span.latitudeDelta = 0.2;
//    span.longitudeDelta = 0.2;
    span.latitudeDelta = 1.0/50.0;
    span.longitudeDelta = 1.0/50.0;
    region.span = span;
    region.center = SelectedLocation.Coordinates;
    
    [mMapView setRegion:region animated:TRUE];
    [mMapView regionThatFits:region];

    [mMapView addAnnotation : aAnnotation];
    [mMapView selectAnnotation:[[mMapView annotations] lastObject] animated:YES];

    currAnnotation = aAnnotation;
}


#pragma Annotation Delegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    for (id<MKAnnotation> aCurrentAnnotation in mMapView.annotations) {
        if ([aCurrentAnnotation isEqual:currAnnotation]) {
            [mMapView selectAnnotation:aCurrentAnnotation animated:FALSE];
        }
    }

}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    for (id<MKAnnotation> aCurrentAnnotation in mMapView.annotations) {
        if ([aCurrentAnnotation isEqual:currAnnotation]) {
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
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: when the detail disclosure button is tapped, we respond to it via:
            //       calloutAccessoryControlTapped delegate method
            //
            // by using "calloutAccessoryControlTapped", it's a convenient way to find out which annotation was tapped
            //
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            //customPinView.rightCalloutAccessoryView = rightButton;
            
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dogoBackScreen:(UIButton *)inSender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)doSelectMatTypeSegment:(UISegmentedControl *)inSender
{
    switch (inSender.selectedSegmentIndex)
    {
        case eMapDefaultType:
            mMapView.mapType = MKMapTypeStandard;
            break;
        case eMapSatelliteType:
            mMapView.mapType = MKMapTypeSatellite;

            break;
        case eMapHybridType:
            mMapView.mapType = MKMapTypeHybrid;

            break;
        default:
            break;
    }
    
}

@end
