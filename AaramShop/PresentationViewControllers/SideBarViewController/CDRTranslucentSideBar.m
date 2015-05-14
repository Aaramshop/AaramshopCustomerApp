//
//  CDRTranslucentSideBar.m
//  CDRTranslucentSideBar
//

//
//  CDRTranslucentSideBar.h
//  JobIck
//
//  Created by AppRoutes on 06/04/15.
//  Copyright (c) 2015 AppRoutes. All rights reserved.



#import "CDRTranslucentSideBar.h"
#import "PreferencesViewController.h"
#import "AccountSettingsViewC.h"
#import "CartViewController.h"
#import "UIImageEffects.h"

#define kDefaultHeaderFrame CGRectMake(0, 0, tblView.frame.size.width, tblView.frame.size.height)


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface CDRTranslucentSideBar ()
{
    NSMutableArray *arrMenu;
    NSMutableArray *arrImages;
    UITableView *tblView;
    UIStoryboard *storyboard;
    UIImageView * bluredImageView;
    UIView *secView;
    UIImage *effectImage;
    
}
@property (nonatomic, strong) UIToolbar *translucentView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;

//@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;

@property CGPoint panStartPoint;

@end

@implementation CDRTranslucentSideBar
- (id)init
{
    self = [super init];
    if (self) {
        [self initCDRTranslucentSideBar];
    }
    return self;
}

- (id)initWithDirection:(BOOL)showFromRight
{
    self = [super init];
    if (self) {
        _showFromRight = showFromRight;
        [self initCDRTranslucentSideBar];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - Custom Initializer
- (void)initCDRTranslucentSideBar
{
    
    _hasShown = NO;
    self.isCurrentPanGestureTarget = NO;
    
    //  self.sideBarWidth = 150;
    self.animationDuration = 0.35f;
    
    [self initTranslucentView];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)initTranslucentView
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        CGRect translucentFrame =
        CGRectMake(self.showFromRight ? self.view.bounds.size.width : -self.sideBarWidth, 0, self.sideBarWidth, self.view.bounds.size.height);
        self.translucentView = [[UIToolbar alloc] initWithFrame:translucentFrame];
        self.translucentView.frame = translucentFrame;
        self.translucentView.contentMode = _showFromRight ? UIViewContentModeTopRight : UIViewContentModeTopLeft;
        self.translucentView.clipsToBounds = YES;
        self.translucentView.backgroundColor=[UIColor clearColor];
        self.translucentView.barStyle =UIBarStyleDefault;
        
        [self.view.layer insertSublayer:self.translucentView.layer atIndex:0];
    }
}
#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    arrMenu=[[NSMutableArray alloc]initWithObjects:@"Account Settings",@"Preferences",@"Cart",@"Vouchers",@"Awards Points",nil];
    
    arrImages=[[NSMutableArray alloc]initWithObjects:@"menuAccountSettingsIcon",@"menuPreferencesIcon",@"menuCartIcon",@"menuVouchersIcon",@"menuAwardsPointsIcon",nil];
    
 
   
    // Add PanGesture to Show SideBar by PanGesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    
    
    // Create Content of SideBar
    UIView *vContentView = [[UIView alloc] initWithFrame:CGRectZero];
    vContentView.backgroundColor = [UIColor clearColor];
    if (!_showFromRight) {
        
        //  tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, 270, [UIScreen mainScreen].bounds.size.height-135) style:UITableViewStyleGrouped];
        tblView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,260, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    }
    
    
    tblView.scrollEnabled=NO;
    tblView.backgroundColor=[UIColor clearColor];
    [vContentView addSubview:tblView];
    tblView.dataSource = self;
    tblView.delegate = self;
    tblView.scrollEnabled=YES;
//    [tblView separatorInset:c]
    tblView.alwaysBounceVertical=YES;
    tblView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Set ContentView in SideBar
    [self setContentViewInSideBar:vContentView];
    
}
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tblView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tblView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tblView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tblView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
}
#pragma mark - UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        
        return arrMenu.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 215;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //menuFacebookBox
    return 60;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 44)];
    UIButton *btnFacebook=[[UIButton alloc]initWithFrame:CGRectMake((tblView.frame.size.width - 184)/2, 8, 184, 34)];
    [btnFacebook setBackgroundImage:[UIImage imageNamed:@"menuFacebookBox"] forState:UIControlStateNormal];
    [btnFacebook setTitle:@"Share with Facebook" forState:UIControlStateNormal];
    [btnFacebook setTitleEdgeInsets:UIEdgeInsetsMake(3.0f, 30.0f, 0.0f, 0.0f)];
    btnFacebook.titleLabel.font=[UIFont fontWithName:kMyriadProRegular size:15];
    [btnFacebook addTarget:self action:@selector(shareWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [secView addSubview:btnFacebook];
    
    return secView;
}
-(void)shareWithFacebook
{
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage* image;
    secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 215)];
    UIImageView *imgBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, secView.frame.size.width, 215)];
    
//    imgBackground.image = [UIImage imageNamed:@"menuProfileBackImage"];
    UIImageView *imgProfile=[[UIImageView alloc]initWithFrame:CGRectMake((secView.frame.size.width - 101)/2, 39, 101, 101)];
    imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2;
    imgProfile.clipsToBounds=YES;
    
    
//    [imgBackground sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,objUserModel.profilePicUrl]] placeholderImage:[UIImage imageNamed:@"inviteDefaultImage"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:kImage];
    if (imageData) {
        image = [UIImage imageWithData:imageData];
        effectImage = [UIImageEffects imageByApplyingDarkEffectToImage:image];
        imgBackground.image = effectImage;
        imgProfile.image = image;
    }
    else
    {
//        imgBackground.image=[UIImage imageNamed:@"defaultProfilePic"];
        imgProfile.image = [UIImage imageNamed:@"defaultProfilePic"];
    }

    
   
    
//    [imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kBaseURL] ,[Utils getUserDefaultValue:kProfilePicUrl]]] placeholderImage:[UIImage imageNamed:@"inviteDefaultImage"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
        
//    }];
    
    
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, imgProfile.frame.origin.y + imgProfile.frame.size.height +5, tblView.frame.size.width, 21)];
    lblName.textColor= [UIColor whiteColor];
    lblName.textAlignment=NSTextAlignmentCenter;
    lblName.font=[UIFont fontWithName:kMyriadProBold size:15];
    lblName.text=@"Reena Sharma";
    
    
    
    UILabel *lblSeperator = [[UILabel alloc]initWithFrame:CGRectMake(8, secView.frame.size.height - 47, secView.frame.size.width - 16, 2)];
    lblSeperator.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.40];
    
    
    
    UIImageView *imglocation=[[UIImageView alloc]initWithFrame:CGRectMake(8, lblSeperator.frame.origin.y + 10, 20, 20)];
    imglocation.image=[UIImage imageNamed:@"locationIcon"];
    
    UILabel *lblAddress = [[UILabel alloc]initWithFrame:CGRectMake(32, lblSeperator.frame.origin.y + 5, tblView.frame.size.width-64, 40)];
    lblAddress.numberOfLines = 2;
    lblAddress.lineBreakMode = NSLineBreakByWordWrapping;
    lblAddress.font=[UIFont fontWithName:kMyriadProRegular size:15];
    lblAddress.text=@"Noida, Sec - 18, Near Hospital, Uttar pradesh";
    lblAddress.textColor=[UIColor whiteColor];
    
    UIButton *btnEdit=[[UIButton alloc]initWithFrame:CGRectMake(8, lblSeperator.frame.origin.y + 5, tblView.frame.size.width-16, 34)];
    [btnEdit setImage:[UIImage imageNamed:@"menuEditIcon"] forState:UIControlStateNormal];
    [btnEdit setImageEdgeInsets:UIEdgeInsetsMake(-2.0f, 0.0f, 0.0f, -225.0f)];
    btnEdit.titleLabel.font=[UIFont fontWithName:kMyriadProRegular size:15];
    [btnEdit addTarget:self action:@selector(EditAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [secView addSubview:imgBackground];
    [secView addSubview:imgProfile];
    
    [secView addSubview:lblSeperator];
    [secView addSubview:imglocation];
    [secView addSubview:lblName];
    [secView addSubview:lblAddress];
    [secView addSubview:btnEdit];
    
  
    return secView;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    tblView.backgroundColor=[UIColor clearColor];
//    if (modeSelected == eJobsMode)
//    {
        cell.textLabel.text=[arrMenu objectAtIndex:indexPath.row];
        cell.imageView.image=[UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
//    }
//    else
//    {
//        cell.textLabel.text=[arrayHireModeMenu objectAtIndex:indexPath.row];
//        cell.imageView.image=[UIImage imageNamed:[arrayHireSideImages objectAtIndex:indexPath.row]];
//    }
    cell.textLabel.textColor=[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
    cell.textLabel.font=[UIFont fontWithName:kMyriadProRegular size:16];
//    cell.textLabel.font=[UIFont fontWithName:kFontCalibriRegular size:13];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorInset =UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorInset =UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self dismiss];
   
        
        
        switch (indexPath.row) {
            case 0:
            {
                
                AccountSettingsViewC *accSettingsVCon = [storyboard instantiateViewControllerWithIdentifier:@"AccountSettViewScreen"];
                
                if ([self.delegate respondsToSelector:@selector(sideBarDelegatePushMethod:)]) {
                    [self.delegate sideBarDelegatePushMethod:accSettingsVCon];
                }
                
            }
                break;
            case 1:
            {
                PreferencesViewController *preferncesVCon = [storyboard instantiateViewControllerWithIdentifier:@"PreferencesViewScene"];
                
                if ([self.delegate respondsToSelector:@selector(sideBarDelegatePushMethod:)]) {
                    [self.delegate sideBarDelegatePushMethod:preferncesVCon];
                }
            }
                break;
            case 2:
            {
                CartViewController *cartVCon = [storyboard instantiateViewControllerWithIdentifier:@"CartViewScene"];
                
                if ([self.delegate respondsToSelector:@selector(sideBarDelegatePushMethod:)]) {
                    [self.delegate sideBarDelegatePushMethod:cartVCon];
                }
                
            }
                break;
                            
            default:
                break;
        }
    
    }
-(void)EditAddress
{
    
}
//#pragma mark Button Actions And Method
//-(void)btnHireMode:(UIButton *)button
//{
//    [self dismiss];
//    [btnHireMode setSelected:![btnHireMode isSelected]];
//    
//    [self setModeBtnState: eHireMode];
//    modeSelected = eHireMode;
//    
//    //    HireViewController *HireVwController = (HireViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HireFeedScreen"];
//    //    if ([self.delegate respondsToSelector:@selector(sideBarDelegatePushMethod:)])
//    //    {
//    //        [self.delegate sideBarDelegatePushMethod:HireVwController];
//    //    }
//    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    viewController = [storyboard instantiateViewControllerWithIdentifier:@"navHireScene"];
//    appDel.window.rootViewController = viewController;
//    [appDel.window makeKeyAndVisible];
//}
//-(void)btnJobsMode:(UIButton *)button
//{
//    [btnJobsMode setSelected:![btnJobsMode isSelected]];
//    
//    [self setModeBtnState: eJobsMode];
//    modeSelected = eJobsMode;
//    [self dismiss];
//    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    viewController = [storyboard instantiateViewControllerWithIdentifier:@"navJobScene"];
//    appDel.window.rootViewController = viewController;
//    [appDel.window makeKeyAndVisible];
//}
//-(void)btnMatchesClicked
//{
//    [self dismiss];
//    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    JobMatchesViewControllerViewController *Vc=[storyboard instantiateViewControllerWithIdentifier:@"jobMatchesVC"];
//    if ([self.delegate respondsToSelector:@selector(sideBarDelegatePushMethod:)])
//    {
//        [self.delegate sideBarDelegatePushMethod:Vc];
//    }
//}
//-(void)btnSettingsClicked
//{
//    [self dismiss];
//    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SettingsViewController *Vc=[storyboard instantiateViewControllerWithIdentifier:@"SettingsScreen"];
//    if ([self.delegate respondsToSelector:@selector(sideBarDelegatePushMethod:)])
//    {
//        [self.delegate sideBarDelegatePushMethod:Vc];
//    }
//    
//}
-(void)btnAppliedClicked
{
//    [self dismiss];
//    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    AppliedJobsViewController *Vc=[storyboard instantiateViewControllerWithIdentifier:@"jobAppliedVC"];
//    if ([self.delegate respondsToSelector:@selector(sideBarDelegatePushMethod:)])
//    {
//        [self.delegate sideBarDelegatePushMethod:Vc];
//    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadView
{
    [super loadView];
}

#pragma mark - Layout
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if ([self isViewLoaded] && self.view.window != nil) {
        [self layoutSubviews];
    }
}

- (void)layoutSubviews
{
    CGFloat x = self.showFromRight ? self.parentViewController.view.bounds.size.width - self.sideBarWidth : 0;
    
    if (self.contentView != nil) {
        self.contentView.frame = CGRectMake(x, 0, self.sideBarWidth, self.parentViewController.view.bounds.size.height);
    }
}

#pragma mark - Accessor
- (void)setTranslucentStyle:(UIBarStyle)translucentStyle
{
    self.translucentView.barStyle = translucentStyle;
}

- (UIBarStyle)translucentStyle
{
    return self.translucentView.barStyle;
}

- (void)setTranslucent:(BOOL)translucent
{
    self.translucentView.translucent = translucent;
}

- (BOOL)translucent
{
    return self.translucentView.translucent;
}

- (void)setTranslucentAlpha:(CGFloat)translucentAlpha
{
    self.translucentView.alpha = translucentAlpha;
}

- (CGFloat)translucentAlpha
{
    return self.translucentView.alpha;
}

- (void)setTranslucentTintColor:(UIColor *)translucentTintColor
{
    self.translucentView.tintColor = translucentTintColor;
}

- (UIColor *)translucentTintColor
{
    return self.translucentView.tintColor;
}


#pragma mark - Show
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(sideBar:willAppear:)]) {
        [self.delegate sideBar:self willAppear:animated];
    }
    
    [self addToParentViewController:controller callingAppearanceMethods:YES];
    self.view.frame = controller.view.bounds;
    
    CGFloat parentWidth = self.view.bounds.size.width;
    CGRect sideBarFrame = self.view.bounds;
    sideBarFrame.origin.x = self.showFromRight ? parentWidth : -self.sideBarWidth;
    sideBarFrame.size.width = self.sideBarWidth;
    
    if (self.contentView != nil) {
        self.contentView.frame = sideBarFrame;
    }
    sideBarFrame.origin.x = self.showFromRight ? parentWidth - self.sideBarWidth : 0;
    
    void (^animations)() = ^{
        if (self.contentView != nil) {
            self.contentView.frame = sideBarFrame;
        }
        self.translucentView.frame = sideBarFrame;
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        _hasShown = YES;
        self.isCurrentPanGestureTarget = YES;
        if (finished && [self.delegate respondsToSelector:@selector(sideBar:didAppear:)]) {
            // [self.delegate sideBar:self didAppear:animated];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration delay:0 options:kNilOptions animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}

- (void)showAnimated:(BOOL)animated
{
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController != nil) {
        controller = controller.presentedViewController;
    }
    [self showInViewController:controller animated:animated];
}

- (void)show
{
    [self showAnimated:YES];
}

#pragma mark - Show by Pangesture
- (void)startShow:(CGFloat)startX
{
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController != nil) {
        controller = controller.presentedViewController;
    }
    [self addToParentViewController:controller callingAppearanceMethods:YES];
    self.view.frame = controller.view.bounds;
    
    CGFloat parentWidth = self.view.bounds.size.width;
    
    CGRect sideBarFrame = self.view.bounds;
    sideBarFrame.origin.x = self.showFromRight ? parentWidth : -self.sideBarWidth;
    sideBarFrame.size.width = self.sideBarWidth;
    if (self.contentView != nil) {
        self.contentView.frame = sideBarFrame;
    }
    self.translucentView.frame = sideBarFrame;
}

- (void)move:(CGFloat)deltaFromStartX
{
    
    CGRect sideBarFrame = self.translucentView.frame;
    CGFloat parentWidth = self.view.bounds.size.width;
    
    if (self.showFromRight) {
        CGFloat x = deltaFromStartX;
        if (deltaFromStartX >= self.sideBarWidth) {
            x = self.sideBarWidth;
        }
        sideBarFrame.origin.x = parentWidth - x;
    } else {
        CGFloat x = deltaFromStartX - _sideBarWidth;
        if (x >= 0) {
            x = 0;
        }
        sideBarFrame.origin.x = x;
    }
    
    if (self.contentView != nil) {
        self.contentView.frame = sideBarFrame;
    }
    self.translucentView.frame = sideBarFrame;
}

- (void)showAnimatedFrom:(BOOL)animated deltaX:(CGFloat)deltaXFromStartXToEndX
{
    if ([self.delegate respondsToSelector:@selector(sideBar:willAppear:)]) {
        [self.delegate sideBar:self willAppear:animated];
    }
    
    CGRect sideBarFrame = self.translucentView.frame;
    CGFloat parentWidth = self.view.bounds.size.width;
    
    sideBarFrame.origin.x = self.showFromRight ? parentWidth - sideBarFrame.size.width : 0;
    
    void (^animations)() = ^{
        if (self.contentView != nil) {
            self.contentView.frame = sideBarFrame;
        }
        
        self.translucentView.frame = sideBarFrame;
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        _hasShown = YES;
        if (finished && [self.delegate respondsToSelector:@selector(sideBar:didAppear:)]) {
            [self.delegate sideBar:self didAppear:animated];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration delay:0 options:kNilOptions animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}

#pragma mark - Dismiss
- (void)dismiss
{
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(sideBar:willDisappear:)]) {
        [self.delegate sideBar:self willDisappear:animated];
    }
    
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        [self removeFromParentViewControllerCallingAppearanceMethods:YES];
        _hasShown = NO;
        self.isCurrentPanGestureTarget = NO;
        if ([self.delegate respondsToSelector:@selector(sideBar:didDisappear:)]) {
            [self.delegate sideBar:self didDisappear:animated];
        }
    };
    
    if (animated) {
        CGRect sideBarFrame = self.translucentView.frame;
        CGFloat parentWidth = self.view.bounds.size.width;
        sideBarFrame.origin.x = self.showFromRight ? parentWidth : -self.sideBarWidth;
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             if (self.contentView != nil) {
                                 self.contentView.frame = sideBarFrame;
                             }
                             self.translucentView.frame = sideBarFrame;
                         }
                         completion:completion];
    } else {
        completion(YES);
    }
}

#pragma mark - Dismiss by Pangesture
- (void)dismissAnimated:(BOOL)animated deltaX:(CGFloat)deltaXFromStartXToEndX
{
    if ([self.delegate respondsToSelector:@selector(sideBar:willDisappear:)]) {
        [self.delegate sideBar:self willDisappear:animated];
    }
    
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        [self removeFromParentViewControllerCallingAppearanceMethods:YES];
        _hasShown = NO;
        self.isCurrentPanGestureTarget = NO;
        if ([self.delegate respondsToSelector:@selector(sideBar:didDisappear:)]) {
            [self.delegate sideBar:self didDisappear:animated];
        }
    };
    
    if (animated) {
        CGRect sideBarFrame = self.translucentView.frame;
        CGFloat parentWidth = self.view.bounds.size.width;
        sideBarFrame.origin.x = self.showFromRight ? parentWidth : -self.sideBarWidth + deltaXFromStartXToEndX;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             if (self.contentView != nil) {
                                 self.contentView.frame = sideBarFrame;
                             }
                             self.translucentView.frame = sideBarFrame;
                         }
                         completion:completion];
    } else {
        completion(YES);
    }
}

#pragma mark - Gesture Handler
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    if (!CGRectContainsPoint(self.translucentView.frame, location)) {
        [self dismissAnimated:YES];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (!self.isCurrentPanGestureTarget) {
        return;
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartPoint = [recognizer locationInView:self.view];
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint currentPoint = [recognizer locationInView:self.view];
        if (!self.showFromRight) {
            [self move:self.sideBarWidth + currentPoint.x - self.panStartPoint.x];
        } else {
            [self move:self.sideBarWidth + self.panStartPoint.x - currentPoint.x];
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint endPoint = [recognizer locationInView:self.view];
        
        if (!self.showFromRight) {
            if (self.panStartPoint.x - endPoint.x < self.sideBarWidth / 3) {
                [self showAnimatedFrom:YES deltaX:endPoint.x - self.panStartPoint.x];
            } else {
                [self dismissAnimated:YES deltaX:endPoint.x - self.panStartPoint.x];
            }
        } else {
            if (self.panStartPoint.x - endPoint.x >= self.sideBarWidth / 3) {
                [self showAnimatedFrom:YES deltaX:self.panStartPoint.x - endPoint.x];
            } else {
                [self dismissAnimated:YES deltaX:self.panStartPoint.x - endPoint.x];
            }
        }
    }
}

- (void)handlePanGestureToShow:(UIPanGestureRecognizer *)recognizer inView:(UIView *)parentView
{
    if (!self.isCurrentPanGestureTarget) {
        return;
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartPoint = [recognizer locationInView:parentView];
        [self startShow:self.panStartPoint.x];
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint currentPoint = [recognizer locationInView:parentView];
        if (!self.showFromRight) {
            [self move:currentPoint.x - self.panStartPoint.x];
        } else {
            [self move:self.panStartPoint.x - currentPoint.x];
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint endPoint = [recognizer locationInView:parentView];
        
        if (!self.showFromRight) {
            if (endPoint.x - self.panStartPoint.x >= self.sideBarWidth / 3) {
                [self showAnimatedFrom:YES deltaX:endPoint.x - self.panStartPoint.x];
            } else {
                [self dismissAnimated:YES deltaX:endPoint.x - self.panStartPoint.x];
            }
        } else {
            if (self.panStartPoint.x - endPoint.x >= self.sideBarWidth / 3) {
                [self showAnimatedFrom:YES deltaX:self.panStartPoint.x - endPoint.x];
            } else {
                [self dismissAnimated:YES deltaX:self.panStartPoint.x - endPoint.x];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != gestureRecognizer.view) {
        return NO;
    }
    return YES;
}

#pragma mark - ContentView
- (void)setContentViewInSideBar:(UIView *)contentView
{
    if (self.contentView != nil) {
        [self.contentView removeFromSuperview];
    }
    
    self.contentView = contentView;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
}

#pragma mark - Helper
- (void)addToParentViewController:(UIViewController *)parentViewController callingAppearanceMethods:(BOOL)callAppearanceMethods
{
    if (self.parentViewController != nil) {
        [self removeFromParentViewControllerCallingAppearanceMethods:callAppearanceMethods];
    }
    
    if (callAppearanceMethods) [self beginAppearanceTransition:YES animated:NO];
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:self];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

- (void)removeFromParentViewControllerCallingAppearanceMethods:(BOOL)callAppearanceMethods
{
    if (callAppearanceMethods) [self beginAppearanceTransition:NO animated:NO];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (callAppearanceMethods) [self endAppearanceTransition];
}
@end
