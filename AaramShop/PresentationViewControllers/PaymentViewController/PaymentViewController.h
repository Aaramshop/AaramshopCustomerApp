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
typedef enum
{
    enPickerSlots,
    enPickerAddress
}enPickerType;


@interface PaymentViewController : UIViewController<AaramShop_ConnectionManager_Delegate,UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak IBOutlet UITableView *tblView;
    NSMutableArray *arrAddressData;
    NSMutableArray *arrLastMinPick;
    NSString *strPopUpMessage;
    NSMutableArray *arrDeliverySlot;
    UIDatePicker *datePicker;
    UIToolbar *keyBoardToolBar;
    UIPickerView *pickerViewSlots;
}
@property(nonatomic,strong) NSString *strStore_Id;
@property(nonatomic,strong) NSString *strTotalPrice;
@property(nonatomic,strong) NSMutableArray *arrSelectedProducts;
@property(nonatomic,assign) enPickerType ePickerType;

- (IBAction)btnPayClick:(UIButton *)sender;

@end
