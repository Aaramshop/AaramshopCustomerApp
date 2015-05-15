//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/NSString+SH.h $
//	$Revision: -1 $
//	$Date: $
//	$Author: $
//	
//	Creator: Aman Alam
//	Created: 14-Jul-2011
//	Copyright: 2011-2012 Redfive. All rights reserved.
//	
//	Description:
//========================================================================================


@interface NSString(NSStringSH)

+(NSString*)			emptyString;
+(NSString*)			emptyStringWithRetain;

-(char*)				soapCString;

-(NSString*)			makeGUIDString;
-(NSString*)			MD5;
@end
