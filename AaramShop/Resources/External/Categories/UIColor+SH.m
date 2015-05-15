//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/UIColor+Red5.m $
//	$Revision: 1 $
//	$Date: 2013-02-08 17:49:04 +0530 (Fri, 08 Feb 2013) $
//	$Author: shakir.husain $
//	
//	Creator: Raj Kumar Sehrawat
//	Created: 01-Aug-2011
//	Copyright: 2011-2012 Redfive. All rights reserved.
//	
//	Description:
//========================================================================================

#import "UIColor+SH.h"

@implementation UIColor (UIColorSH)

+(UIColor*)
ColorFromRGBStr		:(NSString*)				inColorStr
					:(CGFloat)					inAlpha
{
	if( !inColorStr || [inColorStr length] != 7 )
		return nil;
	
	NSRange r;
    r.location = 1;
    r.length = 2;
   	
	NSString * tempStr = [inColorStr substringWithRange: r];
	
	unsigned int  redValue=0;
	NSScanner *scanner = [NSScanner scannerWithString:tempStr];
    [scanner scanHexInt:&redValue];
	
	unsigned int  greenValue = 0;
	r.location = 3;
	tempStr = [inColorStr substringWithRange: r];
	scanner = [NSScanner scannerWithString:tempStr];
    [scanner scanHexInt:&greenValue];
	
	unsigned int  blueValue = 0;
	r.location = 5;
	tempStr = [inColorStr substringWithRange: r];
	scanner = [NSScanner scannerWithString:tempStr];
	[scanner scanHexInt:&blueValue];
	
	UIColor * toReturn = [UIColor colorWithRed: ((float) redValue / 255.0f) green: ((float) greenValue / 255.0f) blue: ((float) blueValue / 255.0f) alpha: inAlpha];
	return toReturn;
}

@end
