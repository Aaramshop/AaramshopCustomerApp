//
//  CustomNavigationView.h
//  Insurance App
//
//  Created by Shiv on 05/11/14.
//  Copyright (c) 2014 Kunal Khanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomNavigationDelegate <NSObject>

@optional

-(void)customNavigationRightButtonClick:(UIButton *)sender;
-(void)customNavigationLeftButtonClick:(UIButton *)sender;

@end

@interface CustomNavigationView : UIView
{
    UILabel *lblNavigationTitle;
    UILabel *lblRightButtonText;
    UILabel *lblLeftButtonText;
    UILabel *lblBottomLine;

    UIButton *btnLeft;
    UIImage * effectImage;
}
@property (nonatomic) UIImage *image;
@property(nonatomic,strong) UIImageView *imgNavigationBlur;
@property(nonatomic,strong) UIButton *btnRight1;
@property(nonatomic,strong) UIButton *btnRight2;
@property(nonatomic,strong) UIButton *btnRight3;

@property (nonatomic, weak) id <CustomNavigationDelegate> delegate;


// Set Navigation and Button Title
-(void)setCustomNavigationTitle:(NSString *)navTitle;
-(void)setCustomNavigationRightButtonText:(NSString *)rightText;
-(void)setCustomNavigationLeftButtonText:(NSString *)leftText;



// Set Left and Right Button Images If Required.
-(void)setCustomNavigationRightArrowImage;
-(void)setCustomNavigationLeftArrowImage;


-(void)removeCustomNavigationRightArrowImage;
-(void)removeCustomNavigationLeftArrowImage;


-(void)setCustomNavigationRightButtonIntraction:(BOOL)intractionType;
-(void)setCustomNavigationLeftButtonIntraction:(BOOL)intractionType;

-(void)showCustomNavigationRightButtonOnViewOmlyMode;

-(void)setCustomNavigationLeftArrowImageWithImageName :(NSString*)ImageName;
-(void)setCustomNavigationRightArrowImageWithImageName :(NSString*)ImageName;

//Special Case
-(void)setCustomNavigationRightButtonHiddenForceful:(BOOL)hiddenType;
-(void)setCustomNavigationLeftButtonHiddenForceful:(BOOL)hiddenType;

@end



