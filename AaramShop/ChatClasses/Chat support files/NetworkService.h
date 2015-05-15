//
//  NetworkService.h
//  Thrones
//
//  Created by Pradeep on 01/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHBaseRequest.h"
@class RequestDeligate;

typedef enum
{
    eAppJsonType = 1,
    eAppXWWWFormType
}enReqContentType;

typedef enum
{
    eParaNone =0,
    eJson,
    eParameter,
    eJsonAndParameter,
    eStrInHeader,
    eNSData
}enReqParaType;


@interface NetworkService : NSObject
{
    NSString *mUserId;
    NSString *mAuthToken;
}

+ (NetworkService *)sharedInstance;

-(NSString *)getUserDefaultValueByKey:(NSString *)inKey;
//@property(nonatomic,assign)id delegateObj;

-(void)sendAsynchRequestByPostToServer:(NSString*)inApi  dataToSend:(id)inData delegate:(id)inDelegate contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHealBool;

-(id)sendSynchronusRequestByPostToServer:(NSString*)inApi  dataToSend:(id)inData contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHealBool;

-(void)sendAsynchRequestByGetToServer:(NSString*)inApi  dataToSend:(id)inData delegate:(id)inDelegate contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHealBool;

-(id)sendSynchronusRequestByGetToServer:(NSString*)inApi  dataToSend:(id)inData contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHealBool;

-(void)sendAsynchRequestByPutToServer:(NSString*)inApi  dataToSend:(id)inData delegate:(id)inDelegate contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHealBool;

-(id)sendSynchronusRequestByPutToServer:(NSString*)inApi  dataToSend:(id)inData contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header :(BOOL)inHealBool;

#pragma mark - Image uploading Methods


-(void)sendAsynchRequestUploadImageByPostToServer:(NSString*)inApi  dataToSend:(id)inData delegate:(id)inDelegate contentType:(enReqContentType)inContentType andReqParaType :(enReqParaType)inParaType header:(BOOL)inHearBool boundry:(NSString*)inBoundry;

-(id)sendSynchronusUploadImageByGetUsingMultiPart:(NSString *)inApi dataToSend :(id)inData boundry :(NSString*)inBoundry header :(BOOL)inHeaderBool;

-(void)sendAsynchronusUploadImageByGetUsingMultiPart:(NSString *)inApi dataToSend :(id)inData boundry :(NSString*)inBoundry header :(BOOL)inHeaderBool andDelegate:(id)inDelegate andChatId:(NSString*)inChatId andMediaType:(NSString *)inMediaType andfileName:(NSString *)inFileName;

//-(void)sendAsynchronusUploadVideoByGetUsingMultiPart:(NSString *)inApi dataToSend :(id)inData boundry :(NSString*)inBoundry header :(BOOL)inHeaderBool andDelegate:(id)inDelegate andChatId:(NSString*)inChatId andMediaType:(NSString *)inMediaType andfileName:(NSString *)inFileName;

-(id)sendSynchronusUploadVideoByPostUsingMultiPart:(NSString *)inApi dataToSend :(id)inData boundry :(NSString*)inBoundry header :(BOOL)inHeaderBool;

-(void)downloadFileAsynchronusByGet:(NSString *)inApi dataToSend :(id)inData header :(BOOL)inHeaderBool andDelegate:(id)inDelegate andChatId:(NSString*)inChatId;

@end
