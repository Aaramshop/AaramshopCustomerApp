//
//  ChatCustomKeyboardViewController.m

//
//  Created by Pankaj on 9/7/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "ChatCustomKeyboardViewController.h"

#define kViewMainContainerHeight 216
#define kViewMainContainerWidth 320
#define kViewDashboardHeight 180
#define kViewDashboardWidth 320
#define kViewPageControlHeight 15
#define kViewPageControlWidth 320


#define kViewBottomToolBarHeight 41
#define kViewBottomToolBarWidth 320
#define kButtonBottomHeight 41
#define kButtonBottomWidth 60

#define kButtonBuyHeight 25
#define kButtonBuyWidth 50

#define kTagBtnStiker 786
#define kTagBtnSmiley 787
#define kTagBtnBadge 788
#define kTagBtnBuy 789
#define kTagViewStiker 800
#define kTagViewSmiley 801
#define kTagViewBadge 802
#define kTagViewBuy 803

#define kTagPageControl 987







@interface ChatCustomKeyboardViewController ()
{
    

}

@end

@implementation ChatCustomKeyboardViewController

//changed17-9-13
@synthesize  custEmojiArray,custEmotionsArray,custStickerArray;
//end
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

-(id)init{
    
    
    CGRect device = [[UIScreen mainScreen] bounds];
    float yAxis = 0;
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    if ([iOSVersion floatValue]>=7.0)
    {
        yAxis=0;
    }
    if([Utils isIPhone5])
    {
        [self.view setFrame:CGRectMake(0, device.size.height - kViewMainContainerHeight , kViewMainContainerWidth, kViewMainContainerHeight)];
    }
    else
    {
        [self.view setFrame:CGRectMake(0, device.size.height - 216 , kViewMainContainerWidth, 304)];
    }
    [self.view setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    
    viewMainContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0+yAxis, kViewMainContainerWidth, kViewMainContainerHeight)];
    viewDashboardContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewDashboardWidth, kViewDashboardHeight)];
    viewPageControl = [[UIView alloc] initWithFrame:CGRectMake(0, kViewDashboardHeight, kViewPageControlWidth, kViewPageControlHeight)];
//
//
//    
//    viewBottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kViewDashboardHeight + kViewPageControlHeight+yAxis , kViewDashboardWidth, kViewBottomToolBarHeight)];
//    
//    
//    //Adding background image to the Custom keyboard
    UIImageView *imgBackground = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, kViewMainContainerWidth, kViewMainContainerHeight)];
    [imgBackground setImage:[UIImage imageNamed:@"keyboard_bg.png"]];
    [viewMainContainer addSubview:imgBackground];
    [viewMainContainer sendSubviewToBack:imgBackground];
    [self.view addSubview:viewMainContainer];

//    imgBackground = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, kViewBottomToolBarWidth, kViewBottomToolBarHeight)];
//    [imgBackground setImage:[UIImage imageNamed:@"chatTabsBg@2x.png"]];
//    [viewBottomToolBar addSubview:imgBackground];
//    [viewBottomToolBar sendSubviewToBack:imgBackground];
//  
//    //commented temporary
////    [self.view addSubview:viewBottomToolBar];
//    //end
//    
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kViewPageControlWidth, kViewPageControlHeight)];
//    UIImage *image = [UIImage imageNamed:@"keyboard_bg.png"];
//    [imgView setImage:image];
    [viewPageControl setBackgroundColor:[UIColor clearColor]];
//    [viewPageControl addSubview:imgView];
    
    
    
    
    [self.view addSubview:viewPageControl];
    
    
    
    [viewMainContainer addSubview:viewPageControl];
    
    [self setBottomToolBar];
//    [self showCustomKeyboardSmiley:nil];
    [self showOptionView];

    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view downSubviews:self.view];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBottomToolBar{
    
    
    int x = 0;
    UIImage *image;
    
    self.btnSmiley = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnSmiley setFrame:CGRectMake(x, 0, kButtonBottomWidth, kButtonBottomHeight)];
    image = [UIImage imageNamed:@"chatTabsInactiveBg.png"];
    [self.btnSmiley setBackgroundImage:image forState:UIControlStateNormal];
    self.btnSmiley.showsTouchWhenHighlighted = YES;
    [self.btnSmiley setTitle:@"Smiley" forState:UIControlStateNormal];
    [self.btnSmiley.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [self.btnSmiley setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [self.btnSmiley setTag:kTagBtnSmiley];
    [self.btnSmiley addTarget:self action:@selector(showCustomKeyboardSmiley:) forControlEvents:UIControlEventTouchUpInside];
    [viewBottomToolBar addSubview:self.btnSmiley];

    
    x += kButtonBottomWidth;
    
    self.btnEmoticons = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnEmoticons setFrame:CGRectMake(x, 0, kButtonBottomWidth, kButtonBottomHeight)];
    image = [UIImage imageNamed:@"chatTabsInactiveBg.png"];
    [self.btnEmoticons setBackgroundImage:image forState:UIControlStateNormal];
    self.btnEmoticons.showsTouchWhenHighlighted = YES;
    [self.btnEmoticons setTitle:@"Emoticons" forState:UIControlStateNormal];
    [self.btnEmoticons.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [self.btnEmoticons setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnEmoticons setTag:kTagBtnBadge];
    [self.btnEmoticons addTarget:self action:@selector(showCustomKeyboardEmoticons:) forControlEvents:UIControlEventTouchUpInside];
    [viewBottomToolBar addSubview:self.btnEmoticons];
    
     x += kButtonBottomWidth;
    
    self.btnStiker = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnStiker setFrame:CGRectMake(x, 0, kButtonBottomWidth, kButtonBottomHeight + 1)];
    image = [UIImage imageNamed:@"chatTabsInactiveBg.png"];
    [self.btnStiker setBackgroundImage:image forState:UIControlStateNormal];
    //    [btnStiker setBackgroundImage:image forState:UIControlStateHighlighted];
    self.btnStiker.showsTouchWhenHighlighted = YES;
    
    [self.btnStiker setTitle:@"Stickers" forState:UIControlStateNormal];
    [self.btnStiker.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [self.btnStiker setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.btnStiker setTag:kTagBtnStiker];
    [self.btnStiker addTarget:self action:@selector(showCustomKeyboardStikers:) forControlEvents:UIControlEventTouchUpInside];
    [viewBottomToolBar addSubview:self.btnStiker];
    
    x += kButtonBottomWidth;
   
    self.btnPictures = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnPictures setFrame:CGRectMake(x, 0, kButtonBottomWidth, kButtonBottomHeight + 1)];
    image = [UIImage imageNamed:@"chatTabsInactiveBg.png"];
    [self.btnPictures setBackgroundImage:image forState:UIControlStateNormal];
    //    [btnStiker setBackgroundImage:image forState:UIControlStateHighlighted];
    self.btnPictures.showsTouchWhenHighlighted = YES;
   
    [self.btnPictures setTitle:@"Pictures" forState:UIControlStateNormal];
    [self.btnPictures.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [self.btnPictures setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   
    [self.btnPictures setTag:kTagBtnStiker];
    [self.btnPictures addTarget:self action:@selector(showCustomImagePicker:) forControlEvents:UIControlEventTouchUpInside];
    [viewBottomToolBar addSubview:self.btnPictures];
   

    
    
    //Code for Buy button--- To be implemented later
    
//    x = kViewBottomToolBarWidth - 5 - kButtonBuyWidth;
//    
//    UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnBuy setFrame:CGRectMake(x, (kViewBottomToolBarHeight - kButtonBuyHeight)/2, kButtonBuyWidth, kButtonBuyHeight)];
//    image = [UIImage imageNamed:@"keyboard_btn_buy.png"];
//    [btnBuy setBackgroundImage:image forState:UIControlStateNormal];
//    [btnBuy setTitle:@"Buy" forState:UIControlStateNormal];
//    [btnBuy.titleLabel setFont:[UIFont fontWithName:kProximaSemiBold size:10.0f]];
//    [btnBuy.titleLabel setTextColor: [UIColor whiteColor]];
//    [btnBuy setTag:kTagBtnBuy];
//    [btnBuy addTarget:self action:@selector(showBuyDetails:) forControlEvents:UIControlEventTouchUpInside];
//    [viewBottomToolBar addSubview:btnBuy];
//    
//    [viewMainContainer addSubview:viewBottomToolBar];
//    [viewMainContainer bringSubviewToFront:viewBottomToolBar];
    
    
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageNumber = scrollView.contentOffset.x / scrollView.bounds.size.width;
   
    
    for (id obj in [viewPageControl subviews]) {
        
        if ([(UIImageView*)obj isKindOfClass:[UIImageView class]] && [(UIImageView*)obj tag]) {
            if ([(UIImageView*)obj tag] == (kTagPageControl + pageNumber)) {
                [obj setImage:[UIImage imageNamed:@"keyboard_toggle_selected.png"]];
            }
            else{
                [obj setImage:[UIImage imageNamed:@"keyboard_toggle_not_selected.png"]];
            }
        }
       
    }
}

-(void)setPageControlWith:(int)totalPages{
    
    int gap = 5;
    int width = 7;
    int height = 7;
    int x = (kViewPageControlWidth - ((totalPages * width) + (totalPages - 1) * gap)) / 2;
    int y = (kViewPageControlHeight - height) / 2;
    
    
//    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(x, y, width, height)];
//    pageControl.numberOfPages = totalPages;
//    pageControl.currentPage = 0;
//    [viewPageControl addSubview:pageControl];
    
    for (int i = 0; i < totalPages; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
       
        if (i == 0) {
             [imgView setImage:[UIImage imageNamed:@"keyboard_toggle_selected.png"]];
        }else{
             [imgView setImage:[UIImage imageNamed:@"keyboard_toggle_not_selected.png"]];
        }
        
        [imgView setTag:kTagPageControl + i ];
        [viewPageControl addSubview:imgView];
        
        x += width + gap;
        
    }
    
}

- (void)showCustomImagePicker:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(ChatCustomKeyboardViewDelegate)])
    {
        [self.delegate btnImageChangeClicked:nil];
    }
}

-(void)showCustomKeyboardSmiley:(id)sender{
    
    //30-5-14 stop emoticons
    if ([self.delegate conformsToProtocol:@protocol(ChatCustomKeyboardViewDelegate)])
    {
        [self.delegate customSmileyClicked:nil];
        return;
    }
 //end
     [self removeSubviewsOfDashboard];
   
    UIScrollView *scrollviewEmojiContainer;
    //Adding ScrollView and components to the Dashboard
    if (!arrayEmoji) {
           arrayEmoji = [self allocateEmojiArray];
        }
        
        scrollviewEmojiContainer = [[UIScrollView alloc] init];
        [scrollviewEmojiContainer setFrame:viewDashboardContainer.frame];
        [scrollviewEmojiContainer setScrollsToTop:YES];
        [scrollviewEmojiContainer setShowsHorizontalScrollIndicator:NO];
        [scrollviewEmojiContainer setShowsVerticalScrollIndicator:NO];
        [scrollviewEmojiContainer setPagingEnabled:YES];
        [scrollviewEmojiContainer setBackgroundColor:[UIColor clearColor]];
        [scrollviewEmojiContainer setDelegate:self];
    
        
        
        int numberOfViews=[arrayEmoji count]%12==0?[arrayEmoji count]/12:[arrayEmoji count]/12+1;
        [self setPageControlWith:numberOfViews];
    
        [scrollviewEmojiContainer setContentSize:CGSizeMake(320*numberOfViews, kViewDashboardHeight)];
        
        for (int i=0; i<numberOfViews; i++) {
            UIView *viewEmo=[[UIView alloc]initWithFrame:CGRectMake(320*i, 0, 320, kViewDashboardHeight)];
           
            int count1=([arrayEmoji count]>((12*i)+12)?12:([arrayEmoji count]-12*i));
            int row=0;
            for (int j=12*i; j<count1+12*i; j++)
            {
                if (j%4==0) {
                    row=row+1;
                }
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                
                    [button setFrame:CGRectMake(15+(j%4)*80,((row-1)*55) + 10,50, 50)];
                
    
                [button setBackgroundColor:[UIColor clearColor]];
                [button setBackgroundImage:[UIImage imageNamed:[[arrayEmoji objectAtIndex:j] valueForKey:@"imageName"]] forState:UIControlStateNormal];
//                [button setBackgroundImage:[UIImage imageNamed:[[arrayEmoji objectAtIndex:j] valueForKey:@"imageName"]] forState:UIControlStateHighlighted];
                [button setTag:j];
                button.showsTouchWhenHighlighted = YES;
                [button addTarget:self action:@selector(emoJiClicked:) forControlEvents:UIControlEventTouchUpInside];
                [viewEmo addSubview:button];
                
            }
            [scrollviewEmojiContainer addSubview:viewEmo];
        }
    [viewDashboardContainer addSubview:scrollviewEmojiContainer];
    [viewMainContainer addSubview:viewDashboardContainer];
    //changed17-9-13
    [self createEmojies];
    //end


}

-(void)showCustomKeyboardStikers:(id)sender{
    
//    [self.btnEmoticons setBackgroundImage:[UIImage imageNamed:@"chatTabsInactiveBg.png"] forState:UIControlStateNormal];
//    [self.btnEmoticons setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    
//    [self.btnSmiley setBackgroundImage:[UIImage imageNamed:@"chatTabsInactiveBg.png"] forState:UIControlStateNormal];
//    [self.btnSmiley setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    
//    [self.btnStiker setBackgroundImage:[UIImage imageNamed:@"chatTabsActiveBg.png"] forState:UIControlStateNormal];
//    [self.btnStiker setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [self removeSubviewsOfDashboard];
    
    
    UIScrollView *scrollviewStickersContainer;
    //Adding ScrollView and components to the Dashboard
    if (!arrayStickers) {
        arrayStickers = [self allocateStickersArray];
    }
    
    scrollviewStickersContainer = [[UIScrollView alloc] init];
    [scrollviewStickersContainer setFrame:viewDashboardContainer.frame];
    [scrollviewStickersContainer setScrollsToTop:YES];
    [scrollviewStickersContainer setShowsHorizontalScrollIndicator:NO];
    [scrollviewStickersContainer setShowsVerticalScrollIndicator:NO];
    [scrollviewStickersContainer setPagingEnabled:YES];
    [scrollviewStickersContainer setBackgroundColor:[UIColor clearColor]];
    [scrollviewStickersContainer setDelegate:self];
    
    
    
    int numberOfViews=[arrayStickers count]%12==0?[arrayStickers count]/12:[arrayStickers count]/12+1;
    [self setPageControlWith:numberOfViews];
    
    [scrollviewStickersContainer setContentSize:CGSizeMake(320*numberOfViews, kViewDashboardHeight)];
    
    for (int i=0; i<numberOfViews; i++) {
        UIView *viewEmo=[[UIView alloc]initWithFrame:CGRectMake(320*i, 0, 320, kViewDashboardHeight)];
        
        int count1=([arrayStickers count]>((12*i)+12)?12:([arrayStickers count]-12*i));
        int row=0;
        for (int j=12*i; j<count1+12*i; j++)
        {
            if (j%4==0) {
                row=row+1;
            }
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(j%5)*65,((row-1)*50) + 10, 40, 40)];
//            [imgView setImage:[UIImage imageNamed:[[arrayStickers objectAtIndex:j] valueForKey:@"imageName"]]];
//            [imgView setContentMode:UIViewContentModeCenter];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//            [button setFrame:CGRectMake(12+(j%4)*85,((row-1)*50) + 10, 40, 40)];
            
            [button setFrame:CGRectMake(15+(j%4)*80,((row-1)*55) + 10,50, 50)];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setBackgroundImage:[UIImage imageNamed:[[arrayStickers objectAtIndex:j] valueForKey:@"imageName"]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:[[arrayStickers objectAtIndex:j] valueForKey:@"imageName"]] forState:UIControlStateHighlighted];
            [button setTag:j];
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(stickersClicked:) forControlEvents:UIControlEventTouchUpInside];
//            [viewEmo addSubview:imgView];
            [viewEmo addSubview:button];
            
        }
        [scrollviewStickersContainer addSubview:viewEmo];
    }
    [viewDashboardContainer addSubview:scrollviewStickersContainer];
    [viewMainContainer addSubview:viewDashboardContainer];
    //changed17-9-13
    [self createSticker];
    //end
    
}
-(void)showCustomKeyboardEmoticons:(id)sender{
    
    [self.btnEmoticons setBackgroundImage:[UIImage imageNamed:@"chatTabsActiveBg.png"] forState:UIControlStateNormal];
    [self.btnEmoticons setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [self.btnSmiley setBackgroundImage:[UIImage imageNamed:@"chatTabsInactiveBg.png"] forState:UIControlStateNormal];
    [self.btnSmiley setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.btnStiker setBackgroundImage:[UIImage imageNamed:@"chatTabsInactiveBg.png"] forState:UIControlStateNormal];
    [self.btnStiker setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self removeSubviewsOfDashboard];
    
    UIScrollView *scrollviewEmoticonsContainer;
    //Adding ScrollView and components to the Dashboard
    if (!arrayEmoticons) {
        arrayEmoticons = [self allocateEmoticonsArray];
    }
    
    scrollviewEmoticonsContainer = [[UIScrollView alloc] init];
    [scrollviewEmoticonsContainer setFrame:viewDashboardContainer.frame];
    [scrollviewEmoticonsContainer setScrollsToTop:YES];
    [scrollviewEmoticonsContainer setShowsHorizontalScrollIndicator:NO];
    [scrollviewEmoticonsContainer setShowsVerticalScrollIndicator:NO];
    [scrollviewEmoticonsContainer setPagingEnabled:YES];
    [scrollviewEmoticonsContainer setBackgroundColor:[UIColor clearColor]];
    [scrollviewEmoticonsContainer setDelegate:self];
    
    
    
    int numberOfViews=[arrayEmoticons count]%12==0?[arrayEmoticons count]/12:[arrayEmoticons count]/12+1;
    [self setPageControlWith:numberOfViews];
    
    [scrollviewEmoticonsContainer setContentSize:CGSizeMake(320*numberOfViews, kViewDashboardHeight)];
    
    for (int i=0; i<numberOfViews; i++) {
        UIView *viewEmo=[[UIView alloc]initWithFrame:CGRectMake(320*i, 0, 320, kViewDashboardHeight)];
        
        int count1=([arrayEmoticons count]>((12*i)+12)?12:([arrayEmoticons count]-12*i));
        int row=0;
        for (int j=12*i; j<count1+12*i; j++)
        {
            if (j%4==0) {
                row=row+1;
            }
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15+(j%4)*80,((row-1)*50) + 10, 40, 40)];
            [imgView setImage:[UIImage imageNamed:[[arrayEmoticons objectAtIndex:j] valueForKey:@"imageName"]]];
            [imgView setContentMode:UIViewContentModeCenter];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(15+(j%4)*80,((row-1)*50) + 10, 40, 40)];
            
            
            [button setBackgroundColor:[UIColor clearColor]];
//            [button setBackgroundImage:[UIImage imageNamed:[[arrayEmoticons objectAtIndex:j] valueForKey:@"imageName"]] forState:UIControlStateNormal];
            //                [button setBackgroundImage:[UIImage imageNamed:[[arrayEmoji objectAtIndex:j] valueForKey:@"imageName"]] forState:UIControlStateHighlighted];
            [button setTag:j];
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(emoticonsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [viewEmo addSubview:imgView];
            [viewEmo addSubview:button];
            
        }
        [scrollviewEmoticonsContainer addSubview:viewEmo];
    }
    [viewDashboardContainer addSubview:scrollviewEmoticonsContainer];
    [viewMainContainer addSubview:viewDashboardContainer];
    //changed17-9-13
    [self createEmotions];
    //end

    
}

-(void)showCustomKeyboardBadge:(id)sender{
    
//    [self removeSubviewsOfDashboard];
    
}
-(void)showBuyDetails:(id)sender{
    
   
    
}

-(void)removeSubviewsOfDashboard{
    
    for (id obj in [viewDashboardContainer subviews]) {
        [obj removeFromSuperview];
    }
    
    for (id obj in [viewPageControl subviews]) {
        [obj removeFromSuperview];
    }
}


-(void)emoJiClicked:(id)sender{
    UIButton *but=(UIButton *)sender;
//    NSLog(@"Clicked %d:", [but tag]);
   //chaned17-9-13
//    NSLog(@" %@",[self.custEmojiArray objectAtIndex :[but tag]]);
    
    //[self customSmileyClicked:[[arrayEmoji objectAtIndex:[but tag]] valueForKey:@"emojiName"]];

    
    [self customSmileyClicked:[[self.custEmojiArray objectAtIndex:[but tag]] valueForKey:@"emojiName"]];
    //end
}

-(void)emoticonsClicked:(id)sender{
    UIButton *but=(UIButton *)sender;
//    NSLog(@"Clicked %d:", [but tag]);
    //chaned17-9-13

    
   // [self customEmoticonsClicked:[[arrayEmoticons objectAtIndex:[but tag]] valueForKey:@"emoticonName"]];
    
    [self customEmoticonsClicked:[[self.custEmotionsArray objectAtIndex:[but tag]] valueForKey:@"emoticonName"]];

//end
    
}

-(void)stickersClicked:(id)sender{
    UIButton *but=(UIButton *)sender;
    //    NSLog(@"Clicked %d:", [but tag]);
    
    //chaned17-9-13

//    [self customStickersClicked:[[arrayStickers objectAtIndex:[but tag]] valueForKey:@"stickerName"]];
    
    [self customStickersClicked:[[self.custStickerArray objectAtIndex:[but tag]] valueForKey:@"stickerName"]];

    //end
    
    
}

-(void)customSmileyClicked:(NSString *)smileyname{
   
    if ([self.delegate conformsToProtocol:@protocol(ChatCustomKeyboardViewDelegate)])
    {
        [self.delegate customSmileyClicked:smileyname];
    }
}
    
-(void)customEmoticonsClicked:(NSString *)emoticonName{
    if ([self.delegate conformsToProtocol:@protocol(ChatCustomKeyboardViewDelegate)])
    {
        [self.delegate customEmoticonsClicked:emoticonName];
    }
}

-(void)customStickersClicked:(NSString *)stickerName{
    if ([self.delegate conformsToProtocol:@protocol(ChatCustomKeyboardViewDelegate)])
    {
        [self.delegate customStickersClicked:stickerName];
    }
}
-(void)cameraClicked{
    
    if ([self.delegate conformsToProtocol:@protocol(ChatCustomKeyboardViewDelegate)])
    {
        [self.delegate btnImageChangeClicked:nil];
    }
}
-(void)soundItClicked{
    
    if ([self.delegate conformsToProtocol:@protocol(ChatCustomKeyboardViewDelegate)])
    {
        [self.delegate soundItClicked:nil];
    }
}
-(NSArray *)allocateEmojiArray{
    
      NSArray *array = [[NSMutableArray alloc] init];
   
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Emoji.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    array = (NSMutableArray *)[NSPropertyListSerialization
                                    propertyListFromData:plistXML
                                    mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                    format:&format
                                    errorDescription:&errorDesc];
    if (!array) {
//        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    return array;
}

-(NSArray *)allocateEmoticonsArray{
    
    NSArray *array = [[NSMutableArray alloc] init];
    
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Emoticons.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Emoticons" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    array = (NSMutableArray *)[NSPropertyListSerialization
                               propertyListFromData:plistXML
                               mutabilityOption:NSPropertyListMutableContainersAndLeaves
                               format:&format
                               errorDescription:&errorDesc];
    if (!array) {
//        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    return array;
}

-(NSArray *)allocateStickersArray{
    
    NSArray *array = [[NSMutableArray alloc] init];
    
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Stickers.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Stickers" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    array = (NSMutableArray *)[NSPropertyListSerialization
                               propertyListFromData:plistXML
                               mutabilityOption:NSPropertyListMutableContainersAndLeaves
                               format:&format
                               errorDescription:&errorDesc];
    if (!array) {
//        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    return array;
}

//changed17-9-13
-(void)createSticker
{
    NSArray *aStickers = [NSArray arrayWithArray:[self allocateStickersArray]];
    if (!self.custStickerArray)
    {
        self.custStickerArray = [[NSMutableArray alloc] init];
        
    }
    for (id aDic in aStickers)
    {
        NSString *aEmotionName = [aDic objectForKey: @"stickerName"];
        NSMutableDictionary *dicFace = [NSMutableDictionary dictionary];
        [dicFace setValue: [NSString stringWithFormat:@"{/%@}",aEmotionName] forKey:@"stickerName"];
        
        [self.custStickerArray addObject:dicFace];
    }
    
}


-(void)createEmotions
{
    NSArray *Emotions = [NSArray arrayWithArray:[self allocateEmoticonsArray]];
    if (!self.custEmotionsArray)
    {
        self.custEmotionsArray = [[NSMutableArray alloc] init];
        
    }
    for (id aDic in Emotions)
    {
        NSString *aEmotionName = [aDic objectForKey: @"emoticonName"];
        NSMutableDictionary *dicFace = [NSMutableDictionary dictionary];
        [dicFace setValue: [NSString stringWithFormat:@"(/%@)",aEmotionName] forKey:@"emoticonName"];
        
        [self.custEmotionsArray addObject:dicFace];
    }
    
}

-(void)createEmojies
{
    NSArray *Emojies = [NSArray arrayWithArray:[self allocateEmojiArray]];
    if (!self.custEmojiArray)
    {
        self.custEmojiArray = [[NSMutableArray alloc] init];

    }
    for (id aDic in Emojies)
    {
        NSString *aEmojiName = [aDic objectForKey: @"emojiName"];
        NSMutableDictionary *dicFace = [NSMutableDictionary dictionary];
        [dicFace setValue: [NSString stringWithFormat:@"[/%@]",aEmojiName] forKey:@"emojiName"];
        
        [self.custEmojiArray addObject:dicFace];
    }

}
//end
- (void)showOptionView
{
    [self removeSubviewsOfDashboard];
    
        UIView *viewEmo=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kViewDashboardHeight)];
    float x = 27.5;
    float y=50;
    float width = 70;
    float height = 70;
        for (int j=0; j<4; j++)
        {
            //            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(j%5)*65,((row-1)*50) + 10, 40, 40)];
            //            [imgView setImage:[UIImage imageNamed:[[arrayStickers objectAtIndex:j] valueForKey:@"imageName"]]];
            //            [imgView setContentMode:UIViewContentModeCenter];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(x,y,width,height)];
            [button setBackgroundColor:[UIColor clearColor]];
//            button.layer.cornerRadius = button.bounds.size.width/2;
//            button.clipsToBounds = YES;

            UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(x, y+70+5, width, 20)];
            lblName.textColor = [UIColor grayColor];
            [lblName setBackgroundColor:[UIColor clearColor]];
            lblName.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
            lblName.textAlignment = NSTextAlignmentCenter;
            if(j==0)
            {
                [button setBackgroundImage:[UIImage imageNamed:@"chatOptionsCamera"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"chatOptionsCamera"] forState:UIControlStateHighlighted];

                [lblName setText:@"Camera"];
                
            }
            if(j==1)
            {
                [button setBackgroundImage:[UIImage imageNamed:@"chatOptionsLocation"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"chatOptionsLocation"] forState:UIControlStateHighlighted];
                [lblName setText:@"Location"];
                
            }
            if(j==2)
            {
                [button setBackgroundImage:[UIImage imageNamed:@"trayIconSticker"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"trayIconSticker"] forState:UIControlStateHighlighted];
                [lblName setText:@"Stickers"];
            }
//            if(j==3)
//            {
//                [button setBackgroundImage:[UIImage imageNamed:@"chatOpSound"] forState:UIControlStateNormal];
//                [button setBackgroundImage:[UIImage imageNamed:@"chatOpSound"] forState:UIControlStateHighlighted];
//                [lblName setText:@"Sound It"];
//            y = y+70+5+25;
//            x = 27.5;
//            }
            
            [button setTag:j+1000];
            button.showsTouchWhenHighlighted = YES;
            [button addTarget:self action:@selector(optionClicked:) forControlEvents:UIControlEventTouchUpInside];
            //            [viewEmo addSubview:imgView];
            [viewEmo addSubview:button];
            [viewEmo addSubview:lblName];
            x = x+width+27.5;
        }
    [viewDashboardContainer addSubview:viewEmo];
    [viewMainContainer addSubview:viewDashboardContainer];
    //changed17-9-13
    //end

}
-(void)optionClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case 1000:
            [self cameraClicked];
            break;
        case 1001:
            [self showCustomKeyboardSmiley:nil];
            break;
        case 1002:
            [self showCustomKeyboardStikers:nil];
            break;
        case 1003:
            [self soundItClicked];
        default:
            break;
    }
}
@end
