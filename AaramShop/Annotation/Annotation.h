//
//  Annotation.h
//  BullsEye
//
//  Created by Approutes on 9/9/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Address;
@property (nonatomic, strong) NSString *strImgUrl;


- (id)initWithName:(NSString*)name Address:(NSString*)address Coordinate:(CLLocationCoordinate2D)cornidate imageUrl:(NSString *)strImageUrl;
@end
