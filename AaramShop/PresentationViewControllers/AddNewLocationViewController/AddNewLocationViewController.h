//
//  AddNewLocationViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 18/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDAnnotationView.h"

@interface AddNewLocationViewController : UIViewController<UIGestureRecognizerDelegate,MKMapViewDelegate,AaramShop_ConnectionManager_Delegate>
{
	__weak IBOutlet PWTextField *txtState;
	__weak IBOutlet PWTextField *txtCity;
	__weak IBOutlet PWTextField *txtLocality;
	__weak IBOutlet PWTextField *txtPinCode;
	UIButton *backBtn;
	__weak IBOutlet UIButton *continueBtn;
	__weak IBOutlet MKMapView *mapViewLocation;
//	DXAnnotationView *annotationView;
//	DXAnnotation *annotation1;
}
@property (weak, nonatomic) IBOutlet AKKeyboardAvoidingScrollView *scrollView;
- (IBAction)btnContinue:(id)sender;
@end
