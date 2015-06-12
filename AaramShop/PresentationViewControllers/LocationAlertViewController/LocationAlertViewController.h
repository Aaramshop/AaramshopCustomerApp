//
//  LocationAlertViewController.h
//  AaramShop
//
//  Created by Approutes on 16/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKKeyboardAvoidingScrollView.h"
@protocol LocationAlertViewControllerDelegate <NSObject>

-(void)saveAddress;
@end



@interface LocationAlertViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    
    __weak IBOutlet UIButton *dropDownBtn;
    UIPickerView *picker;
    __weak IBOutlet PWTextField *txtTitle;
    __weak IBOutlet UIView *subView;
    __weak IBOutlet UITextView *txtVAddress;
    NSMutableArray *dataSource;
    UIToolbar* keyBoardToolBar;
}
@property (nonatomic, retain) IBOutlet AKKeyboardAvoidingScrollView *scrollView;
@property(nonatomic,strong) NSString *strAddress;
@property(nonatomic,weak) id<LocationAlertViewControllerDelegate> delegate;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnDropDown:(id)sender;



@end
