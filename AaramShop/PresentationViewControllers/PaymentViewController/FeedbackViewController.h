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
    __weak IBOutlet UIView *viewRating;
    
    __weak IBOutlet UIImageView *imgStore;
    __weak IBOutlet UILabel *lblStoreName;
    __weak IBOutlet UILabel *lblDescText;

    __weak IBOutlet UIButton *btnOK;

    __weak IBOutlet UIButton *btnRating1;
    __weak IBOutlet UIButton *btnRating2;
    __weak IBOutlet UIButton *btnRating3;
    __weak IBOutlet UIButton *btnRating4;
    __weak IBOutlet UIButton *btnRating5;
    
    __weak IBOutlet UITextView *txtView;
    __weak IBOutlet UILabel *lblPlaceHolder;
    
    int rating;
    
    AaramShop_ConnectionManager *aaramShop_ConnectionManager;

}

@property(nonatomic,strong) NSString *strStore_Id;
@property(nonatomic,strong) NSString *strStore_name;
@property(nonatomic,strong) NSString *strStore_image;

@property (nonatomic, copy) FeedbackCompletion feedbackCompletion;


@end
