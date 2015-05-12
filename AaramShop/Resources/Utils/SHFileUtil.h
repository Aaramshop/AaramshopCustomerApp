
#ifndef __SHFileUtil_H__
#define __SHFileUtil_H__

@interface SHFileUtil : NSObject
{
}

+(NSString *)		getFullPathFromPath	: (NSString *)		inPath;

+(BOOL)			createDirectoryWithPath	: (NSString *)		inPath;
+(BOOL)				createFileWithPath	: (NSString *)		inPath;
+(BOOL)				deleteItemAtPath	: (NSString *)		inPartialPath;
+(BOOL)					directoryExist	: (NSString *)		inPath;
+(BOOL)						fileExist	: (NSString *)		inPath;

+(void)					writePlistForId	: (NSString *)		inId
							withData	: (NSDictionary *)	inPlistData;
+(NSDictionary *)		readPlistForId	: (NSString *)		inId;

+(BOOL)writeFileInCache	: (NSData *)		inData
								toPartialPath	: (NSString *)		inPath;

+(NSData *)					readFileFromCache	: (NSString *)		inPath;
// Memory
+(float)                    getFreeMemoryInPercent;


@end

#endif
