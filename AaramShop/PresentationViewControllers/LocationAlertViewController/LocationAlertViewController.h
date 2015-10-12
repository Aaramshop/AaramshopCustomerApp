//
//  LocationAlertViewController.h
//  AaramShop
//
//  Created by Approutes on 16/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKKeyboardAvoidingScrollView.h"
#import "AddressModel.h"
#import "PostAutoSuggestionTableViewController.h"
#import "FSVenue.h"
#import "FSConverter.h"
#import <CoreLocation/CoreLocation.h>


@protocol LocationAlertViewControllerDelegate <NSObject>

-(void)saveAddress;
@end



@interface LocationAlertViewController : UIViewController<AaramShop_ConnectionManager_Delegate, AutoSuggestionDelegate,CLLocationManagerDelegate>
{
    __weak IBOutlet UIView *subView;
        __weak IBOutlet PWTextField *txtAddress;
        __weak IBOutlet PWTextField *txtState;
        __weak IBOutlet PWTextField *txtCity;
        __weak IBOutlet PWTextField *txtLocality;
        __weak IBOutlet PWTextField *txtPinCode;
        __weak IBOutlet PWTextField *txtTitle;
    __weak IBOutlet UIButton *btnHome;
    __weak IBOutlet UIButton *btnOffice;
    __weak IBOutlet UIButton *btnOthers;
    __weak IBOutlet UIButton *btnSave;
    
    PostAutoSuggestionTableViewController *postAutoSuggestionView;
    


    
}
@property (nonatomic, retain) IBOutlet AKKeyboardAvoidingScrollView *scrollView;
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;

@property(nonatomic,assign) CLLocationCoordinate2D cordinatesLocation;
@property(nonatomic,strong) AddressModel *objAddressModel;
@property(nonatomic,weak) id<LocationAlertViewControllerDelegate> delegate;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSave:(id)sender;

- (IBAction)btnActionClicked:(UIButton *)sender;



//@property (strong, nonatomic) NSMutableArray *searchedNearbyVenues;
//@property (assign, nonatomic) BOOL isSearching;
//@property (nonatomic, strong) CLLocation * currentLocation;
//@property (strong, nonatomic) CLLocationManager *locationManager;



@end
