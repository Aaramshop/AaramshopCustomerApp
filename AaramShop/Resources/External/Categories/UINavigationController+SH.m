//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/UINavigationController+Red5.m $
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

#import "UINavigationController+SH.h"


@implementation UINavigationController(UINavigationControllerSH)

-(BOOL)
isControllerOnStack	:(UIViewController *)				inViewController
{
	NSArray * theStack = [self viewControllers];
	
	BOOL toReturn = [theStack containsObject: inViewController];
	return toReturn;
}

@end
