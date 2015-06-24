//
//  CustomMapAnnotationView.h
//  BullsEye
//
//  Created by Approutes on 9/9/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CustomMapAnnotationView : MKPinAnnotationView

@property(nonatomic,strong) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorVw;


@end
