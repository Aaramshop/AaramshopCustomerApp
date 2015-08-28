
#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

#import "CDRTranslucentSideBar.h"
@interface ImageOnNavigationBar : UINavigationBar
{
	
}

@end


@interface Utils : NSObject 
{

}
+ (NSString*) StringdateFromString:(NSString*)aStr;
+ (NSDate*) dateFromString2:(NSString*)aStr;
+ (void) showAlertView :(NSString*)title message:(NSString*)msg delegate:(id)delegate cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;
+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate 
			cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;

+ (UIButton *)newButtonWithTarget:(id)target
						 selector:(SEL)selector
							frame:(CGRect)frame
							image:(UIImage *)image
					selectedImage:(UIImage *)selectedImage
							  tag:(NSInteger)aTag;
+(UITextField*) createTextFieldWithTag:(NSInteger)aTag startX:(CGFloat)aX startY:(CGFloat)aY width:(CGFloat)aW height:(CGFloat)aH placeHolder:(NSString*)aPl keyBoard:(BOOL)isNumber;
+ (UIImage *)scaleImage:(UIImage *)image maxWidth:(int) maxWidth maxHeight:(int) maxHeight;
+ (NSString*) stringFromImage:(UIImage*)image;
+ (UIImage*) imageFromString:(NSString*)imageString;
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image ;
+ (UIImage *)resizeImage:(UIImage *)image width:(int)width height:(int)height;
+ (void) addLabelOnNavigationBarWithTitle:(NSString*)aTitle OnNavigation:(UINavigationController*)naviController;


+(void) startActivityIndicatorInView:(UIView*)aView withMessage:(NSString*)aMessage;
+(void) stopActivityIndicatorInView:(UIView*)aView;
+ (NSString *)stringFromDateToEmail:(NSDate *)date;
+ (NSString*) stringFromDate:(NSDate*)date;
+ (NSDate*) dateFromString:(NSString*)aStr;
+ (NSString *)stringFromDateGmt9;
+ (NSString*) stringFromDateFor24Time:(NSDate*)date;
+ (NSString*) stringFromDateForTime:(NSDate*)date;
+ (NSString*) stringFromDateForTimeWithAt:(NSDate*)date;
+ (NSString*) returnStringFromDate:(NSDate*)date;
+ (NSString*) stringFromDateForExactTime:(NSDate*)date;
+ (NSDate*) dateFromStringforfolder:(NSString*)aStr;
+ (NSDate *)DateFromStringDatabase:(NSString *)strdate;
+ (NSDate*) dateWithDateComponents:(NSDateComponents*)components;
+(NSString *)timefromstring:(NSString *)string;
+(BOOL)isInternetAvailable;
+(float)timeInterval;
+(BOOL)isIPhone5;

+(NSString*)getThumbNailImagePathByItsImagePath:(NSString *)inItsImagePath;
+ (NSData*)encodeDictionary:(NSDictionary*)dictionary;
+ (UIImage *)rotateImageToItsOrignalOrientation:(UIImage *)image;
//nehaa 25-03-2014
+(BOOL)isNetworkAvailable;
//end
+(NSString *)convertToJSON:(id)requestParameters;
+(NSTextAlignment)alignmentForString:(NSString *)astring;
+ (int)iOSVersion;
+(BOOL)isArebic;// amar 15-3-14
//18-3-14
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
+(NSString*)getVideoThumbNailImagePathByItsImagePath:(NSString *)inItsImagePath;
+(NSString*)getThumbnailURL:(NSString *)inFullUrl;
+(NSString*)getMediaURL:(NSString *)inFullUrl;
+(NSString*)getSimpleStringFromURL:(id)inFullUrl;
+(NSString*)getDownloadedThumbnailCachePath:(NSString *)inUrl;

+(NSArray*)getArrayOfDateTime:(NSString*)dateString;

//end
+ (NSString *)convertedDate:(NSDate*)date;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;
+ (NSString *)setTextWithNonLossy:(NSString *)text;
#pragma mark - play sound method
+(void) playSound:(NSString *)tone;

+(NSString *)getLastTimeStampOfGroupForRoomName:(NSString *)roomJid;
+ (NSString *)StringWithDateFormat:(NSString *)dateFormat withDate:(NSDate *)date;

#pragma mark - afnetworking methods
+(AFHTTPSessionManager *)InitSetUpForWebService;
#pragma mark - Check Request Timeout---

+(BOOL)isRequestTimeOut:(NSError *)error;

#pragma mark - Predefined values for webservice
+(NSString *)getUserDefaultValue:(NSString *)key;
+(NSMutableDictionary *)setPredefindValueForWebservice;
+(CGSize)getLabelSizeByText:(NSString * )text font:(UIFont *)inFont andConstraintWith:(float)inWidth;
+ (float)getTimeZone;

#pragma mark SideBar
+(CDRTranslucentSideBar*)createLeftBarWithDelegate:(id)delegate;
+(CDRTranslucentSideBar*)createRightBarWithDelegate:(id)delegate;
+ (NSString *)getFinalStringFromDate:(NSDate *)date;

#pragma mark - Calculate distance from two coordinates
+(NSString *)milesFromLatitude:(double)fromLatitude fromLongitude:(double)fromLongitude ToLatitude:(double)toLatitude andToLongitude:(double)toLongitude;
#pragma mark - AFNetworking task cancel
+(BOOL)isRequestCancelled:(NSError *)error;
@end




