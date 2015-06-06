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
{
    MPMoviePlayerController *theMoviPlayer;
    UIView *blurView;
}
@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    blurView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    blurView.backgroundColor = [UIColor grayColor];
    blurView.alpha = 0.65f;
    UIToolbar* bgToolbar = [[UIToolbar alloc] initWithFrame:blurView.frame];
    bgToolbar.barStyle = UIBarStyleDefault;
    [blurView.superview insertSubview:bgToolbar belowSubview:blurView];
//    blurView = [[JCRBlurView alloc] initWithFrame:CGRectMake(0, -20, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
//    blurView.alpha = 0.65f;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath1 = [bundle pathForResource:@"disc" ofType:@"mp4"];
    NSString *moviePath2 = [bundle pathForResource:@"disc2" ofType:@"mp4"];
    NSString *moviePath3 = [bundle pathForResource:@"disc3" ofType:@"mp4"];
    NSURL *movieURL1 = [NSURL fileURLWithPath:moviePath1];
    NSURL *movieURL2 = [NSURL fileURLWithPath:moviePath2];
    NSURL *movieURL3 = [NSURL fileURLWithPath:moviePath3];
    NSArray *arrMovieURLs = [[NSArray alloc]initWithObjects:movieURL1,movieURL2,movieURL3, nil];
//    theMoviPlayer. = MPMovieFinishReasonPlaybackEnded;
    
    theMoviPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[arrMovieURLs objectAtIndex:0]];
       theMoviPlayer.controlStyle = MPMovieControlStyleNone;
    theMoviPlayer.repeatMode = MPMovieRepeatModeOne;
    theMoviPlayer.scalingMode = MPMovieScalingModeAspectFill;
    
    [theMoviPlayer.view setFrame:CGRectMake(0, -20, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    [theMoviPlayer play];
    [subView addSubview:theMoviPlayer.view];
    [subView addSubview:blurView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kIsLoggedIn]) {
        UITabBarController *tabBarController = (UITabBarController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabbarScreen"];
        [self.navigationController pushViewController:tabBarController animated:YES];

    }
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
