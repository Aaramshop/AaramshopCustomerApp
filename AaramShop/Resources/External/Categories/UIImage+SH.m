//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/UIImage+Red5.m $
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

#import "UIImage+SH.h"

NSMutableDictionary * gCachedResourceImages;
NSMutableDictionary * gImageNames;

@interface UIImage (UIImageMF_)

+(int)						getDeviceType;

@end

@implementation UIImage (UIImageSH)

+(UIImage*)
cachedImageForName	:(NSString*)				inImageName
{
	if( !gCachedResourceImages )
		gCachedResourceImages = [[NSMutableDictionary alloc] init];
	
	UIImage * toReturn = [gCachedResourceImages objectForKey: inImageName];
	if( !toReturn )
	{
		toReturn = [UIImage imageNamed: inImageName];
		if( toReturn )
			[gCachedResourceImages setObject: toReturn forKey: inImageName];
		else
		{
//			SHLogs( eLLErrors, eLAAll, @"********Image \"%@\" not found in resource.********", inImageName);
		}
	}
	return toReturn;
}

//Tries "-ipad" or "-iphone"
+(UIImage*)
cachedImageForPartialName	:(NSString*)		inImageName
{
	if( !gImageNames )
		gImageNames = [[NSMutableDictionary alloc] init];
	NSString * newName = [gImageNames objectForKey: inImageName];
	if( newName == nil )
	{
		NSString * suffix = @"-ipad";
		if( [UIImage getDeviceType] == 2 )
			suffix = @"-iphone";
		
		NSString * ext = [inImageName pathExtension];
		NSString * nameWithoutExt = inImageName;
		if( ext && [ext length] > 0 )
			nameWithoutExt = [inImageName stringByDeletingPathExtension];
		newName = [nameWithoutExt stringByAppendingString: suffix];
		if( ext && [ext length] > 0 )
			newName = [newName stringByAppendingString: ext];
		
//		NSLog( @"Old Name : %@, New Name : %@", inImageName, newName);
		[gImageNames setObject: newName forKey: inImageName];
	}
	
	UIImage * toReturn = [UIImage cachedImageForName: newName];
	if( toReturn )
		return toReturn;
	else
		return [UIImage cachedImageForName: inImageName];
}

+(int) getDeviceType
{
	static int gDeviceType = 0;
	if( gDeviceType == 0 )
	{
		NSString * currDeviceModel = [UIDevice currentDevice].model;
		
//		SHLogs( eLLDebugInfo, eLAAppController, @"Device Model : %@", currDeviceModel );
		if( [currDeviceModel isEqualToString: @"iPad" ] || [currDeviceModel isEqualToString: @"iPad Simulator" ])
			gDeviceType = 1;
		else
			gDeviceType = 2;
	}
	return gDeviceType;
}
@end
