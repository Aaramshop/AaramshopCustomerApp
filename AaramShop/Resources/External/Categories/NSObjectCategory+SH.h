//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/NSObjectCategory+SH.h $
//	$Revision: -1 $
//	$Date: $
//	$Author: $
//	
//	Creator: Raj Kumar Sehrawat
//	Created: 13-Jul-2011
//	Copyright: 2011-2012 Redfive. All rights reserved.
//	
//	Description: This must be first file to included in prefix header file.
//========================================================================================

#ifndef __NSObjectCategory+SH_H__
#define __NSObjectCategory+SH_H__

@interface NSObject(NSObjectCategorySH)

-(id)			retain_dbg	:(const char *) inCaller;
-(oneway void)	release_dbg :(const char *) inCaller;

@end

//Uncomment the following macros to debug our retain release count issues.
//#undef retain
//#undef release
//#define retain retain_dbg : __FUNCTION__
//#define release release_dbg : __FUNCTION__

#endif	//__NSObjectCategory+SH_H__
