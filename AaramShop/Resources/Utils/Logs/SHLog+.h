
#ifndef __SHLog__H__
#define __SHLog__H__

#ifdef __cplusplus
extern "C"
{
#endif
void		SHLogRect_(
//				enLogLevels				inLogLevel,
//				enLogAreas				inLogArea,
				const CGRect 			inRect,
				const char *			inFilePath,
				const char *			inFunctionName,
				int						inLineNumber );
					  
#ifdef __cplusplus
}
#endif

#ifdef DEBUG // 1	//Enable logs

#define SHLogRect( l, a, s )	\
			SHLogRect_(l, a, s, __FILE__, __FUNCTION__, __LINE__ ); 

#else

#define SHLogRect( l, a, s )

#endif


#endif	//__SHLog__H__
