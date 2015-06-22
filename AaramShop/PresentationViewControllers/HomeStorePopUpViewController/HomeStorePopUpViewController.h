//
//  HomeStorePopUpViewController.h
//  AaramShop
//
//  Created by Approutes on 09/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomeStorePopUpViewControllerDelegate <NSObject>

-(void)hidePopUp;
@end



@interface HomeStorePopUpViewController : UIViewController
{
  __weak IBOutlet UITextView *txtVWhatsHomeStore;
}
@property(nonatomic,weak) id<HomeStorePopUpViewControllerDelegate> delegate;
@property(nonatomic) __weak IBOutlet UIView *viewPopUp;

- (IBAction)btncloseClick:(UIButton *)sender;

@end
