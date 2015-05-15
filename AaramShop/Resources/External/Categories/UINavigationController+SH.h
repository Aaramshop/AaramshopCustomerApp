//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/UINavigationController+Red5.h $
//	$Revision: 1 $
//	$Date: 2013-02-08 17:49:04 +0530 (Fri, 08 Feb 2013) $
//	$Author: shakir.husain $
//	
//	Creator: Aman Alam
//	Created: 29-Jul-2011
//	Copyright: 2011-2012 Redfive. All rights reserved.
//	
//	Description:
//========================================================================================

#ifndef __UINavigationControllerSH_H__
#define __UINavigationControllerSH_H__

#pragma once
@interface UINavigationController(UINavigationControllerSH)

-(BOOL)			isControllerOnStack	:(UIViewController *)				inViewController;

@end

#endif //__UINavigationController+SH_H__