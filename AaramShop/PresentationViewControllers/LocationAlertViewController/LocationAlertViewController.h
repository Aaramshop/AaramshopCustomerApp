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
@protocol LocationAlertViewControllerDelegate <NSObject>

-(void)saveAddress;
@end



@interface LocationAlertViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
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
    //    __weak IBOutlet UIButton *dropDownBtn;
    //    UIPickerView *picker;
    //    __weak IBOutlet PWTextField *txtTitle;
    //    __weak IBOutlet UITextView *txtVAddress;
    //    UIToolbar* keyBoardToolBar;

//    NSMutableArray *dataSource;
}
@property (nonatomic, retain) IBOutlet AKKeyboardAvoidingScrollView *scrollView;
@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;
//@property(nonatomic,strong) NSString *strAddress;
@property(nonatomic,assign) CLLocationCoordinate2D cordinatesLocation;
@property(nonatomic,strong) AddressModel *objAddressModel;
@property(nonatomic,weak) id<LocationAlertViewControllerDelegate> delegate;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSave:(id)sender;
//- (IBAction)btnDropDown:(id)sender;

- (IBAction)btnActionClicked:(UIButton *)sender;


@end
