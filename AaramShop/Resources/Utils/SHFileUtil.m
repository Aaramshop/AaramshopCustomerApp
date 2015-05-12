
#import "SHFileUtil.h"
// memory status
#import <mach/mach.h> 
#import <mach/mach_host.h>
#define STR_CacheFILEPATH @"~//Library//Caches"

@implementation SHFileUtil

+(NSString *)
getFullPathFromPath	: (NSString *)		inPath
{
	NSString *cachePath = [STR_CacheFILEPATH stringByExpandingTildeInPath];
	NSString *fullPath = [[cachePath stringByAppendingFormat: @"//%@", inPath] stringByExpandingTildeInPath];
	
	return fullPath;
}

+(BOOL)
createDirectoryWithPath	: (NSString *)		inPath
{
	if([SHFileUtil directoryExist: inPath])
		return YES;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *directoryPath = [SHFileUtil getFullPathFromPath: inPath];

	return [fileManager createDirectoryAtPath :directoryPath withIntermediateDirectories: YES attributes:nil error:nil];
}

+(BOOL)
createFileWithPath	: (NSString *)		inPath
{
	if([SHFileUtil fileExist: inPath])
		return YES;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filePath = [SHFileUtil getFullPathFromPath: inPath];
	
	return [fileManager createFileAtPath: filePath contents: nil attributes: nil];
}

+(BOOL)
deleteItemAtPath	: (NSString *)		inPartialPath
{
	BOOL result = YES;
	if([SHFileUtil directoryExist: inPartialPath] || [SHFileUtil fileExist: inPartialPath])
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *filePath = [SHFileUtil getFullPathFromPath: inPartialPath];
		
		NSError * err = [[NSError alloc] init];
		result = [fileManager removeItemAtPath: filePath error: &err];
	}
	
	return result;
}

+(BOOL)
directoryExist	: (NSString *)		inPath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *directoryPath = [SHFileUtil getFullPathFromPath: inPath];
	
	return [fileManager fileExistsAtPath: directoryPath];
}

+(BOOL)
fileExist	: (NSString *)		inPath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filePath = [SHFileUtil getFullPathFromPath: inPath];
	
	return [fileManager fileExistsAtPath: filePath];
}

+(void)
writePlistForId	: (NSString *)		inId
	   withData	: (NSDictionary *)	inPlistData
{
	NSString * plistFileNameWithExtension = [[NSString stringWithFormat: @"%@.plist", inId] stringByExpandingTildeInPath];
	if(![SHFileUtil fileExist: plistFileNameWithExtension])
	{
		if([SHFileUtil createFileWithPath: plistFileNameWithExtension] == NO)
			return;
	}
	
	NSString * fullPath = [SHFileUtil getFullPathFromPath: plistFileNameWithExtension];

	//NSLog( @"%@", inPlistData);
	
	NSString *error;
	NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList: inPlistData
														 format:NSPropertyListXMLFormat_v1_0
											   errorDescription:&error];
	if(xmlData) {
		[xmlData writeToFile:fullPath atomically:YES];
	}
}

+(NSDictionary *)
readPlistForId	: (NSString *)		inId
{
	NSString * plistFileNameWithExtension = [[NSString stringWithFormat: @"%@.plist", inId] stringByExpandingTildeInPath];
	if(![SHFileUtil fileExist: plistFileNameWithExtension])
		return nil;

	NSString * fullPath = [SHFileUtil getFullPathFromPath: plistFileNameWithExtension];
#if 0	
	NSMutableDictionary *plistData = [[[NSMutableDictionary alloc] initWithContentsOfFile: fullPath] autorelease];
#else	
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath: fullPath];
	
	NSPropertyListFormat format = 0;
	NSString * errorDesc;
	
	NSMutableDictionary *plistData = nil;
	if( plistXML && [plistXML length] > 0 )
	{
		plistData = (NSMutableDictionary *)[NSPropertyListSerialization
										  propertyListFromData: plistXML
										  mutabilityOption: NSPropertyListMutableContainers
										  format: &format
										  errorDescription: &errorDesc];
		if (!plistData) {
			//NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
		}
	}
#endif	
	return plistData;
}

+(BOOL)
writeFileInCache	: (NSData *)		inData
	toPartialPath	: (NSString *)		inPath
{
	if(!inData || !inPath)
		return NO;
	
	NSString * fullPath = [SHFileUtil getFullPathFromPath: inPath];
	NSRange range = [inPath rangeOfString: @"/"];
	if(range.location != NSNotFound)
	{
		int lastIndex = (int)([inPath rangeOfString:@"/" options: NSBackwardsSearch].location);
		NSString * directoryPath = [inPath substringToIndex: lastIndex];
		[SHFileUtil createDirectoryWithPath: directoryPath];
	}
	return [inData writeToFile: fullPath atomically: YES];
}

+(NSData *)
readFileFromCache	: (NSString *)		inPath
{
	if(!inPath)
		return nil;
	
	NSString * fullPath = [SHFileUtil getFullPathFromPath: inPath];
	return [NSData dataWithContentsOfFile: fullPath];
}
+(float)
getFreeMemoryInPercent
{

    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;

    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);		

    vm_statistics_data_t vm_stat;

    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"***** Failed to fetch vm statistics ******");

    /* Stats in bytes */ 
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;

    float aMemoryAvailable = 0.0;
     aMemoryAvailable = (((float)mem_free /(float)mem_total)*100);

    return aMemoryAvailable;
}



@end
