//
//  LocationEnterViewController.h
//  AaramShop
//
//  Created by Approutes on 08/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationAlertViewController.h"

typedef void (^AddAddressCompletion)(void);



@interface LocationEnterViewController : UIViewController<UITextFieldDelegate,MKMapViewDelegate,AaramShop_ConnectionManager_Delegate,LocationAlertViewControllerDelegate>
{
   __weak IBOutlet UITextField *txtFLocation;
    __weak IBOutlet MKMapView *mapViewLocation;
    NSMutableArray *arrShopsData;
}
@property (nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager ;
@property (nonatomic, copy) AddAddressCompletion addAddressCompletion;




- (IBAction)btnDoneClick:(UIButton *)sender;
- (IBAction)btnEditClick:(UIButton *)sender;

@end
