//
//  PalsFriendTableViewCell.m
//  SocialParty
//
//  Created by Shakir Approutes on 30/05/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Foursquare2.h"
#import "FSVenue.h"
#import "FSConverter.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CAnnotation.h"
@protocol ShareWithLocationDelegate <NSObject>
-(void) shareSelectedLocation:(FSVenue*)venue;
@end


@interface ShareLocationViewController : UIViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,MKAnnotation,MKMapViewDelegate>
{
    NSMutableArray *arrLocationName;
    NSMutableArray *arrLocationAddress;
    IBOutlet UITextField *txtSearch;
    IBOutlet UITableView *tblLocation;
    IBOutlet UIButton *btnRefresh;
    IBOutlet UIButton *btnBack;
    IBOutlet MKMapView * mMapView;
    FSVenue *selectedVenue;
    FSVenue *convertedCurrLocation;
    FSVenue *searchNotFoundVenue;


    NSIndexPath *refernceIndexPath;
}
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *ActivityIncator;
@property (strong, nonatomic) CLGeocoder * GeoCoder;
@property (strong, nonatomic) NSString * CurrAddress;
@property (strong, nonatomic) CAnnotation * CurrAnnotation;


@property (strong, nonatomic) FSVenue *selected;
@property (strong, nonatomic) NSMutableArray *nearbyVenues;
@property (strong, nonatomic) NSMutableArray *searchedNearbyVenues;
@property (strong, nonatomic) NSMutableArray *currentlyContainVenues;

@property (assign, nonatomic) BOOL isSearching;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, weak) id <ShareWithLocationDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) CLLocation * currentLocation;
@end
