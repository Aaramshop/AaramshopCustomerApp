//
//  ChatComponent.h

//
//  Created by Shakir Approutes on 26/09/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomUplaodingView.h"
@class CustomUplaodingView;
typedef enum
{
    eLangEnglish = 0,
    eLangArbic
}
enLanguageType;


@interface ChatComponent : NSObject

@property(nonatomic,assign)enLanguageType LangType;
@property(nonatomic,assign)id delegate;

//18-2-14
@property(nonatomic,assign)enChatType chatType;
//end

-(UIView *)createChatViewOfMsg:(NSString *)inMsg andLanguageType
                              :(enLanguageType)inLangType andFromSelf:(BOOL)inFromSelf;
-(UIView *)createStickerViewByImageName:(NSString *)inImageName;
- (CustomUplaodingView *)ImageView:(NSString *)inMsg isSelf:(BOOL)isSelf andMediaType:(MediaType)inMediaType;
- (CustomUplaodingView *)Sound:(NSString *)inMsg isSelf:(BOOL)isSelf  andMediaType:(MediaType)inMediaType;
//nehaa thumbnail
- (CustomUplaodingView *)ImageView:(NSString *)inMsg isSelf:(BOOL)isSelf andMediaType:(MediaType)inMediaType andMediaOrientation:(enMediaOrientation)inMediaOrient andThumbString:(NSString *)inThumbStr;
//end thumbnail
@end
