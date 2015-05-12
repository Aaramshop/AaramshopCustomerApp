//
//  TabbarViewController.m
//  Giftr
//
//  Created by AppRoutes on 27/01/15.
//  Copyright (c) 2015 AppRoutes. All rights reserved.
//

#import "TabbarViewController.h"


@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self codeForTabbar];
    
    
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)codeForTabbar
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:254/255.0f green:56/255.0f blue:45/255.0f alpha:1.0f]];
        UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:0];
        
        UIImage *unselectedImage = [UIImage imageNamed:@"tabBarHomeIcon"];
        UIImage *selectedImage = [UIImage imageNamed:@"tabBarHomeIconActive"];
        
        [tabBarItem setImage: [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem setSelectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        
        UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
        
        UIImage *unselectedImage1 = [UIImage imageNamed:@"tabBarMyListIcon"];
        UIImage *selectedImage1 = [UIImage imageNamed:@"tabBarMyListIconActive"];
        
        [tabBarItem1 setImage: [unselectedImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem1 setSelectedImage: [selectedImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];
        
        UIImage *unselectedImage2 = [UIImage imageNamed:@"tabBarChatIcon"];
        UIImage *selectedImage2 = [UIImage imageNamed:@"tabBarChatIconActive"];
        
        [tabBarItem2 setImage: [unselectedImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem2 setSelectedImage:[selectedImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        //
        UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:3];
        //
        UIImage *unselectedImage3 = [UIImage imageNamed:@"tabBarOrdersIcon"];
        UIImage *selectedImage3 = [UIImage imageNamed:@"tabBarOrdersIconActive"];
        //
        [tabBarItem3 setImage: [unselectedImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem3 setSelectedImage:[selectedImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        //
        UITabBarItem *tabBarItem4 = [self.tabBar.items objectAtIndex:4];
        //
        UIImage *unselectedImage4 = [UIImage imageNamed:@"tabBarOffersIcon"];
        UIImage *selectedImage4 = [UIImage imageNamed:@"tabBarOffersIconActive"];
        //
        [tabBarItem4 setImage: [unselectedImage4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem4 setSelectedImage:[selectedImage4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        
        //UIFont *font = [UIFont fontWithName:@"Roboto" size:20];
        [tabBarItem setTitle:@"Home"];
        
        
        [tabBarItem1 setTitle:@"My List"];
        
        [tabBarItem2 setTitle:@"Chat"];
        [tabBarItem3 setTitle:@"Orders"];
        [tabBarItem4 setTitle:@"Offers"];
        //        [[UITabBarItem appearance] setTitleTextAttributes:
        //         [NSDictionary dictionaryWithObjectsAndKeys:
        //          [UIColor colorWithRed:223.0/255.0f green:110.0/255.0f blue:0.0/255.0f alpha:1.0f], UITextAttributeTextColor,
        //          [UIFont fontWithName:@"Roboto" size:20.0], UITextAttributeFont,
        //          nil]
        //                                                 forState:UIControlStateHighlighted];
        //
        
        
    }
    
    else
    {
        
        
        
        [[[self.tabBarController.viewControllers objectAtIndex:0] tabBarItem] setTitle:@"Home"];
        [[[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem] setTitle:@"My List"];
        [[[self.tabBarController.viewControllers objectAtIndex:2] tabBarItem] setTitle:@"Chat"];
        [[[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem] setTitle:@"Orders"];
        [[[self.tabBarController.viewControllers objectAtIndex:4] tabBarItem] setTitle:@"Offers"];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
    
}


@end
