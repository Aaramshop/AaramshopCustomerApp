//
//  UIImage+Extension.m
//  DailyReports
//
//  Created by JTMD Innovations GmbH on 6/6/14.
//  Copyright (c) 2013 Till. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)scaleDownImage:(UIImage *)image toSize:(CGSize)newSize{
    
    CGSize newImageSize = CGSizeMake(0, 0);
    if (image.size.width > newSize.width && image.size.width >= image.size.height)
    {
        CGFloat widthDifference = image.size.width - newSize.width;
        CGFloat ratio = 1 - (widthDifference/image.size.width);
        CGFloat newWidth = ratio * image.size.width;
        CGFloat newHeight = ratio * image.size.height;
        
        
        newImageSize.width = newWidth;
        newImageSize.height  = newHeight;
        
    }
    else if (image.size.height > newSize.height && image.size.width <= image.size.height) {
        
        CGFloat heightDifference = image.size.height - newSize.height;
        CGFloat ratio = 1 - (heightDifference/image.size.height);
        CGFloat newWidth = ratio * image.size.width;
        CGFloat newHeight = ratio * image.size.height;
        
        
        newImageSize.width = newWidth;
        newImageSize.height  = newHeight;
        
    }else{
        return image;
    }
    
//    if (newImageSize.width < newSize.width || newImageSize.height < newSize.height) {
//        return image;
//    }
    
    return [UIImage imageWithImage:image scaledToSize:newImageSize];
}


+(UIImage *)scaleDownOriginalImage:(UIImage *)image{
    
    CGSize newImageSize = CGSizeMake(0, 0);
    
    int maxSize = kMaxSizeOriginalImage;
    
    if (image.size.width > maxSize && image.size.width >= image.size.height) {
        CGFloat widthDifference = image.size.width - maxSize;
        CGFloat ratio = 1 - (widthDifference/image.size.width);
        CGFloat newWidth = ratio * image.size.width;
        CGFloat newHeight = ratio * image.size.height;
        
        newImageSize.width = newWidth;
        newImageSize.height  = newHeight;
        
    }
    else if (image.size.height > maxSize && image.size.width <= image.size.height) {
        CGFloat heightDifference = image.size.height - maxSize;
        CGFloat ratio = 1 - (heightDifference/image.size.height);
        CGFloat newWidth = ratio * image.size.width;
        CGFloat newHeight = ratio * image.size.height;
        
        newImageSize.width = newWidth;
        newImageSize.height  = newHeight;
        
    }
    else
    {
        return image;
    }
    return [UIImage imageWithImage:image scaledToSize:newImageSize];
}

+(UIImage *)scaleDownOriginalImage:(UIImage *)image ProportionateTo:(int)MaxHeight{
    
    CGSize newImageSize = CGSizeMake(0, 0);
    
    int maxSize = MaxHeight;
    
    if(image.size.width==image.size.height)
    {
        if(image.size.width>maxSize)
        {
            newImageSize.width = maxSize;
            newImageSize.height = maxSize;
        }
        else
        {
            return image;
        }
    }
    else if(image.size.width>image.size.height)
    {
        if(image.size.width>maxSize)
        {
            CGFloat widthDifference = image.size.width - maxSize;
            CGFloat ratio = 1 - (widthDifference/image.size.width);
            CGFloat newWidth = ratio * image.size.width;
            CGFloat newHeight = ratio * image.size.height;
            newImageSize.width = newWidth;
            newImageSize.height  = newHeight;
        }
        else
        {
            return image;
        }
    }
    else
    {
        if(image.size.height>maxSize)
        {
            CGFloat heightDifference = image.size.height - maxSize;
            CGFloat ratio = 1 - (heightDifference/image.size.height);
            CGFloat newWidth = ratio * image.size.width;
            CGFloat newHeight = ratio * image.size.height;
            newImageSize.width = newWidth;
            newImageSize.height  = newHeight;

        }
        else
        {
            return image;
        }
    }
     return [UIImage imageWithImage:image scaledToSize:newImageSize];
    
//    if (image.size.width > maxSize && image.size.width >= image.size.height) {
//        CGFloat widthDifference = image.size.width - maxSize;
//        CGFloat ratio = 1 - (widthDifference/image.size.width);
//        CGFloat newWidth = ratio * image.size.width;
//        CGFloat newHeight = ratio * image.size.height;
//        
//        newImageSize.width = newWidth;
//        newImageSize.height  = newHeight;
//        
//    }
//    else if (image.size.height > maxSize && image.size.width <= image.size.height) {
//        CGFloat heightDifference = image.size.height - maxSize;
//        CGFloat ratio = 1 - (heightDifference/image.size.height);
//        CGFloat newWidth = ratio * image.size.width;
//        CGFloat newHeight = ratio * image.size.height;
//        
//        newImageSize.width = newWidth;
//        newImageSize.height  = newHeight;
//        
//    }
//    else
//    {
//        return image;
//    }
  //  return [UIImage imageWithImage:image scaledToSize:newImageSize];
}

+(UIImage*)cropImageInSquare:(UIImage *)image
{
//    NSLog(@"%f %f",image.size.height,image.size.width);
    float x;
    float y;
    float size;
    if (!(image.size.height==70 && image.size.width ==70))
    {
//        image = [UIImage scaleDownImage:image toSize:CGSizeMake(200,200)];
        
        if(image.size.width>=image.size.height)
        {
//            NSLog(@"Landscape");
            x =  (image.size.width-image.size.height)/2;
            y = 0;
            size = image.size.height;
        }
        else {
//            NSLog(@"Potrait");
            x = 0;
            y = (image.size.height-image.size.width)/2;
            size = image.size.width;
        }
        
        CGRect new = CGRectMake(x, y, size, size);
        //Croping image depending upon the cropview selected i.e. Square, landscape or portrait
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], new);
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
        
        if (imageRef) {
             CFRelease(imageRef);
        }
       
        
        return croppedImage;
    }
    return nil;
}

+(UIImage*)cropImage:(UIImage *)image withSize:(CGFloat)Size
{
    NSLog(@"H :%f",image.size.height);
    NSLog(@"W :%f",image.size.width);

    float x;
    float y;
//    float size;
    if (image.size.height>=Size || image.size.width >=Size)
    {
        if(image.size.width>=image.size.height)
        {
            NSLog(@"Landscape");
            x =  (image.size.width-Size)/2;
            NSLog(@"X :%f",x);

            y = 0;
//            size = image.size.height;
        }
        else {
            NSLog(@"Potrait");
            x = 0;
            y = (image.size.height-Size)/2;
            NSLog(@"Y :%f",y);

//            size = image.size.width;
        }
        
        CGRect new = CGRectMake(x, y, Size, Size);
        //Croping image depending upon the cropview selected i.e. Square, landscape or portrait
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], new);
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
        
        
        if (imageRef) {
            CFRelease(imageRef);
        }
        
        return croppedImage;
    }
    return image;
}
@end
