//
//  NSString+Date.m
//  JabberClient
//
//  Created by cesarerocchi on 9/12/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import "NSString+Utils.h"


@implementation NSString (Utils)

+ (NSString *) getCurrentTime:(NSDate *)date {
    
    NSString *strTime;
    
    NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
    [date_formater setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    
    NSDate*todate1=[NSDate date];
    NSString *str=[date_formater stringFromDate:todate1];
    todate1=[date_formater dateFromString:str];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:date
                                                  toDate:todate1 options:0];
    //        NSInteger months = [components month];
    NSInteger days = [components day];
    
    NSString *time = nil;
    if (days <= 0 )
    {
        NSDate *nowUTC = date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        time = [dateFormatter stringFromDate:nowUTC];
        if([time rangeOfString:@","].length>0)
        {
            strTime = [NSString stringWithFormat:@"%@",[[time componentsSeparatedByString:@","] objectAtIndex:2]];
            
        }
        else
        {
            NSArray *array = [time componentsSeparatedByString:@" "];
            //            return [NSString stringWithFormat:@"%@ %@",[array objectAtIndex:1],[array objectAtIndex:2]];
            if (array.count > 1)
            {
                strTime = [NSString stringWithFormat:@"%@ %@",[array objectAtIndex:0],[array objectAtIndex:1]];
                
            }
        }
    }
    else
    {
        if(days == 1)
        {
            NSDate *nowUTC = date;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
            time = [dateFormatter stringFromDate:nowUTC];
            if([time rangeOfString:@","].length>0)
            {
                strTime = [NSString stringWithFormat:@"Yesterday, %@",[[time componentsSeparatedByString:@","] objectAtIndex:2]];
            }
            else
            {
                NSArray *array = [time componentsSeparatedByString:@" "];
                //                return [NSString stringWithFormat:@"Yesterday, %@ %@",[array objectAtIndex:1],[array objectAtIndex:2]];
                if (array.count > 1)
                {
                    strTime = [NSString stringWithFormat:@"%@ %@",[array objectAtIndex:0],[array objectAtIndex:1]];
                    
                }
            }
        }
        
        else
        {
            NSDate *nowUTC = date;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
            time = [dateFormatter stringFromDate:nowUTC];
            strTime = time;
        }
    }
    
    return time;
}

- (NSString *) substituteEmoticons {
	
	//See http://www.easyapns.com/iphone-emoji-alerts for a list of emoticons available
	
//	NSString *res = [self stringByReplacingOccurrencesOfString:@":)" withString:@"\ue415"];	
//	res = [res stringByReplacingOccurrencesOfString:@":(" withString:@"\ue403"];
//	res = [res stringByReplacingOccurrencesOfString:@";-)" withString:@"\ue405"];
//	res = [res stringByReplacingOccurrencesOfString:@":-x" withString:@"\ue418"];
	
	return self;
	
}
+ (NSString *) getCurrentTime {
    
	NSDate *nowUTC = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	return [dateFormatter stringFromDate:nowUTC];
	
}
@end
