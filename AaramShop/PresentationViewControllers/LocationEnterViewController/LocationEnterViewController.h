//
//  LocationEnterViewController.h
//  AaramShop
//
//  Created by Approutes on 08/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationEnterViewController : UIViewController<UITextFieldDelegate,MKMapViewDelegate>
{
   __weak IBOutlet UITextField *txtFLocation;
    __weak IBOutlet MKMapView *mapViewLocation;
    NSMutableArray *arrShopsData;
}
- (IBAction)btnDoneClick:(UIButton *)sender;
- (IBAction)btnEditClick:(UIButton *)sender;

@end
