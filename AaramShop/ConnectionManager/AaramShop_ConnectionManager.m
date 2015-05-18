//
//  AaramShop_ConnectionManager.m
//  AaramShop
//
//  Created by Approutes on 17/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AaramShop_ConnectionManager.h"

@implementation AaramShop_ConnectionManager
@synthesize delegate,sessionManager,currentTask;

-(BOOL) getDataForFunction:(NSString *)functionName withInput:(NSMutableDictionary *)aDict withCurrentTask:(CURRENT_TASK)inputTask andDelegate:(id)inputDelegate
{
    
    self.delegate = inputDelegate;
    self.currentTask = inputTask;
    
    AFHTTPSessionManager *manager = [Utils InitSetUpForWebService];
    [manager POST:functionName parameters:aDict
          success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"value %@",responseObject);
         [AppManager stopStatusbarActivityIndicator];
         if(self.delegate != nil && [self.delegate respondsToSelector:@selector(responseReceived:)])
         {
             [self.delegate performSelector:@selector(responseReceived:) withObject:self];
         }
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"value %@",error);
         [AppManager stopStatusbarActivityIndicator];
         
         if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didFailWithError:)])
         {
             [self.delegate performSelector:@selector(didFailWithError:) withObject:self];
         }
         
     }];
    return YES;
}

@end
