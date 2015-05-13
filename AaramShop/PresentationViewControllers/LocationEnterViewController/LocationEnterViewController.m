//
//  LocationEnterViewController.m
//  AaramShop
//
//  Created by Approutes on 08/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "LocationEnterViewController.h"
@interface LocationEnterViewController ()
{
    AppDelegate *appDeleg;
    CustomMapAnnotationView *viewOfCustomAnnotation;

}
@end

@implementation LocationEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDeleg = APP_DELEGATE;
    txtFLocation.delegate = self;
    txtFLocation.tintColor = [UIColor blackColor];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //user needs to press for half a second.
    [mapViewLocation addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [gestureRecognizer locationInView:mapViewLocation];
    CLLocationCoordinate2D touchMapCoordinate = [mapViewLocation convertPoint:touchPoint toCoordinateFromView:mapViewLocation];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = touchMapCoordinate;
    for (id annotation in mapViewLocation.annotations) {
        [mapViewLocation removeAnnotation:annotation];
    }
    [mapViewLocation addAnnotation:point];
}

- (void)plotPosition
{
    for (id<MKAnnotation> annotation in mapViewLocation.annotations)
    {
        [mapViewLocation removeAnnotation:annotation];
    }
    
        NSString *strName=@"You";
        NSString *strAddress=@"s";
    
    
    Annotation *pinpoint=[[Annotation alloc] initWithName:strName Address:strAddress  Coordinate:appDeleg.myCurrentLocation.coordinate imageUrl:@""];
    
    if ([pinpoint observationInfo]==nil)
    {
        [mapViewLocation addAnnotation: pinpoint];
    }
    else
    {
        [pinpoint removeObserver:pinpoint forKeyPath:@"Anotations"];
    }
    
    pinpoint = nil;
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

#pragma mark - MKMapViewDelegate methods.

#pragma mark-

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if(![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        viewOfCustomAnnotation = (CustomMapAnnotationView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomMapAnnotationView" owner:self options:nil]objectAtIndex:0];
        
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


#pragma mark - MKMapViewDelegate methods.

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapViewLocation dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
    
    if (annotationView == nil)
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier] ;
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    else
    {
        annotationView.enabled = YES;
        annotationView.canShowCallout = NO;
        annotationView.calloutOffset = CGPointMake(0, 0);
        annotationView.annotation = annotation;
        return annotationView;
    }
    return annotationView;
}


//- (MKAnnotationView *)mapView:(MKMapView *)mapView
//            viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    // If the annotation is the user location, just return nil.
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
//    
//    // Handle any custom annotations.
//    if ([annotation isKindOfClass:[MyCustomAnnotation class]])
//    {
//        // Try to dequeue an existing pin view first.
//        MKPinAnnotationView*    pinView = (MKPinAnnotationView*)[mapView
//                                                                 dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
//        
//        if (!pinView)
//        {
//            // If an existing pin view was not available, create one.
//            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
//                                                      reuseIdentifier:@"CustomPinAnnotationView"];
//            pinView.pinColor = MKPinAnnotationColorRed;
//            pinView.animatesDrop = YES;
//            pinView.canShowCallout = YES;
//            
//            // If appropriate, customize the callout by adding accessory views (code not shown).
//        }
//        else
//            pinView.annotation = annotation;
//        
//        return pinView;
//    }
//    
//    return nil;
//}
//
//- (MKAnnotationView *)viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    
//}
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
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
#pragma mark - Button Actions

- (IBAction)btnDoneClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
