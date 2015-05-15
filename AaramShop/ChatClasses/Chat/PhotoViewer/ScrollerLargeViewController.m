/*
 File: ImageScrollView.m
 Abstract: Centers image within the scroll view and configures image sizing and display.
 Version: 1.3
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */
#import "NewPhoto.h"
#import <Foundation/Foundation.h>

#import "ScrollerLargeViewController.h"
#import "UIImage+Extension.h"
#import "SHBaseRequestImage.h"
#import "SHRequestSampleImage.h"
//#import "HttpRequestProcessor.h"
#import "SHFileUtil.h"

#define TILE_IMAGES 0  // turn on to use tiled images, if off, we use whole images
// Pankaj

// forward declaration of our utility functions
static NSUInteger _ImageCount(void);

#if TILE_IMAGES
static CGSize _ImageSizeAtIndex(NSUInteger index);
static UIImage *_PlaceholderImageNamed(NSString *name);
#endif

#if !TILE_IMAGES
static UIImage *_ImageAtIndex(NSUInteger index);
#endif

static NSString *_ImageNameAtIndex(NSUInteger index);

#pragma mark -

@interface ScrollerLargeViewController () <UIScrollViewDelegate>
{
    UIImageView *_zoomView;  // if tiling, this contains a very low-res placeholder image,
    // otherwise it contains the full image.
    CGSize _imageSize;
    
    CGPoint _pointToCenterAfterResize;
    CGFloat _scaleToRestoreAfterResize;
}

@end

@implementation ScrollerLargeViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        
        
        
        UITapGestureRecognizer *doubleTapGesture=[[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(doubleTapped:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTapGesture];
        
    }
    return self;
}


-(void)doubleTapped:(UITapGestureRecognizer*)gesture{
    if([self zoomScale]==self.maximumZoomScale)
    {
        //        CGRect rect=_imgViewUserProfileImage.frame;
        [self setZoomScale:self.minimumZoomScale animated:YES];
        //          scrollImageView.contentSize = CGSizeMake(_imgViewUserProfileImage.frame.size.width, _imgViewUserProfileImage.frame.size.height+2*rect.origin.y);
        
    }
    else
    {
        [self setZoomScale:self.maximumZoomScale animated:YES];
        
    }
    
    self.contentSize = CGSizeMake(_zoomView.frame.size.width, _zoomView.frame.size.height);
    
//    if (_zoomView.frame.size.width>300) {
//  
//    if(self.zoomScaleNew < self.zoomScale ){
//        self.zoomScaleNew=self.zoomScale+0.5;
////        [self setZoomScale:self.zoomScaleNew animated:YES];
//        
////        CGRect zoomRect = [self zoomRectForScale:self.zoomScaleNew
////                                      withCenter:[gesture locationInView:gesture.view]];
////        [self zoomToRect:zoomRect animated:YES];
//        
//        [self zoomToPoint:[gesture locationInView:gesture.view] withScale:self.zoomScaleNew animated:YES];
//    }else{
//        self.zoomScaleNew=self.zoomScale-0.6;
//        [self setZoomScale:self.zoomScale-0.5 animated:YES];
//        
//    }
//    }
}
- (void)zoomToPoint:(CGPoint)zoomPoint withScale: (CGFloat)scale animated: (BOOL)animated
{
    //Normalize current content size back to content scale of 1.0f
    CGSize contentSize;
    contentSize.width = (self.contentSize.width / self.zoomScale);
    contentSize.height = (self.contentSize.height / self.zoomScale);
    
    //translate the zoom point to relative to the content rect
    zoomPoint.x = (zoomPoint.x / self.bounds.size.width) * contentSize.width;
    zoomPoint.y = (zoomPoint.y / self.bounds.size.height) * contentSize.height;
    
    //derive the size of the region to zoom to
    CGSize zoomSize;
    zoomSize.width = self.bounds.size.width / scale;
    zoomSize.height = self.bounds.size.height / scale;
    
    //offset the zoom rect so the actual zoom point is in the middle of the rectangle
    CGRect zoomRect;
    zoomRect.origin.x = zoomPoint.x - zoomSize.width / 2.0f;
    zoomRect.origin.y = zoomPoint.y - zoomSize.height / 2.0f;
    zoomRect.size.width = zoomSize.width;
    zoomRect.size.height = zoomSize.height;
    
    //apply the resize
    [self zoomToRect: zoomRect animated: animated];
}


-(void)setImageCount{
    
}
- (void)setIndex:(NSUInteger)index
{
    
    //For Downloading Images Asynchronously
//    [HttpRequestProcessor shareHttpRequest];
    _index = index;
 
    NSInteger indexForNextImages =index;
    
    
    if (index<[[AppManager sharedManager].arrImages count]) {
        [Utils startActivityIndicatorInView:self withMessage:@""];
        //    if ([[[AppManager sharedManager].arrImages objectAtIndex:index] valueForKey:@"imgToUpload"]) {
        
        
        
//        if([AppManager sharedManager].isFromChat)
//        {
            [self displayImage:[[[AppManager sharedManager].arrImages objectAtIndex:index] valueForKey:@"originalUrl"]];
//        }
//        else
//        {
//            _strUrlll=[[[AppManager sharedManager].arrImages objectAtIndex:index] valueForKey:@"originalCompressImage"];
//            [self displayImage:[[[AppManager sharedManager].arrImages objectAtIndex:index] valueForKey:@"originalCompressImage"]];
//        }
    }else{
        
        
        
        
          [Utils startActivityIndicatorInView:self withMessage:@""];
        _zoomView =[[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_zoomView];
    }

   
}


-(void)CallDisplayImageMethodWithIndex{
    
//    [self displayImage:[[[AppManager sharedManager].arrImages objectAtIndex:_index] valueForKey:@"originalCompressImage"]];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CallDisplayImageMethod" object:nil];
}


- (void)layoutSubviews
{
    
//    NSLog(@"zoom scale %f  minimum zoom scale %f",self.zoomScale, self.minimumZoomScale);
//    if (self.zoomScale > self.minimumZoomScale) return;
    
    [super layoutSubviews];
    
    // center the zoom view as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _zoomView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    _zoomView.frame = frameToCenter;
    
}

- (void)setFrame:(CGRect)frame
{
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    
    if (sizeChanging) {
        [self prepareToResize];
    }
    
    [super setFrame:frame];
    
    
    if (sizeChanging) {
        [self recoverFromResizing];
    }
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self layoutSubviews];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomView;
}


#pragma mark - Configure scrollView to display new image (tiled or not)

#if TILE_IMAGES

- (void)displayTiledImageNamed:(NSString *)imageName size:(CGSize)imageSize
{
    // clear views for the previous image
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    // make views to display the new image
    _zoomView = [[UIImageView alloc] initWithFrame:(CGRect){ CGPointZero, imageSize }];
    [_zoomView setImage:_PlaceholderImageNamed(imageName)];
    [self addSubview:_zoomView];
    
    
    [self configureForImageSize:imageSize];
}

#else

- (void)displayImage:(NSString *)strUrl
{
    // clear the previous image
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    

     UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
//    if(![AppManager sharedManager].isFromChat)
//    {
    
//        [imgView setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"photoIcon"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
//                             //                       NSLog(@"width %f height %f", image.size.width, image.size.height);
//                             
//                             
//                             _zoomView =[[UIImageView alloc] initWithImage:image];
//                             [_zoomView setFrame:(CGRect){ CGPointZero, CGSizeMake(image.size.width, image.size.height) }];
//                             [self addSubview:_zoomView];
//                             [self configureForImageSize:image.size];
//                             [Utils stopActivityIndicatorInView:self];
//                         }];
//        
 
//    }
//    else
//    {
//        NSData *imageData = [SHFileUtil readFileFromCache: strUrl];
//        UIImage *image = [UIImage imageWithData: imageData];
//
//        _zoomView =[[UIImageView alloc] initWithImage:image];
//        [_zoomView setFrame:(CGRect){ CGPointZero, CGSizeMake(image.size.width, image.size.height) }];
//        [self addSubview:_zoomView];
//        [self configureForImageSize:image.size];
//
//    }
    
    NSData *imageData = [SHFileUtil readFileFromCache: strUrl];
    UIImage *image = [UIImage imageWithData: imageData];
    
    _zoomView =[[UIImageView alloc] initWithImage:image];
    [_zoomView setFrame:(CGRect){ CGPointZero, CGSizeMake(image.size.width, image.size.height) }];
    [self addSubview:_zoomView];
    [self configureForImageSize:image.size];

    [self addSubview:imgView];
    
    [imgView setHidden:YES];
    imgView=nil;
}
-(void)updateImageFromPhotoViewer:(NSString*)strUrl{
   
    
    
    // clear the previous image
    [_zoomView removeFromSuperview];
    _zoomView = nil;
     _zoomView =[[UIImageView alloc] init];
     __weak typeof(UIImageView) *weakimgView = _zoomView;
      __weak typeof(self) weakSelf = self;
       [self addSubview:_zoomView];
    [_zoomView setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"photoIcon"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
        //                       NSLog(@"width %f height %f", image.size.width, image.size.height);
        
        
        
        [weakimgView setFrame:(CGRect){ CGPointZero, CGSizeMake(image.size.width, image.size.height) }];
     
        [weakSelf configureForImageSize:image.size];
        [Utils stopActivityIndicatorInView:weakSelf];
    }];

}
#endif // TILE_IMAGES

- (void)configureForImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    self.contentSize = imageSize;
    [self setMaxMinZoomScalesForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
    
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width  / _imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / _imageSize.height;   // the scale needed to perfectly fit the image height-wise
    
    // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
    BOOL imagePortrait = _imageSize.height > _imageSize.width;
    BOOL phonePortrait = boundsSize.height > boundsSize.width;
    CGFloat minScale = imagePortrait == phonePortrait ? xScale : MIN(xScale, yScale);
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    //    if (minScale > maxScale) {
    //        minScale = maxScale;
    //    }
    
    self.maximumZoomScale = maxScale+1;
    self.minimumZoomScale = minScale;
    
    
}

#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image

#pragma mark - Rotation support

- (void)prepareToResize
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:_zoomView];
    
    _scaleToRestoreAfterResize = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing
{
    [self setMaxMinZoomScalesForCurrentBounds];
    
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:_zoomView];
    
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}


#pragma mark - Activity Indicator and Lazy Loading
#pragma mark
#pragma mark fetch images
-(void)doFetchEditionImage:(NSString *)inImageId withIndex:(NSInteger)index andAssetId:(NSUInteger)assetId
{
//    SHRequestSampleImage *aRequest = [[SHRequestSampleImage alloc] initWithURL: nil] ;
//    [aRequest setImageId:inImageId];
//    [aRequest SetResponseHandler:@selector(handledImage:) ];
//    [aRequest SetErrorHandler:@selector(errorHandler:)];
//    [aRequest SetResponseHandlerObj:self];
//    [aRequest SetRequestType:eRequestType1];
//    aRequest.index = index;
//    aRequest.assetId=assetId;
//    [gHttpRequestProcessor ProcessImage: aRequest];
    
}

-(void)errorHandler:(SHBaseRequestImage *)inRequest
{
    //  NSLog(@"*** errorHandler ***");
    
}
-(void)handledImage:(SHBaseRequestImage *)inRequest
{
    [Utils stopActivityIndicatorInView:self];
    
    //[self.activityIndicator stopAnimating];
    NSData *aImageData =  [inRequest GetResponseData];
    SHRequestSampleImage * aCurrReq = (SHRequestSampleImage *)inRequest;
    
    
    if (aImageData)
    {
        if ([UIImage imageWithData:aImageData]) {
            UIImage *thumbNail=[UIImage imageWithData:aImageData];
            NSString *cellIndex=[NSString stringWithFormat:@"%d",aCurrReq.assetId];
            
            NSInteger filteredIndexes = [[AppManager sharedManager].arrImages indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
                NSString *ID =[NSString stringWithFormat:@"%@",[obj valueForKey:@"assetsId"]];
                return [ID isEqualToString:cellIndex];
            }];
            if (filteredIndexes != NSNotFound) {
                NewPhoto *photo=(NewPhoto*)[[AppManager sharedManager].arrImages objectAtIndex: filteredIndexes];
//                [adict setObject:thumbNail forKey:@"imgToUpload"];
                photo.imgToUpload=thumbNail;
                
                if (_index==inRequest.index) {
                    [self displayImage:thumbNail];
                }
            }
        }
        //    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}


@end

#pragma mark - End Of Class
#pragma mark Static Methods
static NSArray *_ImageData(void)
{
    static NSArray *data = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        NSString *path = [[NSBundle mainBundle] pathForResource:@"ImageData" ofType:@"plist"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"imageData.plist"];
        NSData *plistData = [NSData dataWithContentsOfFile:path];
        NSString *error; NSPropertyListFormat format;
        data = [NSPropertyListSerialization propertyListFromData:plistData
                                                mutabilityOption:NSPropertyListImmutable
                                                          format:&format
                                                errorDescription:&error];
        if (!data) {
            NSLog(@"Unable to read image data: %@", error);
        }
    });
    
    return data;
}

static NSUInteger _ImageCount(void)
{
    static NSUInteger count = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        count = [_ImageData() count];
        NSLog(@"count %d",count);
    });
    return count;
}

static NSString *_ImageNameAtIndex(NSUInteger index)
{
    NSDictionary *info = [_ImageData() objectAtIndex:index];
    return [info valueForKey:@"imageName"];
}

#if !TILE_IMAGES
// we use "imageWithContentsOfFile:" instead of "imageNamed:" here to avoid caching....

static UIImage *_ImageAtIndex(NSUInteger index)
{
    NSString *imageName = _ImageNameAtIndex(index);
    NSLog(@"Image Name :: %@",imageName);
    NSString *path = [[NSBundle mainBundle] pathForResource:[[imageName componentsSeparatedByString:@"."] objectAtIndex:0] ofType:[[imageName componentsSeparatedByString:@"."] objectAtIndex:1]];
    return [UIImage imageWithContentsOfFile:path];
}

#endif
#if TILE_IMAGES

static CGSize _ImageSizeAtIndex(NSUInteger index)
{
    NSDictionary *info = [_ImageData() objectAtIndex:index];
    return CGSizeMake([[info valueForKey:@"width"] floatValue],
                      [[info valueForKey:@"height"] floatValue]);
}

static UIImage *_PlaceholderImageNamed(NSString *name)
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@", name]];
}
#endif



