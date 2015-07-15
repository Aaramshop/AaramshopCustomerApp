//
//  HomeStoreViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeStoreViewController.h"
#import "HomeStoreDetailViewController.h"
#import "StoreModel.h"

#define kTblSuggestedStoresTag 100

@interface HomeStoreViewController ()
{
    HomeStorePopUpViewController *homeStorePopUpVwController;
    AppDelegate *appDeleg;
}
@end

@implementation HomeStoreViewController
@synthesize aaramShop_ConnectionManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    appDeleg = (AppDelegate *)APP_DELEGATE;
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;
    
    tblSuggestedStores.tag = kTblSuggestedStoresTag;
        
//    UITapGestureRecognizer *tapToHideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
//
//    [tapToHideKeyboard setNumberOfTouchesRequired:1];
//    [self.view addGestureRecognizer:tapToHideKeyboard];
    
    
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    arrSuggestedStores = [[NSMutableArray alloc]init];

    NSString *strTitle = @"Add HOME STORE";
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:strTitle];
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:15.0],NSFontAttributeName,[UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 3)];
    
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoBold size:15.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(3, strTitle.length-3)];

    lblHd.attributedText = hogan;
    
    tblSuggestedStores.layer.cornerRadius = 1.0;
    
    [self createDataToGetAddress];
}

- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    UIView *view = sender.view;
    
    
    if (view.tag == kTblSuggestedStoresTag)
    {
        return;
    }
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    [self.view endEditing:YES];
    tblSuggestedStores.hidden = YES;
}



#pragma mark - createDataToGetHomeStoreBanner
-(void)createDataToGetAddress
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
//    [dict setObject:@"26" forKey:@"userId"]; //temp
    
    [self callWebserviceToGetAddress:dict];
}
-(void)callWebserviceToGetAddress:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kGetUserAddressURL withInput:aDict withCurrentTask:TASK_GET_USER_ADDRESS andDelegate:self ];

}
-(void)createDataToGetHomeStoreBanner
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    
//    [dict setObject:@"26" forKey:@"userId"]; //temp
    
//    [dict setObject:@"28.5136781" forKey:kLatitude]; //temp
//    [dict setObject:@"77.3769436" forKey:kLongitude]; //temp
    
    
//    28°30'41"N   77°22'41"E
    
    
//    19.0176147
//    72.8561644

    
    
    [self callWebserviceToGetHomeStoreBanner:dict];
}

-(void)callWebserviceToGetHomeStoreBanner:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kGetHomeStoreBannerURL withInput:aDict withCurrentTask:TASK_TO_GET_HOME_STORE_BANNER andDelegate:self ];
}

-(void) didFailWithError:(NSError *)error
{
    btnStartShopping.enabled = YES;
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_HOME_STORE_BANNER) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            [self parseHomeStoreResponseData:responseObject];
        }
        else
        {
          //  [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
    else if (aaramShop_ConnectionManager.currentTask == TASK_TO_GET_HOME_STORE_DETAILS)
    {
        btnStartShopping.enabled = YES;

        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            [self parseHomeStoreResponseDetailData:responseObject];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
    else if (aaramShop_ConnectionManager.currentTask == TASK_GET_USER_ADDRESS)
    {
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            [self parseAddressData:responseObject];
        }
        else
        {
//            [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
}

-(void)parseHomeStoreResponseData:(NSMutableDictionary *)responseObject
{
    [arrSuggestedStores removeAllObjects];
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [imgVOffer sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[responseObject objectForKey:kBanner]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
            }
        }];
    }
    else if ([UIScreen mainScreen].bounds.size.height == 568) {
        [imgVOffer sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[responseObject objectForKey:kBanner_2x]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
            }
        }];
    }
    else if ([UIScreen mainScreen].bounds.size.height == 667) {
        [imgVOffer sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[responseObject objectForKey:kBanner_2x]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
            }
        }];
    }

    
    NSArray *arrStores = [responseObject objectForKey:@"suggested_stores"];
    for (id obj in arrStores) {
        StoreModel *objStoreModel = [[StoreModel alloc]init];
        objStoreModel.store_code = [NSString stringWithFormat:@"%@",[obj valueForKey:kStore_code]];
        objStoreModel.store_distance = [NSString stringWithFormat:@"%@",[obj valueForKey:kStore_distance]];
        objStoreModel.store_id = [NSString stringWithFormat:@"%@",[obj valueForKey:kStore_id]];
        
        [arrSuggestedStores addObject:objStoreModel];
    }
}
-(void)parseAddressData:(NSDictionary *)responseObject
{
//    NSDictionary *dict = [responseObject objectForKey:kUser_address];
    [[NSUserDefaults standardUserDefaults] setValue:[responseObject objectForKey:kUser_address] forKey:kUser_address];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self createDataToGetHomeStoreBanner];

}
-(void)parseHomeStoreResponseDetailData:(NSMutableDictionary *)responseObject
{
    NSDictionary *dict = [responseObject objectForKey:kStore_data];
    
    StoreModel *objStoreModel = [[StoreModel alloc]init];
    objStoreModel.banner = [NSString stringWithFormat:@"%@",[[dict objectForKey:      kBanner] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    
    objStoreModel.banner_2x = [NSString stringWithFormat:@"%@",[[dict objectForKey:      kBanner_2x]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    objStoreModel.banner_3x = [NSString stringWithFormat:@"%@",[[dict objectForKey:      kBanner_3x]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    objStoreModel.store_address = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_address]];
    objStoreModel.store_category_icon = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_category_icon]];
    objStoreModel.store_category_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_category_name]];

    objStoreModel.store_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_id]];
    objStoreModel.store_image = [NSString stringWithFormat:@"%@",[[dict objectForKey:kStore_image]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    objStoreModel.store_latitude = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_latitude]];
    objStoreModel.store_longitude = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_longitude]];
    objStoreModel.store_distance = [NSString stringWithFormat:@"%@",[AppManager getDistance:objStoreModel]];
    objStoreModel.store_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_name]];
    objStoreModel.store_rating = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_rating]];
    objStoreModel.home_delivey = [NSString stringWithFormat:@"%@",[dict valueForKey:kHome_delivery]];

    HomeStoreDetailViewController *homeStoreDetailVwController = (HomeStoreDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeStoreDetailScreen"];
    homeStoreDetailVwController.objStoreModel = objStoreModel;
    [self.navigationController pushViewController:homeStoreDetailVwController animated:YES];
    
}
#pragma mark - TableView Datasource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 1;
    return sectionNum;;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsNum = arrSuggestedStores.count;
    return rowsNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 45.0;
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }

    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    StoreModel *objStoreModel = [arrSuggestedStores objectAtIndex:indexPath.row];
    UILabel *lblStoreName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-56, 45)];
    lblStoreName.font = [UIFont fontWithName:kRobotoRegular size:16.0];
    lblStoreName.textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
    lblStoreName.text = objStoreModel.store_code;
    [cell.contentView addSubview:lblStoreName];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoreModel *objStoreModel = [arrSuggestedStores objectAtIndex:indexPath.row];
    txtStoreId.text = objStoreModel.store_code;
    tblSuggestedStores.hidden = YES;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



#pragma mark - scrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [txtStoreId resignFirstResponder];
}

#pragma mark - createDataToGetHomeStoreBannerDetails
-(void)createDataToGetHomeStoreBannerDetails
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    
    
//    [dict setObject:@"26" forKey:@"userId"]; //temp
    
//    [dict setObject:@"28.5136781" forKey:kLatitude]; //temp
//    [dict setObject:@"77.3769436" forKey:kLongitude]; //temp

    
    [dict setObject:txtStoreId.text forKey:kStore_code];
    [self callWebserviceToGetHomeStoreBannerDetails:dict];
}

-(void)callWebserviceToGetHomeStoreBannerDetails:(NSMutableDictionary *)aDict
{
    btnStartShopping.enabled = NO;
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        btnStartShopping.enabled = YES;

        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kGetHomeStoreDetailsURL withInput:aDict withCurrentTask:TASK_TO_GET_HOME_STORE_DETAILS andDelegate:self ];
}

#pragma mark -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (arrSuggestedStores.count>0 && textField == txtStoreId) {
        tblSuggestedStores.hidden = NO;
        [tblSuggestedStores reloadData];
        return NO;
    }
    else if (arrSuggestedStores.count == 0 && textField == txtStoreId)
    {
        tblSuggestedStores.hidden = YES;
        return YES;
    }
    return NO;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UIButton Actions
- (IBAction)btnStart:(id)sender {
    if ([txtStoreId.text length] >0) {
        [self createDataToGetHomeStoreBannerDetails];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessfulNotificationName object:self userInfo:nil];

    }
}

- (IBAction)btnWhatsHomeStoreClick:(UIButton *)sender {

    homeStorePopUpVwController =  [self.storyboard instantiateViewControllerWithIdentifier :@"homeStorePopUp"];
    CGRect homeStorePopUpVwControllerRect = [UIScreen mainScreen].bounds;
    homeStorePopUpVwController.view.frame = homeStorePopUpVwControllerRect;
    homeStorePopUpVwController.viewPopUp.frame = CGRectMake(30, ([UIScreen mainScreen].bounds.size.height-295)/2, [UIScreen mainScreen].bounds.size.width-60, 295);
    [appDeleg.window addSubview:homeStorePopUpVwController.view];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
