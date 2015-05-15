//
//  SHBaseRequest.h
//  NSConnectionTest
//
//  Created by Shakir on 25/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//
typedef enum 
{
    eRequestType1 = 0,
    eRequestType2
    
}eRequestType;


#import <Foundation/Foundation.h>

@interface SHBaseRequestImage : NSMutableURLRequest
{
    //Response handler
	SEL							mResponseHandler;
	SEL							mErrorHandler;
	id							mResponseHandlerClass;
    eRequestType                mReqType;
    NSMutableData *                    mResponseData;
 int index;
    id mReqId;

}
@property(assign,nonatomic)int index;
@property(assign,nonatomic)int position;

@property(retain,nonatomic)id ReqId;
@property(nonatomic)BOOL saveToCache;


-(void)						SetRequestType	:(eRequestType)			inReqType;

-(eRequestType)             GetRequestType;

-(void)						SetResponseData	:(NSData *)inData;

-(NSData *)                GetResponseData;

-(SEL)						GetResponseHandler;
-(void)						SetResponseHandler	:(SEL)					inHandler;

-(SEL)						GetErrorHandler;
-(void)						SetErrorHandler	:(SEL)						inErrorHandler;

-(id)						GetResponseHandlerObj;
-(void)						SetResponseHandlerObj	:(id)				inHandlerClass;
@end
