//
//  PaymentViewController.m
//  AaramShop
//
//  Created by Arbab Khan on 22/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PaymentViewController.h"
#import "ProductsModel.h"
#import "AddressModel.h"

#define kBtnDone   33454
#define kBtnCancel 33455


static NSString *strCollectionItems = @"collectionItems";

@interface PaymentViewController ()
{
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    AppDelegate *appDel;
    BOOL isPickerOpen;
    NSString *strDeliveryDate;
    NSString *strSelectSlot;
    NSMutableArray *arrSelectedLastMinPick;
    NSString *strSelectAddress;
    NSString *strSelectedUserAddress_Id;
}
@end

@implementation PaymentViewController
@synthesize strStore_Id,strTotalPrice,arrSelectedProducts,ePickerType;
- (void)viewDidLoad {
    [super viewDidLoad];
    appDel = APP_DELEGATE;
    [self setNavigationBar];
    isPickerOpen = NO;
    ePickerType = enPickerSlots;
    strDeliveryDate = @"Immediate";
    strSelectSlot = @"Select Slot";
    strSelectAddress = @"Select Address";
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
    aaramShop_ConnectionManager.delegate = self;
    arrAddressData = [[NSMutableArray alloc] init];
    arrLastMinPick = [[NSMutableArray alloc]init];
    arrDeliverySlot = [[NSMutableArray alloc]init];
    arrSelectedLastMinPick = [[NSMutableArray alloc]init];
    tblView.sectionFooterHeight= 0.0;
    tblView.sectionHeaderHeight = 0.0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createDataToGetPaymentPageData];
    [self designDatePicker];
    [self designToolBar];
    [self designPickerViewSlots];
}
-(void)designDatePicker
{
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+216, [UIScreen mainScreen].bounds.size.width, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setMinimumDate:[NSDate date]];
    [appDel.window addSubview:datePicker];
}
-(void)designPickerViewSlots
{
    pickerViewSlots = [[UIPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+216, [UIScreen mainScreen].bounds.size.width, 216)];
    pickerViewSlots.delegate = self;
    pickerViewSlots.dataSource = self;
    pickerViewSlots.backgroundColor=[UIColor whiteColor];
    pickerViewSlots.clipsToBounds=YES;
    pickerViewSlots.showsSelectionIndicator = YES;
    [appDel.window addSubview:pickerViewSlots];
}
-(void)createDataForCheckout
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:strStore_Id forKey:kStore_id];
    AddressModel *objAddress = [arrAddressData objectAtIndex:0];
    [dict setObject:objAddress.user_address_id forKey:kUser_address_id];
    
    if (arrSelectedLastMinPick.count>0) {
        [arrSelectedProducts addObjectsFromArray:arrSelectedLastMinPick];
    }
    NSArray *arrayProductId = [arrSelectedProducts valueForKey:kProduct_id];
    NSString *strProductId = [arrayProductId componentsJoinedByString:@","];
    [dict setObject:strProductId forKey:@"product_ids"];
    
    arrayProductId = [arrSelectedProducts valueForKey:kProduct_sku_id];
    NSString *strProductSKUId = [arrayProductId componentsJoinedByString:@","];
    [dict setObject:strProductSKUId forKey:@"product_sku_ids"];
    
    arrayProductId = [arrSelectedProducts valueForKey:kProduct_price];
    NSString *strProductPrice = [arrayProductId  componentsJoinedByString:@","];
    [dict setObject:strProductPrice forKey:@"product_prices"];
    
    
    arrayProductId = [arrSelectedProducts valueForKey:@"strCount"];
    NSString *strProductQTY = [arrayProductId componentsJoinedByString:@","];
    [dict setObject:strProductQTY forKey:@"product_qtys"];
    
    UITableViewCell *cell = (UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];

    UIButton *btnSlot = (UIButton *)[cell.contentView viewWithTag:302];
    
    if ([strDeliveryDate isEqualToString:@"Immediate" ]) {
        strDeliveryDate = [appDel getDateAndFromString:nil andDate:[NSDate date] needSting:YES dateFormat:DATE_FORMATTER_yyyy_mm_dd];
    }
    [dict setObject:strDeliveryDate forKey:@"delivery_date"];
    [dict setObject:btnSlot.titleLabel.text forKey:@"delivery_slot"];
    [dict setObject:strTotalPrice forKey:@"total_amount"];
    [dict setObject:@"0" forKey:@"total_discount"];
    [dict setObject:@"0.0.0.0" forKey:@"ip_address"];
    [dict setObject:@"0" forKey:@"coupon_code"];
    [self callWebServiceForCheckout:dict];
}
-(void)callWebServiceForCheckout:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kcheckoutURL withInput:aDict withCurrentTask:TASK_CHECKOUT andDelegate:self ];
    
}

-(void)createDataToGetDeliverySlots
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict removeObjectForKey:kUserId];
    NSString *strDate = [appDel getDateAndFromString:nil andDate:datePicker.date needSting:YES dateFormat:DATE_FORMATTER_yyyy_mm_dd];
    [dict setObject:strDate forKey:kDate];
    [self callWebServiceToGetDeliverySlots:dict];
}
-(void)callWebServiceToGetDeliverySlots:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:KGetDeliverySlotURL withInput:aDict withCurrentTask:TASK_GET_DELIVERY_SLOTS andDelegate:self ];

}
-(void)createDataToGetPaymentPageData
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:strStore_Id forKey:kStore_id];
    [dict setObject:[NSString stringWithFormat:@"%f",appDel.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDel.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    [self callWebServiceToGetPaymentPageData:dict];
}
-(void)callWebServiceToGetPaymentPageData: (NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kGetPaymentPageDataURL withInput:aDict withCurrentTask:TASK_GET_PAYMENT_PAGE_DATA andDelegate:self ];
}
- (void)responseReceived:(id)responseObject
{
    [AppManager stopStatusbarActivityIndicator];
    if(aaramShop_ConnectionManager.currentTask == TASK_GET_PAYMENT_PAGE_DATA)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            [self parsePaymentPageData:[responseObject objectForKey:@"payment_page_info"]];
        }
    }
    else if(aaramShop_ConnectionManager.currentTask == TASK_GET_DELIVERY_SLOTS)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            NSLog(@"VALUE = %@",responseObject);
            [self parseGetDeliverySlots:responseObject];
        }
    }
    else if(aaramShop_ConnectionManager.currentTask == TASK_CHECKOUT)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }

}
-(void)parseGetDeliverySlots:(NSDictionary *)responseObject
{
    NSArray *arrDeliverySlotTemp = [responseObject objectForKey:@"delivery_slot"];
    [arrDeliverySlot removeAllObjects];
    for (NSDictionary *dictDeliverySlots in arrDeliverySlotTemp) {
        NSMutableDictionary *dictSlots = [[NSMutableDictionary alloc]init];
        [dictSlots setObject:[dictDeliverySlots objectForKey:@"slot"] forKey:@"slot"];
        [arrDeliverySlot addObject:dictSlots];
    }
    strSelectSlot = @"Select Slot";
    [tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didFailWithError:(NSError *)error
{
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
#pragma mark - Parsing Data
- (void)parsePaymentPageData:(NSDictionary *)data
{
    NSArray *arrDeliverySlotTemp = [data objectForKey:@"delivery_slot"];
    NSArray *arrLastMinPickTemp = [data objectForKey:@"last_minute_pick"];
    NSArray *arrAddressTemp = [data objectForKey:@"address"];
    
    for (NSDictionary *dictAddress in arrAddressTemp) {

        AddressModel *objAddressModel = [[AddressModel alloc]init];
        objAddressModel.user_address_id = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kUser_address_id]];
        objAddressModel.title = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kUser_address_title]];
        objAddressModel.state = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kState]];
        objAddressModel.city = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kCity]];
        objAddressModel.pincode = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kPincode]];
        objAddressModel.locality = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kLocality]];
        objAddressModel.address = [NSString stringWithFormat:@"%@",[dictAddress objectForKey:kAddress]];

        [arrAddressData addObject:objAddressModel];
    }
    for (NSDictionary *dictDeliverySlots in arrDeliverySlotTemp) {
        NSMutableDictionary *dictSlots = [[NSMutableDictionary alloc]init];
        [dictSlots setObject:[dictDeliverySlots objectForKey:@"slot"] forKey:@"slot"];
        [arrDeliverySlot addObject:dictSlots];
    }

    for (NSDictionary *dictProducts in arrLastMinPickTemp) {
        
        ProductsModel *objProducts = [[ProductsModel alloc]init];
        objProducts.product_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_id]];
        objProducts.product_image = [NSString stringWithFormat:@"%@",[[dictProducts objectForKey:kProduct_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        objProducts.product_name = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_name]];
        objProducts.product_price = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_price]];
        objProducts.product_sku_id = [NSString stringWithFormat:@"%@",[dictProducts objectForKey:kProduct_sku_id]];
        objProducts.isSelected = NO;
        [arrLastMinPick addObject:objProducts];
    }
    strPopUpMessage = [data objectForKey:kPopup_message];
    [tblView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
-(void)setNavigationBar
{
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
    titleView.text = @"Payment";
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    self.navigationItem.titleView = _headerTitleSubtitleView;
    
    UIImage *imgBack = [UIImage imageNamed:@"backBtn"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake( -10, 0, 30, 30);
    
    [backBtn setImage:imgBack forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
}
-(void)backBtn
{
    [self showOptionPatch:NO];
    [self showPickerView:NO];
    [pickerViewSlots removeFromSuperview];
    [datePicker removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return 130;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 78;
            break;
        case 3:
            return 87;
            break;
        case 4:
            return 117;
            break;
            
        default:
            return 0;
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 1:
        case 2:
        {
            return CGFLOAT_MIN;
        }
            break;
        case 3:
        case 4:
        {
            return 10;
        }
        default:
            return CGFLOAT_MIN;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellIdentifier = @"TotalPriceCell";
            
            TotalPriceTableCell *cell = [self createCellTotalPrice:cellIdentifier];
            cell.indexPath = indexPath;
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:strTotalPrice,kTotalPrice,strTotalPrice,kSubTotalPrice,@"0",kDeliveryCharges,@"0",kDiscount, nil];
            tableCell = cell;
            [cell updateCellWithData:dict];
        }
            break;
        case 1:
        {
            
            static NSString *cellIdentifier = @"ApplyBtnCell";
            
            tableCell = [self createCell:cellIdentifier];
            
            UIButton *applyCoupon = (UIButton *)[tableCell.contentView viewWithTag:201];
            [applyCoupon addTarget:self action:@selector(applyCouponClick) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case 2:
        {
            static NSString *cellIdentifier = @"DateTimeSlotCell";
            
            tableCell = [self createCell:cellIdentifier];
            
            UIButton *btnImmdediate = (UIButton *)[tableCell.contentView viewWithTag:301];
            
            UIButton *btnSlot = (UIButton *)[tableCell.contentView viewWithTag:302];
            
            [btnImmdediate setTitle:strDeliveryDate forState:UIControlStateNormal];
            
            [btnSlot setTitle:strSelectSlot forState:UIControlStateNormal];
            
            [btnSlot addTarget:self action:@selector(btnSlotClick) forControlEvents:UIControlEventTouchUpInside];
            
            [btnImmdediate addTarget:self action:@selector(btnImmdediateClick) forControlEvents:UIControlEventTouchUpInside];

        }
            break;
            
        case 3:
        {
            static NSString *cellIdentifier = @"AddressCell";
            
            tableCell = [self createCell:cellIdentifier];
            
            UILabel *lblTitle = (UILabel *)[tableCell.contentView viewWithTag:401];
            lblTitle.text = strSelectAddress;
        }
            break;
        case 4:
        {
            
            static NSString *cellIdentifier = @"PickCollectionCell";
            
            UITableViewCell *cell = (UITableViewCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
            
            UILabel *lblLastPick = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 21)];
            lblLastPick.textColor = [UIColor blackColor];
            lblLastPick.font = [UIFont fontWithName:kRobotoRegular size:13.0];
            lblLastPick.text = @"Last minute pick";
            [cell.contentView addSubview:lblLastPick];
            
            UICollectionViewFlowLayout *flowLayout1= [[UICollectionViewFlowLayout alloc] init];
            flowLayout1.minimumLineSpacing = 0.0;
            flowLayout1.minimumInteritemSpacing = 0.0f;
            [flowLayout1  setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            
            UICollectionView *collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 22, [UIScreen mainScreen].bounds.size.width-20, 85) collectionViewLayout:flowLayout1];
            collectionV.allowsSelection=YES;
            collectionV.alwaysBounceHorizontal = YES;
            [collectionV setDataSource:self];
            [collectionV setDelegate:self];
            
            [collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:strCollectionItems];
            collectionV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
            
            collectionV.backgroundColor = [UIColor clearColor];
            collectionV.pagingEnabled = YES;
            [collectionV reloadData];
            [cell.contentView addSubview:collectionV];
            tableCell = cell;
            
        }
            break;
        default:
            break;
    }
    return tableCell;
}
-(UITableViewCell*)createCell:(NSString*)cellIdentifier{
    UITableViewCell *cell = (UITableViewCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}
-(TotalPriceTableCell*)createCellTotalPrice:(NSString*)cellIdentifier{
    TotalPriceTableCell *cell = (TotalPriceTableCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TotalPriceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}
-(PickLastTableCell*)createCellPick:(NSString*)cellIdentifier{
    PickLastTableCell *cell = (PickLastTableCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PickLastTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tblView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    if (selectedIndexPath == indexPath) {
        ePickerType = enPickerAddress;
        [self showDatePickerView:NO];
        [self showOptionPatch:YES];
        [self showOptionPatch:YES];
        [pickerViewSlots reloadAllComponents];
    }
}

#pragma mark - UIPickerView Delegate

#pragma mark-


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsNum = 0;
    if (ePickerType == enPickerAddress) {
        rowsNum = arrAddressData.count;
    }
    else
        rowsNum = arrDeliverySlot.count;
    return rowsNum;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strTitle =@"";
    if (ePickerType == enPickerAddress) {
        
        AddressModel *objAddressModel = [arrAddressData objectAtIndex:row];
        strTitle =  objAddressModel.title;
    }
    else
    {
        NSDictionary *dict = [arrDeliverySlot objectAtIndex:row];
        strTitle = [dict objectForKey:@"slot"];
    }
    return strTitle;
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setSlot];
}
-(void)setSlot
{
    if (ePickerType == enPickerAddress) {
        
        AddressModel *objaddressModel = [arrAddressData objectAtIndex:[pickerViewSlots selectedRowInComponent:0]];
        UITableViewCell *cell = (UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        
        UILabel *lblTitle = (UILabel *)[cell.contentView viewWithTag:401];
        strSelectAddress = objaddressModel.address;
        lblTitle.text = strSelectAddress;
        strSelectedUserAddress_Id = objaddressModel.user_address_id;
    }
    else
    {
        NSDictionary *dict = [arrDeliverySlot objectAtIndex:[pickerViewSlots selectedRowInComponent:0]];
        UITableViewCell *cell = (UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        UIButton *btnSlot = (UIButton *)[cell.contentView viewWithTag:302];
        strSelectSlot = [dict objectForKey:@"slot"];
        [btnSlot setTitle:strSelectSlot forState:UIControlStateNormal];
    }
}


#pragma mark - CollectionView Delegates & DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrLastMinPick.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeCell=CGSizeZero;
    sizeCell=CGSizeMake(([UIScreen mainScreen].bounds.size.width)/3-2, 85);
    return sizeCell;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell ;
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:strCollectionItems forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    
    ProductsModel *objProductModel =[arrLastMinPick objectAtIndex:indexPath.row];
    
    UIImageView *imgProfilePic = [[UIImageView alloc]initWithFrame:CGRectMake( ((([UIScreen mainScreen].bounds.size.width)/3-2)-56)/2, 3, 56, 56)];
    imgProfilePic.backgroundColor = [UIColor clearColor];
    
    
    UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 58, ([UIScreen mainScreen].bounds.size.width)/3-2, 21)];
    lblPrice.textColor = [UIColor redColor];
    lblPrice.textAlignment = NSTextAlignmentCenter;
    lblPrice.font = [UIFont fontWithName:kRobotoRegular size:11.0];
    lblPrice.text=objProductModel.product_price;
    
    [imgProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objProductModel.product_image]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];
    
    
    [cell.contentView addSubview:imgProfilePic];
    [cell.contentView addSubview:lblPrice];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ProductsModel *objProduct = [arrLastMinPick objectAtIndex:indexPath.row];
    objProduct.isSelected = !objProduct.isSelected;
    
    if (objProduct.isSelected) {
        objProduct.strCount = [NSString stringWithFormat:@"1"];
        int selectedPrice =  1 * [objProduct.product_price intValue];
        
        int priceValue = [strTotalPrice intValue];
        priceValue+=selectedPrice;
        strTotalPrice = [NSString stringWithFormat:@"%d",priceValue];

        [arrSelectedLastMinPick addObject:objProduct];
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (objProduct.isSelected == NO)
    {
        int selectedPrice =  1 * [objProduct.product_price intValue];

        int priceValue = [strTotalPrice intValue];
        priceValue-=selectedPrice;
        strTotalPrice = [NSString stringWithFormat:@"%d",priceValue];
        [arrSelectedLastMinPick removeObject:objProduct];
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}



#pragma mark - Button Actions

-(void)applyCouponClick
{
    
}
-(void)btnImmdediateClick
{
    [self showOptionPatch:YES];
    [self showDatePickerView:YES];
}
-(void)btnSlotClick
{
    isPickerOpen = YES;
    ePickerType = enPickerSlots;
    [self showPickerView:YES];
    [self showOptionPatch:YES];
    [pickerViewSlots reloadAllComponents];
}
- (IBAction)btnPayClick:(UIButton *)sender {
    
    if ([strSelectSlot isEqualToString:@"Select Slot"]) {
        [Utils showAlertView:kAlertTitle message:@"Please select Slot" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else if([strSelectAddress isEqualToString:@"Select Address"])
    {
        [Utils showAlertView:kAlertTitle message:@"Please select Address For Delivery" delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];

    }
    else
    [self createDataForCheckout];
}

-(void)designToolBar
{
    if (keyBoardToolBar==nil)
    {
        keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 630 , [UIScreen mainScreen].bounds.size.width, 44)];
        keyBoardToolBar.backgroundColor = [UIColor clearColor];
        
        UIBarButtonItem *tempDistance = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarBtnClicked:)];
        btnDone.tintColor = [UIColor blueColor];
        btnDone.tag = kBtnDone;
        
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarBtnClicked:)];
        btnCancel.tintColor = [UIColor blueColor];
        btnCancel.tag = kBtnCancel;

        keyBoardToolBar.items = [NSArray arrayWithObjects:btnDone,tempDistance,btnCancel, nil];
    }
    else
    {
        [keyBoardToolBar removeFromSuperview];
    }
    
    [self.view addSubview:keyBoardToolBar];
    [self.view bringSubviewToFront:keyBoardToolBar];
}

-(void)toolBarBtnClicked:(UIBarButtonItem*)sender
{
    switch (sender.tag) {
        case kBtnCancel:
            [self showOptionPatch:NO];
            [self showDatePickerView:NO];
            [self showPickerView:NO];

            break;
        case kBtnDone:
        {
            UITableViewCell *cell = (UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            UIButton *btnImmdediate = (UIButton *)[cell.contentView viewWithTag:301];

            strDeliveryDate = [appDel getDateAndFromString:nil andDate:datePicker.date needSting:YES dateFormat:DATE_FORMATTER_yyyy_mm_dd];
            [btnImmdediate setTitle:strDeliveryDate forState:UIControlStateNormal];
            [self showOptionPatch:NO];
            [self showDatePickerView:NO];

            if (isPickerOpen) {
                [self setSlot];
                [self showPickerView:NO];
            }
            else
            {
                if (![datePicker.date isEqualToDate:[NSDate date]]) {
                    [self createDataToGetDeliverySlots];
                }

            }
        }
            break;
    
        default:
            break;
    }
}
-(void)showOptionPatch:(BOOL)isShow
{
    if(isShow)
    {
        [UIView animateWithDuration:0.29 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
         {
             keyBoardToolBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-216-44,[UIScreen mainScreen].bounds.size.width, 44 );

             
         }completion:nil];
        
    }
    else{
        [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^
         {
             keyBoardToolBar.frame = CGRectMake(0, 1000, [UIScreen mainScreen].bounds.size.width, 40);
         }
         
                         completion:nil];
    }
}
#pragma mark Show and Hide Picker View

-(void)showDatePickerView:(BOOL)isShow
{
    if(isShow)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            datePicker.frame = CGRectMake(0,[[UIScreen mainScreen]bounds].size.height-216, [[UIScreen mainScreen]bounds].size.width, 216);
        } completion:nil];
        
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             datePicker.frame = CGRectMake(0, [[UIScreen mainScreen]bounds].size.height+216, [[UIScreen mainScreen]bounds].size.width,216);
                         }
                         completion:nil];
    }
}


-(void)showPickerView:(BOOL)isShow
{
    if(isShow)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            pickerViewSlots.frame = CGRectMake(0,[[UIScreen mainScreen]bounds].size.height-216, [[UIScreen mainScreen]bounds].size.width, 216);
        } completion:nil];
        
    }
    else
    {
        isPickerOpen = NO;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             pickerViewSlots.frame = CGRectMake(0, [[UIScreen mainScreen]bounds].size.height+216, [[UIScreen mainScreen]bounds].size.width,216);
                         }
                         completion:nil];
    }
}



#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
