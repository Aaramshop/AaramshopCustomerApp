//
//  OptionViewController.h
//  AaramShop
//
//  Created by Approutes on 30/04/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface OptionViewController : UIViewController
{
    __weak IBOutlet UIView *subView;
    
}
- (IBAction)btnNewUserClick:(UIButton *)sender;
- (IBAction)btnExistingUserClick:(UIButton *)sender;

@end
