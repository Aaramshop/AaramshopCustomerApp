#import "FacebookLoginClass.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FacebookLoginClass


-(void)facebookLoginMethod
{
//    NSArray* readPermissions = @[@"basic_info",@"user_location",@"user_birthday",@"user_likes",@"email",@"user_photos"];
    
    NSArray* readPermissions =@[@"user_photos",@"user_videos",@"offline_access",@"email"];
    [FBSession openActiveSessionWithReadPermissions:readPermissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error)
     {
         [self sessionStateChanged:session state:state error:error];
     }];
}

-(void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        {
            [[[FBSession activeSession] accessTokenData] accessToken];
            AppDelegate *app = APP_DELEGATE;
            [Utils startActivityIndicatorInView:app.window withMessage:nil];
            [self useInfo];
        }        
            break;
        case FBSessionStateClosed:
        {
            break;
        }
        case FBSessionStateClosedLoginFailed:
        {
            [FBSession.activeSession closeAndClearTokenInformation];
        }
            break;
        default:
            break;
    }
}
-(void)useInfo
{
   if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error)
         {
             if (!error)
             {
                 self.dictFacebookUserinfo = [[NSMutableDictionary alloc] initWithDictionary:user];
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"NotifyFetchedFacebookInformation" object:self.dictFacebookUserinfo userInfo:nil];
                 
          }
         }];
    }
    AppDelegate *app = APP_DELEGATE;
    [Utils stopActivityIndicatorInView:app.window];

}
@end
