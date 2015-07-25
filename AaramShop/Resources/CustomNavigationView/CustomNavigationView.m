//
//  CustomNavigationView.m
//  Insurance App
//
//  Created by Shiv on 05/11/14.
//  Copyright (c) 2014 Kunal Khanna. All rights reserved.
//

#import "CustomNavigationView.h"

#define IS_IPAD  [[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad

#define NAVIGATIONHEIGHT                      64
#define RIGHT_BUTTONLABELWIDTH         (IS_IPAD)?120:64
#define LEFT_BUTTONLABELWIDTH          (IS_IPAD)?120:64

#define NAV_ORIGIN_X                             (IS_IPAD)?120:70
#define ORIGIN_Y                                      27.0
#define HEIGHT                                         30

#define BUTTONLABELPADDING                 7
#define LBLPADDINGWITHIMAGE                (IS_IPAD)?16:12
#define kScreenWidth  [[UIScreen mainScreen ] bounds ].size.width

#define  KBackButton  @"backBtn.png"




@implementation CustomNavigationView
@synthesize btnRight3,btnRight2,btnRight1,imgNavigationBlur;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setFrame:CGRectMake(0, 0, kScreenWidth, NAVIGATIONHEIGHT)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        // NAVIGATION TITLE LABEL
        lblNavigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(RIGHT_BUTTONLABELWIDTH, ORIGIN_Y, kScreenWidth-((RIGHT_BUTTONLABELWIDTH)*2), HEIGHT)];
        lblNavigationTitle.backgroundColor=[UIColor clearColor];
        lblNavigationTitle.textAlignment = NSTextAlignmentCenter;
        [lblNavigationTitle setAdjustsFontSizeToFitWidth:YES];

        
        // Right Button And Label
        lblRightButtonText = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-BUTTONLABELPADDING-(RIGHT_BUTTONLABELWIDTH), ORIGIN_Y, RIGHT_BUTTONLABELWIDTH, HEIGHT)];
        lblRightButtonText.textAlignment = NSTextAlignmentRight;
        
        btnRight1 =  [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRight1 setFrame:CGRectMake(kScreenWidth-(35), ORIGIN_Y, 30, HEIGHT)];
        btnRight1.tag = 1;
        [btnRight1 addTarget:self action:@selector(navigationRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btnRight2 =  [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRight2 setFrame:CGRectMake(btnRight1.frame.origin.x-35, ORIGIN_Y, 30, HEIGHT)];
        btnRight2.tag = 2;
        [btnRight2 addTarget:self action:@selector(navigationRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//
        btnRight3 =  [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRight3 setFrame:CGRectMake(btnRight2.frame.origin.x-35, ORIGIN_Y, 30, HEIGHT)];
        btnRight3.tag = 3;
        [btnRight3 addTarget:self action:@selector(navigationRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        // Left Button And Label
        lblLeftButtonText = [[UILabel alloc] initWithFrame:CGRectMake(BUTTONLABELPADDING, ORIGIN_Y, LEFT_BUTTONLABELWIDTH, HEIGHT)];
        lblLeftButtonText.textAlignment = NSTextAlignmentLeft;
        
        btnLeft =  [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLeft setFrame:CGRectMake(-10, ORIGIN_Y, RIGHT_BUTTONLABELWIDTH, HEIGHT)];
        [btnLeft addTarget:self action:@selector(navigationLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        // Update Text Color
        lblRightButtonText.textColor = lblLeftButtonText.textColor = lblNavigationTitle.textColor = [UIColor whiteColor];
        self.image = [UIImage imageNamed:@""];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.1)
        {
            // There was a bug in iOS versions 7.0.x which caused vImage buffers
            // created using vImageBuffer_InitWithCGImage to be initialized with data
            // that had the reverse channel ordering (RGBA) if BOTH of the following
            // conditions were met:
            //      1) The vImage_CGImageFormat structure passed to
            //         vImageBuffer_InitWithCGImage was configured with
            //         (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little)
            //         for the bitmapInfo member.  That is, if you wanted a BGRA
            //         vImage buffer.
            //      2) The CGImage object passed to vImageBuffer_InitWithCGImage
            //         was loaded from an asset catalog.
            //
            // To reiterate, this bug only affected images loaded from asset
            // catalogs.
            //
            // The workaround is to setup a bitmap context, draw the image, and
            // capture the contents of the bitmap context in a new image.
            UIGraphicsBeginImageContextWithOptions(self.image.size, NO, self.image.scale);
            [self.image drawAtPoint:CGPointZero];
            self.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        imgNavigationBlur= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NAVIGATIONHEIGHT)];
        
        effectImage = [UIImageEffects imageByApplyingLightEffectToImageOnNavigationBar:self.image];
        imgNavigationBlur.image=effectImage;
        
        [self addSubview:imgNavigationBlur];
        [self addSubview:lblNavigationTitle];
        [self addSubview:lblRightButtonText];
        [self addSubview:lblLeftButtonText];
        [self addSubview:btnRight1];
        [self addSubview:btnRight2];
        [self addSubview:btnRight3];

        [self addSubview:btnLeft];
        
        // HIde Left and Right Buttom
        // Until title not sat
        [self setCustomNavigationRightButtonHidden:NO];
        [self setCustomNavigationLeftButtonHidden:NO];
    }
    return self;
}
#pragma mark - Set text in Nav title and button -
// Set Navigation and Button Title
-(void)setCustomNavigationTitle:(NSString *)navTitle
{
    lblNavigationTitle.text = NSLocalizedString(navTitle, nil);
}
-(void)setCustomNavigationRightButtonText:(NSString *)rightText
{
    lblRightButtonText.text = NSLocalizedString(rightText, nil);
    [self setCustomNavigationRightButtonHidden:NO];
}
-(void)setCustomNavigationLeftButtonText:(NSString *)leftText
{
    lblLeftButtonText.text = NSLocalizedString(leftText, nil);
    [self setCustomNavigationLeftButtonHidden:NO];
}

#pragma mark - Set Arrow Image for Button -
// Set Left and Right Button Images If Required.
-(void)setCustomNavigationRightArrowImage
{
//    [btnRight setTitle:@"About" forState:UIControlStateNormal];
//    btnRight.titleLabel.font = [UIFont fontWithName:@"YanoneKaffeesatz-Light" size:22.0f] ;
//    [btnRight setTitleColor: [UIColor colorWithRed:217.0/255.0f green:136.0/255.0f blue:40.0/255.0f alpha:1.0f] forState:UIControlStateNormal];
//    [btnRight setImageEdgeInsets:UIEdgeInsetsMake(0, (RIGHT_BUTTONLABELWIDTH)/1.3, 0, 0)];
//    // Update label frame
//    [lblRightButtonText setFrame:CGRectMake(kScreenWidth-(BUTTONLABELPADDING+(LBLPADDINGWITHIMAGE))-(RIGHT_BUTTONLABELWIDTH), ORIGIN_Y, RIGHT_BUTTONLABELWIDTH, HEIGHT)];
    
}
-(void)setCustomNavigationLeftArrowImage
{
    // Add Image
    [btnLeft setImage:[UIImage imageNamed:IS_IPAD?KBackButton:KBackButton] forState:UIControlStateNormal];
    //[btnLeft setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, (LEFT_BUTTONLABELWIDTH)/1.2)];
    // Update label frame
    
    
    [lblLeftButtonText setFrame:CGRectMake(BUTTONLABELPADDING+(LBLPADDINGWITHIMAGE), ORIGIN_Y, LEFT_BUTTONLABELWIDTH, HEIGHT)];
}

-(void)setCustomNavigationLeftArrowImageWithImageName :(NSString*)ImageName
{
    // Add Image
    [btnLeft setImage:[UIImage imageNamed:ImageName] forState:UIControlStateNormal];
    // Update label frame
    
    
    [lblLeftButtonText setFrame:CGRectMake(BUTTONLABELPADDING+(LBLPADDINGWITHIMAGE), ORIGIN_Y, LEFT_BUTTONLABELWIDTH, HEIGHT)];
}

-(void)setCustomNavigationRightArrowImageWithImageName :(NSString*)ImageName
{
    // Add Image
//    [btnRight setImage:[UIImage imageNamed:ImageName] forState:UIControlStateNormal];
//    //[btnLeft setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, (LEFT_BUTTONLABELWIDTH)/1.2)];
//    // Update label frame
//    
//    
//    [lblRightButtonText setFrame:CGRectMake(BUTTONLABELPADDING+(LBLPADDINGWITHIMAGE) +100 , ORIGIN_Y, RIGHT_BUTTONLABELWIDTH, HEIGHT)];
}


#pragma mark - Hide/Unhide Nav Button -
// Hide Left and Right Button if Required
-(void)setCustomNavigationRightButtonHidden:(BOOL)hiddenType
{
//    //    if([CDataManager isReadOnlyRequiredForFirstThreeStep])
//    //    {
//    //        [lblRightButtonText setHidden:YES];
//    //        [btnRight setHidden:YES];
//    //    }
//    //    else
//    //    {
//    [lblRightButtonText setHidden:hiddenType];
//    [btnRight setHidden:hiddenType];
    //    }
}
-(void)setCustomNavigationLeftButtonHidden:(BOOL)hiddenType
{
    //    if([CDataManager isReadOnlyRequiredForFirstThreeStep])
    //    {
    //        [lblLeftButtonText setHidden:YES];
    //        [btnLeft setHidden:YES];
    //    }
    //    else
    //    {
    [lblLeftButtonText setHidden:hiddenType];
    [btnLeft setHidden:hiddenType];
    //    }
}

#pragma mark - User Intraction -
-(void)setCustomNavigationRightButtonIntraction:(BOOL)intractionType
{
   // [btnRight setUserInteractionEnabled:intractionType];
}
-(void)setCustomNavigationLeftButtonIntraction:(BOOL)intractionType
{
    [btnLeft setUserInteractionEnabled:intractionType];
}

#pragma mark - Nav Button Actions -
// Right and Left Button Actions
-(void)navigationRightButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol( CustomNavigationDelegate)] && [self.delegate respondsToSelector:@selector(customNavigationRightButtonClick :)])
    {
        [self.delegate customNavigationRightButtonClick:sender];
    }
}

-(void)navigationLeftButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol( CustomNavigationDelegate)] && [self.delegate respondsToSelector:@selector(customNavigationLeftButtonClick :)])
    {
        [self.delegate customNavigationLeftButtonClick:sender];
    }
}

// Show Right Nav Button on View Only Mode
-(void)showCustomNavigationRightButtonOnViewOmlyMode
{
//    [lblRightButtonText setHidden:NO];
//    [btnRight setHidden:NO];
}

#pragma mark - Special Case to Hide -
-(void)setCustomNavigationRightButtonHiddenForceful:(BOOL)hiddenType
{
//    [lblRightButtonText setHidden:hiddenType];
//    [btnRight setHidden:hiddenType];
}

-(void)setCustomNavigationLeftButtonHiddenForceful:(BOOL)hiddenType
{
    [lblLeftButtonText setHidden:hiddenType];
    [btnLeft setHidden:hiddenType];
}

#pragma mark To remove Navigation Button Image---

-(void)removeCustomNavigationRightArrowImage
{
//    [btnRight setImage:nil forState:UIControlStateNormal];
//    [lblRightButtonText setFrame:CGRectMake(kScreenWidth-BUTTONLABELPADDING-(RIGHT_BUTTONLABELWIDTH), ORIGIN_Y, RIGHT_BUTTONLABELWIDTH, HEIGHT)];
    
}
-(void)removeCustomNavigationLeftArrowImage
{
    [btnLeft setImage:nil forState:UIControlStateNormal];
    [lblLeftButtonText setFrame:CGRectMake(BUTTONLABELPADDING, ORIGIN_Y, LEFT_BUTTONLABELWIDTH, HEIGHT)];
}


@end
