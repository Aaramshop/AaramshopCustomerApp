//
//  HomeStoreDetailViewController.m
//  AaramShop
//
//  Created by Approutes on 08/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeStoreDetailViewController.h"
@interface HomeStoreDetailViewController ()
{
    AppDelegate *appDeleg;
}

@end

@implementation HomeStoreDetailViewController
@synthesize objStoreModel,aaramShop_ConnectionManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationView];
    appDeleg = APP_DELEGATE;
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate = self;
    [self bindData];

}
-(void)bindData
{
    NSString *strName = objStoreModel.store_name;
    NSString *strTitle = [NSString stringWithFormat:@"you have choose %@ as your HOME STORE.",strName];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:strTitle];
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:15.0],NSFontAttributeName,[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 15)];
    
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoBold size:18.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(16, strName.length)];
    
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:15.0],NSFontAttributeName,[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(16+strName.length, 10)];
    
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoBold size:18.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(24+strName.length, 11)];
    
    lblTitle.attributedText = hogan;

    lblStoreCategoryName.text = objStoreModel.store_category_name;
    lblStoreName.text = objStoreModel.store_name;
    lblStoreDistance.text = objStoreModel.store_distance;
    lblStoreAddress.text = objStoreModel.store_address;
    
    if ([objStoreModel.home_delivey isEqualToString:@"1"]) {
        [imgDelivery setHidden:NO];
        [lblDelivery setHidden:NO];
    }
    else
    {
        [imgDelivery setHidden:YES];
        [lblDelivery setHidden:YES];
    }
    
    NSLog(@"value =%f",[UIScreen mainScreen].bounds.size.height);
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [imgVOfferImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objStoreModel.banner]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
            }
        }];
    }
    else if ([UIScreen mainScreen].bounds.size.height == 568) {
        [imgVOfferImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objStoreModel.banner_2x]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
            }
        }];
    }
    else if ([UIScreen mainScreen].bounds.size.height == 667) {
        [imgVOfferImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objStoreModel.banner_3x]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
            }
        }];
    }
    
    [imgVStoreCategoryImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objStoreModel.store_category_image]] placeholderImage:[UIImage imageNamed:@"homeStoreDetailsGroceryCircle.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];
    
    [imgVStoreImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",objStoreModel.store_image]] placeholderImage:[UIImage imageNamed:@"homeDetailsDefaultImgae.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
        }
    }];
    
}

#pragma mark Navigation

-(void)setUpNavigationView
{
    CustomNavigationView* navView =[[CustomNavigationView alloc]init];
    navView.imgNavigationBlur.image = [UIImage imageNamed:@""];
    [navView setCustomNavigationLeftArrowImageWithImageName:@"backBtn.png"];
    navView.delegate=self;
    [self.view addSubview:navView];
}
-(void)customNavigationLeftButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)customNavigationRightButtonClick:(UIButton *)sender
{
    
}


- (IBAction)btnReenterHomeStoreIdClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnStartShoppingClick:(UIButton *)sender {
    [self createDataToMakeHomeStore];
}

-(void)createDataToMakeHomeStore
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    [dict setObject:objStoreModel.store_id forKey:kStore_id];
    [self callWebserviceToMakeHomeStore:dict];
}
-(void)callWebserviceToMakeHomeStore:(NSMutableDictionary *)aDict
{
    [AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
    [aaramShop_ConnectionManager getDataForFunction:kMakeHomeStoreURL withInput:aDict withCurrentTask:TASK_TO_MAKE_HOME_STORE andDelegate:self ];

}
-(void) didFailWithError:(NSError *)error
{
    [aaramShop_ConnectionManager failureBlockCalled:error];
}
-(void) responseReceived:(id)responseObject
{
    if (aaramShop_ConnectionManager.currentTask == TASK_TO_MAKE_HOME_STORE) {
        
        if ([[responseObject objectForKey:kstatus] intValue] == 1 && [[responseObject objectForKey:kIsValid] intValue] == 1) {
            
            UITabBarController *tabBarController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarScreen"];
            tabBarController.selectedIndex = 0;
            appDeleg.window.rootViewController = tabBarController;
        }
        else
        {
              [Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:self cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end