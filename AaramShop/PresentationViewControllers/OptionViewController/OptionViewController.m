//
//  OptionViewController.m
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "OptionViewController.h"
#import "LoginViewController.h"
#import "MobileEnterViewController.h"
@interface OptionViewController ()

@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)btnNewUserClick:(UIButton *)sender {
    
    MobileEnterViewController *mobileEnterVwController = (MobileEnterViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MobileEnterScreen" ];
    [self.navigationController pushViewController:mobileEnterVwController animated:YES];

}

- (IBAction)btnExistingUserClick:(UIButton *)sender {
    
    
    LoginViewController *loginVwController = (LoginViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [self.navigationController pushViewController:loginVwController animated:YES];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
