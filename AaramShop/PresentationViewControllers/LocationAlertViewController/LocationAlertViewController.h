//
//  LocationAlertViewController.h
//  AaramShop
//
//  Created by Approutes on 16/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationAlertViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    
    __weak IBOutlet UIButton *dropDownBtn;
    UIPickerView *picker;
    __weak IBOutlet PWTextField *txtTitle;
    __weak IBOutlet UIView *subView;
    __weak IBOutlet UIView *viewBackAlert;
    NSMutableArray *dataSource;
    UIToolbar* keyBoardToolBar;
}
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnDropDown:(id)sender;



@end
