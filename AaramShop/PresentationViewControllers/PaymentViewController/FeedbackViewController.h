//
//  FeedbackViewController.h
//  AaramShop
//
//  Created by Approutes on 05/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FeedbackCompletion)(void);

@interface FeedbackViewController : UIViewController<AaramShop_ConnectionManager_Delegate>
{
    IBOutlet UIView *viewRating;
    
    IBOutlet UIImageView *imgStore;
    IBOutlet UILabel *lblStoreName;
    IBOutlet UILabel *lblDescText;
    
    IBOutlet UIButton *btnOK;
    
    IBOutlet UIButton *btnRating1;
    IBOutlet UIButton *btnRating2;
    IBOutlet UIButton *btnRating3;
    IBOutlet UIButton *btnRating4;
    IBOutlet UIButton *btnRating5;
    
    IBOutlet UITextView *txtView;
    IBOutlet UILabel *lblPlaceHolder;
    
    int rating;
    
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;
    
}
- (IBAction)handleSingleTap:(id)sender;
@property(nonatomic,strong) NSString *strStore_Id;
@property(nonatomic,strong) NSString *strStore_name;
@property(nonatomic,strong) NSString *strStore_image;

@property (nonatomic, copy) FeedbackCompletion feedbackCompletion;


@end
