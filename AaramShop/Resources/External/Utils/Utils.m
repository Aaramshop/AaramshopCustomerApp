
#import "Utils.h"
#import "GSNSDataExtensions.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#include<unistd.h>//Osscube.yaab.bug347_amar
#include<netdb.h>//Osscube.yaab.bug347_amar

#import <AVFoundation/AVFoundation.h>
#import "AFHTTPSessionManager.h"
#define MOVE_ANIMATION_DURATION_SECONDS_FOR_C1 .5


@implementation ImageOnNavigationBar

- (void) drawRect:(CGRect)rect
{
	UIImage *tabImage=[UIImage imageNamed:@"navBar.png"];
	[tabImage drawAtPoint:CGPointMake(0, 0)];
}
@end


@implementation Utils


#pragma mark -
////----- show a alert massage
+ (void) showAlertView :(NSString*)title message:(NSString*)msg delegate:(id)delegate 
													cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertTitle message:msg delegate:delegate
										  cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
	[alert show];
	[alert release];
}

+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate 
      cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertTitle message:msg delegate:delegate 
										  cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
    alert.tag = tag;
	[alert show];
	[alert release];
}


#pragma mark UIButton

+ (UIButton *)newButtonWithTarget:(id)target  selector:(SEL)selector frame:(CGRect)frame
							image:(UIImage *)image
					selectedImage:(UIImage *)selectedImage
							  tag:(NSInteger)aTag
{	
	//UIButton *button = [[UIButton alloc] initWithFrame:frame];
	// or you can do this:
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = frame;
	[button setImage:image forState:UIControlStateNormal];
	[button setImage:selectedImage forState:UIControlStateSelected];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	button.showsTouchWhenHighlighted = YES;
	button.tag = aTag;
	return button;
}

#pragma mark textField
+(UITextField*) createTextFieldWithTag:(NSInteger)aTag startX:(CGFloat)aX startY:(CGFloat)aY width:(CGFloat)aW height:(CGFloat)aH placeHolder:(NSString*)aPl keyBoard:(BOOL)isNumber
{
	UITextField *aTextField=[[UITextField alloc] init];
	aTextField.frame = CGRectMake(aX,aY ,aW ,aH);
	aTextField.tag = aTag;
	aTextField.placeholder = aPl;
	aTextField.backgroundColor=[UIColor clearColor];
	aTextField.textColor = [UIColor brownColor];
	aTextField.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
	aTextField.borderStyle = UITextBorderStyleNone ;
	if (isNumber)
		aTextField.keyboardType = UIKeyboardTypeNumberPad;
	else
	  aTextField.keyboardType = UIKeyboardTypeDefault;
	aTextField.returnKeyType = UIReturnKeyDone;
	aTextField.contentVerticalAlignment = YES;
	//aTextField.text = aPl;
	aTextField.textAlignment = NSTextAlignmentLeft;
	return [aTextField autorelease];
}

#pragma mark label


#pragma mark - Image Resize 
+ (UIImage *)resizeImage:(UIImage *)image width:(int)width height:(int)height {
	
	CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	//if (alphaInfo == kCGImageAlphaNone)
    alphaInfo = kCGImageAlphaNoneSkipLast;
	
	CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;	
}
+ (UIImage *)scaleImage:(UIImage *)image maxWidth:(int) maxWidth maxHeight:(int) maxHeight
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
	
    if (width <= maxWidth && height <= maxHeight)
	{
		return image;
	}
	
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
	
    if (width > maxWidth || height > maxHeight)
	{
		CGFloat ratio = width/height;
		
		if (ratio > 1)
		{
			bounds.size.width = maxWidth;
			bounds.size.height = bounds.size.width / ratio;
		}
		else
		{
			bounds.size.height = maxHeight;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
    CGFloat scaleRatio = bounds.size.width / width;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return imageCopy;
	
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma mark Image Conversion
+ (NSString*) stringFromImage:(UIImage*)image
{
	
	NSData* imageData = UIImagePNGRepresentation(image);
	
	//NSData *imageData = UIImageJPEGRepresentation(image, 1);
	
	NSString* str = [imageData base64EncodingWithLineLength:80];
	return str;
	
}

+ (UIImage*) imageFromString:(NSString*)imageString
{
	NSData* imageData = [NSData dataWithBase64EncodedString:imageString];
	return [UIImage imageWithData: imageData];
}

#pragma mark - Use it when pickup an image from imagepicker
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image 
{
	//int kMaxResolution = 320; 
	
	CGImageRef imgRef = image.CGImage; 
	
	CGFloat width = CGImageGetWidth(imgRef); 
	CGFloat height = CGImageGetHeight(imgRef); 
	
	CGAffineTransform transform = CGAffineTransformIdentity; 
	CGRect bounds = CGRectMake(0, 0, width, height); 
	/*if (width > kMaxResolution || height > kMaxResolution) 
	 { 
	 CGFloat ratio = width/height; 
	 if (ratio > 1)
	 { 
	 bounds.size.width = kMaxResolution; 
	 bounds.size.height = bounds.size.width / ratio; 
	 } 
	 else
	 { 
	 bounds.size.height = kMaxResolution; 
	 bounds.size.width = bounds.size.height * ratio; 
	 } 
	 } */
	
	CGFloat scaleRatio = bounds.size.width / width; 
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));  
	CGFloat boundHeight;                       
	UIImageOrientation orient = image.imageOrientation;                         
	switch(orient)
	{ 
		case UIImageOrientationUp: //EXIF = 1 
			transform = CGAffineTransformIdentity; 
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2  
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0); 
			transform = CGAffineTransformScale(transform, -1.0, 1.0); 
			break; 
			
		case UIImageOrientationDown: //EXIF = 3 
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height); 
			transform = CGAffineTransformRotate(transform, M_PI); 
			break; 
			
		case UIImageOrientationDownMirrored: //EXIF = 4 
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height); 
			transform = CGAffineTransformScale(transform, 1.0, -1.0); 
			break; 
			
		case UIImageOrientationLeftMirrored: //EXIF = 5 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width); 
			transform = CGAffineTransformScale(transform, -1.0, 1.0); 
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0); 
			break; 
			
		case UIImageOrientationLeft: //EXIF = 6 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width); 
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0); 
			break; 
			
		case UIImageOrientationRightMirrored: //EXIF = 7 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeScale(-1.0, 1.0); 
			transform = CGAffineTransformRotate(transform, M_PI / 2.0); 
			break; 
			
		case UIImageOrientationRight: //EXIF = 8 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0); 
			transform = CGAffineTransformRotate(transform, M_PI / 2.0); 
			break; 
		default: 
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"]; 
			break;
	} 
	
	UIGraphicsBeginImageContext(bounds.size); 
	
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
	{ 
		CGContextScaleCTM(context, -scaleRatio, scaleRatio); 
		CGContextTranslateCTM(context, -height, 0); 
	} 
	else
	{ 
		CGContextScaleCTM(context, scaleRatio, -scaleRatio); 
		CGContextTranslateCTM(context, 0, -height); 
	} 
	
	CGContextConcatCTM(context, transform); 
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef); 
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext(); 
	UIGraphicsEndImageContext(); 
	
	return imageCopy;
	
}

+ (void) addLabelOnNavigationBarWithTitle:(NSString*)aTitle OnNavigation:(UINavigationController*)naviController
{
    // Add Title on NavigationBar

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 44)];
    titleLabel.tag = 1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:(20.0)];
    naviController.navigationBar.topItem.titleView = titleLabel;
}



#pragma mark - Activity Indicator
+(void) startActivityIndicatorInView:(UIView*)aView withMessage:(NSString*)aMessage
{
    MBProgressHUD *_hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    _hud.dimBackground  = YES;
    _hud.labelText      = aMessage;
}

+(void) stopActivityIndicatorInView:(UIView*)aView
{
    [MBProgressHUD hideHUDForView:aView animated:YES];
}
+ (NSString *)stringFromDateGmt9
{
    NSDate *myDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*9]];
    [dateFormatter setDateFormat:@"dd-MM-YYYY"];
    NSString *GMTDateString = [dateFormatter stringFromDate: myDate];
    [dateFormatter release];
    return GMTDateString;
}
+ (NSString *)stringFromDateToEmail:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM d, yyyy"];
	//[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    //	NSLog(@"%@", date);
   	NSString *strDateTime = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return strDateTime;
}
+ (NSString*) stringFromDate:(NSDate*)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/YYYY"];
	//[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
//	NSLog(@"%@", date);
   	NSString *strDateTime = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return strDateTime;
}
+ (NSString*) stringFromDateForTime:(NSDate*)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"hha"];
	//[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
	
   	NSString *strDateTime = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return strDateTime;
}
+ (NSString*) stringFromDateForExactTime:(NSDate*)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"hh:mm a"];
	//[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
	
   	NSString *strDateTime = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return strDateTime;
}
+ (NSString*) stringFromDateFor24Time:(NSDate*)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH"];
	//[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
	
   	NSString *strDateTime = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return strDateTime;
}
+ (NSDate*) dateFromString2:(NSString*)aStr
{
    //    NSMutableString *dtStr = [[NSMutableString alloc]init];
//	NSArray *array = [aStr componentsSeparatedByString:@" "];
//    aStr = [array objectAtIndex:0];
//    aStr = [aStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
//    NSArray *array2 = [aStr componentsSeparatedByString:@"-"];
//    aStr = [NSString stringWithFormat:@"%@-%@-%@",[array2 objectAtIndex:2],[array2 objectAtIndex:0],[array2 objectAtIndex:1]];
//    aStr = [aStr stringByAppendingString:[NSString stringWithFormat:@" %@ %@",[array objectAtIndex:1],[array objectAtIndex:2]]];
    
    //    [dtStr stringByAppendingString:[NSString stringWithFormat:@" %@ %@",[array objectAtIndex:1],[array objectAtIndex:2]]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [ [NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"] ;
    [dateFormatter setLocale:locale];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLog(@"*%@*", aStr);
    
    NSDate *aDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",aStr]];
	return aDate;
}
+ (NSDate*) dateFromStringforfolder:(NSString*)aStr
{
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"YYYY-MM-dd"];
	//[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
//	NSLog(@"%@", aStr);
    NSDate   *aDate = [dateFormatter dateFromString:aStr];
	[dateFormatter release];
	return aDate;
}
+ (NSDate*) dateFromString:(NSString*)aStr
{
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	//[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
//	NSLog(@"%@", aStr);
    NSDate   *aDate = [dateFormatter dateFromString:aStr];
	[dateFormatter release];
	return aDate;
}
+ (NSString*) StringdateFromString:(NSString*)aStr
{
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate   *aDate = [dateFormatter dateFromString:aStr];

    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //	[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	//[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    //	NSLog(@"%@", aStr);
    aStr = [dateFormatter stringFromDate:aDate];
	[dateFormatter release];
	return aStr;
}
+ (NSString*) returnStringFromDate:(NSDate*)date
{
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	//[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
//	NSLog(@"%@", date);
   	NSString *strDateTime = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return strDateTime;
}

#pragma mark- Network reachabiliyt
+(BOOL)isInternetAvailable
{
    BOOL isInternetAvailable = false;
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
            isInternetAvailable = FALSE;
            break;
        case ReachableViaWWAN:
            isInternetAvailable = TRUE;
            break;
        case ReachableViaWiFi:
            isInternetAvailable = TRUE;
            break;
    }
    [internetReach  stopNotifier];
    return isInternetAvailable;
}
+ (NSDate *)DateFromStringDatabase:(NSString *)strdate
{
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc]init];
    [newFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [newFormatter dateFromString:strdate];
    [newFormatter release];
    newFormatter = nil;
    return date;
}
+ (NSDate*) dateWithDateComponents:(NSDateComponents*)components{
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	gregorian.timeZone = components.timeZone;
	return [gregorian dateFromComponents:components];
}

+(float)timeInterval
{
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval1 = destinationGMTOffset - sourceGMTOffset;
    return (interval1/3600);
    
}
+(BOOL)isIPhone5{
    if ([[UIScreen mainScreen]bounds].size.height>480) {
        return YES;
    }else
        return NO;
}
+(NSString *)convertToJSON:(id)requestParameters
{
    NSData *jsonData   = [NSJSONSerialization dataWithJSONObject:requestParameters options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString    = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    jsonString =[jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    //    NSLog(@"%@",jsonString);
    return jsonString;
    
}
+(NSString *)timefromstring:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@":"];
    NSString *hour = [array objectAtIndex:0];
    NSString *second = [array objectAtIndex:1];
    BOOL isPM = NO;
    if([hour intValue]>12)
    {
        int h = ([hour intValue]-10)-2;
        hour = [NSString stringWithFormat:@"%d",h];
        isPM=YES;
    }
    if([hour intValue]==12 && [second intValue]>0)
    {
        hour = @"12";
        isPM=YES;
    }
    if(isPM==YES)
    {
        string = [NSString stringWithFormat:@"%@:%@ PM",hour,[array objectAtIndex:1]];
    }
    else
    {
        string = [NSString stringWithFormat:@"%@:%@ AM",hour,[array objectAtIndex:1]];
    }
    return string;
}

+(NSString*)getThumbNailImagePathByItsImagePath:(NSString *)inItsImagePath
{
    NSString * thumbNailfilePath = nil;
    //seperate directory from its filename.
    NSArray *fileComponet = [inItsImagePath componentsSeparatedByString:@"/"];
    if (fileComponet.count >1)
    {
        NSString *fileName = [fileComponet objectAtIndex: 1];
        
//        NSString * thumbfileName = [NSString stringWithFormat:@"thumbnail%@",fileName];
        
        thumbNailfilePath = [NSString stringWithFormat:@"%@/%@",[fileComponet objectAtIndex: 0],fileName];
    }
    return  thumbNailfilePath;
}

+ (NSData*)encodeDictionary:(NSDictionary*)dictionary
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

+ (UIImage *)rotateImageToItsOrignalOrientation:(UIImage *)image
{
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

//end
//nehaa 25-03-2014
+(BOOL)isNetworkAvailable
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = "google.com";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        return NO;
    }
    else{
        return YES;
    }
}
//end
+(NSTextAlignment)alignmentForString:(NSString *)astring
{
    if (astring.length)
    {
        NSArray *rightLeftLanguages = @[@"ar"];
        NSString *lang = CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage((CFStringRef)astring,CFRangeMake(0,[astring length])));
        
        if ([rightLeftLanguages containsObject:lang]) {
            
            return NSTextAlignmentRight;
            
        }
    }
    else{
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedLanguage"] isEqualToString:@"en"])
        {
            return NSTextAlignmentLeft;
        }
        else{
            return NSTextAlignmentRight;
        }
    }
    
    return NSTextAlignmentLeft;
    
}
//end
+ (int)iOSVersion{
    
    //    static NSUInteger _deviceSystemMajorVersion = -1;
    //
    //    static dispatch_once_t onceToken;
    //
    //    dispatch_once(&onceToken, ^{
    NSUInteger  _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    //});
    
    return (int)_deviceSystemMajorVersion;
    
}
//end
// amar 15-3-14
+(BOOL)isArebic{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedLanguage"] rangeOfString:@"ar"].location!=NSNotFound)return YES;
    return NO;
}

//18-3-14

+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetIG =
    [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *igError = nil;
    thumbnailImageRef =
    [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                    actualTime:NULL
                         error:&igError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", igError );
    
    UIImage *thumbnailImage = thumbnailImageRef
    ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
    : nil;
    
    return thumbnailImage;
}

//18-3-14
+(NSString*)getVideoThumbNailImagePathByItsImagePath:(NSString *)inItsImagePath
{
    NSString * thumbNailfilePath = nil;
    //seperate directory from its filename.
    NSArray *fileComponet = [inItsImagePath componentsSeparatedByString:@"/"];
    if (fileComponet.count >1)
    {
        NSString *fileName = [fileComponet objectAtIndex: 1];
        
        NSString * thumbfileName = [NSString stringWithFormat:@"thumbnail%@.JPG",fileName];
        
        thumbNailfilePath = [NSString stringWithFormat:@"%@/%@",[fileComponet objectAtIndex: 0],thumbfileName];
        return  thumbNailfilePath;
        
    }
    else
    {
        NSString * thumbfileName = [NSString stringWithFormat:@"Chat/thumbnail%@.JPG",inItsImagePath];
        return  thumbfileName;
        
    }
    return  thumbNailfilePath;
}

+(NSString*)getThumbnailURL:(NSString *)inFullUrl
{
    NSString *thumbNailUrl = nil;
    NSArray *aUrls = [inFullUrl componentsSeparatedByString: @"ThumbUrlDelimeter"];
    
    if(aUrls && [aUrls count] > 1)
    {
        thumbNailUrl = [NSString stringWithFormat:@"%@",[aUrls objectAtIndex: 1]];
    }
    return  thumbNailUrl;
}

+(NSString*)getDownloadedThumbnailCachePath:(NSString *)inUrl
{
    NSString *thumbNailUrl = nil;
    NSString *simpleUrlStr = [Utils getSimpleStringFromURL: inUrl];
    thumbNailUrl = [NSString stringWithFormat:@"ThumbNails/%@",simpleUrlStr];
    return  thumbNailUrl;
}

+(NSString*)getMediaURL:(NSString *)inFullUrl
{
    NSString *medialUrl = nil;
    NSArray *aUrls = [inFullUrl componentsSeparatedByString: @"{{thumb}}"];
    
    if(aUrls && [aUrls count] > 0)
    {
        medialUrl = [NSString stringWithFormat:@"%@",[aUrls objectAtIndex: 0]];
    }
    return  medialUrl;
}

+(NSString*)getSimpleStringFromURL:(id)inFullUrl
{
    NSString *str = [NSString stringWithFormat: @"%@",inFullUrl];
    str =[str stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return  str;
}

+(NSArray*)getArrayOfDateTime:(NSString*)dateString
{
    NSDateFormatter *Formatter1=[[NSDateFormatter alloc] init];
    [Formatter1 setDateFormat:@"dd/MM/YYYY hh:mm a"];//@"yyyy-MM-dd hh:mm a"
    NSDateFormatter *formatter2=[[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *dateOfBirth=[Formatter1 dateFromString:dateString];
    if(dateOfBirth==nil){
        dateOfBirth=[formatter2 dateFromString:dateString];
    }

    NSDateFormatter  *formatterTime=[[NSDateFormatter alloc] init];
    [formatterTime setDateFormat:@"hh:mm a"];
    
    NSDateFormatter  *formatterDate=[[NSDateFormatter alloc] init];
    [formatterDate setDateFormat:@"dd/MM/YYYY"];
    
    NSString  *strTime=[formatterTime stringFromDate:dateOfBirth];
    
    NSString  *strDate=[formatterDate stringFromDate:dateOfBirth];
    
    return [NSArray arrayWithObjects:strDate,strTime,nil];
}

//end
+ (NSString *)convertedDate:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterShortStyle;
    df.dateStyle = NSDateFormatterShortStyle;
    df.doesRelativeDateFormatting = YES;  // this enables relative dates like yesterday, today, tomorrow...
    
    return  [df stringFromDate:date];
}

+(void) playSound:(NSString *)tone{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:tone ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
}
+ (NSString *)setTextWithNonLossy:(NSString *)text
{
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    return str;
}
+ (NSString *)StringWithDateFormat:(NSString *)dateFormat withDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString *str = [dateFormatter stringFromDate:date];
    
    return str;
}
#pragma mark - Check Request Timeout---

+(BOOL)isRequestTimeOut:(NSError *)error
{
    BOOL isTimeOut = NO;
    NSString *str = @"NSLocalizedDescription=The request timed out.";
    
    if ([error.description rangeOfString:str].location!=NSNotFound)
    {
        isTimeOut=YES;
    }
    return isTimeOut;
}
#pragma mark - Predefined values for webservice
+(NSString *)getUserDefaultValue:(NSString *)key
{
    id strValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    return strValue;
}
#pragma mark - afnetworking methods

+(AFHTTPSessionManager *)InitSetUpForWebService
{
    NSURL *baseURL = [NSURL URLWithString:kBaseURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
       [manager.requestSerializer setTimeoutInterval:60];
    
    return manager;
}

+(NSMutableDictionary *)setPredefindValueForWebservice
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    //SessionToken
//    NSString *strSessionToken = [NSString stringWithFormat:@"%@",[self getUserDefaultValue:kSessionToken]];
//    [dict setValue:strSessionToken forKey:kSessionToken];
    
    //UserId
    
    NSString *strUserId = [NSString stringWithFormat:@"%@",[self getUserDefaultValue:kUserId]];
    [dict setValue:strUserId forKey:kUserId];
    
    NSLog(@"My user Id ==>> %@",strUserId);     // added by chetan
    
    //Device Id and Device Token..
    [dict setObject:kDevice forKey:kDeviceType];
    [dict setObject:[self getUserDefaultValue:kDeviceId] forKey:kDeviceId];
    
    return dict;
}

 
+(CGSize)getLabelSizeByText:(NSString * )text font:(UIFont *)inFont andConstraintWith:(float)inWidth
{
    UILabel *aLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, inWidth, 0)];
    [aLbl setFont: inFont];
    
    aLbl.text = text;
    aLbl.numberOfLines = 0;
    [aLbl sizeToFit];
    
    return aLbl.frame.size;
}

+ (float)getTimeZone
{
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
//    NSLocale *locale = [NSLocale currentLocale];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    float timeInterval = interval;
    return timeInterval;
}
#pragma mark SideBar
+ (CDRTranslucentSideBar *)createLeftBarWithDelegate:(id)delegate
{
    // Create SideBar and Set Properties
    CDRTranslucentSideBar *sideBar = [[CDRTranslucentSideBar alloc] init];
    sideBar.sideBarWidth = 260;
    sideBar.translucentStyle=UIBarStyleDefault;
    sideBar.delegate = delegate;
    sideBar.tag = 0;
    return sideBar;
}
+ (CDRTranslucentSideBar *)createRightBarWithDelegate:(id)deleagte
{
    CDRTranslucentSideBar *rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirectionFromRight:YES];
    rightSideBar.delegate = deleagte;
    rightSideBar.sideBarWidth = 320;
    rightSideBar.translucentStyle = UIBarStyleDefault;
    rightSideBar.tag = 1;
    return rightSideBar;
}

+ (NSString *)getFinalStringFromDate:(NSDate *)date
{
    NSString *strTime = [Utils convertedDate:date];
    
    if ([strTime hasPrefix:@"Today,"])
    {
        strTime = [strTime substringFromIndex:6];
    }
    
    return strTime;
}
@end
