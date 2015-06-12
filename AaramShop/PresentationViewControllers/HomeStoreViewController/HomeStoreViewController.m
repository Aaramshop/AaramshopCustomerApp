//
//  HomeStoreViewController.m
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "HomeStoreViewController.h"
#import "HomeStoreDetailViewController.h"

@interface HomeStoreViewController ()
{
    HomeStorePopUpViewController *homeStorePopUpVwController;
    AppDelegate *appDeleg;
}
@end

@implementation HomeStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDeleg = (AppDelegate *)APP_DELEGATE;
    NSString *strTitle = @"Add HOME STORE";
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:strTitle];
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoRegular size:15.0],NSFontAttributeName,[UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 3)];
    
    [hogan addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kRobotoBold size:15.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] range:NSMakeRange(3, strTitle.length-3)];

    lblHd.attributedText = hogan;
}


- (IBAction)btnStart:(id)sender {
    HomeStoreDetailViewController *homeStoreDetailVwController = (HomeStoreDetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"homeStoreDetailScreen"];
    [self.navigationController pushViewController:homeStoreDetailVwController animated:YES];
}

- (IBAction)btnWhatsHomeStoreClick:(UIButton *)sender {

    homeStorePopUpVwController =  [self.storyboard instantiateViewControllerWithIdentifier :@"homeStorePopUp"];
    homeStorePopUpVwController.delegate = self;
    CGRect homeStorePopUpVwControllerRect = self.view.bounds;
    homeStorePopUpVwController.view.frame = homeStorePopUpVwControllerRect;
    [appDeleg.window addSubview:homeStorePopUpVwController.view];
}
//-(void)hidePopUp
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
