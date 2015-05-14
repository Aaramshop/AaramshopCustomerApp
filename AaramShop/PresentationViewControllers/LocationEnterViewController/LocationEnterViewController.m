//
//  LocationEnterViewController.m
//  AaramShop
//
//  Created by Approutes on 08/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "LocationEnterViewController.h"
#import "DDAnnotationView.h"

@interface LocationEnterViewController ()
{
    AppDelegate *appDeleg;
    CustomMapAnnotationView *viewOfCustomAnnotation;

}
- (void)coordinateChanged_:(NSNotification *)notification;

@end

@implementation LocationEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDeleg = APP_DELEGATE;
    txtFLocation.delegate = self;
    txtFLocation.tintColor = [UIColor blackColor];
    
    mapViewLocation.delegate = self;
    
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = 27.810000;
    theCoordinate.longitude = 82.477989;

    Annotation *annotation = [[Annotation alloc]initWithName:@"You" Address:@"" Coordinate:theCoordinate imageUrl:@""];
    [mapViewLocation addAnnotation:annotation];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification

- (void)coordinateChanged_:(NSNotification *)notification {
    
    Annotation *annotation = notification.object;
    annotation.Address = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (oldState == MKAnnotationViewDragStateDragging) {
        annotationView.image = [UIImage imageNamed:@"mapPinGreen.png"];
        Annotation *annotation = (Annotation *)annotationView.annotation;
        annotation.Address = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
        
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
    MKAnnotationView *draggablePinView = [mapViewLocation dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
    
    if (draggablePinView) {
        draggablePinView.annotation = annotation;
        draggablePinView.image= [UIImage imageNamed:@"mapPinGreen.png"];

    } else {

        draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:mapViewLocation];
        draggablePinView.draggable = YES;
        draggablePinView.image= [UIImage imageNamed:@"mapPinGreen.png"];

        if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
            // draggablePinView is DDAnnotationView on iOS 3.
        } else {
            draggablePinView.draggable = YES;
            // draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
        }
    }		
    
    return draggablePinView;
}

#pragma mark-

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if(![view.annotation isKindOfClass:[MKUserLocation class]])
    {
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
