//
//  MapViewController.h
 
//
//  Created by Shakir Approutes on 23/10/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CLocation.h"
#import "CAnnotation.h"

@interface MapViewController : UIViewController<MKMapViewDelegate,MKAnnotation,CLLocationManagerDelegate>
{
    IBOutlet  MKMapView *mMapView;
    IBOutlet UISegmentedControl *segment;
    CLLocationManager * locationManager;
    CAnnotation * currAnnotation;
    CLLocation *currLocation;
     NSString * CurrAddress;
    CLGeocoder * GeoCoder;
    IBOutlet  UILabel *lblState;
    IBOutlet  UILabel *lblCountry;
    MKPlacemark * mPlaceMark;
    IBOutlet UIActivityIndicatorView *mActivityIndicator;

    
}
@property(nonatomic,strong)CLocation *SelectedLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

-(IBAction)dogoBackScreen:(UIButton *)inSender;
-(IBAction)doSelectMatTypeSegment:(UISegmentedControl *)inSender;

@end
