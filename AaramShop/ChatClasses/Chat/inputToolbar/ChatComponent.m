//
//  ChatComponent.m

//
//  Created by Shakir Approutes on 26/09/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "UIWebView+SH.h"
#import "ChatComponent.h"
#import "WebLinkButton.h"
//#import "UIImageView+WebCache.h"
#import "SHFileUtil.h"
#import "CustomUplaodingView.h"
//28-2-14
#import "CustomChatView.h"
//end
#import "UITextView+UITextView_sh.h"
#define KEmojiSizeWidth  20.0
#define KEmojiSizeHeight 20.0

#define KEmoticonSizeWidth  18.0
#define KEmoticonSizeHeight 18.0

#define KStickerSizeWidth  120.0
#define KStickerSizeHeight 120.0

//#define KImageSizeWidth  100.0
//#define KImageSizeHeight 100.0

#define MIN_WIDTH 80.0

#define MAX_WIDTH 250.0
#define MAX_WIDTH_SELF 290.0
#define MAX_WIDTH_OTHER 290.0

#define TOOLBARTAG		200.0
#define TABLEVIEWTAG	300.0

#define kSelfBubblePosition	300.0
#define kSelfTextWidth	250.0
#define kTextHeight 18.0

#define kOtherBubblePosition 300.0
#define kOtherTextWidth 210.0


#define LeftPaddingForSticker 20.0
#define RightPaddingForSticker 20.0

#define RightPaddingForTime 20.0
#define LeftPaddingForTime 20.0
#define VericalPaddingForTime 20.0
#define VericalPaddingChatV 15.0

#define LeftPaddingForChatV 10.0
#define RightPaddingForChatV 10.0
#define BubblePadding 4

//color font and size
#define FontSise 15.0
#define FontName @"ProximaNova-Regular"
#define RColorCode 107.0/255.0
#define GColorCode 109.0/255.0
#define BColorCode 110.0/255.0
#define AlphaTrans 1.0
//#define FontName @"Helvetica"
#define MaxCharInWebLinkSelf 33
#define MaxCharInWebLinkOther 35


#define NativeEmojiBEGIN_FLAG @"{+"
#define NativeEmojiEND_FLAG @"-}"

#define EmojiBEGIN_FLAG @"[/"
#define EmojiEND_FLAG @"]"

#define EmotionBEGIN_FLAG @"(/"
#define EmotionEND_FLAG @")"

#define StickerBEGIN_FLAG @"{/"
#define StickerEND_FLAG @"}"

#define kWebLinLeftkRGBColor [UIColor colorWithRed:0.0/255.0 green: 162.0/255.0 blue: 255.0/255.0 alpha:1]
#define kWebLinRightkRGBColor [UIColor colorWithRed:100.0/255.0 green: 10.0/255.0 blue: 100.0/255.0 alpha:1]



@implementation ChatComponent
@synthesize LangType;
@synthesize delegate;
//24-12-13
@synthesize chatType;
//end
-(id)init
{
    if (self = [super init])
    {
        // Iniatilized custom objects
        //        self.LangType = eLangEnglish;
        
        //24-12-13
        self.chatType = eChatNone;
        //end
        
        
        NSString * aLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedLanguage"];
        if([aLanguage isEqualToString: @"ar"])
        {
            self.LangType = eLangArbic;
        }
        else
        {
            self.LangType = eLangEnglish;
        }
        //        self.LangType = eLangArbic;
        
    }
    return  self;
}

-(void)dealloc
{
    // Release Memory If no needed
    [super dealloc];
}
- (BOOL) validateUrl: (NSString *) inStr
{
    
    
    inStr = [[inStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    
    
    //    NSString *urlRegEx1;
    NSString *urlRegEx2;
    //    NSString *urlRegEx3;
    //    NSString *urlRegEx4;
    
    //    urlRegEx1 = @"(http|https)?://((\\www.)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    urlRegEx2 = @"((http(s)?://)|(www.))([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?";
    
    
    //    urlRegEx3  = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?";
    
    //    urlRegEx4 = @"^(https?://)?(([\\w!~*'().&=+$%-]+: )?[\\w!~*'().&=+$%-]+@)?(([0-9]{1,3}\\.){3}[0-9]{1,3}|([\\w!~*'()-]+\\.)*([\\w^-][\\w-]{0,61})?[\\w]\\.[a-z]{2,6})(:[0-9]{1,4})?((/*)|(/+[\\w!~*'().;?:@&=+$,%#-]+)+/*)$";
    
    //    NSPredicate *urlTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx1];
    NSPredicate *urlTest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx2];
    //    NSPredicate *urlTest3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx3];
    //    NSPredicate *urlTest4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx4];
    
    
    
    //    BOOL toReturn1 = [urlTest1 evaluateWithObject:inStr];
    BOOL toReturn2 = [urlTest2 evaluateWithObject:inStr];
    //    BOOL toReturn3 = [urlTest3 evaluateWithObject:inStr];
    //    BOOL toReturn4 = [urlTest4 evaluateWithObject:inStr];
    
    NSArray *aDomainArr = [NSArray arrayWithObjects:@".com",@".co.in",@".org",@".co.uk",@".in", nil];
    
    
    if (toReturn2)
    {
        return  YES;
    }
    else
    {
        for (NSString * aDom in aDomainArr)
        {
            NSRange aRange = [inStr rangeOfString:aDom];
            if (aRange.length > 0 )
            {
                
                NSString *founDom = [inStr substringFromIndex: inStr.length - aRange.length];
                
                if ( [founDom isEqualToString: aDom])
                {
                    return  YES;
                }
                
            }
        }
    }
    
    return NO;
}

-(BOOL)isMsgContainsWebLink:(NSString *)inMsg
{
    BOOL toReturn = NO;
    
    NSError *error = NULL;
    NSDataDetector *detector =
    [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypes)NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber
                                    error:&error];
    NSArray *matches = [detector matchesInString:inMsg
                                         options:0
                                           range:NSMakeRange(0, [inMsg length])];
    for (NSTextCheckingResult *match in matches)
    {
        
        if (([match resultType] == NSTextCheckingTypeLink))
            
        {
            //                NSURL *url = [match URL];
            //                NSLog(@"URL is  :%@",url);
            toReturn = YES;
            break;
        }
    }
    return toReturn;
}

- (BOOL) validateIsEnglishLang: (NSString *) inStr
{
    NSData *strData ;
    strData = [inStr dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString * goodValue = [[NSString alloc] initWithData: strData encoding:NSUTF8StringEncoding];
    NSString * gValue = [NSString stringWithFormat:@"%@",goodValue];
    
    if ([gValue rangeOfString :@"u06"].location == NSNotFound)
    {
        return YES;
    }
    return NO;
    
}


-(UIView *)createStickerViewByImageName:(NSString *)inMsg
{
    
    CustomChatView *chatView = [[CustomChatView alloc] initWithFrame:CGRectZero];
    chatView.Delegate = self.delegate;
    
    if ([inMsg hasPrefix: StickerBEGIN_FLAG] && [inMsg hasSuffix: StickerEND_FLAG])
    {
        NSString *imageName=[inMsg substringWithRange:NSMakeRange(2, inMsg.length - 3)];
        imageName = [imageName stringByAppendingString:@"@2x"];
        NSString *imagePath = [[NSBundle mainBundle] resourcePath];
        imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
        imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        imageName = [imageName stringByAppendingFormat:@".png"];
        imagePath = [imagePath stringByAppendingString:[NSString stringWithFormat:@"/%@",imageName]];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame =  CGRectMake(5, 8, 110, 110);
        imgView.image = [UIImage imageNamed:imageName];
        imgView.backgroundColor = [UIColor clearColor];
        [chatView addSubview:imgView];
        [chatView setFrame:CGRectMake(0, 3, KStickerSizeWidth, KStickerSizeHeight )];
        
        //        NSString *HTMLData = [ NSString stringWithFormat:
        //                              @"<html><head></head>"
        //                              "<img src=\"%@\" alt=\"\" width=\"110\" height=\"110\" align=\"middle\"/>"
        //                              "</body></html>",imageName];
        //        returnView = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
        //
        //        returnView.frame = CGRectMake(0, 3, KStickerSizeWidth, KStickerSizeHeight );
        //
        //        [returnView loadHTMLString:HTMLData baseURL:[NSURL URLWithString: [NSString stringWithFormat:@"file:/%@//",imagePath]]];
        
        
        //        NSLog(@"str(image)---->%@",inMsg);
    }
    else
    {
        return nil;
    }
    //    returnView.opaque = NO;
    //    [returnView setBackgroundColor: [UIColor clearColor]];
    //    [returnView enableScrolling: NO];
    
    return  chatView;
    
}
- (CustomUplaodingView *)ImageView:(NSString *)inMsg isSelf:(BOOL)isSelf  andMediaType:(MediaType)inMediaType
{
    CGRect rect;
    rect.size.width = 320;
    rect.size.height = KImageSizeLandscapeHeight;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    
    CustomUplaodingView *returnView = [[CustomUplaodingView alloc]initWithFrame: rect];
    returnView.delegate = self.delegate;
    //24-3-14 media
    //    returnView.eventType = eTypeUpldDownLoading;
    //end
    returnView.mediaType = inMediaType;
    returnView.isFromSelf = isSelf;
    
    
    returnView = [returnView ImageView: inMsg isSelf: isSelf];
    [returnView setNeedsDisplay];
    [returnView UpdateUIContents];
    //    [returnView setBackgroundColor:[UIColor redColor]];
    
    return returnView;
}
//nehaa thumbnail
- (CustomUplaodingView *)ImageView:(NSString *)inMsg isSelf:(BOOL)isSelf andMediaType:(MediaType)inMediaType andMediaOrientation:(enMediaOrientation)inMediaOrient andThumbString:(NSString *)inThumbStr
//end thumbnail
{
    CustomUplaodingView *returnView = [[CustomUplaodingView alloc]initWithFrame: CGRectZero];
    returnView.delegate = self.delegate;
    //24-3-14 media
    //    returnView.eventType = eTypeUpldDownLoading;
    //end
    returnView.mediaType = inMediaType;
    returnView.isFromSelf = isSelf;
    
    //nehaa thumbnail
    returnView = [returnView ImageView: inMsg isSelf: isSelf andMediaOrientation:inMediaOrient andthumbString:inThumbStr] ;
    //end thumbnail
    [returnView setNeedsDisplay];
    [returnView UpdateUIContents];
    //    [returnView setBackgroundColor:[UIColor redColor]];
    if(inMediaType == eMediaTypeAudeo)
    {
        if(isSelf)
        {
            UIView *cstview = [returnView.subviews objectAtIndex:0];
            UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(cstview.frame.origin.x +2, cstview.frame.origin.y + 2, 50, 50)];
            
            profileImage.layer.cornerRadius = profileImage.bounds.size.width/2;
            profileImage.clipsToBounds = YES;
            [profileImage setBackgroundColor:[UIColor redColor]];
            
            UIImageView *micImage = [[UIImageView alloc] initWithFrame:CGRectMake(profileImage.frame.origin.x+profileImage.frame.size.width-5, profileImage.frame.origin.y+profileImage.frame.size.height-20, 10, 20)];
            [micImage setImage:[UIImage imageNamed:@""]];
            
            UIImageView *playBtnImg =[[UIImageView alloc] initWithFrame:CGRectMake(profileImage.frame.origin.x+profileImage.frame.size.width+15, 23, 14, 14)];
            [playBtnImg setImage:[UIImage imageNamed:@"chatPlayIconWhite"]];
            [playBtnImg setHidden:YES];
            
            UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(playBtnImg.frame.origin.x, playBtnImg.frame.origin.y+14, 40, 20)];
            lblTime.font = [UIFont systemFontOfSize:12];
            lblTime.textColor = [UIColor whiteColor];
            //            lblTime.text = @"hello";
            lblTime.backgroundColor = [UIColor clearColor];
            
            UIProgressView *progress= [[UIProgressView alloc] initWithFrame:CGRectMake(playBtnImg.frame.origin.x+playBtnImg.frame.size.width+5, playBtnImg.frame.origin.y+6, 70, 5)];
            
            [progress setTintColor:[UIColor whiteColor]];
            [progress setHidden:YES];
            
            [returnView addSubview:profileImage];
            [returnView addSubview:micImage];
            [returnView addSubview:playBtnImg];
            [returnView addSubview:progress];
            [returnView addSubview:lblTime];
        }
        else
        {
            UIView *cstview = [returnView.subviews objectAtIndex:0];
            UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(cstview.frame.origin.x +2, cstview.frame.origin.y + 2, 50, 50)];
            profileImage.layer.cornerRadius = profileImage.bounds.size.width/2;
            profileImage.clipsToBounds = YES;
            [profileImage setBackgroundColor:[UIColor redColor]];
            
            UIImageView *micImage = [[UIImageView alloc] initWithFrame:CGRectMake(profileImage.frame.origin.x+profileImage.frame.size.width-5, profileImage.frame.origin.y+profileImage.frame.size.height-20,10, 20)];
            [micImage setImage:[UIImage imageNamed:@""]];
            
            UIImageView *playBtnImg =[[UIImageView alloc] initWithFrame:CGRectMake(profileImage.frame.origin.x+profileImage.frame.size.width+15, 23, 14, 14)];
            [playBtnImg setImage:[UIImage imageNamed:@"chatPlayIcon"]];
            [playBtnImg setHidden:YES];
            UIProgressView *progress= [[UIProgressView alloc] initWithFrame:CGRectMake(playBtnImg.frame.origin.x+playBtnImg.frame.size.width+5, playBtnImg.frame.origin.y+6, 70, 5)];
            [progress setTintColor:[UIColor colorWithRed:42.0/255.0 green:137.0/255.0 blue:252.0/255.0 alpha:1.0]];
            progress.hidden = YES;
            
            UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(playBtnImg.frame.origin.x, playBtnImg.frame.origin.y+14, 40, 20)];
            lblTime.font = [UIFont systemFontOfSize:12];
            lblTime.textColor = [UIColor colorWithRed:42.0/255.0 green:137.0/255.0 blue:252.0/255.0 alpha:1.0];
            //            lblTime.text = @"hello";
            
            [returnView addSubview:profileImage];
            [returnView addSubview:micImage];
            [returnView addSubview:playBtnImg];
            [returnView addSubview:progress];
            [returnView addSubview:lblTime];
        }
    }
    else
    {
        UIView *cstview = [returnView.subviews objectAtIndex:0];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(cstview.frame.origin.x, cstview.frame.size.height -25, cstview.frame.size.width-1, 25)];
        
        [imgView setImage:[UIImage imageNamed:@"shadowOverlayBottom-1"]];
        [returnView addSubview:imgView];
        
    }
    
    
    return returnView;
}

- (CustomUplaodingView *)Sound:(NSString *)inMsg isSelf:(BOOL)isSelf  andMediaType:(MediaType)inMediaType
{
    CustomUplaodingView *returnView = [[CustomUplaodingView alloc]initWithFrame: CGRectZero];
    returnView.delegate = self.delegate;
    returnView.mediaType = inMediaType;
    returnView.isFromSelf = isSelf;
    UIFont *font = [UIFont systemFontOfSize: FontSise];
    UIColor * color = nil;
    if(isSelf)
    {
        color =[UIColor whiteColor];
    }
    else
    {
        color = [UIColor blueColor];
    }
    //    UIColor * color = [UIColor colorWithRed:191.0/255.0 green:202.0/255.0 blue:215.0/255.0 alpha: AlphaTrans];s
    float maxWidth;
    if (isSelf)
    {
        maxWidth = MAX_WIDTH_SELF;
    }
    else
    {
        maxWidth = MAX_WIDTH_OTHER;
    }
    int width =270;
    int height = 0;
    int x = 5;
    int y = 10;
    //    if(isSelf)
    //    {
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(x, y, MAX_WIDTH, kTextHeight)];
    
    [la setFont:font];
    CGSize maximumLabelSize = CGSizeMake(width, 20.0);
    la.lineBreakMode = NSLineBreakByWordWrapping;
    la.numberOfLines = 5;
    CGSize expectedLabelSize = [[[inMsg componentsSeparatedByString:@"$$$"] objectAtIndex:0] sizeWithFont:la.font constrainedToSize:maximumLabelSize lineBreakMode:la.lineBreakMode];
    
    
    //adjust the label the the new height.
    CGRect newFrame = la.frame;
    newFrame.size.height = expectedLabelSize.height+10;
    la.frame = newFrame;
    la.textColor = color;
    
    la.backgroundColor = [UIColor clearColor];
    la.text = [[inMsg componentsSeparatedByString:@"$$$"] objectAtIndex:1];
    [returnView addSubview :la];
    height = height + x + la.frame.size.height + 5;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(x,y+height, 30, 30)];
    if(isSelf)
    {
        [imgView setImage:[UIImage imageNamed:@"chatPlayIconWhite"]];
    }
    else
    {
        [imgView setImage:[UIImage imageNamed:@"chatPlayIcon"]];
    }
    imgView.contentMode = UIViewContentModeCenter;
    [returnView addSubview:imgView];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x+30+10, y+height, 50, 30)];
    lbl.text = @"Play";
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = font;
    lbl.textColor = color;
    height = height + 30 +5;
    [returnView addSubview:lbl];
    //    }
    
    
    returnView.frame = CGRectMake(5.0f,0.0f, width + 10 , height + 20 ); //@ 需要将该view的尺寸记下，方便以后使用
    //NSLog(@"%.1f %.1f", width, height);
    //    [returnView setBackgroundColor:[UIColor blueColor]];
    return returnView;
}

-(UIView *)createChatViewOfMsg:(NSString *)inMsg andLanguageType :(enLanguageType)inLangType andFromSelf:(BOOL)inFromSelf
{
    //23-12-13
    NSArray*aWordArr = [inMsg componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    NSString *aWord = [self isFirstWordEmojiAndEmoticonInMsg: aWordArr];
    
    if (aWord && aWord.length > 0 )
    {
        if ([self validateIsEnglishLang: aWord])
        {
            self.LangType = eLangEnglish;
        }
        else
        {
            self.LangType = eLangArbic;
        }
        
        
    }
    //end
    UIView *aChatView = nil;
    if (self.LangType == eLangEnglish)
    {
        aChatView =  [self chatViewForEnglishOfMsg: inMsg andFromSelf: inFromSelf];
    }
    else if (self.LangType == eLangArbic)
    {
        aChatView = [self chatViewForArabicOfMsg: inMsg  andFromSelf:inFromSelf];
    }
    //    NSLog(@"aChatView");
    return aChatView;
}

-(UIView *)chatViewForArabicOfMsg:(NSString *)inMsg andFromSelf :(BOOL)inFromSelf
{
    NSMutableArray *ViewsArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange: inMsg :array];
    //    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    CustomChatView *returnView = [[CustomChatView alloc] initWithFrame:CGRectZero];
    returnView.Delegate = self.delegate;
    //end
    NSArray *data = [NSArray arrayWithArray: array];
    UIFont *fon = [UIFont systemFontOfSize: FontSise];
    UIColor * color;
    if(inFromSelf)
    {
        color =[UIColor whiteColor];//[UIColor colorWithRed:RColorCode green:GColorCode blue:BColorCode alpha: AlphaTrans];
    }
    else
    {
        color = [UIColor blackColor];
    }
    CGFloat upY = 0;
    CGFloat width = 0.0;
    CGFloat height = 0.0;//KEmojiSizeHeight;
    //    BOOL isAnyImage  = [self isContainAnyEmojiAndEmoticonInMsg: data];
    //    BOOL isAnyImage1  = NO;
    //
    float maxWidth;
    float maxCharForWebLink;
    
    if (inFromSelf)
    {
        maxWidth = MAX_WIDTH_SELF + 10;
        maxCharForWebLink  = MaxCharInWebLinkSelf;
    }
    else
    {
        maxWidth = MAX_WIDTH_OTHER + 10;
        maxCharForWebLink  = MaxCharInWebLinkOther;
        
    }
    
    CGFloat upX = maxWidth;
    
    if (data)
    {
        int count = [data count];
        
        for (int i= 0 ; i < count; i ++ )
        {
            NSString *str=[data objectAtIndex:i];
            //            NSLog(@"str--->%@",str);
            
            if ((i == 0 && [str length]==0)|| (i == count - 1 && [str length]==0))
            {
                continue;
            }
            if ([str hasPrefix: EmojiBEGIN_FLAG] && [str hasSuffix: EmojiEND_FLAG])
            {
                
                if (upX - KEmojiSizeWidth <= 0)
                {
                    upY = upY + KEmojiSizeHeight;
                    upX = maxWidth;
                    width = maxWidth;
                    height = height + KEmojiSizeHeight ;//upY;
                }
                
                NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                UIImageView *aImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                
                if (height == 0)
                {
                    height = KEmojiSizeHeight;
                }
                
                float y = height - KEmojiSizeHeight ;
                y = y + (KEmojiSizeHeight - KEmojiSizeHeight)/2 + 3.0;
                
                float x = upX - KEmojiSizeWidth;
                aImage.frame = CGRectMake(x, y, KEmojiSizeWidth, KEmojiSizeHeight );
                
                [ViewsArr addObject: aImage];
                
                upX = upX - KEmojiSizeWidth;
                
                if(width < maxWidth)
                {
                    width =  maxWidth - upX;
                }
                
            }
            else if ([str hasPrefix: EmotionBEGIN_FLAG] && [str hasSuffix: EmotionEND_FLAG])
            {
                if (upX - KEmoticonSizeWidth <= 0)
                {
                    upY = upY + KEmojiSizeHeight;
                    upX = maxWidth;
                    width = maxWidth;
                    height = height + KEmojiSizeHeight ;
                }
                //                NSLog(@"str(image)---->%@",str);
                NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                UIImageView *aImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                
                if (height == 0)
                {
                    height = KEmojiSizeHeight;
                }
                
                float y = height - KEmojiSizeHeight ;
                y = y + (KEmojiSizeHeight - KEmoticonSizeHeight)/2 + 3.0;
                
                float x = upX - KEmoticonSizeWidth;
                
                
                aImage.frame = CGRectMake(x , y, KEmoticonSizeWidth, KEmoticonSizeHeight );
                [ViewsArr addObject: aImage];
                
                upX = upX - KEmoticonSizeWidth;
                
                if(width < maxWidth)
                {
                    width = maxWidth - upX;
                }
            }
            
            else
            {
                NSMutableArray *ntvData = [[NSMutableArray alloc] init];
                [self getImageRangeForNativEmotions: str  :ntvData];
                
                NSMutableArray *allWords = [[NSMutableArray alloc] init];
                NSMutableArray *breakonWords = [[NSMutableArray alloc] init];
                
                
                for (int i = ntvData.count-1;i >= 0; i--)
                {
                    NSString * aSentance = [ntvData objectAtIndex: i];
                    
                    NSArray * sepeateWords = [self seperateWordBySpaceIfNeeded: aSentance];
                    if (sepeateWords == nil)
                    {
                        [allWords addObject: aSentance];
                    }
                    else
                    {
                        for (int k = 0 ; k < sepeateWords.count ; k ++)
                        {
                            id aWord = [sepeateWords objectAtIndex:k];
                            //                            [allWords addObject: [NSString stringWithFormat:@" %@",aWord]];
                            CGSize size =   [aWord sizeWithFont:[UIFont systemFontOfSize:FontSise]];
                            
                            if ([self validateUrl: aWord] == YES)
                            {
                                [allWords addObject: [NSString stringWithFormat:@"%@",aWord]];
                                
                            }
                            
                            
                            else if (size.width > maxWidth)
                            {
                                [self breakSingleWordIfItCrossedItsWitdh: aWord andMaxWitdh: maxWidth andFillWordArr: breakonWords];
                                for (int m = 0 ; m < breakonWords.count; m ++)
                                {
                                    aWord = [breakonWords objectAtIndex:m];
                                    
                                    [allWords addObject: [NSString stringWithFormat:@" %@",aWord]];
                                    
                                }
                                
                            }
                            else
                                ////
                                [allWords addObject: [NSString stringWithFormat:@" %@",aWord]];
                        }
                        
                    }
                }
                
                //do set word according to Language
                NSArray *aTempWrds = [self setWordsWhenLangArabicByWords : allWords];
                [allWords removeAllObjects];
                [allWords addObjectsFromArray:aTempWrds];
                //end
                
                for (int i = 0; i < allWords.count ; i ++)
                {
                    NSString * aNtvEmoticon = [allWords objectAtIndex: i];
                    BOOL isWeblink = [self validateUrl: aNtvEmoticon];
                    
                    if ([allWords count] > 1 && i == [allWords count]-1 )
                    {
                        //when last object is nul string in printing ordere
                        if ([aNtvEmoticon isEqualToString:@" "])
                        {
                            continue;
                        }
                    }
                    
                    NSString *emoticonName;
                    if ([self isMsgHasAnyEmojiAndEmoticon: aNtvEmoticon])
                    {
                        emoticonName =[aNtvEmoticon substringWithRange:NSMakeRange(2, aNtvEmoticon.length - 4)];
                        
                    }
                    else
                    {
                        emoticonName = aNtvEmoticon;
                    }
                    
                    //                    CGSize size=[emoticonName sizeWithFont:fon constrainedToSize:CGSizeMake(maxWidth, kTextHeight)];
                    CGSize size =   [emoticonName sizeWithFont:[UIFont systemFontOfSize:FontSise]];
                    
                    float y ;
                    
                    if (isWeblink == YES)
                    {
                        if ((upX - size.width <= 0))
                        {
                            upY = upY + KEmojiSizeHeight;
                            upX = maxWidth;
                            width = maxWidth;
                            height = height + KEmojiSizeHeight ;
                            
                        }
                        if (height == 0)
                        {
                            height = KEmojiSizeHeight;
                        }
                        
                        y = height - KEmojiSizeHeight ;
                        y = y + (KEmojiSizeHeight - kTextHeight)/2.0 + 2.0;
                        
                        
                        upX = upX - size.width;
                        
                        if(upX >= 0 && width < maxWidth)
                        {
                            width = maxWidth - upX + 10 ;//+ size.width;
                            size.width+= 10.0;
                        }
                        if (size.width > maxWidth)
                        {
                            size.width = maxWidth;
                        }
                        if(size.width < maxWidth && width == maxWidth)
                        {
                            size.width+=10;
                        }
                        
                    }
                    else
                        
                    {
                        if ((upX - size.width <= 0))
                        {
                            upY = upY + KEmojiSizeHeight;
                            upX = maxWidth;
                            width = maxWidth;
                            height = height + KEmojiSizeHeight ;
                            
                        }
                        else if(width < size.width)
                        {
                            width = size.width;
                            
                        }
                        if (height == 0)
                        {
                            height = KEmojiSizeHeight;
                        }
                        
                        y = height - KEmojiSizeHeight ;
                        y = y + (KEmojiSizeHeight - kTextHeight)/2.0 + 2;
                        
                        
                        upX = upX - size.width;
                        
                        if(upX >= 0 && width < maxWidth)
                        {
                            width = maxWidth - upX ;//+ size.width;
                        }
                        
                    }
                    
                    if (isWeblink)
                    {
                        NSString * webLinkName = emoticonName;
                        WebLinkButton  *webLinkBtn = [WebLinkButton buttonWithType:UIButtonTypeCustom];
                        
                        webLinkBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                        webLinkBtn.titleLabel.textAlignment = NSTextAlignmentRight;
                        
                        CGRect frame;
                        frame =      CGRectMake( upX ,y,size.width  ,kTextHeight);
                        
                        
                        webLinkBtn.frame = frame;
                        webLinkBtn.titleLabel.font = fon;
                        
                        [webLinkBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                        
                        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:webLinkName];
                        
                        // making text property to underline text-
                        [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
                        
                        // using text on button
                        [webLinkBtn setAttributedTitle: titleString forState:UIControlStateNormal];
                        
                        //                        [webLinkBtn setTitle:webLinkName forState:UIControlStateNormal];
                        webLinkBtn.webLink = emoticonName;
                        [webLinkBtn addTarget:self.delegate action:@selector(doOpenWebLink:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [ViewsArr addObject: webLinkBtn];
                        
                        
                        
                    }
                    else
                    {
                        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake( upX ,y,size.width,kTextHeight)];
                        
                        [la setFont:[UIFont systemFontOfSize:FontSise]];
                        la.text = emoticonName;
                        la.textColor = color;
                        la.backgroundColor = [UIColor clearColor];
                        
                        [ViewsArr addObject: la];
                        
                        
                    }
                    
                    
                    //                    upX = upX - size.width;
                    
                }
                
            }
        }
    }
    if (width < MIN_WIDTH)
    {
        if (inFromSelf)
        {
            width = MIN_WIDTH ;
            
        }
        else
        {
            width = MIN_WIDTH + 5;
            
        }
    }
    
    
    CGRect viewRect;
    float w = 0.0;
    float x = 0.0;
    for (UIView *  aView in ViewsArr)
    {
        viewRect = aView.frame;
        
        if (w == 0)
        {
            x =  width - viewRect.size.width - w;
            
        }
        else
        {
            x =  width - viewRect.size.width - w;
        }
        
        if (x <= 0 && width == maxWidth)
        {
            x = width - viewRect.size.width ;
            w = 0;
        }
        w = w + viewRect.size.width;
        
        viewRect.origin.x = x;
        aView.frame = viewRect;
        [returnView addSubview: aView];
        
        
    }
    returnView.frame = CGRectMake(0.0f,0.0f, width + 10 , height + 20 );
    
    //    NSLog(@"%.1f %.1f", width, height);
    //        [returnView setBackgroundColor:[UIColor blueColor]];
    [array release]; array = nil;
    [ViewsArr release]; ViewsArr = nil;
    return returnView;
}

//25-4-14
-(NSArray *)seperateLineInMsgByNewLine:(NSString *)inMsg
{
    NSArray *aSeperatedLines = [inMsg componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return  aSeperatedLines;
    
}
//end


-(UIView *)chatViewForEnglishOfMsg:(NSString *)inMsg andFromSelf:(BOOL)inFromSelf
{
    
    CustomChatView *aReturnView = [[CustomChatView alloc] initWithFrame:CGRectZero];
    aReturnView.Delegate = self.delegate;
    
        CGRect labelRect = CGRectMake(0, 0,  MAX_WIDTH_SELF, 0);
        UITextView *aMsgTextView = [[UITextView alloc] initWithFrame: labelRect];
        [aMsgTextView setContentInset:UIEdgeInsetsMake(-5, -2, 0, -2)];
        aMsgTextView.text = inMsg;
        aMsgTextView.editable = NO;
        aMsgTextView.selectable = YES;
        aMsgTextView.dataDetectorTypes = UIDataDetectorTypeLink ;
        
        aMsgTextView.font = [UIFont systemFontOfSize: FontSise];
        [aMsgTextView sizeToFit];

        CGSize lblMsgSize = aMsgTextView.frame.size;

        UIColor* aWebLinkColor;
        UIColor *aTextColor;

        if(inFromSelf)
        {
            aWebLinkColor = kWebLinRightkRGBColor;
            aTextColor = [UIColor whiteColor];
        }
        else
        {
            aWebLinkColor = kWebLinLeftkRGBColor;
            aTextColor = [UIColor blackColor];
            
        }
        
        NSDictionary *attrDict = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize: FontSise],
                                   
                                   NSForegroundColorAttributeName :aWebLinkColor
                                   };
        [aMsgTextView setLinkTextAttributes:attrDict];
        
        aMsgTextView.textColor = aTextColor;
        aMsgTextView.scrollEnabled = NO;
        aMsgTextView.backgroundColor = [UIColor clearColor];
        [aReturnView addSubview: aMsgTextView];
        
    
        if (lblMsgSize.width <= MIN_WIDTH)
        {
            aMsgTextView.frame = CGRectMake(0.0f,0.0f, MIN_WIDTH  , aMsgTextView.frame.size.height );
            aReturnView.frame = CGRectMake(0.0f,0.0f, MIN_WIDTH , aMsgTextView.frame.size.height );
        }
        else if (lblMsgSize.width >= MAX_WIDTH_SELF)
        {
            aMsgTextView.frame = CGRectMake(0.0f,0.0f, MAX_WIDTH_SELF, aMsgTextView.frame.size.height );
            aReturnView.frame = CGRectMake(0.0f,0.0f, MAX_WIDTH_SELF , aMsgTextView.frame.size.height );
        }

        else
        {
            aMsgTextView.frame = CGRectMake(0.0f,0.0f, aMsgTextView.frame.size.width , aMsgTextView.frame.size.height) ;
            aReturnView.frame = CGRectMake(0.0f,0.0f, aMsgTextView.frame.size.width , aMsgTextView.frame.size.height );
            
        }
        return  aReturnView;

    
    // Not in use
    
    //25-4-14
    NSArray *msgLines = [self seperateLineInMsgByNewLine: inMsg];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSString *aMsgLine in msgLines)
    {
        NSMutableArray *AlineArray = [[NSMutableArray alloc] init];
        
        [self getImageRange: aMsgLine :AlineArray];
        [array addObject:AlineArray];
        
    }
    
    //    [self getImageRange: inMsg :array];
    //end
    
    //    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    CustomChatView *returnView = [[CustomChatView alloc] initWithFrame:CGRectZero];
    returnView.Delegate = self.delegate;
    NSArray *data = [NSArray arrayWithArray: array];
    UIFont *fon = [UIFont systemFontOfSize: FontSise];
    UIColor * color = nil;
    
    //    UIColor * color = [UIColor colorWithRed:191.0/255.0 green:202.0/255.0 blue:215.0/255.0 alpha: AlphaTrans];
    
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat width = 0;
    CGFloat height = 0.0;//KEmojiSizeHeight;
    //    BOOL isAnyImage  = [self isContainAnyEmojiAndEmoticonInMsg: data];
    //    BOOL isAnyImage1  = NO;
    
    //25-4-14
    float actualMaxWidth = 0;
    //end
    
    float maxWidth;
    float maxCharForWebLink;
    
    if (inFromSelf)
    {
        //24-12-13
        color = [UIColor whiteColor];
        if (self.chatType == eChatHistory)
        {
            maxWidth = MAX_WIDTH_SELF - 100;
            maxCharForWebLink  = MaxCharInWebLinkSelf;
        }
        else
        {
            maxWidth = MAX_WIDTH_SELF;
            maxCharForWebLink  = MaxCharInWebLinkSelf;
        }
        //end
    }
    else
    {
        color = [UIColor blackColor];
        maxWidth = MAX_WIDTH_OTHER;
        maxCharForWebLink  = MaxCharInWebLinkOther;
        
    }
    
    
    if (data)
    {
        for (int p = 0;p < [data count]; p ++)
        {
            NSArray * newData = [data objectAtIndex: p];
            
            
            for (int k=0;k < [newData count];k++)
            {
                NSString *str=[newData objectAtIndex: k];
                
                
                {
                    
                    NSMutableArray *ntvData = [[NSMutableArray alloc] init];
                    [self getImageRangeForNativEmotions: str  :ntvData];
                    
                    NSMutableArray *allWords = [[NSMutableArray alloc] init];
                    NSMutableArray *breakonWords = [[NSMutableArray alloc] init];
                    
                    for (int i = ntvData.count-1;i >= 0; i--)
                    {
                        NSString * aSentance = [ntvData objectAtIndex: i];
                        
                        NSArray * sepeateWords = [self seperateWordBySpaceIfNeeded: aSentance];
                        if (sepeateWords == nil)
                        {
                            [allWords addObject: aSentance];
                        }
                        else
                        {
                            for (int k = sepeateWords.count - 1 ; k >= 0; k --)
                            {
                                
                                
                                id aWord = [sepeateWords objectAtIndex:k];
                                /////
                                
                                CGSize size =   [aWord sizeWithFont:[UIFont systemFontOfSize:FontSise]];
                                
                                if ([self validateUrl: aWord] == YES)
                                {
                                    [allWords addObject: [NSString stringWithFormat:@"%@",aWord]];
                                    
                                }
                                else if (size.width > maxWidth)
                                {
                                    [self breakSingleWordIfItCrossedItsWitdh: aWord andMaxWitdh: maxWidth andFillWordArr: breakonWords];
                                    for (int m = breakonWords.count - 1 ; m >= 0; m --)
                                    {
                                        aWord = [breakonWords objectAtIndex:m];
                                        
                                        [allWords addObject: [NSString stringWithFormat:@" %@",aWord]];
                                        
                                    }
                                    [breakonWords removeAllObjects];
                                    
                                }
                                else
                                    ////
                                    [allWords addObject: [NSString stringWithFormat:@" %@",aWord]];
                            }
                            
                        }
                    }
                    
                    /////
                    
                    
                    //do set word according to Language
                    NSArray *aTempWrds = [self setWordsWhenLangEnlishByWords: allWords];
                    [allWords removeAllObjects];
                    [allWords addObjectsFromArray:aTempWrds];
                    //
                    
                    /////
                    
                    //25-4-14
                    if (p > 0 && p < [data count])
                    {
                        if (width > actualMaxWidth )
                        {
                            actualMaxWidth = width;
                        }
                        height = height + KEmojiSizeHeight ;
                        upX = 0;
                        upY = 0;
                        width = 0;
                    }
                    //end
                    
                    for (int i = allWords.count-1;i >= 0; i--)//for (int i = allWords.count-1;i >= 0; i--)
                    {
                        
                        
                        NSString * aNtvEmoticon = [allWords objectAtIndex: i];
                        
                        if ([allWords count] > 1 && i == 0)
                        {
                            //when last object is nul string in printing ordere
                            if ([aNtvEmoticon isEqualToString:@" "])
                            {
                                continue;
                            }
                        }
                        
                        BOOL isWeblink = [self validateUrl: aNtvEmoticon];
                        
                        NSString *emoticonName;
                        if ([self isMsgHasAnyEmojiAndEmoticon: aNtvEmoticon])
                        {
                            emoticonName =[aNtvEmoticon substringWithRange:NSMakeRange(2, aNtvEmoticon.length - 4)];
                            
                        }
                        else
                        {
                            emoticonName = aNtvEmoticon;
                        }
                        
                        //23-4-14 issue 465
                        
                        CGSize size =   [emoticonName sizeWithFont:[UIFont systemFontOfSize:FontSise]];
                        //                        size.width = size.width + 10;
                        //end
                        
                        float y  ;
                        
                        if (isWeblink == YES)
                        {
                            
                            if (upX + size.width > maxWidth)
                            {
                                upY = upY + KEmojiSizeHeight;//upY + KEmoticonSizeHeight + 10;
                                upX = 0;
                                width = maxWidth;
                                height = height + KEmojiSizeHeight ;//upY;
                                
                            }
                            else if (upX >= maxWidth)
                            {
                                upY = upY + KEmojiSizeHeight;//upY + KEmoticonSizeHeight + 10;
                                upX = 0;
                                width = maxWidth;
                                height = height + KEmojiSizeHeight ;//upY;
                            }
                            if (size.width > maxWidth)
                            {
                                size.width = maxWidth;
                            }
                            
                            if(size.width < maxWidth && width < maxWidth)
                            {
                                size.width+=10;
                                //3-5-14
                                width = size.width;
                                //end
                                
                            }
                            
                            if (height == 0)
                            {
                                height = KEmojiSizeHeight;
                            }
                            y = height - KEmojiSizeHeight ;
                            y = y + (KEmojiSizeHeight - kTextHeight)/2.0 + 2;
                            
                            //25-4-14
                            if (width > actualMaxWidth )
                            {
                                actualMaxWidth = width;
                            }
                            //end
                            
                        }
                        else
                        {
                            
                            if (upX + size.width >= maxWidth)
                            {
                                upY = upY + KEmojiSizeHeight;//upY + KEmoticonSizeHeight + 10;
                                upX = 0;
                                width = maxWidth;
                                height = height + KEmojiSizeHeight ;//upY;
                            }
                            else if (upX >= maxWidth)
                            {
                                upY = upY + KEmojiSizeHeight;//upY + KEmoticonSizeHeight + 10;
                                upX = 0;
                                width = maxWidth;
                                height = height + KEmojiSizeHeight ;//upY;
                            }
                            //3-5-14
                            //                            else if(maxWidth < size.width)
                            //                            {
                            //                                width = size.width;
                            //
                            //                            }
                            else if(maxWidth >= (width + size.width))
                            {
                                width = width + size.width;
                                
                            }
                            //end
                            if (height == 0)
                            {
                                height = KEmojiSizeHeight;
                            }
                            y = height - KEmojiSizeHeight ;
                            y = y + (KEmojiSizeHeight - kTextHeight)/2.0 + 2;
                            
                            //25-4-14
                            if (width > actualMaxWidth )
                            {
                                actualMaxWidth = width;
                            }
                            //end
                            
                            
                        }
                        
                        if (isWeblink)
                        {
                            NSString *webLinkName = emoticonName;
                            
                            WebLinkButton  *webLinkBtn = [WebLinkButton buttonWithType:UIButtonTypeCustom];
                            webLinkBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                            
                            CGRect frame =  CGRectMake( upX + 3 ,y,size.width,kTextHeight);
                            
                            webLinkBtn.frame = frame;
                            webLinkBtn.titleLabel.font = fon;
                            NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:webLinkName];
                            
                            UIColor *webLinkColor = nil;
                            if(inFromSelf)
                            {
                                webLinkColor = [UIColor whiteColor];
                            }
                            else
                            {
                                webLinkColor = [UIColor blueColor];
                            }
                            [titleString addAttribute:NSForegroundColorAttributeName value:webLinkColor range:NSMakeRange(0, [titleString length])];
                            
                            // making text property to underline text-
                            [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
                            
                            // using text on button
                            [webLinkBtn setAttributedTitle: titleString forState:UIControlStateNormal];
                            
                            //                        [webLinkBtn setTitle:webLinkName forState:UIControlStateNormal];
                            //                            [webLinkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            
                            //                            [webLinkBtn setTitle:webLinkName forState:UIControlStateNormal];
                            webLinkBtn.webLink = emoticonName;
                            [webLinkBtn addTarget:self.delegate action:@selector(doOpenWebLink:) forControlEvents:UIControlEventTouchUpInside];
                            [returnView addSubview : webLinkBtn];
                            
                        }
                        else
                        {
                            UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake( upX ,y,size.width,kTextHeight)];
                            //                la.font = fon;
                            [la setFont:[UIFont systemFontOfSize:FontSise]];
                            la.text = emoticonName;
                            la.textColor = color;
                            la.backgroundColor = [UIColor clearColor];
                            
                            [returnView addSubview :la];
                            
                        }
                        upX=upX+ size.width;
                        if (width < maxWidth)
                        {
                            width = upX;
                        }
                        
                    }
                    
                    
                }
                
                
                
            }
            
            
        }
    }
    
    //25-4-14
    
    if (actualMaxWidth < MIN_WIDTH)
    {
        if (inFromSelf)
        {
            actualMaxWidth = MIN_WIDTH ;
            
        }
        else
        {
            actualMaxWidth = MIN_WIDTH - 5;
            
        }
    }
    //3-5-14
    //    if (inFromSelf)
    //    {
    //        if (MAX_WIDTH_SELF-actualMaxWidth >=30)
    //        {
    //            actualMaxWidth+=20;
    //        }
    //
    //
    //    }
    //    else
    //    {
    //        if (MAX_WIDTH_OTHER-actualMaxWidth >=30)
    //        {
    //            actualMaxWidth+=20;
    //        }
    //    }
    //end
    
    returnView.frame = CGRectMake(0.0f,0.0f, actualMaxWidth + 10 , height + 20 ); //@ 需要将该view的尺寸记下，方便以后使用
    //NSLog(@"%.1f %.1f", width, height);
    //    [returnView setBackgroundColor:[UIColor blueColor]];
    return returnView;
}


-(NSArray *)setWordsWhenLangEnlishByWords:(NSArray *)inWords
{
    NSMutableArray *tempaArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    BOOL isArabic = NO;
    
    for (int i = 0; i < inWords.count;  i ++)
    {
        NSString *aWord = [NSString stringWithFormat:@"%@",[inWords objectAtIndex: i ]];
        
        BOOL success = [self validateIsEnglishLang : aWord];
        
        if (success)
        {
            if (isArabic)
            {
                //do add english word in reverse order
                
                if (tempaArr.count > 0)
                {
                    for (int i = tempaArr.count - 1; i >= 0;  i --)
                    {
                        [arr addObject: [tempaArr objectAtIndex: i]];
                        
                    }
                    
                    [tempaArr removeAllObjects];
                    isArabic = NO;
                    
                    //add Arabic Word
                    [arr addObject: aWord];
                    
                    
                }
            }
            else
            {
                [arr addObject: aWord];
            }
            //            NSLog(@"English Lang and Word = %@",[inWords objectAtIndex: i ]);
            
        }
        else
        {
            isArabic = YES;
            if (inWords.count > 1)
            {
                [tempaArr addObject: aWord];
                
            }
            if (inWords.count == 1)
            {
                [arr addObject: aWord];
            }
            //            NSLog(@"Arabic Lang and Word = %@",[inWords objectAtIndex: i ]);
            
        }
    }
    if (isArabic)
    {
        for (int i = tempaArr.count - 1; i >= 0;  i --)
        {
            [arr addObject: [tempaArr objectAtIndex: i]];
            
        }
    }
    //    NSLog(@"");
    
    return  arr;
    
}

-(NSArray *)setWordsWhenLangArabicByWords:(NSArray *)inWords
{
    NSMutableArray *tempaArr = [[NSMutableArray alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    BOOL isEnglish = NO;
    
    for (int i = 0; i < inWords.count;  i ++)
    {
        NSString *aWord = [NSString stringWithFormat:@"%@",[inWords objectAtIndex: i ]];
        BOOL success = ![self validateIsEnglishLang : aWord];
        
        if (success)
        {
            if (isEnglish)
            {
                //do add english word in reverse order
                
                if (tempaArr.count > 0)
                {
                    for (int i = tempaArr.count - 1; i >= 0;  i --)
                    {
                        [arr addObject: [tempaArr objectAtIndex: i]];
                        
                    }
                    
                    [tempaArr removeAllObjects];
                    isEnglish = NO;
                    
                    //add English Word
                    [arr addObject: aWord];
                    
                    
                }
            }
            else
            {
                [arr addObject: aWord];
            }
            //            NSLog(@"Arabic Lang and Word = %@",[inWords objectAtIndex: i ]);
            
        }
        else
        {
            isEnglish = YES;
            if (inWords.count > 1)
            {
                [tempaArr addObject: aWord];
                
            }
            if (inWords.count == 1)
            {
                [arr addObject: aWord];
            }
            //            NSLog(@"English Lang and Word = %@",[inWords objectAtIndex: i ]);
            
        }
    }
    if (isEnglish)
    {
        for (int i = tempaArr.count - 1; i >= 0;  i --)
        {
            [arr addObject: [tempaArr objectAtIndex: i]];
            
        }
    }
    
    //    NSLog(@"");
    
    return  arr;
    
}

-(void)breakSingleWordIfItCrossedItsWitdh:(NSString *)inWord andMaxWitdh :(float)inMaxWidth andFillWordArr:(NSMutableArray *)inArr
{
    NSString *rightHalfStr;
    int len = inWord.length;
    int rightLen = 1;
    int leftLen = len - rightLen;
    CGSize size;
    
    if (rightLen > 0 && leftLen > 0)
    {
        rightHalfStr = [inWord substringToIndex:1];
        
        if (rightHalfStr.length == 0)
        {
            return;
        }
        else
        {
            
            size =   CGSizeZero;
            
            if (rightHalfStr.length < inWord.length)
            {
                int counter = 0;
                while (size.width < inMaxWidth && rightLen >= 0 && leftLen >= 0)
                {
                    if (size.width < inMaxWidth)
                    {
                        rightHalfStr = [inWord substringToIndex: rightLen + counter];
                        //                leftLen = leftLen - 1;
                        size =   [rightHalfStr sizeWithFont:[UIFont systemFontOfSize:FontSise]];
                    }
                    counter  = counter + 1;
                    
                    leftLen = leftLen - 1;
                }
                if (leftLen > 0)
                {
                    rightHalfStr = [rightHalfStr substringToIndex: rightHalfStr.length -1];
                    
                    NSString *aRestStr = [inWord substringFromIndex: rightHalfStr.length];
                    [inArr addObject: rightHalfStr];
                    
                    [self breakSingleWordIfItCrossedItsWitdh: aRestStr andMaxWitdh: inMaxWidth andFillWordArr: inArr];
                    
                    
                }
                else if(leftLen <= 0)
                {
                    [inArr addObject: rightHalfStr];
                    rightHalfStr = [inWord substringFromIndex: rightHalfStr.length];
                    [self breakSingleWordIfItCrossedItsWitdh: rightHalfStr andMaxWitdh: inMaxWidth andFillWordArr: inArr];
                }
                
            }
            else
                return;
            
            
            
            
        }
        
    }
    else
        return;
    
}

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array
{
    NSRange range2=[message rangeOfString: EmojiBEGIN_FLAG];
    NSRange range1=[message rangeOfString: EmojiEND_FLAG];
    
    NSRange range4=[message rangeOfString: EmotionBEGIN_FLAG];
    NSRange range3=[message rangeOfString: EmotionEND_FLAG];
    
    
    if ([message hasPrefix: EmojiBEGIN_FLAG] )
    {
        if (range2.location != NSNotFound)//for emoji
        {
            [array addObject:[message substringToIndex:range2.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range2.location, range1.location+1-range2.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            //            NSLog(@"str = %@",str);
            [self getImageRange:str :array];
        }
        else
        {
            //for emoji
            NSString *nextstr1=[message substringWithRange:NSMakeRange(range2.location, range1.location+1-range2.location)];
            
            //for emoji
            if (![nextstr1 isEqualToString:@""]) {
                [array addObject:nextstr1];
                NSString *str=[message substringFromIndex:range1.location+1];
                //                NSLog(@"str = %@",str);
                
                [self getImageRange:str :array];
            }
            
            else
            {
                return;
            }
            
        }
    }
    else if ([message hasPrefix: EmotionBEGIN_FLAG])
    {
        if (range4.length>0 && range3.length>0)
        {
            if (range4.location != NSNotFound)//for emotion
            {
                [array addObject:[message substringToIndex:range4.location]];
                [array addObject:[message substringWithRange:NSMakeRange(range4.location, range3.location+1-range4.location)]];
                NSString *str=[message substringFromIndex:range3.location+1];
                //                NSLog(@"str = %@",str);
                
                [self getImageRange:str :array];
            }
            else
            {
                
                //for emotion
                NSString *nextstr2=[message substringWithRange:NSMakeRange(range4.location, range3.location+1-range4.location)];
                
                
                //排除文字是“”的
                //for emotion
                if (![nextstr2 isEqualToString:@""]) {
                    [array addObject:nextstr2];
                    NSString *str=[message substringFromIndex:range3.location+1];
                    //                    NSLog(@"str = %@",str);
                    
                    [self getImageRange:str :array];
                }
                else
                {
                    return;
                }
            }
            
        }
        
    }
    else if((range2.length>0 && range1.length>0)|| (range4.length>0 && range3.length>0))
    {
        if (range2.location > range4.location)
        {
            [array addObject:[message substringToIndex:range4.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range4.location, range3.location+1-range4.location)]];
            NSString *str=[message substringFromIndex:range3.location+1];
            //            NSLog(@"str = %@",str);
            
            [self getImageRange:str :array];
            
        }
        else if (range2.location < range4.location)
        {
            [array addObject:[message substringToIndex:range2.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range2.location, range1.location+1-range2.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            //            NSLog(@"str = %@",str);
            [self getImageRange:str :array];
            
            
        }
    }
    
    else if (message != nil) {
        [array addObject:message];
    }
}


-(void)getImageRangeForNativEmotions:(NSString*)message : (NSMutableArray*)array
{
    NSRange range=[message rangeOfString: NativeEmojiBEGIN_FLAG];
    NSRange range1=[message rangeOfString: NativeEmojiEND_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+2-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+2];
            [self getImageRangeForNativEmotions:str :array];
        }
        else
        {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+2-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+2];
                [self getImageRangeForNativEmotions:str :array];
            }
            else
            {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

-(BOOL)isMsgHasAnyEmojiAndEmoticon:(NSString *)inMsg
{
    //    NSLog(@"str--->%@",inMsg);
    
    if (([inMsg hasPrefix: EmotionBEGIN_FLAG] && [inMsg hasSuffix: EmotionEND_FLAG]) ||
        ([inMsg hasPrefix: EmojiBEGIN_FLAG] && [inMsg hasSuffix: EmojiEND_FLAG])
        || ([inMsg hasPrefix: NativeEmojiBEGIN_FLAG] && [inMsg hasSuffix: NativeEmojiEND_FLAG]))
    {
        return  YES;
    }
    return NO;
}

#pragma mark- Helper Methods
#pragma mark- Helper Methods
//23-12-13
-(NSString *)isFirstWordEmojiAndEmoticonInMsg:(NSArray *)inWordArr
{
    //    NSLog(@"str--->%@",inMsg);
    BOOL isContainLanWord = NO;
    NSString *inMsg;
    for (int i = 0; i < inWordArr.count ;  i ++)
    {
        inMsg = [NSString stringWithFormat:@"%@",[inWordArr objectAtIndex: i]];
        
        if (([inMsg hasPrefix: EmotionBEGIN_FLAG] && [inMsg hasSuffix: EmotionEND_FLAG]) ||
            ([inMsg hasPrefix: EmojiBEGIN_FLAG] && [inMsg hasSuffix: EmojiEND_FLAG])
            || ([inMsg hasPrefix: NativeEmojiBEGIN_FLAG] && [inMsg hasSuffix: NativeEmojiEND_FLAG]))
        {
            isContainLanWord = NO;
        }
        else
        {
            isContainLanWord = YES;
            break;
        }
    }
    if (isContainLanWord)
    {
        return  inMsg;
    }
    else
    {
        return  nil;
    }
    
    
}

//end
-(BOOL)isContainAnyEmojiAndEmoticonInMsg:(NSArray *)inData
{
    for (int i=0;i < [inData count];i++)
    {
        NSString *inMsg=[inData objectAtIndex:i];
        //        NSLog(@"str--->%@",inMsg);
        
        if (([inMsg hasPrefix: EmotionBEGIN_FLAG] && [inMsg hasSuffix: EmotionEND_FLAG]) ||
            ([inMsg hasPrefix: EmojiBEGIN_FLAG] && [inMsg hasSuffix: EmojiEND_FLAG]))
        {
            return  YES;
        }
    }
    return NO;
}
-(BOOL)isContainStickerInMsg:(NSString *)inMsg
{
    //    NSLog(@"str--->%@",inMsg);
    
    if (([inMsg hasPrefix: StickerBEGIN_FLAG] && [inMsg hasSuffix: StickerEND_FLAG]))
    {
        return  YES;
    }
    return NO;
}

-(NSArray *)seperateWordBySpaceIfNeeded :(NSString *)inSentance
{
    if (inSentance == nil)
    {
        return  nil;
    }
    if (([inSentance hasPrefix: NativeEmojiBEGIN_FLAG] == NO
         && [inSentance hasSuffix: NativeEmojiEND_FLAG] == NO))
    {
        NSArray * words = [inSentance componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return  words;
    }
    return nil;
}
#pragma mark-

@end
