//
//  CDRTranslucentSideBar.m
//  AaramShop
//
//  Created by AppRoutes on 06/04/15.
//  Copyright (c) 2015 AppRoutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
typedef enum
{
    eAccountSettings=0,
    ePreferences,
    eWallet,
	eLogout
}eRowTypeLeftSideBar;
typedef enum
{
    eBeverages=0,
    eBakery,
    eSoap,
    eTea,
    eSnacks
}eRowTypeRightSideBar;
@class CDRTranslucentSideBar;
@protocol CDRTranslucentSideBarDelegate <NSObject,UINavigationControllerDelegate>
@optional

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated;
- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated;
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated;
- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated;
- (void)sideBarDelegatePushMethod:(UIViewController*)viewC;



@end

@interface CDRTranslucentSideBar : UIViewController <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
	AppDelegate *appDel;
}
@property (nonatomic, assign) CGFloat sideBarWidth;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic) BOOL translucent;
@property (nonatomic) UIBarStyle translucentStyle;
@property (nonatomic) CGFloat translucentAlpha;
@property (nonatomic, strong) UIColor *translucentTintColor;
@property (readonly) BOOL hasShown;
@property (readonly) BOOL showFromRight;
@property BOOL isCurrentPanGestureTarget;
@property NSInteger tag;

@property (nonatomic, weak) id<CDRTranslucentSideBarDelegate> delegate;
//@property(nonatomic,strong) RightCollectionViewController *rightSideBarClass;
- (id)init;
- (instancetype)initWithDirectionFromRight:(BOOL)showFromRight;


- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated;

- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated;

- (void)handlePanGestureToShow:(UIPanGestureRecognizer *)recognizer inView:(UIView *)parentView;

- (void)setContentViewInSideBar:(UIView *)contentView;

@end
