//
//  LocationEnterViewController.h
//  AaramShop
//
//  Created by Approutes on 08/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationAlertViewController.h"
#import "AddNewLocationViewController.h"
@protocol LocationEnterViewControllerDelegate <NSObject>

-(void)saveAddressInLocationEnter;
@end

typedef void (^AddAddressCompletion)(void);



@interface LocationEnterViewController : UIViewController<UITextFieldDelegate,MKMapViewDelegate,AaramShop_ConnectionManager_Delegate,LocationAlertViewControllerDelegate,CLLocationManagerDelegate,AddNewLocationViewDelegate>
{
   __weak IBOutlet UITextField *txtFLocation;
    __weak IBOutlet MKMapView *mapViewLocation;
    NSMutableArray *arrShopsData;
	__weak IBOutlet UIButton *btnCancel;
	CLGeocoder *geocoder;
}
@property(nonatomic,weak) id<LocationEnterViewControllerDelegate> delegate;

@property (nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager ;
@property (nonatomic, copy) AddAddressCompletion addAddressCompletion;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong)	AddNewLocationViewController *addNewLocationView;

- (IBAction)btnCancelClicked:(id)sender;

- (IBAction)btnDoneClick:(UIButton *)sender;
- (IBAction)btnEditClick:(UIButton *)sender;

@end
