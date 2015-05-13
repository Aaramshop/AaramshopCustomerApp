//
//  Annotation.m
//  BullsEye
//
//  Created by Approutes on 9/9/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import "Annotation.h"
@implementation Annotation
@synthesize Name,Address,coordinate,strImgUrl;
- (id)initWithName:(NSString*)name Address:(NSString*)address Coordinate:(CLLocationCoordinate2D)cornidate imageUrl:(NSString *)strImageUrl
{
    self.Address = address;
    self.Name = name;
    self.coordinate = cornidate;
    self.strImgUrl=strImageUrl;
    return self;
}

@end
