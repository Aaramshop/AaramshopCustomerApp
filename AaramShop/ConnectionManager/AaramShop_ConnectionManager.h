//
//  AaramShop_ConnectionManager.h
//  AaramShop
//
//  Created by Approutes on 17/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef enum
{
    TASK_LOGIN,
    TASK_ENTER_MOBILE_NUMBER,
    TASK_ENTER_LOCATION,
    TASK_VERIFY_MOBILE,
    TASK_RESEND_OTP,
    TASK_FORGOT_PASSWORD,
    TASK_UPDATE_ADDRESS
}CURRENT_TASK;

@protocol AaramShop_ConnectionManager_Delegate <NSObject>

@optional
-(void) didFailWithError:(NSError *)error;
-(void) responseReceived:(id)responseObject;

@end
@interface AaramShop_ConnectionManager : NSObject
{
    CURRENT_TASK currentTask;
}
@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic,assign) CURRENT_TASK currentTask;
@property(nonatomic,weak) id<AaramShop_ConnectionManager_Delegate> delegate;

-(BOOL) getDataForFunction : (NSString *) functionName withInput: (NSMutableDictionary *) aDict withCurrentTask : (CURRENT_TASK) inputTask andDelegate : (id)inputDelegate;
-(BOOL) getDataForFunction:(NSString *)functionName withInput:(NSMutableDictionary *)aDict withCurrentTask:(CURRENT_TASK)inputTask Delegate:(id)inputDelegate andMultipartData:(NSData *)data;

-(void)failureBlockCalled:(NSError *)error;

@end
