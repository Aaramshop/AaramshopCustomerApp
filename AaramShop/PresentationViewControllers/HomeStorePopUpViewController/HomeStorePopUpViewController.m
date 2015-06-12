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
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)btncloseClick:(UIButton *)sender {
    
    [self.view removeFromSuperview];

//    if (self.delegate && [self.delegate conformsToProtocol:@protocol(HomeStorePopUpViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(hidePopUp)])
//    {
//        [self.delegate hidePopUp];
//    }

}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
