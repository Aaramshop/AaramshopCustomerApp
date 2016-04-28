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
    
    NSURL *baseURL = [NSURL URLWithString:gURLManager.baseUrl];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
	
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
	if (self.currentTask == TASK_TO_GET_GLOBAL_SEARCH_RESULT || self.currentTask ==TASK_TO_SEARCH_HOME_STORE_PRODUCTS || self.currentTask == TASK_SEARCH_STORE_PRODUCT_CATEGORY) {
		if (task) {
			[task cancel];
			task = nil;
		}
	}
    
	
//	}
//
    [manager.requestSerializer setTimeoutInterval:60];
    task = [manager POST:functionName parameters:aDict
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
//         [loginView.loginClickBtn setEnabled:YES];
		 if ([Utils isRequestCancelled:error]) {
   
		 }
		 else
		 {
			 if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didFailWithError:)])
			 {
				 [self.delegate performSelector:@selector(didFailWithError:) withObject:error];
			 }
		 }
		 
     }];
    return YES;
}
-(BOOL) getDataForFunction:(NSString *)functionName withInput:(NSMutableDictionary *)aDict withCurrentTask:(CURRENT_TASK)inputTask Delegate:(id)inputDelegate andMultipartData:(NSData *)data withMediaKey:(NSString *)imageKey
{
    
    self.delegate = inputDelegate;
    self.currentTask = inputTask;
    
    NSURL *baseURL = [NSURL URLWithString:gURLManager.baseUrl];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:60];
    [manager POST:functionName parameters:aDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         if (data) {
             [formData appendPartWithFileData:data name:imageKey fileName:@"profileImage.jpg" mimeType:@"image/jpg"];
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
