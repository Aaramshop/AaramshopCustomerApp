//
//  HomeViewController.m
//  AaramShop
//
//  Created by Pradeep Singh on 12/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeViewController.h"
#import "LocationEnterViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sideBar = [Utils createLeftBarWithDelegate:self];
    [self setUpNavigationView];
    [self showLocationScreen];

}
-(void)showLocationScreen
{
    LocationEnterViewController *locationScreen = (LocationEnterViewController*) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationEnterScreen"];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:locationScreen];
    [self presentViewController:locationScreen animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Navigation

-(void)setUpNavigationView
{
    //.view.backgroundColor =kCommonScreenBackgroundColor;
    CustomNavigationView* navView =[[CustomNavigationView alloc]init];
    //  [navView setCustomNavigationLeftButtonText:NSLocalizedString(kCommonNavButtonCancelText, nil)];
    // [navView setCustomNavigationRightButtonText:NSLocalizedString(kCommonNavButtonSaveText, nil)];
//    [navView setCustomNavigationTitle:NSLocalizedString(@"Your LineJump", nil)];
//    //    [navView setCustomNavigationLeftArrowImage];
//    [navView removeCustomNavigationLeftArrowImage];
    
    [navView setCustomNavigationLeftArrowImageWithImageName:@"menuIcon.png"];
    
        navView.delegate=self;
    [self.view addSubview:navView];
    
    
}
-(void)customNavigationLeftButtonClick:(UIButton *)sender
{
    [self.sideBar show];
}
- (void)sideBarDelegatePushMethod:(UIViewController*)viewC{
    
    
    [self.navigationController pushViewController:viewC animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
