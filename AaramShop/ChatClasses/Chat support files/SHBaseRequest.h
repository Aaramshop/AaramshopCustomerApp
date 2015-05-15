//
//  SHBaseRequest.h
//  NSConnectionTest
//
//  Created by Shakir on 25/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol RequestDeligate <NSObject>

@required
-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier;
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier;

@optional
- (void)fileUploadingResponseHandler:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite andRequestIdentifier:(NSString *)inRequestIdentifier;

-(void)fileDownLoadingDidFinished:(NSURLConnection *)inConnection downloadedByte:(NSData *)inData andRequestIdentifier:(NSString *)inReqIdentifier;

-(void)fileDownLoadingResponseHandler:(NSURLConnection *)inConnection downloadedByte:(double)inBytes andRequestIdentifier:(NSString *)inReqIdentifier;
@end

@interface SHBaseRequest : NSMutableURLRequest
{
	id <RequestDeligate>        mResponseClassDelegate;
    NSMutableData *                    mResponseData;
    NSString *                  mRequestIdentifier;
    BOOL                        mIsDownload;
    BOOL                        mIsReqStarted;


}
@property(nonatomic,retain) id <RequestDeligate> ResponseClassDelegate;
@property(nonatomic,retain)  NSData *  ResponseData;
@property(nonatomic,retain)  NSString * RequestIdentifier;
@property(nonatomic,assign)  BOOL  IsDownload;
@property(nonatomic,assign)  BOOL  IsReqStarted;

-(void) SetResponseData:(NSData *)inData;
-(NSData *) GetResponseData;


@end
