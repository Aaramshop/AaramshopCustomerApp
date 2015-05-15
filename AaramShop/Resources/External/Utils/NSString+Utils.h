//
//  NSString+Date.h
//  JabberClient
//
//  Created by cesarerocchi on 9/12/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Utils)

+ (NSString *) getCurrentTime:(NSDate *)date;
- (NSString *) substituteEmoticons;
+ (NSString *) getCurrentTime;
@end
