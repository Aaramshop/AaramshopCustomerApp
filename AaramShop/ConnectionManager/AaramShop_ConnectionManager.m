//
//  AaramShop_ConnectionManager.m
//  AaramShop
//
//  Created by Approutes on 17/05/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AaramShop_ConnectionManager.h"
#import "LoginViewController.h"


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
         
         [AppManager stopStatusbarActivityIndicator];
//        [loginView.loginClickBtn setEnabled:YES];
         
         
         if(self.delegate != nil && [self.delegate respondsToSelector:@selector(responseReceived:)])
         {
             [self.delegate performSelector:@selector(responseReceived:) withObject:responseObject];
         }  
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [AppManager stopStatusbarActivityIndicator];
//         [loginView.loginClickBtn setEnabled:YES];
         if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didFailWithError:)])
         {
             [self.delegate performSelector:@selector(didFailWithError:) withObject:error];
         }
         
     }];
    return YES;
}
-(BOOL) getDataForFunction:(NSString *)functionName withInput:(NSMutableDictionary *)aDict withCurrentTask:(CURRENT_TASK)inputTask Delegate:(id)inputDelegate andMultipartData:(NSData *)data
{
    
    self.delegate = inputDelegate;
    self.currentTask = inputTask;
    
    AFHTTPSessionManager *manager = [Utils InitSetUpForWebService];
    [manager POST:@"" parameters:aDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         if (data) {
             [formData appendPartWithFileData:data name:kProfileImage fileName:@"profileImage.jpg" mimeType:@"image/jpg"];
         }
     }

          success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [AppManager stopStatusbarActivityIndicator];
         if(self.delegate != nil && [self.delegate respondsToSelector:@selector(responseReceived:)])
         {
             [self.delegate performSelector:@selector(responseReceived:) withObject:responseObject];
         }
     }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [AppManager stopStatusbarActivityIndicator];
         
         if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didFailWithError:)])
         {
             [self.delegate performSelector:@selector(didFailWithError:) withObject:error];
         }
         
     }];

     
    return YES;
}

-(void)failureBlockCalled:(NSError *)error
{
    if ([Utils isRequestTimeOut:error])
    {
        [Utils showAlertView:kAlertTitle message:kRequestTimeOutMessage delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:kAlertServiceFailed delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
    }
    

}
@end
