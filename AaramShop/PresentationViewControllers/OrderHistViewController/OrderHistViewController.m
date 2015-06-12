//
//  OrderHistViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OrderHistViewController.h"

@interface OrderHistViewController ()

@end

@implementation OrderHistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sideBar = [Utils createLeftBarWithDelegate:self];
    [self setNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Navigation
-(void)setNavigationBar
{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    UIButton *sideMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    sideMenu.bounds = CGRectMake( 0, 0, 30, 30 );
    [sideMenu setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
    [sideMenu addTarget:self action:@selector(SideMenuClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnHome = [[UIBarButtonItem alloc] initWithCustomView:sideMenu];
    
    
    NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:btnHome, nil];
    self.navigationItem.leftBarButtonItems = arrBtnsLeft;
    
    
}
-(void)SideMenuClicked
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
