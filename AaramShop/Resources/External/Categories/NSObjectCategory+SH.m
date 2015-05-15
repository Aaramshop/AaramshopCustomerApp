
#undef retain
#undef release

@implementation NSObject(NSObjectCategorySH)

-(id)
retain_dbg	: (const char *) inCaller
{
	//NSLog( @"\nRetain  : Object at Address : %x, Refcount : %d, Caller : %s", self, [self retainCount], inCaller);
	return [self retain];
}

-(oneway void)
release_dbg : (const char *) inCaller
{
	//NSLog( @"\nRelease : Object at Address : %x, Refcount : %d, Caller : %s", self, [self retainCount], inCaller);
	[self release];
}

@end
