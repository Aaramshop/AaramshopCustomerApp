//
//  ShoppingListCalenderViewController.m
//  AaramShop
//
//  Created by Approutes on 15/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ShoppingListCalenderViewController.h"

@interface ShoppingListCalenderViewController ()

@end

@implementation ShoppingListCalenderViewController
@synthesize aaramShop_ConnectionManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBar];
    
    
    store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent
                          completion:^(BOOL granted, NSError *error) {
                              // Handle not being granted permission
                          }];
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate= self;
    
    arrPickerData=@[@"Select",@"Every day",@"30 days",@"15 days",@"7 days"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark Navigation
-(void)setNavigationBar
{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 150, 44);
    UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = NO;
    
    CGRect titleFrame = CGRectMake(0,0, 150, 44);
    UILabel* titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:kRobotoRegular size:15];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"Calender";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.bounds = CGRectMake( 0, 0, 30, 30 );
    [btnBack setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *batBtnBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:batBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
    
    UIImage *imgDone = [UIImage imageNamed:@"doneBtn"];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.bounds = CGRectMake( -10, 0, 50, 30);
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:13.0]];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:imgDone forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(btnDoneClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnDone = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
    NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnDone, nil];
    self.navigationItem.rightBarButtonItems = arrBtnsRight;
    
}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)btnDoneClicked
{
    
    if (lblStartDate.text.length==0) {
        [Utils showAlertView:kAlertTitle message:@"Please set Start date" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        return;
    }
    if (lblEndDate.text.length==0) {
        [Utils showAlertView:kAlertTitle message:@"Please set End date" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        return;
    }
    if (lblRepeat.text.length==0) {
        [Utils showAlertView:kAlertTitle message:@"Please set Repeat" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        return;
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    NSDate *startDate = [dateFormatter dateFromString:lblStartDate.text];
    NSDate *endDate = [dateFormatter dateFromString:lblEndDate.text];
    
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:_shoppingListId forKey:@"shoppingListId"];
    [dict setObject:@"1" forKey:@"store_id"];
    [dict setObject:[NSString stringWithFormat:@"%.0f",[startDate timeIntervalSince1970]] forKey:@"start_date"];
    [dict setObject:[NSString stringWithFormat:@"%.0f",[endDate timeIntervalSince1970]] forKey:@"end_date"];
    
    
    NSString *strRepeatDays=@"";
    if ([lblRepeat.text isEqualToString:@"Every day"])
    {
        strRepeatDays=@"1";
        [dict setObject:@"0" forKey:@"frequency"];
    }else if ([lblRepeat.text isEqualToString:@"30 days"])
    {
        strRepeatDays=@"30";
        [dict setObject:@"30" forKey:@"frequency"];
    }else if ([lblRepeat.text isEqualToString:@"15 days"])
    {
        strRepeatDays=@"15";
        [dict setObject:@"15" forKey:@"frequency"];
    }else if ([lblRepeat.text isEqualToString:@"7 days"])
    {
        strRepeatDays=@"7";
        [dict setObject:@"7" forKey:@"frequency"];
    }
    
    
    [dict setObject:reminderSwitch.isOn?@"1":@"0" forKey:@"reminder"];
    
    [self callWebServiceToGetProductsList:dict];
    
    if (reminderSwitch.isOn && [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusAuthorized) {
        
//        EKEvent *event = [EKEvent eventWithEventStore:store];
//        event.title = !_shoppingListName?_shoppingListName:@"My Shopping List";
//        event.startDate = startDate; //today
//        event.endDate = endDate;  
//        event.calendar = [store defaultCalendarForNewEvents];
//        NSError *err = nil;
//        
//
//        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
//
        
        EKReminder *reminder = [EKReminder reminderWithEventStore:store];
        [reminder setTitle:!_shoppingListName?_shoppingListName:@"My Shopping List"];
        EKCalendar *defaultReminderList = [store defaultCalendarForNewReminders];
        
        [reminder setCalendar:defaultReminderList];
        
        EKRecurrenceRule *recurrenceRule = nil;
        
        if ([lblRepeat.text isEqualToString:@"Every day"])
        {
            strRepeatDays=@"1";
            recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 daysOfTheWeek:nil daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:nil];
        }else if ([lblRepeat.text isEqualToString:@"30 days"])
        {
            strRepeatDays=@"30";
            
            NSDate *newDate1 = [startDate dateByAddingTimeInterval:60*60*24*strRepeatDays.intValue];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newDate1];
            
            recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:1 daysOfTheWeek:nil daysOfTheMonth:@[[NSString stringWithFormat:@"%ld",(long)components.day]] monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:nil];
            
            
        }else if ([lblRepeat.text isEqualToString:@"15 days"])
        {
            strRepeatDays=@"15";
            NSDate *newDate1 = [startDate dateByAddingTimeInterval:60*60*24*strRepeatDays.intValue];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components1 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newDate1];
            NSDateComponents* components2 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:startDate];
            
            
            recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:1 daysOfTheWeek:nil daysOfTheMonth:@[[NSString stringWithFormat:@"%ld",(long)components1.day],[NSString stringWithFormat:@"%ld",(long)components2.day]] monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:nil];
        }else if ([lblRepeat.text isEqualToString:@"7 days"])
        {
            strRepeatDays=@"7";
            
            
             NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:[NSDate date]];

            recurrenceRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 daysOfTheWeek:@[[NSString stringWithFormat:@"%ld",(long)comps.weekday]] daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:nil];
        }

        
        
        reminder.recurrenceRules = [NSArray arrayWithObject:recurrenceRule];

        int daysToAdd = strRepeatDays.intValue;
        NSDate *newDate1 = [startDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate: newDate1];
        [reminder addAlarm:alarm];
        
        
        NSError *error = nil;
        BOOL success = [store saveReminder:reminder
                                    commit:YES
                                     error:&error];
        if (!success) {
            NSLog(@"Error saving reminder: %@", [error localizedDescription]);
        }
    }
    
    
}
#pragma mark - Call Webservice

-(void)callWebServiceToGetProductsList:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kURLSetShoppingListReminder withInput:aDict withCurrentTask:TASK_TO_SET_SHOPPING_LIST_REMINDER andDelegate:self ];
}


-(void) didFailWithError:(NSError *)error
{
    
    
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}


-(void) responseReceived:(id)responseObject
{
    
    
    [AppManager stopStatusbarActivityIndicator];
    
    
    switch (aaramShop_ConnectionManager.currentTask)
    {
        case TASK_TO_SET_SHOPPING_LIST_REMINDER:
        {
            
//            if ([[responseObject objectForKey:kstatus] intValue] == 1)
//            {
//                [self parseResponseData:responseObject];
//            }
//            else
//            {
                [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//            }
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark - Parse Response Data

-(void)parseResponseData:(NSDictionary *)response
{
    
    
    
}

#pragma mark -- PickerView Delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [arrPickerData count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return arrPickerData[row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    
    if (row>0) {
        NSString *strSelectedActivity = arrPickerData[row];
        [lblRepeat setText:strSelectedActivity];
    }
    
    
}

#pragma mark - picker methods
-(void)closeDatePicker{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            viewPickerBottomConstraint.constant = 0;
                        }
                     completion:nil];
}
-(void)openDatePicker{
    
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            viewPickerBottomConstraint.constant = -206;
                        }
                     completion:nil];
}
-(void)closeRepeatPicker{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            pickerRepeatBottomConstraint.constant = 0;
                        }
                     completion:nil];
}
-(void)openRepeatPicker{
    
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            pickerRepeatBottomConstraint.constant = -211;
                        }
                     completion:nil];
}
- (IBAction)toolRepeatCancelACtion:(id)sender {
    [self closeRepeatPicker];
}

- (IBAction)toolRepeatDoneAction:(UIBarButtonItem *)sender {
    [self closeRepeatPicker];
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
    NSDate *pickerDate = datePicker_.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    
    NSString *selectionString = [dateFormatter stringFromDate:pickerDate];
  
    
    if (btnReference == btnStartDate) {
        [lblStartDate setText:selectionString];
    }else if (btnReference==btnEndDate){
        [lblEndDate setText:selectionString];
    }
    
}

- (IBAction)toolBarDoneAction:(UIBarButtonItem *)sender {
    NSDate *pickerDate = datePicker_.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    
    NSString *selectionString = [dateFormatter stringFromDate:pickerDate];
    
    
    if (btnReference == btnStartDate) {
        [lblStartDate setText:selectionString];
    }else if (btnReference==btnEndDate){
        [lblEndDate setText:selectionString];
    }
      [self closeDatePicker];
}

- (IBAction)btnStartDateAction:(UIButton *)sender {
    btnReference=sender;
    [self openDatePicker];
}

- (IBAction)btnEndDateAction:(id)sender {
    btnReference=sender;
      [self openDatePicker];
}

- (IBAction)btnRepeatAction:(id)sender {
    [self openRepeatPicker];
}

- (IBAction)reminderSwitchValuChanged:(UISwitch *)sender {
}
@end
