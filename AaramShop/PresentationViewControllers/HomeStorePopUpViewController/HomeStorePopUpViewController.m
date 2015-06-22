//
//  HomeStorePopUpViewController.m
//  AaramShop
//
//  Created by Approutes on 09/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeStorePopUpViewController.h"

@interface HomeStorePopUpViewController ()

@end

@implementation HomeStorePopUpViewController
@synthesize delegate,viewPopUp;
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)btncloseClick:(UIButton *)sender {
    
    [self.view removeFromSuperview];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
