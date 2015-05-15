//
//  ShowFullProfileImageViewController.m
//  UmmApp
//
//  Created by Neha Saxena on 01/11/2014.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import "ShowFullProfileImageViewController.h"

@interface ShowFullProfileImageViewController ()

@end

@implementation ShowFullProfileImageViewController
@synthesize imgString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([[UIScreen mainScreen] bounds].size.height > 480)
    {
        nibNameOrNil = @"ShowFullProfileImageViewController";
    }
    else
    {
        nibNameOrNil = @"ShowFullProfileImageViewController4";
    }
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}
- (void)setNavigationBar
{
    self.navigationItem.hidesBackButton = YES;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"btnArrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self.imgViewFull setImageWithURL:[NSURL URLWithString:self.imgString] placeholderImage:[UIImage imageNamed:@"chatDefaultPic"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        UIImageWriteToSavedPhotosAlbum(self.imgViewFull.image,nil,nil,nil);
        [Utils showAlertView:kAlertTitle message:@"Image saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}
#pragma mark - button methods
- (void)btnBackClicked {
    if(self.isComingFromChat)
    {
        self.navigationController.navigationBarHidden = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSaveImage:(id)sender {
    UIActionSheet *actionS = [[UIActionSheet alloc] initWithTitle:@"Save image?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save", nil];
    [actionS showInView:self.view];

}
@end
