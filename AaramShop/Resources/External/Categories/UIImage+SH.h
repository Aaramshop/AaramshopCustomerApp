//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/UIImage+Red5.h $
//	$Revision: 1 $
//	$Date: 2013-02-08 17:49:04 +0530 (Fri, 08 Feb 2013) $
//	$Author: shakir.husain $
//	
//	Creator: Aman Alam
//	Created: 22-Jul-2011
//	Copyright: 2011-2012 Redfive. All rights reserved.
//	
//	Description:
//========================================================================================

#ifndef __UIImageSH_H__
#define __UIImageSH_H__

#pragma once

@interface UIImage (UIImageSH)

						//Use this function instead of imageNamed, so the image can be compared based on pointer
+(UIImage*)				cachedImageForName	:(NSString*)				inImageName;

						//Tries "-ipad" or "-iphone"
+(UIImage*)				cachedImageForPartialName	:(NSString*)		inImageName;

@end

#endif //__UIImageSH_H__