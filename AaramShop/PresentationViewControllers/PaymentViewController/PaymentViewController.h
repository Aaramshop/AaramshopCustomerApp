//
//  PaymentViewController.h
//  AaramShop
//
//  Created by Arbab Khan on 22/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TotalPriceTableCell.h"
#import "PickLastTableCell.h"
#import "HomeSecondCustomCell.h"
#import "LocationEnterViewController.h"
#import "FeedbackViewController.h"
#import "CMPayment.h"


typedef enum
{
    enPickerSlots,
    enPickerAddress
}enPickerType;


@interface PaymentViewController : UIViewController<AaramShop_ConnectionManager_Delegate,UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,HomeSecondCustomCellDelegate,UITableViewDataSource,UITableViewDelegate,LocationEnterViewControllerDelegate>
{
    __weak IBOutlet UITableView *tblView;
    NSMutableArray *arrAddressData;
    NSMutableArray *arrLastMinPick;
    NSString *strPopUpMessage;
    NSMutableArray *arrDeliverySlot;
    UIDatePicker *datePicker;
    UIToolbar *keyBoardToolBar;
    UIPickerView *pickerViewSlots;
	LocationAlertViewController *locationAlert;
    __weak IBOutlet UIButton *btnPay;
    
	__weak IBOutlet UIView *viewOverallValueStatus;
	__weak IBOutlet UILabel *lblOverallValueStatus;
    

//    FeedbackViewController *feedBack;
}
- (IBAction)btnCrossClicked:(id)sender;
@property(nonatomic,strong) NSString *strStore_Id;
@property(nonatomic,strong) NSString *strStore_name;
@property(nonatomic,strong) NSString *strStore_image;
@property(nonatomic,strong) NSString *strTotalPrice;
@property(nonatomic,strong) NSString *strActualTotalPrice;
@property(nonatomic,strong) NSMutableArray *arrSelectedProducts;
@property(nonatomic,assign) enPickerType ePickerType;
@property (nonatomic, assign) BOOL fromCart;
@property(nonatomic,strong) FeedbackViewController *feedBack;

//+(CMPayment*)dataDictionary:(NSMutableDictionary*)dic;

- (IBAction)btnPayClick:(UIButton *)sender;

@end
