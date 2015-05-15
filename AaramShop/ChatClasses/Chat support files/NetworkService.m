            //
//  NetworkService.m
//  Thrones
//
//  Created by Pradeep on 01/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkService.h"
#import "Reachability.h"
#import "Utils.h"
#import "SHBaseRequest.h"
#import "AppDelegate.h"

#define timeOutSpan 90
#define thisFileA eLAWS
static NetworkService *sharedInstance = nil;

@implementation NetworkService

// Get the shared instance and create it if necessary.
+ (NetworkService *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}
- (oneway void)release {
    
}
- (id)autorelease {
    return self;
}


-(NSString *)getUserDefaultValueByKey:(NSString *)inKey
{
    NSString * value = [[NSUserDefaults standardUserDefaults] valueForKey: inKey];
    return  value;
}
#pragma mark-Post Web Request

-(void)sendAsynchRequestByPostToServer:(NSString*)inApi  dataToSend:(id)inData delegate:(id)inDelegate contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHearBool
{
    SHBaseRequest *aRequest = nil;
    NSString *aRequestURL;
    NSString *aContentType;
    NSString *jsonToSend;
    NSString *aReqPara;
    NSData *aRequestData;
    NSDictionary * aDataDic;
    
    NSData *data;
    
    //set request Content Type
    switch (inContentType)
    {
        case eAppJsonType:
            
            aContentType = [NSString stringWithFormat:@"application/JSON"];
            break;
            
        case eAppXWWWFormType:
            
            aContentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
            
            break;
            
        default:
            break;
    }
    
    //According to  request Parameter Type
    switch (inParaType)
    {
        case eParaNone:
            
            inApi = [NSString stringWithFormat:@"%@",inApi];
            inApi = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            aRequest.IsReqStarted = YES;
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPMethod:KPost];
            aRequest.RequestIdentifier = inApi;
            aRequest.ResponseClassDelegate = inDelegate;
         
            //            NSLog(@"ulr inRequest = %@",aRequest.URL);
            break;
            
        case eJson:
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:@"POST"];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            //            NSDictionary *aData = [inData objectForKey: kDataDic];
//            jsonToSend = [inData JSONRepresentation];
            
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            
            
//            NSLog(@"%@",jsonToSend);
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            
            aRequestData =  [jsonToSend dataUsingEncoding:NSUTF8StringEncoding];
            
            
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            
            break;
            
        case eParameter:
            
            inApi = [NSString stringWithFormat:@"%@",inApi];
            inApi = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            aRequest.IsReqStarted = YES;
            
            [aRequest setHTTPMethod:KPost];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            
            //            NSLog(@"ulr inRequest = %@",aRequest.URL);
            break;
            
        case eJsonAndParameter:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPost];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            aDataDic = [inData objectForKey:kDataDic];
//            jsonToSend = [aDataDic JSONRepresentation];
            
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            
            //            NSLog(@"%@",jsonToSend);
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            break;
            
        case eStrInHeader:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kBodyStr];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPost];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            aRequestData = [NSData dataWithBytes:[aReqPara UTF8String] length:[aReqPara length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            break;
            
        default:
            break;
    }
    [[[NSURLConnection alloc] initWithRequest:aRequest delegate:self startImmediately:YES] autorelease];
}

-(id)sendSynchronusRequestByPostToServer:(NSString*)inApi  dataToSend:(id)inData contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHearBool
{
    
    SHBaseRequest *aRequest = nil;
    NSString *aRequestURL;
    NSString *aContentType;
    NSString *jsonToSend;
    NSString *aReqPara;
    NSData *aRequestData;
    NSDictionary * aDataDic;
    
    NSData *data;
    
    //set request Content Type
    switch (inContentType)
    {
        case eAppJsonType:
            
            aContentType = [NSString stringWithFormat:@"application/JSON"];
            
            break;
            
        case eAppXWWWFormType:
            
            aContentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
            
            break;
            
        default:
            break;
    }
    
    //According to  request Parameter Type
    switch (inParaType)
    {
        case eJson:
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPost];
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
//            jsonToSend = [inData JSONRepresentation];
            
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            
            
            //            NSLog(@"%@",jsonToSend);
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            
            break;
            
        case eParameter:
            
            inApi = [NSString stringWithFormat:@"%@",inApi];
            inApi = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            aRequest.IsReqStarted = YES;
            
            [aRequest setHTTPMethod:KPost];
            aRequest.RequestIdentifier = inApi;
            
            //            NSLog(@"ulr inRequest = %@",aRequest.URL);
            break;
            
        case eJsonAndParameter:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPost];
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            aDataDic = [inData objectForKey:kDataDic];
//            jsonToSend = [aDataDic JSONRepresentation];
            
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            
            //            NSLog(@"%@",jsonToSend);
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            break;
            
        case eStrInHeader:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kBodyStr];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPost];
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
            }
            // aRequestData = [NSData dataWithBytes:[aReqPara UTF8String] length:[aReqPara length]];
            
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            //[aRequest setHTTPBody:aRequestData];
            [aRequest setHTTPBody:[[NSString stringWithString: aReqPara] dataUsingEncoding:NSUTF8StringEncoding]];
            
            break;
            
            
        default:
            break;
    }
    
    NSError *error = nil;
    id tempDic;
    NSString * responseString;
    NSURLResponse* response = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:aRequest  returningResponse:&response error:&error];
    if (error)
    {
        //        NSLog(@"%@",error.description);
        // [Utils showAlertView:VENIRE message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        tempDic = [NSDictionary dictionaryWithObject:@"FALSE" forKey:SUCCESS];
        
    }else
    {
        responseString  = [[[NSString alloc]initWithData:result encoding:NSASCIIStringEncoding] autorelease];
//        tempDic  = [[responseString JSONValue] retain];
        
        tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        return tempDic;
        
    }
    return tempDic;
    
}


#pragma mark-Get Web Request


-(void)sendAsynchRequestByGetToServer:(NSString*)inApi  dataToSend:(id)inData delegate:(id)inDelegate contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHearBool
{
    
    SHBaseRequest *aRequest = nil;
    NSString *aRequestURL;
    NSString *aContentType;
    NSString *jsonToSend;
    NSString *aReqPara;
    NSData *aRequestData;
    NSDictionary * aDataDic;
    
    NSData *data;
    
    //set request Content Type
    switch (inContentType)
    {
        case eAppJsonType:
            
            aContentType = [NSString stringWithFormat:@"application/JSON"];
            
            break;
            
        case eAppXWWWFormType:
            
            aContentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
            
            break;
            
        default:
            break;
    }
    
    //According to  request Parameter Type
    switch (inParaType)
    {
        case eParaNone:
            
            inApi = [NSString stringWithFormat:@"%@",inApi];
            inApi = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPMethod : KGet];
            aRequest.RequestIdentifier = inApi;
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.IsReqStarted = YES;
            
            //            NSLog(@"ulr inRequest = %@",aRequest.URL);
            break;
            
        case eJson:
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KGet];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
//            jsonToSend = [inData JSONRepresentation];
            
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            
            //            NSLog(@"%@",jsonToSend);
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
            }
            
            aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            
            break;
            
        case eParameter:
            
            inApi = [NSString stringWithFormat:@"%@",inApi];
            inApi = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            aRequest.IsReqStarted = YES;
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            
            [aRequest setHTTPMethod:KGet];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            
            //            NSLog(@"ulr inRequest = %@",aRequest.URL);
            break;
            
        case eJsonAndParameter:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KGet];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            aDataDic = [inData objectForKey:kDataDic];
//            jsonToSend = [aDataDic JSONRepresentation];
            
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            
            //            NSLog(@"%@",jsonToSend);
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            break;
            
        case eStrInHeader:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kBodyStr];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KGet];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            aRequestData = [NSData dataWithBytes:[aReqPara UTF8String] length:[aReqPara length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            break;
            
            
        default:
            break;
    }
    [[[NSURLConnection alloc] initWithRequest:aRequest delegate:self startImmediately:YES] autorelease];
    
    
}

-(id)sendSynchronusRequestByGetToServer:(NSString*)inApi  dataToSend:(id)inData contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHearBool
{
    
    SHBaseRequest *aRequest = nil;
    NSString *aRequestURL;
    NSString *aContentType;
    NSString *jsonToSend;
    NSString *aReqPara;
    NSData *aRequestData;
    NSDictionary * aDataDic;
    
    NSData *data;
    
    
    //set request Content Type
    switch (inContentType)
    {
        case eAppJsonType:
            
            aContentType = [NSString stringWithFormat:@"application/JSON"];
            
            break;
            
        case eAppXWWWFormType:
            
            aContentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
            
            break;
            
        default:
            break;
    }
    
    //According to  request Parameter Type
    switch (inParaType)
    {
        case eParaNone:
            
            inApi = [NSString stringWithFormat:@"%@",inApi];
            inApi = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            aRequest.IsReqStarted = YES;
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPMethod:KGet];
            aRequest.RequestIdentifier = inApi;
            
            //            NSLog(@"ulr inRequest = %@",aRequest.URL);
            break;
            
        case eJson:
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KGet];
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
//            jsonToSend = [inData JSONRepresentation];
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",jsonToSend);
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            
            break;
            
        case eParameter:
            
            inApi = [NSString stringWithFormat:@"%@",inApi];
            inApi = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            aRequest.IsReqStarted = YES;
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            
            
            [aRequest setHTTPMethod:KGet];
            aRequest.RequestIdentifier = inApi;
            
            //            NSLog(@"ulr inRequest = %@",aRequest.URL);
            break;
            
        case eJsonAndParameter:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KGet];
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            aDataDic = [inData objectForKey:kDataDic];
//            jsonToSend = [aDataDic JSONRepresentation];
            
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            
            //            NSLog(@"%@",jsonToSend);
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            break;
            
        case eStrInHeader:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kBodyStr];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KGet];
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            aRequestData = [NSData dataWithBytes:[aReqPara UTF8String] length:[aReqPara length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            break;
            
            
        default:
            break;
    }
    
    NSError * error = nil;
    id tempDic;
    NSString * responseString;
    NSURLResponse* response = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:aRequest  returningResponse:&response error:&error];
    if (error)
    {
        //        NSLog(@"%@",error);
        // [Utils showAlertView:VENIRE message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        tempDic = [NSDictionary dictionaryWithObject:@"FALSE" forKey:SUCCESS];
        
    }
    else
    {
        responseString  = [[[NSString alloc]initWithData:result encoding:NSASCIIStringEncoding] autorelease];
//        tempDic  = [[responseString JSONValue] retain];
        
        tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        return tempDic;
        
    }
    return tempDic;
    
    
}


#pragma mark-Put Web Request


-(void)sendAsynchRequestByPutToServer:(NSString*)inApi  dataToSend:(id)inData delegate:(id)inDelegate contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHearBool
{
    
    SHBaseRequest *aRequest = nil;
    NSString *aRequestURL;
    NSString *aContentType;
    NSString *jsonToSend;
    NSString *aReqPara;
    NSData *aRequestData;
    NSDictionary * aDataDic;
    
    NSData *data;
    
    //set request Content Type
    switch (inContentType)
    {
        case eAppJsonType:
            
            aContentType = [NSString stringWithFormat:@"application/JSON"];
            
            break;
            
        case eAppXWWWFormType:
            
            aContentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
            
            break;
            
        default:
            break;
    }
    
    //According to  request Parameter Type
    switch (inParaType)
    {
        case eJson:
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            aRequestURL = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPut];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
//            jsonToSend = [inData JSONRepresentation];
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",jsonToSend);
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            
            break;
            
        case eParameter:
            
            inApi = [NSString stringWithFormat:@"%@",inApi];
            inApi = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            [aRequest setHTTPMethod:KPut];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            //            NSLog(@"ulr inRequest = %@",aRequest.URL);
            break;
            
        case eJsonAndParameter:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPut];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            aDataDic = [inData objectForKey:kDataDic];
//            jsonToSend = [aDataDic JSONRepresentation];
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            
            //            NSLog(@"%@",jsonToSend);
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            break;
            
        case eStrInHeader:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kBodyStr];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPut];
            aRequest.ResponseClassDelegate = inDelegate;
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            aRequestData = [NSData dataWithBytes:[aReqPara UTF8String] length:[aReqPara length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            break;
            
            
        default:
            break;
    }
    [[[NSURLConnection alloc] initWithRequest:aRequest delegate:self startImmediately:YES] autorelease];
    
    
}

-(id)sendSynchronusRequestByPutToServer:(NSString*)inApi  dataToSend:(id)inData contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHearBool
{
    
    SHBaseRequest *aRequest = nil;
    NSString *aRequestURL;
    NSString *aContentType;
    NSString *jsonToSend;
    NSString *aReqPara;
    NSData *aRequestData;
    NSDictionary * aDataDic;
    
    NSData *data;
    
    //set request Content Type
    switch (inContentType)
    {
        case eAppJsonType:
            
            aContentType = [NSString stringWithFormat:@"application/JSON"];
            
            break;
            
        case eAppXWWWFormType:
            
            aContentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
            
            break;
            
        default:
            break;
    }
    
    //According to  request Parameter Type
    switch (inParaType)
    {
        case eParaNone:
            
            inApi = [NSString stringWithFormat:@"%@",inApi];
            inApi = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            aRequest.IsReqStarted = YES;
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPMethod:KPut];
            aRequest.RequestIdentifier = inApi;
            
            //            NSLog(@"ulr inRequest = %@",aRequest.URL);
            break;
            
            
        case eJson:
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPut];
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
//            jsonToSend = [inData JSONRepresentation];
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            
            //            NSLog(@"%@",jsonToSend);
            
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            
            break;
            
        case eParameter:
            
            inApi = [NSString stringWithFormat:@"%@",inApi];
            inApi = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            aRequest.IsReqStarted = YES;
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            [aRequest setHTTPMethod:KPut];
            aRequest.RequestIdentifier = inApi;
            
            //            NSLog(@"ulr inRequest = %@",aRequest.URL);
            break;
            
        case eJsonAndParameter:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kParameter];
            
            aRequestURL = [aRequestURL stringByAppendingString: aReqPara];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPut];
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            aDataDic = [inData objectForKey:kDataDic];
//            jsonToSend = [aDataDic JSONRepresentation];
            data = [NSJSONSerialization dataWithJSONObject:inData options:0 error:nil];
            
            jsonToSend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            
            //            NSLog(@"%@",jsonToSend);
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
                
            }
            
            aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:aRequestData];
            break;
            
        case eStrInHeader:
            
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aReqPara = [inData objectForKey: kBodyStr];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPut];
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
            }
            //aRequestData = [NSData dataWithBytes:[aReqPara UTF8String] length:[aReqPara length]];
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody:[[NSString stringWithString: aReqPara] dataUsingEncoding:NSUTF8StringEncoding]];
            break;
            
            
        case eNSData:
            
            aRequestURL = [kBaseURL stringByAppendingString:inApi];
            
            aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            NSLog(@"%@",aRequestURL);
            
            
            aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
            [aRequest setHTTPMethod:KPut];
            aRequest.RequestIdentifier = inApi;
            aRequest.IsReqStarted = YES;
            
            
            if (inHearBool)
            {
                //set Optional Hearder Values
                [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
                [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
                [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
            }
            [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
            [aRequest setHTTPBody: inData];
            break;
            
            
        default:
            break;
    }
    
    NSError *error = nil;
    id tempDic;
    NSString * responseString;
    NSURLResponse* response = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest: aRequest  returningResponse:&response error:&error];
    if (error)
    {
        NSLog(@"%@",error.description);
        // [Utils showAlertView:VENIRE message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        tempDic = [NSDictionary dictionaryWithObject:@"FALSE" forKey:SUCCESS];
        
    }else
    {
        responseString  = [[[NSString alloc]initWithData:result encoding:NSASCIIStringEncoding] autorelease];
//        tempDic  = [[responseString JSONValue] retain];
        
        tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        
        return tempDic;
        
    }
    return tempDic;
}

#pragma mark - Image uploading Methods
-(id)sendSynchronusUploadImageByGetUsingMultiPart:(NSString *)inApi dataToSend :(id)inData boundry :(NSString*)inBoundry header :(BOOL)inHeaderBool
{
    NSString *urlString = inApi;
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",inBoundry];
	
    
    
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:KPost];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", inBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSEnumerator *enumerator = [inData keyEnumerator];
	NSString *key;
	NSString *value;
	NSString *content_disposition;
    
//    NSData *data;
	
    //loop through all our parameters
	while ((key = (NSString *)[enumerator nextObject])) {
		
        //if it's a picture (file)...we have to append the binary data
		if ([key isEqualToString: @"postData"]) {
			
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profileImage\";\r\nfilename=\"media.jpg\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[inData objectForKey:key]];
			
            //key/value nsstring/nsstring
		}
        else if([key isEqualToString:@"profileData"])
        {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";\r\nfilename=\"media.png\"\r\n\r\n",kMyUpload] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[inData objectForKey:key]];
            
        }else if ([key isEqualToString:@"postThumb"])
        {
            if ([[inData valueForKey:key] isKindOfClass:[NSString class]]) {
                continue;
            }
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profileImageThumb\";\r\nfilename=\"media.jpg\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[inData objectForKey:key]];
			
            //key/value nsstring/nsstring
            
        }
        else if ([key isEqualToString:@"postThumb"])
        {
            if ([[inData valueForKey:key] isKindOfClass:[NSString class]]) {
                continue;
            }
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profileImageThumb\";\r\nfilename=\"media.jpg\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[inData objectForKey:key]];
			
            //key/value nsstring/nsstring
            
        }
        else
        {
			value = (NSString *)[inData objectForKey:key];
			
			content_disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
			[body appendData:[content_disposition dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[value dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
		}//end else
		
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", inBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
		
	}//end while
	
    //set Optional Header Values with Keys
    if (inHeaderBool)
    {
        [request addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
        [request addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
        [request addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
        
    }
    
	[request setHTTPBody:body];
	[request addValue:[NSString stringWithFormat:@"%d", body.length] forHTTPHeaderField: @"Content-Length"];
	
    NSURLResponse *response;
    //  NSData *data_reply;
	NSError *err = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
	NSString *responseString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
//    NSLog(@"SHUBHENDU %@",responseString);
    
    NSDictionary *resultDic = nil;
    
    if (err)
    {
        NSLog(@"%@",err.description);
        resultDic = [NSDictionary dictionaryWithObject:@"FALSE" forKey:SUCCESS];
    }
    else
    {
        responseString  = [[NSString alloc]initWithData:result encoding:NSASCIIStringEncoding];
        if (responseString.length)
        {
//            resultDic  = [responseString JSONValue];
            resultDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

        }
    }
    return  resultDic;
}

#pragma mark - Upload Image Asynchronously
-(void)sendAsynchRequestUploadImageByPostToServer:(NSString*)inApi  dataToSend:(id)inData delegate:(id)inDelegate contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header:(BOOL)inHearBool boundry:(NSString*)inBoundry
{
    
    SHBaseRequest *aRequest = nil;
    NSString *aRequestURL;
    
    NSString *urlString =[kBaseURL stringByAppendingString:inApi];
	
//	NSURL *url = [NSURL URLWithString:urlString];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",inBoundry];
 
    aRequestURL = urlString;
	
	contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",inBoundry];
	
    aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   //NSLog(@"%@",aRequestURL);
    
    aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    [aRequest setHTTPMethod:KPost];
    aRequest.ResponseClassDelegate = inDelegate;
    aRequest.RequestIdentifier = inApi;
    
    
	[aRequest setHTTPMethod:KPost];
	[aRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", inBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSEnumerator *enumerator = [inData keyEnumerator];
	NSString *key;
	NSString *value;
	NSString *content_disposition;
	
    while ((key = (NSString *)[enumerator nextObject])) {
		
        //if it's a picture (file)...we have to append the binary data
		if ([key isEqualToString: @"postData"] || [key isEqualToString: kbgImage] || [key isEqualToString: @"profileImage"]) {
			
            if ([[inData valueForKey:key] isKindOfClass:[NSString class]]) {
                continue;
            }
            if([[inData objectForKey:kOption] isEqualToString:kUploadProfilePic] && [[inData objectForKey:kFileType]isEqualToString:@"video"])
            {
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profileImage\";\r\nfilename=\"media.MOV\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[inData objectForKey:key]];
            }
            else
            {
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profileImage\";\r\nfilename=\"media.jpg\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[inData objectForKey:key]];
            }
			
            //key/value nsstring/nsstring
		}
        else if([key isEqualToString:@"profileData"])
        {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";\r\nfilename=\"media.png\"\r\n\r\n",kMyUpload] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[inData objectForKey:key]];
            
        }
        else
        {
			value = (NSString *)[inData objectForKey:key];
			
			content_disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
			[body appendData:[content_disposition dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[value dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
		}//end else
		
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", inBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
		
	}//end while
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", inBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //set Optional Header Values with Keys
    if (inHearBool)
    {
//        NSLog(@"userid = %@ token=%@,lang = %@",
//              [self getUserDefaultValueByKey:@"user_id"],[self getUserDefaultValueByKey:@"auth_token"],[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"]);
        [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
        [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
        [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
        
    }
    
	[aRequest setHTTPBody:body];
	[aRequest addValue:[NSString stringWithFormat:@"%d", body.length] forHTTPHeaderField: @"Content-Length"];
	
    
    [[[NSURLConnection alloc] initWithRequest:aRequest delegate:self startImmediately:YES] autorelease];
    

}
///////////
//sendSynchronusUploadImageByGetUsingMultiPart:(NSString *)inApi dataToSend :(id)inData boundry :(NSString*)inBoundry header :(BOOL)inHeaderBool

-(void)sendAsynchronusUploadImageByGetUsingMultiPart:(NSString *)inApi dataToSend :(id)inData boundry :(NSString*)inBoundry header :(BOOL)inHeaderBool andDelegate:(id)inDelegate andChatId:(NSString *)inChatId andMediaType:(NSString *)inMediaType andfileName:(NSString *)inFileName
{

        NSString *urlString = inApi;
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",inBoundry];
        
         SHBaseRequest  *request = [SHBaseRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
    
        [request setHTTPMethod:KPost];
        request.ResponseClassDelegate = inDelegate;
        request.RequestIdentifier = inChatId;
        request.IsReqStarted = YES;
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", inBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSEnumerator *enumerator = [inData keyEnumerator];
        NSString *key;
        NSString *value;
        NSString *content_disposition;
        
        //loop through all our parameters
    while ((key = (NSString *)[enumerator nextObject])) {
		
        //if it's a picture (file)...we have to append the binary data
		if ([key isEqualToString: @"profileImage"] || [key isEqualToString: kbgImage]) {
			
            if ([[inData valueForKey:key] isKindOfClass:[NSString class]]) {
                continue;
            }
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profileImage\";\r\nfilename=\"media.jpg\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[inData objectForKey:key]];
			
            //key/value nsstring/nsstring
		}
        else if ([key isEqualToString:@"postThumb"])
        {
            if ([[inData valueForKey:key] isKindOfClass:[NSString class]]) {
                continue;
            }
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profileImageThumb\";\r\nfilename=\"media.jpg\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[inData objectForKey:key]];
			
            //key/value nsstring/nsstring

        }
        else if([key isEqualToString:@"profileData"])
        {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profileImage\";\r\nfilename=\"%@\"\r\n\r\n",inFileName] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[inData objectForKey:key]];
            
        }
        else
        {
			value = (NSString *)[inData objectForKey:key];
			
			content_disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
			[body appendData:[content_disposition dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[value dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
		}//end else
		
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", inBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
		
	}//end while
    
        [request setHTTPBody:body];
        [request addValue:[NSString stringWithFormat:@"%d", body.length] forHTTPHeaderField: @"Content-Length"];
	
    
        [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES] autorelease];
    
	
}

//////////
#pragma mark - VIDEO uploading Methods
-(id)sendSynchronusUploadVideoByPostUsingMultiPart:(NSString *)inApi dataToSend :(id)inData boundry :(NSString*)inBoundry header :(BOOL)inHeaderBool
{
    NSString *urlString = inApi;
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",inBoundry];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:KPost];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", inBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSEnumerator *enumerator = [inData keyEnumerator];
	NSString *key;
	NSString *value;
	NSString *content_disposition;
	
    //loop through all our parameters
	while ((key = (NSString *)[enumerator nextObject])) {
		
        //if it's a picture (file)...we have to append the binary data
		if ([key isEqualToString: @"postData"]) {
			
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profileImage\";\r\nfilename=\"media.MOV\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[inData objectForKey:key]];
			
            //key/value nsstring/nsstring
		}
        else if([key isEqualToString:@"profileData"])
        {
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";\r\nfilename=\"media.png\"\r\n\r\n",kMyUpload] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[inData objectForKey:key]];
            
        }
        else
        {
			value = (NSString *)[inData objectForKey:key];
			
			content_disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
			[body appendData:[content_disposition dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[value dataUsingEncoding:NSNonLossyASCIIStringEncoding]];
		}//end else
		
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", inBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
		
	}//end while
	
    //set Optional Header Values with Keys
    if (inHeaderBool)
    {
        [request addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
        [request addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
        [request addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
        
    }
    
	[request setHTTPBody:body];
	[request addValue:[NSString stringWithFormat:@"%d", body.length] forHTTPHeaderField: @"Content-Length"];
	
    NSURLResponse *response;
    //  NSData *data_reply;
	NSError *err = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
	NSString *responseString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",responseString);
    
    NSDictionary *resultDic = nil;
    
    if (err)
    {
        NSLog(@"%@",err.description);
        resultDic = [NSDictionary dictionaryWithObject:@"FALSE" forKey:SUCCESS];
    }
    else
    {
        responseString  = [[NSString alloc]initWithData:result encoding:NSASCIIStringEncoding];
        if (responseString.length)
        {
//            resultDic  = [responseString JSONValue];
            resultDic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        }
    }
    return  resultDic;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    SHBaseRequest *curReq = (SHBaseRequest *)connection.currentRequest;
    [curReq SetResponseData: data];
    
    if (curReq.IsDownload)
    {
        if([curReq.ResponseClassDelegate conformsToProtocol:@protocol(RequestDeligate)] &&
           [curReq.ResponseClassDelegate respondsToSelector:@selector(fileDownLoadingResponseHandler:downloadedByte:andRequestIdentifier:)])
        {
            [curReq.ResponseClassDelegate fileDownLoadingResponseHandler: connection downloadedByte:data.length andRequestIdentifier: curReq.RequestIdentifier];
            if (curReq.IsReqStarted == NO)
            {
                [connection cancel];
            }
        }
        
        
    }
    //    NSLog(@"done fetching : network class");
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    SHBaseRequest *aCurrRequest = (SHBaseRequest *)connection.currentRequest;
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription],          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    NSLog(@"%d",[error code]);
    
    [aCurrRequest.ResponseClassDelegate requestErrorHandler:error andRequestIdentifier:aCurrRequest.RequestIdentifier];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    SHBaseRequest *aCurrRequest = (SHBaseRequest *)connection.currentRequest;
    
    if (aCurrRequest.IsDownload)
    {
        if ([aCurrRequest.ResponseClassDelegate conformsToProtocol:@protocol(RequestDeligate) ] &&
            [aCurrRequest.ResponseClassDelegate respondsToSelector:@selector(fileDownLoadingDidFinished:downloadedByte:andRequestIdentifier:)])
        {
            [aCurrRequest.ResponseClassDelegate fileDownLoadingDidFinished: connection downloadedByte: [aCurrRequest GetResponseData] andRequestIdentifier: aCurrRequest.RequestIdentifier];
        }
        
    }
    else
    {
        NSString *responseString = [[NSString alloc]initWithData:[aCurrRequest GetResponseData] encoding:NSASCIIStringEncoding];
//     NSLog(@"Api Response: %@ %@", aCurrRequest.RequestIdentifier,responseString);
        id dicResult  = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:0 error:NULL];
        ;
        
        if (dicResult)
        {
            [aCurrRequest.ResponseClassDelegate responseHandler: dicResult andRequestIdentifier:aCurrRequest.RequestIdentifier];
        }else
        {
            [aCurrRequest.ResponseClassDelegate requestErrorHandler:nil andRequestIdentifier:aCurrRequest.RequestIdentifier];
        }
        [responseString release];
        
        dicResult = nil;
        
    }
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    SHBaseRequest *aCurrRequest = (SHBaseRequest *)connection.currentRequest;
    
    if([aCurrRequest.ResponseClassDelegate conformsToProtocol:@protocol(RequestDeligate)] &&
       [aCurrRequest.ResponseClassDelegate respondsToSelector:@selector(fileUploadingResponseHandler:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:andRequestIdentifier:)])
    {
        [aCurrRequest.ResponseClassDelegate fileUploadingResponseHandler: connection didSendBodyData: bytesWritten totalBytesWritten: totalBytesWritten totalBytesExpectedToWrite: totalBytesExpectedToWrite andRequestIdentifier: aCurrRequest.RequestIdentifier];
        if (aCurrRequest
            .IsReqStarted == NO)
        {
            [connection cancel];
        }
    }
    
    //    NSLog(@"%d bytes out of %d sent.", totalBytesWritten, totalBytesExpectedToWrite);
    
}

-(void)downloadFileAsynchronusByGet:(NSString *)inApi dataToSend :(id)inData header :(BOOL)inHeaderBool andDelegate:(id)inDelegate andChatId:(NSString*)inChatId
{
    
    SHBaseRequest *aRequest = nil;
    NSString *aRequestURL;
    NSString *aContentType;
    
    aContentType = [NSString stringWithFormat:@"application/JSON"];
    
    inApi = [NSString stringWithFormat:@"%@",inApi];
    inApi = [inApi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    aRequestURL = inApi;//[kBaseURL stringByAppendingString:inApi];
    
    aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutSpan];
    aRequest.IsReqStarted = YES;
    if (inHeaderBool)
    {
        //set Optional Hearder Values
        [aRequest addValue:[self getUserDefaultValueByKey:@"user_id"] forHTTPHeaderField:@"user_id"];
        [aRequest addValue:[self getUserDefaultValueByKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
        [aRequest addValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"] forHTTPHeaderField:@"language"];
        
    }
    
    
    [aRequest addValue:aContentType forHTTPHeaderField:@"Content-Type"];
    [aRequest setHTTPMethod : KGet];
    aRequest.RequestIdentifier = inChatId;
    aRequest.ResponseClassDelegate = inDelegate;
    aRequest.IsDownload = YES;
    
    [[[NSURLConnection alloc] initWithRequest:aRequest delegate:self startImmediately:YES] autorelease];
}





#pragma Connection DownLoading Delegate

//- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
//{
//    NSLog(@"didWriteData");
//}
//- (void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
//{
//    NSLog(@"connectionDidResumeDownloading");
//
//}
//
//- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL
//{
//    NSLog(@"connectionDidFinishDownloading");
//
//}



@end
