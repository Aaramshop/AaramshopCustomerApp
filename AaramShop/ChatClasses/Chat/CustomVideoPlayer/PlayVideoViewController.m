//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/mediafacts/Codebase/trunk/Source/UI/ViewControllers/PlayVideoViewController.m $
//	$Revision: 1528 $
//	$Date: 2011-11-24 14:51:57 +0530 (Thu, 24 Nov 2011) $
//	$Author: aman.alam $
//	
//	Creator: Aman Alam
//	Created: 08-Sept-2011
//	Copyright: 2011-2012 Redfive. All rights reserved.
//	
//	Description:
//========================================================================================

#import "PlayVideoViewController.h"
#import "SHFileUtil.h"
#define thisFileLA	eLAUI

@implementation PlayVideoViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:self];

    
//    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    self.moviePlayer.allowsAirPlay = NO;
    [self.moviePlayer prepareToPlay];
}
- (void) viewWillDisappear:(BOOL)animated
{
//	[self.moviePlayer pause];
	[super viewWillDisappear: animated];
}

- (void) viewDidLoad
{
	[super viewDidLoad];
}	


//-(void)dealloc
//{
//	[[NSNotificationCenter defaultCenter] removeObserver: self];
//	
//	[super dealloc];
//}

- (void) movieFinishedCallback:(NSNotification*) inNotification
{
    
}

@end
