//
//  ChatViewController.h
//  AaramShop
//
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController<CDRTranslucentSideBarDelegate>
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
- (IBAction)btnChatClicked:(id)sender;
@end
