//
//  HomeStoreDetailViewController.m
//  AaramShop
//
//  Created by Approutes on 08/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeStoreDetailViewController.h"

@interface HomeStoreDetailViewController ()

@end

@implementation HomeStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *strName = @"FOOD PLAZA";
    NSString *strTitle = [NSString stringWithFormat:@"you have choose %@ as your HOME STORE.",strName];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:strTitle];
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:15.0],NSFontAttributeName,[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 15)];
    
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoBold size:18.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(16, strName.length)];
    
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:15.0],NSFontAttributeName,[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(16+strName.length, 10)];

    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoBold size:18.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(24+strName.length, 11)];

    lblTitle.attributedText = hogan;

}


- (IBAction)btnStartShoppingClick:(UIButton *)sender {
    UITabBarController *tabBarController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarScreen"];
    [self.navigationController pushViewController:tabBarController animated:YES];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
