#import "FacebookLoginClass.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>


@implementation FacebookLoginClass

-(void)facebookLoginMethod
{
	NSArray* readPermissions = @[@"email",@"public_profile",@"user_friends",@"publish_actions"];
	
	[FBSession openActiveSessionWithReadPermissions:readPermissions
									   allowLoginUI:YES
								  completionHandler:
	 ^(FBSession *session,
	   FBSessionState state, NSError *error)
	 {
		 [self sessionStateChanged:session state:state error:error];
	 }];
}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
	switch (state)
	{
		case FBSessionStateOpen:
		{
			[[NSUserDefaults standardUserDefaults] setValue:[[[FBSession activeSession] accessTokenData] accessToken] forKey:kFBAccessToken];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[[[FBSession activeSession] accessTokenData] accessToken];
			NSLog(@"%@",[[[FBSession activeSession] accessTokenData] accessToken]);
			
			[self useInfo];
		}
			break;
		case FBSessionStateClosed:
		{
			[[NSNotificationCenter defaultCenter]postNotificationName:@"NotifyFetchedFacebookInformationFailed" object:self.dictFacebookUserinfo userInfo:nil];
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
				 //                 NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user username]];
				 
				 NSString *fbuid = [user valueForKey:@"id"];
				 //                 NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", fbuid];
				 NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=640&height=640", fbuid];
				 self.dictFacebookUserinfo = [[NSMutableDictionary alloc] initWithDictionary:user];
				 
				 //                 NSString *fbuid = [user valueForKey:@"id"];
				 //
				 //                 NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200&height=200", fbuid];
				 
				 [[NSUserDefaults standardUserDefaults] setObject:[[user objectForKey:@"location"] objectForKey:@"id"] forKey:@"facebookLocation"];
				 
				 [self.dictFacebookUserinfo setObject:userImageURL forKey:kFBUserImageURL];
				 
				 [[NSNotificationCenter defaultCenter]postNotificationName:@"NotifyFetchedFacebookInformation" object:self.dictFacebookUserinfo userInfo:nil];
			 }
		 }];
	}
}

@end
