
#import "NSString+SH.h"
#import <CommonCrypto/CommonDigest.h>

NSString * gEmptyString = nil;

@implementation NSString(NSStringSH)

+(NSString*)
emptyString
{
	if( !gEmptyString )
		gEmptyString = [[NSString alloc] init];
	return gEmptyString;
}

+(NSString*)
emptyStringWithRetain
{
	return [[NSString emptyString] retain];
}

-(char*)
soapCString
{
	//typecasted intentionally as it will be only used for soap call.
	return (char*)[self cStringUsingEncoding:NSUTF8StringEncoding];
}


-(NSString*)
makeGUIDString
{
	NSMutableString * toReturn = [[NSMutableString alloc] initWithString: self];
	[toReturn insertString: @"-"  atIndex: 8];
	[toReturn insertString: @"-"  atIndex: 13];
	[toReturn insertString: @"-"  atIndex: 18];
	[toReturn insertString: @"-"  atIndex: 23];
	return [toReturn autorelease];
}
/// MD Encryption
- (NSString*)MD5
{
	// Create pointer to the string as UTF8
	const char *ptr = [self UTF8String];
	
 	// Create byte array of unsigned chars
	unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
	
	// Create 16 bytes MD5 hash value, store in buffer
	CC_MD5(ptr, strlen(ptr), md5Buffer);
	
	// Convert unsigned char buffer to NSString of hex values
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
		[output appendFormat:@"%02x",md5Buffer[i]];
	
	return output;
}

@end
