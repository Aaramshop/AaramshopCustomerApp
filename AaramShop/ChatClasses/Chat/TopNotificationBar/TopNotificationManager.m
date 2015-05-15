//
//  NotificationManager.m
//  Notification
//

#import "TopNotificationManager.h"
//20-5-14
#import "CustomNotificationView.h"
//end
#import "JCRBlurView.h"
#import "SMChatViewController.h"

#define kSecondsVisibleDelay 5.0f
static TopNotificationManager *instance = nil;

@implementation TopNotificationManager

+(TopNotificationManager *)sharedManager
{
    if(instance == nil)
    {
        instance = [[TopNotificationManager alloc] init];
    }
    return instance;
}

-(id)init
{
    if( (self = [super init]) ) {
        
        // Setup the array
        notificationQueue = [[NSMutableArray alloc] init];
        
        // Set not showing by default
        showingNotification = NO;
    }
    return self;
}


#pragma messages
+(void)notificationWithMessage:(NSDictionary*)message
{
    // Show the notification
    [[TopNotificationManager sharedManager] addNotificationViewWithMessage:message];
}

-(void)addNotificationViewWithMessage:(NSDictionary *)message
{
      
#pragma mark - this code is written for setting of message for show preview
//    NSDictionary *dictSettings = [[[NSUserDefaults standardUserDefaults] objectForKey:kAPP_SETTINGS] objectForKey:kMESSAGE_NOTIFICATION];
//    if([[dictSettings objectForKey:kSHOW_PREVIEW]integerValue]==0)
//    {
//        return;
//    }
#pragma mark - end
    
    // Grab the background image for calculations
    UIImage *bgImage = [UIImage imageNamed:@"TransparentBlack"];
    
    // Create the notification view (here you could just call another UIVirew subclass)
    
    //20-5-14
    CustomNotificationView *notificationView = [[CustomNotificationView alloc] initWithFrame:CGRectMake(0,0-bgImage.size.height ,bgImage.size.width, bgImage.size.height)];
    notificationView.backgroundColor = [UIColor clearColor];
    notificationView.opaque = NO;
    JCRBlurView *blurView = [JCRBlurView new];
    [blurView setBlurTintColor:[UIColor blackColor	]];
    [blurView setAlpha:0.8];
    [blurView setOpaque:NO];
    [blurView setFrame:CGRectMake(0, 0, 320, 69)];
    [blurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [notificationView addSubview:blurView];
    
    
    //end
    
    [notificationView setBackgroundColor:[UIColor clearColor]];
    
    // Add head image of sender
#pragma mark - this is used for getting details of friends
    
//    AddressBookDB *frnz = [[Database database] fetchDataFromDatabaseForEntity:@"AddressBookDB" chatUserName:[message objectForKey:@"sender"] keyName:kchatUserName];
//    //20-5-14
//    notificationView.FrndDetail = frnz;
    
//    notificationView.FrndDetail = [message objectForKey:@"sender"];
    
    NSDictionary *dict = nil;
#pragma end
    
//    if(frnz!=nil)
//    {
//    
//        UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handledTapGesture:)];
//        [tapGeture setNumberOfTapsRequired:1];
//        [notificationView addGestureRecognizer:tapGeture];
//
//    UIImageView *headImageView = [[UIImageView alloc] init];
//    headImageView.frame =CGRectMake(10, 23, 43, 43);
//        [headImageView setImageWithURL:[NSURL URLWithString:frnz.profilePic] placeholderImage:[UIImage imageNamed:@"chatDefault"]];
////    [headImageView setImage:[UIImage imageNamed:@"chatDefault"]];
//
//    headImageView.layer.cornerRadius = 21.5;
//    headImageView.backgroundColor=[UIColor grayColor];
//    headImageView.clipsToBounds =YES;
//    [notificationView addSubview:headImageView];
//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 320-110, 15)];
//    
//    [label1 setText:[message objectForKey:@"msg"]];
//    [label1 setFont:[UIFont systemFontOfSize:13.0f]];
//    [label1 setTextColor:[UIColor whiteColor]];
//    [label1 setBackgroundColor:[UIColor clearColor]];
//    [notificationView addSubview:label1];
//    
//    
//    
//    // Add some text label
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 240, 14)];
//    [label setText:frnz.fullName];
////    [label setText:[message objectForKey:@"sender"]];
//    [label setFont:[UIFont boldSystemFontOfSize:13.0f]];
//    //    [label setTextAlignment:UITextAlignmentCenter];
//    [label setTextColor:[UIColor whiteColor]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [notificationView addSubview:label];
//    
//    
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    btn.frame = CGRectMake(320-50, 0, 50,bgImage.size.height);
//    [btn addTarget:self action:@selector(hideCurrentNotification:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setImage:[UIImage imageNamed:@"iconCloseNot"] forState:UIControlStateNormal];
//    [notificationView addSubview:btn];
////    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:notificationView,@"view",frnz.chatUserName,kchatUserName, nil];
//    dict = [NSDictionary dictionaryWithObjectsAndKeys:notificationView,@"view",[message objectForKey:@"sender"],kchatUserName, nil];
//    
//    
//    // Add to the window
//    }
//    else
//    {
        notificationView.anonymousDetail = [message objectForKey:@"sender"];
        UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handledTapGestureForAnonymous:)];
        [tapGeture setNumberOfTapsRequired:1];
        [notificationView addGestureRecognizer:tapGeture];

        UIImageView *headImageView = [[UIImageView alloc] init];
        headImageView.frame =CGRectMake(10, 23, 43, 43);
        [headImageView setImage:[UIImage imageNamed:@"chatDefault"]];
        
        headImageView.layer.cornerRadius = 21.5;
        headImageView.backgroundColor=[UIColor grayColor];
        headImageView.clipsToBounds =YES;
        [notificationView addSubview:headImageView];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 320-110, 15)];
        [label1 setText:[message objectForKey:@"msg"]];
        [label1 setFont:[UIFont systemFontOfSize:13.0f]];
        [label1 setTextColor:[UIColor whiteColor]];
        [label1 setBackgroundColor:[UIColor clearColor]];
        [notificationView addSubview:label1];
        
        
        
        // Add some text label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 240, 14)];
        [label setText:[message objectForKey:@"sender"]];
        [label setFont:[UIFont boldSystemFontOfSize:13.0f]];
        //    [label setTextAlignment:UITextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [notificationView addSubview:label];
        
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(320-50, 0, 50,bgImage.size.height);
        [btn addTarget:self action:@selector(hideCurrentNotification:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"iconCloseNot"] forState:UIControlStateNormal];
        [notificationView addSubview:btn];
        dict = [NSDictionary dictionaryWithObjectsAndKeys:notificationView,@"view",[message objectForKey:@"sender"],kchatUserName, nil];
//    }
    [self showNotificationView:notificationView];
    CustomNotificationView *oldNotificationView = nil;
    if([notificationQueue count]>0)
    {
        oldNotificationView = [[notificationQueue objectAtIndex:0] objectForKey:@"view"];
        [self hideCurrentNotification:oldNotificationView];
    }
    [notificationQueue addObject:dict];
        
}

-(void)showNotificationView:(CustomNotificationView *)notificationView
{
    AppDelegate *delg = APP_DELEGATE;
    [delg.window addSubview:notificationView];
    // Set showing the notification
    showingNotification = YES;
    
    // Animate the view downwards
    [UIView beginAnimations:@"" context:nil];
    
    // Setup a callback for the animation ended
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showNotificationAnimationComplete:finished:context:notiView:showNotificationAnimationComplete:finished:context:notiView:)];
    
    [UIView setAnimationDuration:0.5f];
    
    [notificationView setFrame:CGRectMake(notificationView.frame.origin.x, notificationView.frame.origin.y+notificationView.frame.size.height, notificationView.frame.size.width, notificationView.frame.size.height)];
    
    [UIView commitAnimations];
    [self performSelector:@selector(hideCurrentNotification:) withObject:notificationView afterDelay:kSecondsVisibleDelay];

}

-(void)showNotificationAnimationComplete:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context notiView:(CustomNotificationView *)cstView
{
    // Hide the notification after a set second delay
}

-(void)hideCurrentNotification:(CustomNotificationView *)cstView
{
    if([cstView isKindOfClass:[UIButton class]])
    {
        cstView = [[notificationQueue objectAtIndex:0] objectForKey:@"view"];
        [UIView beginAnimations:@"" context:nil];
        
        // Setup a callback for the animation ended
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(hideNotificationAnimationComplete:finished:context:)];
        
        [UIView setAnimationDuration:0.5f];
        
        [cstView setFrame:CGRectMake(cstView.frame.origin.x, cstView.frame.origin.y-cstView.frame.size.height, cstView.frame.size.width, cstView.frame.size.height)];
        
        [UIView commitAnimations];
        [notificationQueue removeObjectAtIndex:0];
        
    }
    // Get the current view
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"view == %@",cstView];
        NSArray *cstViewArray = [notificationQueue filteredArrayUsingPredicate:predicate];
        if([cstViewArray count]>0)
        {
            // Animate the view downwards
            [UIView beginAnimations:@"" context:nil];
            
            // Setup a callback for the animation ended
            [UIView setAnimationDelegate:self];
//            [UIView setAnimationDidStopSelector:@selector(hideNotificationAnimationComplete:finished:context:)];
            
            [UIView setAnimationDuration:0.5f];
            
            [cstView setFrame:CGRectMake(cstView.frame.origin.x, cstView.frame.origin.y-cstView.frame.size.height, cstView.frame.size.width, cstView.frame.size.height)];
            
            [UIView commitAnimations];
            [cstView removeFromSuperview];
            [notificationQueue removeObject:[cstViewArray lastObject]];
        }
    }
}
-(void)hideCurrentNotificationWithCustomNotificationView:(CustomNotificationView *)notificationView
{
    for(int i = 0;i<[notificationQueue count];i++)
    {
        CustomNotificationView *cstView = [[notificationQueue objectAtIndex:i] objectForKey:@"view"];
        if(cstView == notificationView)
        {
        [UIView beginAnimations:@"" context:nil];
        
        // Setup a callback for the animation ended
        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(hideNotificationAnimationComplete:finished:context:)];
        
        [UIView setAnimationDuration:0.5f];
        
        [notificationView setFrame:CGRectMake(notificationView.frame.origin.x, notificationView.frame.origin.y-notificationView.frame.size.height, notificationView.frame.size.width, notificationView.frame.size.height)];
        
        [UIView commitAnimations];
            [cstView removeFromSuperview];
        }
        else
        {
            [cstView removeFromSuperview];
        }
    }
    
}
-(void)hideNotificationAnimationComplete:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
 
//    // Remove the old one
//    
//    if([notificationQueue count]==0)
//    {
//        return;
//    }
//    CustomNotificationView *notificationView = [[notificationQueue objectAtIndex:0] objectForKey:@"view"];
//    [notificationView removeFromSuperview];
//    [notificationQueue removeObject:[notificationQueue objectAtIndex:0]];
//    
//    if(!showingNotification)
//    {
//        [notificationQueue removeAllObjects];
//    }
//    // Set not showing
//    showingNotification = NO;
//    
//    // Do we have to add anymore items - if so show them
//    if([notificationQueue count] > 0) {
//        CustomNotificationView *v = [[notificationQueue objectAtIndex:0] objectForKey:@"view"];
//        FriendsDetails *frnz = v.FrndDetail;
//        if([APP_DELEGATE getChatWindowOpenedStatusBySender:[[frnz.chatUserName stringByAppendingString:[NSString stringWithFormat:@"@%@",STRChatServerURL]]lowercaseString]])
//        {
//            if([[APP_DELEGATE nav].topViewController isKindOfClass:[SMChatViewController class]])
//                return;
//        }
//        [self showNotificationView:v];
//    }
}
-(void)handledTapGesture:(UITapGestureRecognizer *)inTapGesture
{
    id aTempView = inTapGesture.view;
    CustomNotificationView *aCustNotificationView;
    
    if ([aTempView isKindOfClass:[CustomNotificationView class]])
    {
        
        [aCustNotificationView becomeFirstResponder];
//        [self hideCurrentNotification];
        aCustNotificationView =(CustomNotificationView *)aTempView;
        
        AppDelegate *appDel = APP_DELEGATE;
        
        //21-5-14 crashed issue
//        [notificationQueue removeAllObjects];
        showingNotification = NO;
        //end
        
//        [appDel openChatViewfromNotificationViewByFriendDetail: aCustNotificationView.FrndDetail];
        [self hideCurrentNotificationWithCustomNotificationView:aCustNotificationView];
        [notificationQueue removeAllObjects];
    }
    
}
- (void)handledTapGestureForAnonymous:(UITapGestureRecognizer*)inTapGesture
{
    id aTempView = inTapGesture.view;
    CustomNotificationView *aCustNotificationView;
    
    if ([aTempView isKindOfClass:[CustomNotificationView class]])
    {
        
        [aCustNotificationView becomeFirstResponder];
        //        [self hideCurrentNotification];
        aCustNotificationView =(CustomNotificationView *)aTempView;
        
        AppDelegate *appDel = APP_DELEGATE;
        
        //21-5-14 crashed issue
        //        [notificationQueue removeAllObjects];
        showingNotification = NO;
        //end
        
        [appDel openChatViewfromNotificationViewByFriendDetailAnonymous: aCustNotificationView.anonymousDetail];
        [self hideCurrentNotificationWithCustomNotificationView:aCustNotificationView];
        [notificationQueue removeAllObjects];
    }

}
@end
