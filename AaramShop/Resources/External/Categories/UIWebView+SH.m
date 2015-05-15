//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/UIWebView+Red5.m $
//	$Revision: 1 $
//	$Date: 2013-02-08 17:49:04 +0530 (Fri, 08 Feb 2013) $
//	$Author: shakir.husain $
//	
//	Creator: Raj Kumar Sehrawat
//	Created: 29-Jan-2011
//	Copyright: 2010-2011 Redfive. All rights reserved.
//	
//	Description:
//========================================================================================

#import "UIWebView+SH.h"

@implementation UIWebView (UIWebViewSH)

-(UIScrollView*)	webScrollView
{
	UIScrollView * toReturn = nil;
	
	NSArray * selfSubviews = self.subviews;
	NSObject *obj = nil;
	int subViewsCount = selfSubviews.count;
	for (int i = 0; i < subViewsCount ; ++i)
	{
		obj = [selfSubviews objectAtIndex:i];
		
		if([[obj class] isSubclassOfClass:[UIScrollView class]] == YES)
		{
			toReturn = ((UIScrollView*)obj);
			break;
		}
	}
	return toReturn;
}


-(void)				disableScrollBounce
{
	NSArray * selfSubviews = self.subviews;
	NSObject *obj = nil;
	int subViewsCount = selfSubviews.count;
	for (int i = 0; i < subViewsCount ; ++i)
	{
		obj = [selfSubviews objectAtIndex:i];
		
		if([[obj class] isSubclassOfClass:[UIScrollView class]] == YES)
		{
			((UIScrollView*)obj).bounces = NO;
		}
	}
}

-(void)				pagingEnabled :(BOOL)inBool
{
	self.webScrollView.pagingEnabled = inBool;
}

-(void)				setZoomScale :(float)inScale
{
	self.webScrollView.zoomScale = inScale;
}

-(void)				zoomToRect :(CGRect) inZoomToRect
{
	[self.webScrollView zoomToRect: inZoomToRect animated: NO];
}


-(void)				resetWebViewZoom
{
	UIScrollView * webScroll = self.webScrollView;
	float minScale = webScroll.minimumZoomScale;
	if( minScale != 1 )
		[webScroll setZoomScale: minScale animated: NO];
}

-(void)				setContentOffset :(CGPoint) inPoint
{
	self.webScrollView.contentOffset = inPoint;
}

-(void)				setContentSize :(CGSize) inSize;

{
    self.webScrollView.contentSize = inSize;

}

-(void)				setScrollToTop;

{
    self.webScrollView.scrollsToTop = YES;
    
}

-(void)            enableScrolling :(BOOL)inBool
{
 	self.webScrollView.scrollEnabled = inBool;
}
-(CGSize)			getContentSize
{
	CGSize toReturn = CGSizeZero;
	toReturn = self.webScrollView.contentSize;
	return toReturn;
}

-(NSString*)
setMinViewPortScale:(float)inMinimumScale
{
		NSString * aJScriptToScaleViewPort = [NSString stringWithFormat: 
								 @"function scaleViewPort() {"
								 "var metatags = document.getElementsByTagName('meta');"
								 "for(cnt = 0; cnt < metatags.length; cnt++) {" 
								 "var element = metatags[cnt];"
								 "if(element.getAttribute('name') == 'viewport') {"
								 "element.setAttribute('content','minimum-scale=%.3f; initial-scale=%.3f;');}}}"
								,inMinimumScale,inMinimumScale];
	[self stringByEvaluatingJavaScriptFromString:aJScriptToScaleViewPort];
	[self stringByEvaluatingJavaScriptFromString:@"scaleViewPort();"];
	return aJScriptToScaleViewPort;
}



@end
