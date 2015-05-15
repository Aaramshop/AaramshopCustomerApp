//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/Categories/UIWebView+Red5.h $
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

#ifndef __UIWebViewSH_H__
#define __UIWebViewSH_H__

#pragma once

@interface UIWebView (UIWebViewSH)

@property (nonatomic, readonly) UIScrollView*	webScrollView;

-(void)				disableScrollBounce;
-(void)				pagingEnabled :(BOOL)inBool;

-(void)				setZoomScale :(float)inScale;
-(void)				zoomToRect :(CGRect) inZoomToRect;
-(void)				resetWebViewZoom;

-(void)				setContentOffset :(CGPoint) inPoint;
-(void)				setScrollToTop;
-(void)				setContentSize :(CGSize) inSize;
-(CGSize)			getContentSize;
-(NSString*)		setMinViewPortScale:(float)inMinimumScale;
-(void)            enableScrolling:(BOOL)inBool;

@end

#endif //__UIWebViewSH_H__