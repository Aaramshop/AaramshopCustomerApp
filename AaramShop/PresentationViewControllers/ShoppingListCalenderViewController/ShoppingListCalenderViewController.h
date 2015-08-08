//
//  ShoppingListCalenderViewController.h
//  AaramShop
//
//  Created by Approutes on 15/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "ShoppingListModel.h"
#import "ShoppingListChooseStoreModel.h"


@interface ShoppingListCalenderViewController : UIViewController<AaramShop_ConnectionManager_Delegate>

{
    
    __weak IBOutlet UIDatePicker *datePicker_;
    __weak IBOutlet UIView *viewDatePicker;
    __weak IBOutlet NSLayoutConstraint *viewPickerBottomConstraint;
    __weak IBOutlet UIButton *btnStartDate;
    __weak IBOutlet UIButton *btnEndDate;
    __weak IBOutlet UIButton *btnRepeat;
    
    UIButton *btnReference;
    
    __weak IBOutlet UILabel *lblStartDate;
    __weak IBOutlet UILabel *lblEndDate;
    __weak IBOutlet UILabel *lblRepeat;

    
    __weak IBOutlet NSLayoutConstraint *pickerRepeatBottomConstraint;
    __weak IBOutlet UIView *viewRepeatPickerView;
    __weak IBOutlet UISwitch *reminderSwitch;
    
    __weak IBOutlet UIButton *btnRemoveReminder;

    
    NSArray *arrPickerData;
    
    EKEventStore *store;
    
}

@property(nonatomic,strong) AaramShop_ConnectionManager *aaramShop_ConnectionManager;
//@property(nonatomic,strong) NSString *storeId;
@property(nonatomic,strong) ShoppingListModel *shoppingListModel;
@property(nonatomic,strong) ShoppingListChooseStoreModel *selectedStoreModel;


- (IBAction)toolRepeatCancelACtion:(id)sender;

- (IBAction)toolRepeatDoneAction:(UIBarButtonItem *)sender;

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender;
- (IBAction)toolBarDoneAction:(UIBarButtonItem *)sender;
- (IBAction)btnStartDateAction:(UIButton *)sender;
- (IBAction)btnEndDateAction:(id)sender;
- (IBAction)btnRepeatAction:(id)sender;
- (IBAction)reminderSwitchValuChanged:(UISwitch *)sender;
@end
