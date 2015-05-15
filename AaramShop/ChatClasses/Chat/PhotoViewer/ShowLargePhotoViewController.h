//
//  ShowLargePhotoViewController.h
//  SocialParty
//
//  Created by APPROUTES on 06/03/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPhoto.h"
#import "PhotoLargeViewController.h"

@interface ShowLargePhotoViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPageViewController * pageViewController;
@property (nonatomic, strong) NSMutableArray * arrayImages;
@property(nonatomic,assign) NSInteger intArrayIndex;
@property(nonatomic,strong)IBOutlet UIButton *btnBack;

//// Priyanka start
//
@property(nonatomic,strong) NSString *strTotalPhotoCount;

//
//// Priyanka end
@property (strong, nonatomic) IBOutlet UIImageView *imgViewNavigation;


- (IBAction)btnBackClicked:(id)sender;
-(void)setInitializePageViewController;
-(void)UpDateImageViews;
@property (strong, nonatomic) IBOutlet UILabel *lblCounter;
@end

