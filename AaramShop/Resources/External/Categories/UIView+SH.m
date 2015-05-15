//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/UIView+Red5.m $
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

#import "UIView+SH.h"

@interface UIView (UIViewSH_)

//Property to supress the warning.
@property(nonatomic, readonly) UIViewController *	_viewDelegate;

@end

@implementation UIView(UIViewSH_)

@dynamic _viewDelegate;	//Original class member taken instead.

@end



@implementation UIView (UIViewSH)

-(UIViewController *)
selfViewController
{
	return [self _viewDelegate];
}

@end
