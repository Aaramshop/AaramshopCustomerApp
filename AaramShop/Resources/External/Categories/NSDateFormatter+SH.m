
#import "NSDateFormatter+SH.h"

NSLock *gWSDateLock;  //Lock used to sync use of following variables

NSDateFormatter *	gWSDateFormatter = nil;
NSDateFormatter *	gWSDate2Formatter = nil;
NSDateFormatter *	gUIDateFormatter = nil;

NSDateFormatter *	gUIArticleCellDateFormatter = nil;
NSDateFormatter *	gUIArticleCellBigDateFormatter = nil;
NSDateFormatter *	gUIArticleSmallCellNormalDateFormatter = nil;

@implementation NSDateFormatter(NSDateFormatterRR)

+(NSDateFormatter*)
RRWSDateFormatter
{
	if( !gWSDateFormatter )
	{
		gWSDateFormatter = [[NSDateFormatter alloc] init];
		//[gWSDateFormatter setFormatterBehavior: NSDateFormatterBehavior10_0];
		//[gWSDateFormatter setDateStyle: kCFDateFormatterShortStyle];
		//[gWSDateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZ"];
		[gWSDateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"];
	}
	return gWSDateFormatter;
}

+(NSDateFormatter*)
RRWSDate2Formatter
{
	if( !gWSDate2Formatter )
	{
		gWSDate2Formatter = [[NSDateFormatter alloc] init];
		//[gWSDate2Formatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZ"];
		[gWSDate2Formatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"];
	}
	return gWSDate2Formatter;
}



+(NSDateFormatter*)
RRUIDateFormatter
{
	if( !gUIDateFormatter )
	{
		gUIDateFormatter = [[NSDateFormatter alloc] init];
		//[gUIDateFormatter setFormatterBehavior: NSDateFormatterBehavior10_0];
		//[gUIDateFormatter setDateStyle: kCFDateFormatterShortStyle];
		[gUIDateFormatter setDateFormat: @"dd MMMM yyyy"];
	}
	return gUIDateFormatter;
}

+(NSDateFormatter*)
RRUIArticleCellDateFormatter
{
	if( !gUIArticleCellDateFormatter )
	{
		gUIArticleCellDateFormatter = [[NSDateFormatter alloc] init];
		[gUIArticleCellDateFormatter setDateFormat: @"MMM yyyy"];
	}
	return gUIArticleCellDateFormatter;
}


+(NSDateFormatter*)
RRUIArticleCellBigDateFormatter
{
	if (!gUIArticleCellBigDateFormatter)
	{
		gUIArticleCellBigDateFormatter = [[NSDateFormatter alloc] init];
		[gUIArticleCellBigDateFormatter setDateFormat: @"dd MMMM yyyy"];

	}
	return gUIArticleCellBigDateFormatter;
}

+(NSDateFormatter*)
RRUIArticleSmallCellNormalDateFormatter
{
	if (!gUIArticleSmallCellNormalDateFormatter)
	{
		gUIArticleSmallCellNormalDateFormatter = [[NSDateFormatter alloc] init];
		[gUIArticleSmallCellNormalDateFormatter setDateFormat: @"dd-MM-yyyy"];
		
	}
	return gUIArticleSmallCellNormalDateFormatter;
}

+(NSDate*)
dateFromWSString		:(NSString*)				inDateStr
{
	if (inDateStr.length > 20) 
	{
		inDateStr = [inDateStr stringByReplacingOccurrencesOfString:@":" 
														 withString:@"" 
															options:0
															  range:NSMakeRange(20, inDateStr.length-20)];
	}
	
	if( gWSDateLock == nil )
		gWSDateLock = [[NSLock alloc] init];
	
	[gWSDateLock lock];
	
	NSDate * toReturn = [[NSDateFormatter RRWSDateFormatter] dateFromString:inDateStr];
	
	if( !toReturn )
		toReturn = [[NSDateFormatter RRWSDate2Formatter] dateFromString:inDateStr];
	
	
	[gWSDateLock unlock];
	return toReturn;
}


@end
