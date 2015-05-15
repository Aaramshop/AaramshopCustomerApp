//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/UIColor+SH.h $
//	$Revision: -1 $
//	$Date: $
//	$Author: $
//	
//	Creator: Raj Kumar Sehrawat
//	Created: 01-Aug-2011
//	Copyright: 2011-2012 Redfive. All rights reserved.
//	
//	Description:
//========================================================================================

#ifndef __UIColorRR_H__
#define __UIColorRR_H__

#pragma once

@interface UIColor (UIColorSH)

+(UIColor*)				ColorFromRGBStr		:(NSString*)				inColorStr
											:(CGFloat)					inAlpha;

@end

#endif //__UIColorRR_H__