//
//  ChatViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()
{
    
}
@end

@implementation ChatViewController

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

- (IBAction)btnChatClicked:(id)sender {
    AppDelegate *deleg = APP_DELEGATE;
    SMChatViewController *chatView = nil;
    chatView = [deleg createChatViewByChatUserNameIfNeeded:@"reachout_chatuser_87"];
    chatView.chatWithUser =@"reachout_chatuser_87@chat.reach-out.mobi";
    chatView.userName =@"user 2";
    chatView.imageString = @"";
    chatView.friendNameId = @"1";
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}
@end
