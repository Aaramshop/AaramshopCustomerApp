//
//  UIImage+Extension.h
//  DailyReports
//
//  Created by JTMD Innovations GmbH on 6/6/14.
//  Copyright (c) 2013 Till. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMaxSizeOriginalImage 960

@interface UIImage (Extension)
+(UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+(UIImage *)scaleDownImage:(UIImage *)image toSize:(CGSize)newSize;
+(UIImage *)scaleDownOriginalImage:(UIImage *)image;
+(UIImage*)cropImage:(UIImage *)image withSize:(CGFloat)Size;
//+(UIImage*)cropImage:(UIImage *)image;
+(UIImage *)scaleDownOriginalImage:(UIImage *)image ProportionateTo:(int)MaxHeight;
+(UIImage*)cropImageInSquare:(UIImage *)image;

@end
