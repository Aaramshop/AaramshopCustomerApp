

@protocol SHDebugPrint

#if 1//def DEBUG //Allowed for release build also. In Debug buld the functions will do nothing.
-(NSString*)				GetClassDbgName;

-(void)						PrintToLogs		:(enRRDebugMsg)				inDebugMsg
								printChild	:(BOOL)						inPrintChildElements;
#endif

@end
