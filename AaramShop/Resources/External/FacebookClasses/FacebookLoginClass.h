

#import <Foundation/Foundation.h>
@interface FacebookLoginClass : NSObject
@property(nonatomic,retain)NSMutableDictionary *dictFacebookUserinfo;
@property (nonatomic, retain) NSInvocation *callback;
-(void)facebookLoginMethod;
@end
