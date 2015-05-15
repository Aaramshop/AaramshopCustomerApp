//
//  ChatCustomKeyboardViewController.h

//
//  Created by Pankaj on 9/7/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

            
@protocol ChatCustomKeyboardViewDelegate <NSObject>

@optional
-(void)btnImageChangeClicked:(id)sender;
-(void)customSmileyClicked:(NSString *)smileyname;
-(void)customEmoticonsClicked:(NSString *)emoticonName;
-(void)customStickersClicked:(NSString *)stickerName;
-(void)soundItClicked:(id)sender;
@end
@interface ChatCustomKeyboardViewController : UIViewController<UIScrollViewDelegate>
{
    UIView *viewMainContainer;
    UIView *viewDashboardContainer;
    UIView *viewBottomToolBar;
    UIView *viewPageControl;
    NSArray *arrayEmoji;
    NSArray *arrayEmoticons;
    NSArray *arrayStickers;
}

@property (strong, nonatomic) UIButton *btnSmiley;
@property (strong, nonatomic) UIButton *btnStiker;
@property (strong, nonatomic) UIButton *btnEmoticons;
@property (strong, nonatomic) UIButton *btnBadge;
@property (strong, nonatomic) UIButton *btnPictures;
@property (nonatomic, weak) id<ChatCustomKeyboardViewDelegate> delegate;
//changed17-9-13
@property (nonatomic, retain) NSMutableArray *custEmojiArray;
@property (nonatomic, retain) NSMutableArray *custEmotionsArray;
@property (nonatomic, retain) NSMutableArray *custStickerArray;



//end

-(void)setBottomToolBar;
-(void)setPageControlWith:(int)totalSubViews;

-(void)showCustomKeyboardStickers:(id)sender;
-(void)showCustomKeyboardBadge:(id)sender;
-(void)showBuyDetails:(id)sender;

-(void)removeSubviewsOfDashboard;

-(void)showCustomKeyboardSmiley:(id)sender;
-(void)showCustomKeyboardEmoticons:(id)sender;
-(void)showOptionView;
-(void)showSoundItView;

-(NSArray *)allocateEmojiArray;
-(NSArray *)allocateEmoticonsArray;
-(NSArray *)allocateStickersArray;

@end
