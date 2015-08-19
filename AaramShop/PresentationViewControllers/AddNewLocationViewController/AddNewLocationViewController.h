//
//  AddNewLocationViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 18/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddNewLocationViewDelegate<NSObject>
-(void)gotAddress:(CLLocationDegrees)lat longitude:(CLLocationDegrees)longitude;
@end

@interface AddNewLocationViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
	__weak IBOutlet PWTextField *txtAddress;
	__weak IBOutlet UIView *subView;
	__weak IBOutlet PWTextField *txtState;
	__weak IBOutlet PWTextField *txtCity;
	__weak IBOutlet PWTextField *txtLocality;
	__weak IBOutlet PWTextField *txtPinCode;
	__weak IBOutlet UIButton *searchBtn;
}
@property(nonatomic,weak) id<AddNewLocationViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet AKKeyboardAvoidingScrollView *scrollView;

- (IBAction)backBtnAction:(id)sender;
- (IBAction)btnSearch:(id)sender;


@end
