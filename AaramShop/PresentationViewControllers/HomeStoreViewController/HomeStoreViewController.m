//
//  HomeStoreViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeStoreViewController.h"
#import "HomeStoreDetailViewController.h"
#import "StoreModel.h"
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
    
    arrSuggestedStores = [[NSMutableArray alloc]init];

    NSString *strTitle = @"Add HOME STORE";
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:strTitle];
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:15.0],NSFontAttributeName,[UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 3)];
    
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoBold size:15.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(3, strTitle.length-3)];

    lblHd.attributedText = hogan;
    [self createDataToGetHomeStoreBanner];
}
#pragma mark - createDataToGetHomeStoreBanner

-(void)createDataToGetHomeStoreBanner
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
    
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
-(void)parseHomeStoreResponseDetailData:(NSMutableDictionary *)responseObject
{
    NSDictionary *dict = [responseObject objectForKey:kStore_data];
    
    StoreModel *objStoreModel = [[StoreModel alloc]init];
    objStoreModel.banner = [NSString stringWithFormat:@"%@",[dict objectForKey:      kBanner]];
    objStoreModel.banner_2x = [NSString stringWithFormat:@"%@",[dict objectForKey:      kBanner_2x]];
    objStoreModel.banner_3x = [NSString stringWithFormat:@"%@",[dict objectForKey:      kBanner_3x]];
    objStoreModel.store_address = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_address]];
    objStoreModel.store_category_icon = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_category_icon]];
    objStoreModel.store_category_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_category_name]];

    objStoreModel.store_id = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_id]];
    objStoreModel.store_image = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_image]];

    objStoreModel.store_latitude = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_latitude]];
    objStoreModel.store_longitude = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_longitude]];
    objStoreModel.store_distance = [NSString stringWithFormat:@"%@",[AppManager getDistance:objStoreModel]];
    objStoreModel.store_name = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_name]];
    objStoreModel.store_rating = [NSString stringWithFormat:@"%@",[dict objectForKey:kStore_rating]];


    HomeStoreDetailViewController *homeStoreDetailVwController = (HomeStoreDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeStoreDetailScreen"];
    homeStoreDetailVwController.objStoreModel = objStoreModel;
    [self.navigationController pushViewController:homeStoreDetailVwController animated:YES];
}

#pragma mark - createDataToGetHomeStoreBannerDetails
-(void)createDataToGetHomeStoreBannerDetails
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.latitude] forKey:kLatitude];
    [dict setObject:[NSString stringWithFormat:@"%f",appDeleg.myCurrentLocation.coordinate.longitude] forKey:kLongitude];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
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
        UITabBarController *tabBarController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarScreen"];
        [self.navigationController pushViewController:tabBarController animated:YES];
    }
}

- (IBAction)btnWhatsHomeStoreClick:(UIButton *)sender {

    homeStorePopUpVwController =  [self.storyboard instantiateViewControllerWithIdentifier :@"homeStorePopUp"];
    homeStorePopUpVwController.delegate = self;
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
