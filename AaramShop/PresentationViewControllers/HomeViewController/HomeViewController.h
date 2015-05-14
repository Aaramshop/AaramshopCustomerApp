//
//  HomeViewController.h
//  AaramShop
//
//  Created by Pradeep Singh on 12/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<CDRTranslucentSideBarDelegate,CustomNavigationDelegate>

{
}
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

@end
