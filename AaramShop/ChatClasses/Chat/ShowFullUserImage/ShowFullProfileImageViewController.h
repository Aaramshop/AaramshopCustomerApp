//
//  ShowFullProfileImageViewController.h
//  UmmApp
//
//  Created by Neha Saxena on 01/11/2014.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowFullProfileImageViewController : UIViewController <UIActionSheetDelegate>
@property (nonatomic, retain) NSString *imgString;
@property (nonatomic,assign) BOOL isComingFromChat;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewFull;
- (IBAction)btnSaveImage:(id)sender;

@end
